## function [B,L,stats1,original1] = leitor (imagens, counter_i, AREA)
## funcao para ler as imagens, "cria" as variaveis B, L, stats1, original1 e qtd_scm
function [B,L,stats1,original1,qtd_scm] = leitor (imagens, counter_i, AREA)

imagem_de_entrada = imread(imagens(counter_i).name); ### read image file
original1 = imcrop(imagem_de_entrada,[485 360 490 560]); ### corte

### "filtro" da imagem (funcao), transformando em cinza e depois em binário e detecção de borda
binario = filtro(original1);

### preenche buracos dos objetos encontrados
[binario_filled, idx] = bwfill(binario, "holes", 8);

### guarda informacao da borda dos objetos
fprintf("detecção de borda\n");
fflush(stdout);
[B,L] = bwboundaries(binario_filled, 8, 'noholes');

### funcao que calcula caracteristicas dos objetos na imagem
fprintf('Utilizando Regionprops\n');
fflush(stdout);
stats1 = regionprops(L,'Area', 'Centroid','MajorAxisLength', 'MinorAxisLength', 'Orientation');
qtd_scm = sum([stats1.Area] > AREA); ### quantidade de "objetos" com area superior a AREA pixels, 1 px - 5,26 km

end
