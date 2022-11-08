## function tempo = funcao_dir (dir_counter)
function funcao_dir_ans = funcao_dir (dir_counter)

global diretorios;
global diretorio_raiz;
global diretorio_atual;
global diretorio;
global diretorio_destino;
global diretorio_especial;

tamanho_diretorio_raiz = length(diretorio_raiz);

if (diretorios(dir_counter).isdir) == 1 ### verifica se o arquivo da lista é diretório
        
    cd(diretorios(dir_counter).name);

    pasta_atual = pwd;
    pasta_atual_tam = length(pasta_atual);
    pasta_atual = pasta_atual(pasta_atual_tam-1:pasta_atual_tam);
    pasta_atual1 = pasta_atual(1); ### verifica caractere final do nome do diretório
    pasta_atual2 = pasta_atual(2); ### verifica caractere final do nome do diretório

    diretorio_atual = pwd;
    diretorio_atual = diretorio_atual(tamanho_diretorio_raiz+2:length(diretorio_atual));

    diretorio = [pwd "##/"]
    diretorio_destino = diretorio;
    diretorio_destino = diretorio_destino(tamanho_diretorio_raiz+2:length(diretorio_destino)-1);

    if (pasta_atual2 == "2") || (pasta_atual2 == "#") ### verificar se o diretório não é onde cria/move as imagens (dir especial com final _2 ou ##), caso vdd é preciso mudar diretório
        if (pasta_atual1 == "_") || (pasta_atual1 == "#")
            diretorio_especial = true;
        end
    end
    funcao_dir_ans = true;
else
    funcao_dir_ans = false;
end ### verifica se o arquivo da lista é diretório
fprintf('função ok\n'); fflush(stdout);

end
