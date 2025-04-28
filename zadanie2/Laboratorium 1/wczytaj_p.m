%WCZYTAJ_P - funkcja, która z pliku nazwa_pliku, typu ASCII, wczytuje
%parametry systemów dynamicznych i przypisuje je odpowienim polom zmiennej
%baza.

function wczytaj_p(nazwa_pliku)
global baza A B C D;
fID=fopen(nazwa_pliku,'r');
while ~feof(fID)
    zmienna1=strtrim(fgetl(fID));
    A=str2num(fgetl(fID));
    B=str2num(fgetl(fID));
    C=str2num(fgetl(fID));
    D=str2num(fgetl(fID));
    temp_baza=struct('zmienna1',zmienna1,'A',A,'B',B,'C',C,'D',D);
    baza(end+1)=temp_baza;
end
fclose(fID);
end
