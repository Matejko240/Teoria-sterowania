% ZAPISZ_BD - Zapis bazy danych do pliku
function zapisz_bd(nazwa_pliku)
    global baza;
    fid = fopen(nazwa_pliku, 'w');
    for i = 1:length(baza)
        fprintf(fid, '%s\n', baza{i}.nazwa);
        fprintf(fid, '%s\n', mat2str(baza{i}.A));
        fprintf(fid, '%s\n', mat2str(baza{i}.B));
        fprintf(fid, '%s\n', mat2str(baza{i}.C));
        fprintf(fid, '%s\n', mat2str(baza{i}.D));
    end
    fclose(fid);
end