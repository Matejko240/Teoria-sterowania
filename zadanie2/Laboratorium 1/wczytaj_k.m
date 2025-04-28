%WCZYTAJ_K - funkcja, która umożliwia dołączanie do bazy danych nowego
%systemu dynamicznego za pośrednictwem klawiatury

function wczytaj_k
global baza A B C D;
baza(10).zmienna1=input('Nazwa systemu: ','s');
baza(10).A=input('Wartość nr. 1: ', 's');
baza(10).A=str2num(baza(10).A);
baza(10).B=input('Wartość nr. 2: ', 's');
baza(10).B=str2num(baza(10).B);
baza(10).C=input('Wartość nr. 3: ', 's');
baza(10).C=str2num(baza(10).C);
baza(10).D=input('Wartość nr. 4: ', 's');
baza(10).D=str2num(baza(10).D);
end
