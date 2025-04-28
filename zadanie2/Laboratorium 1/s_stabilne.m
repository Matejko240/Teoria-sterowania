%S_STABILNE - funkcja, która wyświetla na ekranie (ze stronicowaniem) nazwy
%systemów z bazy danych, które są asymptotycznie stabilne. 

function s_stabilne
global baza;
for j=1:length(baza)
    if all(real(eig(baza(j).A))<0)==1
        fprintf("s%\n",baza(j).zmienna1)
    end
end
end