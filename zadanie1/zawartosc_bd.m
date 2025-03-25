% ZAWARTOSC_BD - Wyświetlanie zawartości bazy danych
function zawartosc_bd()
    global baza;
    for i = 1:length(baza)
        fprintf('%s\n', baza{i}.nazwa);
    end
end