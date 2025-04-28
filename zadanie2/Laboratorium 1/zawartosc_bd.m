%ZAWARTOŚĆ_BD - funkcja, która wyświetla na ekranie (ze stronnicowaniem)
%nazwy wszystkich systemów dynamicznych w bazie danych

function zawartosc_bd
global baza A B C D;
zmienna2={baza.zmienna1};
more on;
for i=1:length(zmienna2)
    tab=struct2table(baza);
    more(2)
    disp(zmienna2(1,i));
end
more off;
end