%ZAPISZ_BD - funkcja, która zapisuje zawartość bazy daych do pliku (typu
%ASCII) nazwa_pliku.

function zapisz_bd(nazwa_pliku)
global baza
fID=fopen(nazwa_pliku,'w');
for k=1:length(baza)
    fprintf(fID,'%s \n',baza(k).zmienna1);
    fprintf(fID,'%s \n',mat2str(baza(k).A));
    fprintf(fID,'%s \n',mat2str(baza(k).B));
    fprintf(fID,'%s \n',mat2str(baza(k).C));
    fprintf(fID,'%s \n',mat2str(baza(k).D));
end
fclose(fID);
disp('Zapis został wykonany.');
end