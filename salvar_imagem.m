### function salvar_imagem (diretorios,diretorio_destino,diretorio_raiz,imagens,counter_i,diretorio)
### funcao para salvar imagem gerada em pasta especial criada
function salvar_imagem (diretorios,diretorio_destino,diretorio_raiz,imagens,counter_i,diretorio)

    global existe_diretorio;

    if existe_diretorio == false ### verifica se já existe o diretório onde irá criar pôr as imagens criadas
        pasta_atual = pwd;
        cd (diretorio_raiz)
        pasta_raiz = dir;

        for pastas = 3:length(pasta_raiz) ### Loop na lista de diretórios
            if length(pasta_raiz(pastas).name) == length(diretorio_destino)
                if pasta_raiz(pastas).name == diretorio_destino ### verifica se o nome na lista é igual ao nome da possível pasta a ser criada
                    existe_diretorio = true;
                end
            end
        end
        if existe_diretorio == false
            mkdir (diretorio_raiz, diretorio_destino)
            fprintf('diretorio criado: %s\n', diretorio_destino); fflush(stdout);
        end
        cd (pasta_atual)
    end

    if (length(dir) > 2) ### cria e move as imagens para o diretório criado no if acima, esse condicional é para evitar de acontecer erro caso a pasta não tenha arquivos
        filename = imagens(counter_i).name(11:26);
        print(filename, '-djpg'); ################# Salvando a imagem
        movefile(filename, diretorio) ###### Movendo imagem
        fprintf('Print and move\n\n'); fflush(stdout);
    end
    
endfunction
