%SORTUJ_N - funkcja, która wyświetla (ze stronnicowaniem) nazwy systemów z
%bazy danych według rosnących wartości ||macierz||2, gdzie macierz należy
%do zbioru {A, B, C, D}.

function sortuj_N(macierz)
global baza A B C D;
for j=1:length(baza)
    normM(j).norm=norm(eval("baza(j)."+macierz),2);
    normM(j).System=baza(j).zmienna1;
end
[x,idx]=sort([normM,norm]);
normM=normM(idx);
for j=1:length(baza)
    fprint("%s\n", normM(i).System);
end
end