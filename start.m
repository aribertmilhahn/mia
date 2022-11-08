## arquivos auxiliares são funcao_dir.m, leitor, filtro, linhas.m, salvar_imagem.m
## segunda parte do código está em contador.m que utiliza os auxiliar duracao.m
## terceira parte do código está em positions.m
## problemas com print usar <graphics_toolkit("gnuplot")>
graphics_toolkit("gnuplot")
clear all
pkg load image
addpath ("/home/faust/new")

AREA = 2536; ### 1px ~ 4,376 km (19,1551547 km²); 50.000 km² ~ 2611 pixels
contador_array = 1;
num_total_imagens = 1;

contador_for_dir = 3;
contador_for_imagens = 1;

verificador_de_resposta = 0;

global var diretorios = dir;
global var diretorio_raiz = pwd;
global var diretorio_atual = pwd;
global var diretorio = pwd;
global var diretorio_destino = pwd;
global var existe_diretorio = false;
global var diretorio_especial = false;

### verifica se existe o arquivo com as variáveis salvas, se existir ele é iniciado
lista_arquivos = dir;
for arquivo_num = 3:length (lista_arquivos);
    if strncmp (lista_arquivos(arquivo_num).name, 'temp.mat', 8) == true; ### funcao strncmp compara os 'n' (terceiro arg da funcao) primeiros caracteres entre 2 strings
        load temp.mat
        fprintf('iniciando arquivo salvo\n'); fflush(stdout);
        contador_for_dir = dir_counter;
        contador_for_imagens = counter_i;
        verificador_de_resposta = 1;
        break;
    end
end
if verificador_de_resposta == 0
    fprintf('nenhum arquivo salvo foi encontrado\n'); fflush(stdout);
end

for dir_counter = contador_for_dir:length (diretorios) ### loop nos diretórios
    fprintf('dir_counter = %d\n', dir_counter); fflush(stdout);
    existe_diretorio = false;
    diretorio_especial = false;
    
    cd (diretorio_raiz)
    funcao_dir_ans = funcao_dir (dir_counter); ### chama funcao verificadora de diretorios

    if diretorio_especial == false && funcao_dir_ans == true;
        fprintf('entrou no if para lista de imagens\n'); fflush(stdout);

        imagens = dir ("*.jpg");   ### obtem a lista de jpg no diretorio

	for counter_i = contador_for_imagens:length (imagens) ### loop sobre de imagens ################################################################################################
            save temp.mat ### salva todas as variáveis num arquivo chamado temp.mat
            movefile('temp.mat', diretorio_raiz)
            fprintf('salvo e movido\n\n'); fflush(stdout);
            numero_objeto = 1; ### variavel para ordenar as instancias dos objetos no array
            i = num_total_imagens; ### atribui ao indicador <i> o numero total de imagens para fazer as operações com o array, organizando por ordem de imagem
            estrutura_imagem(i).data = imagens(counter_i).name; ### cria uma estrutura com todos os nomes das imagens (nomes estão e forma aaaammddhhmm);
            estrutura_imagem(i).data2 = imagens(counter_i).name(11:26);
            estrutura_imagem(i).caminho = pwd;
            estrutura_imagem(i).caminho2 = diretorio;

            fprintf("Iniciando imagem nº %d de %d - diretorio ~%s/\n", counter_i, length(imagens), diretorio_atual); fflush(stdout);

            [B,L,stats1,original1,qtd_scm] = leitor (imagens, counter_i, AREA); ### funcao para ler as imagens, "cria" as variaveis B, L, stats1, original1 e qtd_scm

            fprintf('plotando imagem\n'); fflush(stdout);

            imshow(original1); title(sprintf("Existem %d objetos", qtd_scm));
            hold on
            for k = 1:length(B)
                if stats1(k).Area > AREA
          
                    [excentricidade,boundary] = linhas (k, B, stats1); ### função que traça as linhas das figuras geométricas e o texto na imagem da area e excentricidade
          
                    estrutura_imagem(i).objeto(numero_objeto) = stats1(k); ### inserindo as características dos obejtos maiores que AREA em pixels na estrutura imagem, na subestrutura objeto
                    estrutura_imagem(i).objeto_exc(numero_objeto) = excentricidade;
                    estrutura_imagem(i).objeto_label{numero_objeto} = k;
                    estrutura_imagem(i).objeto_borda{numero_objeto} = boundary; ### armazena a borda em um array dentro da estrutura imagem

                    fprintf("Objeto label %d de %d\n", k, length(B)); fflush(stdout);
                    numero_objeto++;
                end ### fim do if area > AREA
            end ### fim do for para k = 1:length(B)
            hold off

    	    salvar_imagem (diretorios,diretorio_destino,diretorio_raiz,imagens,counter_i,diretorio) ### verifica se existe o diretório especial, se não houver é criado um e salva a imagem gerada

            ##########################################################################################################################################################################################
            ## PENSAR em como "amarrar" a ultima imagem de uma pasta com a primeira imagem da outra com a condição [if counter_i == 1 && dir_counter > 3] | como continuar de onde o programa parar ##
            ##########################################################################################################################################################################################

            if (i > 1) && (numero_objeto > 1) ### numero_objeto > 1 significa que a imagem tem pelo menos 1 objeto que condiz com a condição stats1(k).Area > AREA
                for contador_de_comparacao_p = 1:length(estrutura_imagem(i-1).objeto) ### loop para comparação de centroids
                    for contador_de_comparacao_q = 1:length(estrutura_imagem(i).objeto)
     
                        px = estrutura_imagem(i-1).objeto(contador_de_comparacao_p).Centroid(1);
                        py = estrutura_imagem(i-1).objeto(contador_de_comparacao_p).Centroid(2);
                        qx = estrutura_imagem(i).objeto(contador_de_comparacao_q).Centroid(1); 
                        qy = estrutura_imagem(i).objeto(contador_de_comparacao_q).Centroid(2);

                        distancia_pq = sqrt( (px - qx)^2 + (py - qy)^2 );
     
                        distancia_provisoria{1, contador_de_comparacao_q} = distancia_pq;
                    end ### fim do for para o loop de comparações para q

                    distancia_definitiva = distancia_provisoria{1, 1};
                    marcador_de_q = 1;
      
                    if contador_de_comparacao_q > 1 ### comparação da menor distancia dos objetos da imagem atual para um objeto da imagem anterior
                        for contador_comp_dist = 1:contador_de_comparacao_q - 1 ### para permanecer o menor valor na variavel distancia_definitiva
                            if distancia_definitiva > distancia_provisoria{1, contador_comp_dist+1}
                                distancia_definitiva = distancia_provisoria{1, contador_comp_dist+1};
                                marcador_de_q = contador_comp_dist+1;
                            elseif distancia_definitiva == distancia_provisoria{1, contador_comp_dist+1}
                                ########################### PENSAR NO QUE FAZER AQUI!!!! ################################
                            end
                        end
                    end ### fim da comparacao

                    if distancia_definitiva <= estrutura_imagem(i-1).objeto(contador_de_comparacao_p).MajorAxisLength## & estrutura_imagem(i-1).objeto_exc(contador_de_comparacao_p) >= 0.7
                        distancia_centroid{1, contador_array} = distancia_definitiva;
                        distancia_centroid{2, contador_array} = contador_de_comparacao_p;
                        distancia_centroid{3, contador_array} = marcador_de_q;
                        distancia_centroid{4, contador_array} = i-1;

                        img_info = [diretorio_atual " i"];
                        counter_i_number = num2str(counter_i);
                        nome_imagem = imagens(counter_i).name;

                        distancia_centroid{5, contador_array} = strjoin({img_info, counter_i_number, nome_imagem});

                        contador_array++;
                    end ### fim do if para o condicional responsável em colocar os valores de distancia_definitiva em um array
                    clear distancia_provisoria;
                end ### fim do for para o loop de comparações para p
            end ### fim do if para comparações de centroids
	    num_total_imagens++;
        end ### fim do loop de imagens ################################################################################################
        contador_for_imagens = 1;
    end ### fim do if verificador da pasta_atual
end ### fim do loop de diretórios

cd (diretorio_raiz)
### save dados.mat distancia_centroid estrutura_imagem ### salva as variaveis distancia_centroid e estrutura_imagem num arquivo chamado dados.mat
save dados.mat
