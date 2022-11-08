%% function binario = filtro (original1)
function binario = filtro (original1)
fprintf('aplicando filtro de cor\n');
fflush(stdout);

%%% filtrando somente as cores com tons de azul e de rosa

red = original1(:,:,1);
green = original1(:,:,2);
blue = original1(:,:,3);

binario = ((red < 120) & (green < 220) & (blue > 170)) | ((red > 205) & (green > 145) & (blue > 250));

end
