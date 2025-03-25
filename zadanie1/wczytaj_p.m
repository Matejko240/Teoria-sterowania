function wczytaj_p(nazwa_pliku)
    global baza;
    fid = fopen(nazwa_pliku, 'r');
    if fid == -1
        error('Nie można otworzyć pliku.');
    end
    baza = {};
    while ~feof(fid)
        nazwa = strtrim(fgetl(fid));
        A = eval(fgetl(fid));
        B = eval(fgetl(fid));
        C = eval(fgetl(fid));
        D = eval(fgetl(fid));
        s = struct('nazwa', nazwa, 'A', A, 'B', B, 'C', C, 'D', D);
        baza{end+1} = s;
    end
    fclose(fid);
end
