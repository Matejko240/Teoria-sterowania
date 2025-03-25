% WYSZUKAJ_BD - Wyszukiwanie systemów dynamicznych
function wyszukaj_bd(string)
    global baza;
    for i = 1:length(baza)
        if contains(baza{i}.nazwa, string)
            fprintf('%s\n', baza{i}.nazwa);
        end
    end
end