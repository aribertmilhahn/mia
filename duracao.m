## function tempo = duracao(datainicial, datafinal)
function tempo = duracao(datainicial, datafinal)

ano_inicial = str2num(datainicial(1:4));
mes_inicial = str2num(datainicial(5:6));
dia_inicial = str2num(datainicial(7:8));
hora_inicial = str2num(datainicial(9:10));
minuto_inicial = str2num(datainicial(11:12));

ano_final = str2num(datafinal(1:4));
mes_final = str2num(datafinal(5:6));
dia_final = str2num(datafinal(7:8));
hora_final = str2num(datafinal(9:10));
minuto_final = str2num(datafinal(11:12));

%%% if para verificar se os anos são bissextos

if rem(ano_inicial, 4) == 0
    if rem(ano_inicial, 100) == 0
        if rem(ano_inicial, 400) == 0
            ano_inicial_bissexto = true;
        else
            ano_inicial_bissexto = false;
        end
    else
        ano_inicial_bissexto = true;
    end
else
    ano_inicial_bissexto = false;
end

if rem(ano_final, 4) == 0
    if rem(ano_final, 100) == 0
        if rem(ano_final, 400) == 0
            ano_final_bissexto = true;
        else
            ano_final_bissexto = false;
        end
    else
        ano_final_bissexto = true;
    end
else
    ano_final_bissexto = false;
end

%%% switch para transformar os meses em dias juliano, tanto para anos normais, quanto anos bissextos

if (ano_inicial_bissexto == false)
    switch mes_inicial
             
    case 01 
        mes_inicial = 0;
    case 02 
        mes_inicial = 31;
    case 03 
        mes_inicial = 59;
    case 04 
        mes_inicial = 90;
    case 05 
        mes_inicial = 120;
    case 06 
        mes_inicial = 151;
    case 07 
        mes_inicial = 181;
    case 08 
        mes_inicial = 212;
    case 09 
        mes_inicial = 243;
    case 10 
        mes_inicial = 273;
    case 11 
        mes_inicial = 304;
    case 12 
        mes_inicial = 334;
    end
else
    switch mes_inicial
             
    case 01 
        mes_inicial = 0;
    case 02 
        mes_inicial = 31;
    case 03 
        mes_inicial = 60;
    case 04 
        mes_inicial = 91;
    case 05 
        mes_inicial = 121;
    case 06 
        mes_inicial = 152;
    case 07 
        mes_inicial = 182;
    case 08 
        mes_inicial = 213;
    case 09 
        mes_inicial = 244;
    case 10 
        mes_inicial = 274;
    case 11 
        mes_inicial = 305;
    case 12 
        mes_inicial = 335;
    end
end

if (ano_final_bissexto == false)
    switch mes_final
             
    case 01 
        mes_final = 0;
    case 02 
        mes_final = 31;
    case 03 
        mes_final = 59;
    case 04 
        mes_final = 90;
    case 05 
        mes_final = 120;
    case 06 
        mes_final = 151;
    case 07 
        mes_final = 181;
    case 08 
        mes_final = 212;
    case 09 
        mes_final = 243;
    case 10 
        mes_final = 273;
    case 11 
        mes_final = 304;
    case 12 
        mes_final = 334;
    end
else
    switch mes_final
             
    case 01 
        mes_final = 0;
    case 02 
        mes_final = 31;
    case 03 
        mes_final = 60;
    case 04 
        mes_final = 91;
    case 05 
        mes_final = 121;
    case 06 
        mes_final = 152;
    case 07 
        mes_final = 182;
    case 08 
        mes_final = 213;
    case 09 
        mes_final = 244;
    case 10 
        mes_final = 274;
    case 11 
        mes_final = 305;
    case 12 
        mes_final = 335;
    end
end

data_ano = ano_final - ano_inicial;

if (data_ano != 0) && (ano_inicial_bissexto == true)
    # data_ano = 366;
elseif (data_ano != 0) && (ano_inicial_bissexto != true)
    # data_ano = 365;
end

data_dia = ((mes_final + dia_final + data_ano) - (mes_inicial + dia_inicial)) * 24 * 60;

data_hora = (hora_final - hora_inicial) * 60;

data_minuto = minuto_final - minuto_inicial;

tempo = data_dia + data_hora + data_minuto;

end
