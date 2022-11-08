### algoritmo para plotar o descolamento dos CCMs

clear all
load dados.mat
load estrutura_ccm.mat
addpath ("/home/faust/new")

diretorio_raiz = pwd;
mkdir (diretorio_raiz, "posicoes_ccms");
dir_ccms = [pwd "/posicoes_ccms/"];

imagem_de_entrada = imread("/home/faust/new/S11147908_201004281800.jpg"); ### read image file
original1 = imcrop(imagem_de_entrada,[485 360 490 560]); ### corte

for num_ccm = 1:numero_do_ccm

    imshow(original1)
    hold on

    for ccm_posicao = 1:length(estrutura_ccm(num_ccm).ccm)-1
        ### pegando o valor da estrutura estrutura_ccm.ccm -> [colunas 1,2,3,4: distancia, p, q, i]

        valor_p = estrutura_ccm(num_ccm).ccm(ccm_posicao,2); ### contador_comparacao_p
        valor_q = estrutura_ccm(num_ccm).ccm(ccm_posicao,3); ### contador_comparacao_q
        valor_i = estrutura_ccm(num_ccm).ccm(ccm_posicao,4); ### i-1

        ax(ccm_posicao,1) = estrutura_imagem(valor_i).objeto(valor_p).Centroid(1);
        ay(ccm_posicao,1) = estrutura_imagem(valor_i).objeto(valor_p).Centroid(2);
        bx(ccm_posicao,1) = estrutura_imagem((valor_i) + 1).objeto(valor_q).Centroid(1); 
        by(ccm_posicao,1) = estrutura_imagem((valor_i) + 1).objeto(valor_q).Centroid(2);

        distancia_reta(ccm_posicao,num_ccm) = sqrt( (ax(ccm_posicao,1) - bx(ccm_posicao,1))^2 + (ay(ccm_posicao,1) - by(ccm_posicao,1))^2 );

        alpha_reta = atand( (by(ccm_posicao,1) - ay(ccm_posicao,1)) / (bx(ccm_posicao,1) - ax(ccm_posicao,1)) );
        alpha_reta_normalizado = (90 - abs(alpha_reta)) * (-(alpha_reta/abs(alpha_reta)));

        ### calculando o angulo
        delta_x = ( bx(ccm_posicao,1) - ax(ccm_posicao,1) );
        delta_y = ( by(ccm_posicao,1) - ay(ccm_posicao,1) );

        seno_alpha = sin( delta_y / distancia_reta(ccm_posicao,num_ccm) );
        seno_alpha_normalizado = (90 - abs(seno_alpha)) * (-(seno_alpha/abs(seno_alpha)));

        ### coseno nao funciona direito, depois procurar o motivo por curiosidade
        #coseno_alpha = cos( delta_x / distancia_reta(ccm_posicao,num_ccm) );
        #coseno_alpha_normalizado = (90 - abs(coseno_alpha)) * (-(coseno_alpha/abs(coseno_alpha)));

        ### if aninhado de seno e tangente afim de saber qual a posicao do quadrante
        if (alpha_reta_normalizado > 0) && (seno_alpha_normalizado > 0)
            angulo_reta = abs(alpha_reta_normalizado);
        elseif (alpha_reta_normalizado < 0) && (seno_alpha_normalizado > 0)
            angulo_reta = abs(alpha_reta_normalizado) + 90;
        elseif (alpha_reta_normalizado > 0) && (seno_alpha_normalizado < 0)
            angulo_reta = abs(alpha_reta_normalizado) + 180;
        else # (alpha_reta_normalizado < 0) && (seno_alpha_normalizado < 0)
            angulo_reta = abs(alpha_reta_normalizado) + 270;
        end

        tangentes(ccm_posicao,num_ccm) = alpha_reta_normalizado;
        #cosenos(ccm_posicao,num_ccm) = coseno_alpha_normalizado;
        senos(ccm_posicao,num_ccm) = seno_alpha_normalizado;
        angulos{ccm_posicao,num_ccm} = angulo_reta;
        angulos_matriz(ccm_posicao,1) = angulo_reta;

    end ### fim do for para obter os angulos

    angulos_array{num_ccm} = angulos_matriz;

    ax(ccm_posicao+1,1) = bx(ccm_posicao,1);
    ay(ccm_posicao+1,1) = by(ccm_posicao,1);

    plot(ax(1,1), ay(1,1), 'p', 'markersize', 3, 'color', 'g', 'linewidth', 2);
    plot(ax, ay, '+', 'markersize', 2, 'color', 'g', 'linewidth', 2);
    plot(ax, ay, 'm', 'linestyle', '-', 'linewidth', 1);
    plot(bx(ccm_posicao,1), by(ccm_posicao,1), 'o', 'markersize', 3, 'color', 'g', 'linewidth', 2);

    hold off

    name = ["ccm"];
    numero = num2str(num_ccm);  
    filename = strjoin({name, numero},'_');
    filename = [filename ".jpg"];
    print(filename, '-djpg'); ################# Salvando a imagem
    movefile(filename, dir_ccms) ###### Movendo imagem
    fprintf('Print and move\n');
    fflush(stdout);
    clf;

end ### fim do for num_ccm

for velo_count = 1:length(estrutura_ccm)
    delta_s_pixel = sum(estrutura_ccm(velo_count).ccm(:,1));
    delta_t_min = duracao(estrutura_ccm(velo_count).datainicial, estrutura_ccm(velo_count).datafinal);
    velocidade_media_kh(velo_count) = (delta_s_pixel * 4.376) / (delta_t_min / 60); ### 1px ~ 4,376 km
    velocidade_media_ms(velo_count) = (delta_s_pixel * 4376) / (delta_t_min * 60); ### 1px ~ 4376 m
end ### fim do for para calculo da velocidade média
