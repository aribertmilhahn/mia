### algoritmo de analisae do array distancia_centroid para separacao dos objetos "contínuos"
### utiliza auxiliar duracao.m
clear all
load dados.mat

addpath ("/home/faust/new")

numero_do_ccm = 1; ### marcador do numero do evento de CCM
coluna_id_array{1, 1} = 0;
valor_ant = 0;
array_de_comparacao{4, 1} = 0; array_de_comparacao(1:4, 1) = 0;

for contadorexterno = 1:length(distancia_centroid)-1
    clear array_provisorio;
    printf("limpou array_provisorio\n"); fflush(stdout);
    contadorinicial = contadorexterno;
    persistencia = 1;
    tempo_de_persistencia = 0;
    repeticao_ex = false;
    repeticao_in = false;

    dist1 = distancia_centroid{1, contadorinicial};
    p1 = distancia_centroid{2, contadorinicial};
    q1 = distancia_centroid{3, contadorinicial};
    i1 = distancia_centroid{4, contadorinicial};
    coluna_id1 = contadorinicial;

    i2 = distancia_centroid{4, contadorinicial+1};
  
    while (i2 < (i1 + 2)) && (contadorinicial <= (length(distancia_centroid)-1))

        for contador_comp = 1:length(coluna_id_array)
            if (coluna_id1 == coluna_id_array{1, contador_comp})
                repeticao_ex = true;
                printf("dentro do for contador_comp ################################\n"); fflush(stdout);
                break;
            end ### fim do if para pular o loop se a sequencia de objetos já existe
        end ### fim do for para comparação

        if repeticao_ex == true
            break;
        end

        dist2 = distancia_centroid{1, contadorinicial+1};
        p2 = distancia_centroid{2, contadorinicial+1};
        q2 = distancia_centroid{3, contadorinicial+1};
        i2 = distancia_centroid{4, contadorinicial+1};
        coluna_id2 = contadorinicial+1;

        for contador_comp = 1:length(coluna_id_array)
            if (coluna_id2 == coluna_id_array{1, contador_comp})
                repeticao_in = true;
                printf("dentro do for contador_comp 2 ################################\n"); fflush(stdout);
                break;
            end ### fim do if para pular o loop se a sequencia de objetos já existe
        end ### fim do for para comparação

        if repeticao_in == true
            contadorinicial++;
            continue;
        end

        printf("contadorinicial: (%d)|dist1: (%d)|p1: (%d)|q1: (%d)|i1: (%d)|dist2: (%d)|p2: (%d)|q2: (%d)|i2: (%d)|P:(%d)\n", contadorinicial,dist1,p1,q1,i1,dist2,p2,q2,i2,persistencia); fflush(stdout);

        if (p2 == q1) && (i2 == (i1 + 1))
      
            printf("entrou no if (p2 == q1) && (i2 == (i1 + 1))\n"); fflush(stdout);

            array_provisorio{1, persistencia} = dist1; ### distancia_pq;
            array_provisorio{2, persistencia} = p1; ### contador_de_comparacao_p;
            array_provisorio{3, persistencia} = q1; ### contador_de_comparacao_q;
            array_provisorio{4, persistencia} = i1; ### i-1;
            array_provisorio{5, persistencia} = coluna_id1;

            persistencia++;
            dist1 = dist2;
            p1 = p2;
            q1 = q2;
            i1 = i2;
            coluna_id1 = coluna_id2;
        end ### fim do if condicional da confirmação do mesmo objeto

        if (contadorinicial == (length(distancia_centroid)-1)) && ((p1 == p2) && (q1 == q2) && (i1 == i2))

            printf("armazenou no array_provisorio o ultimo valor da sequencia\n"); fflush(stdout);

            array_provisorio{1, persistencia} = dist2; ### distancia_pq;
            array_provisorio{2, persistencia} = p2; ### contador_de_comparacao_p;
            array_provisorio{3, persistencia} = q2; ### contador_de_comparacao_q;
            array_provisorio{4, persistencia} = i2; ### i-1;
            array_provisorio{5, persistencia} = coluna_id2;
        elseif (i2 >= (i1 + 2))

            printf("armazenou no array_provisorio o ultimo valor da sequencia\n"); fflush(stdout);

            array_provisorio{1, persistencia} = dist1; ### distancia_pq;
            array_provisorio{2, persistencia} = p1; ### contador_de_comparacao_p;
            array_provisorio{3, persistencia} = q1; ### contador_de_comparacao_q;
            array_provisorio{4, persistencia} = i1; ### i-1;
            array_provisorio{5, persistencia} = coluna_id1;
        end ### fim do if para pausar o loop quando for a ultima imagem a analisar
  
        contadorinicial++; 
    end ### fim do while

    if persistencia > 1
        ### armazenando a data inicial e final da sequencia do array_provisorio
        datainicial = estrutura_imagem(array_provisorio{4, 1}).data(11:22);
        datafinal = estrutura_imagem(array_provisorio{4, columns(array_provisorio)}).data(11:22);
        ### função para obter a variação de tempo do inicio ao final da sequencia do array_provisorio
        tempo_de_persistencia = duracao(datainicial, datafinal);
    end

    if tempo_de_persistencia >= 360 ### condicional para armazenar as informações se o objeto persistir por mais de 6 horas

        clear matrizCCM;
        printf("persistencia >= 6h\n"); fflush(stdout);
    
        for contador_da_linha = 1:4
            matrizCCM(1:columns(array_provisorio), 4) = 1;
            for contador_do_elemento = 1:columns(array_provisorio)
                matrizCCM(contador_do_elemento, contador_da_linha) = array_provisorio{contador_da_linha , contador_do_elemento};
            end
        end ### for para transformação do array_provisorio em matrizCCM, para melhor visualização

        estrutura_ccm(numero_do_ccm).ccm = matrizCCM;
        estrutura_ccm(numero_do_ccm).duracao = tempo_de_persistencia;
        estrutura_ccm(numero_do_ccm).datainicial = datainicial;
        estrutura_ccm(numero_do_ccm).datafinal = datafinal;

        if length(coluna_id_array) > 1
            valor_ant = length(coluna_id_array);
        end

        for contador_do_elemento = 1:columns(array_provisorio)
            coluna_id_array{1, contador_do_elemento + valor_ant} = array_provisorio{5 , contador_do_elemento};
        end

        if numero_do_ccm == 1
            mkdir (diretorio_raiz, "eventos_ccm");
            cd ("eventos_ccm")
            eventos_ccm_dir = pwd;

            pasta_evento = num2str(numero_do_ccm);
            pasta_evento2 = [pasta_evento "##/"]
            mkdir (eventos_ccm_dir, pasta_evento);
            mkdir (eventos_ccm_dir, pasta_evento2);
            cd (pasta_evento)
            pasta_evento_dir = pwd;
            pasta_evento_dir2 = [pwd "##/"]
        else
            pasta_evento = num2str(numero_do_ccm);
            pasta_evento2 = [pasta_evento "##/"]
            mkdir (eventos_ccm_dir, pasta_evento);
            mkdir (eventos_ccm_dir, pasta_evento2);
            cd (pasta_evento)
            pasta_evento_dir = pwd;
            pasta_evento_dir2 = [pwd "##/"]
        end

        for num_imagem = 1:columns(array_provisorio) ### movendo imagens originais e criadas dos possiveis eventos para uma pasta referente a ordem do evento
            caminho = estrutura_imagem(array_provisorio{4, num_imagem}).caminho;
            nome = estrutura_imagem(array_provisorio{4, num_imagem}).data;
            caminho2 = estrutura_imagem(array_provisorio{4, num_imagem}).caminho2;
            nome2 = estrutura_imagem(array_provisorio{4, num_imagem}).data2;
            cd (caminho)
            copyfile(nome, pasta_evento_dir); ###### Movendo imagem
            cd (caminho2)
            copyfile(nome2, pasta_evento_dir2); ###### Movendo imagem
        end

        cd (eventos_ccm_dir)
        clear datainicial; clear datafinal
        numero_do_ccm++;
    end ### fim do if com condicional de conexão do objeto com duracao maior que 6 horas
    contadorexterno++;
end ### fim do for
cd (diretorio_raiz)
numero_do_ccm = numero_do_ccm - 1;
save estrutura_ccm.mat estrutura_ccm numero_do_ccm
