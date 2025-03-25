% WCZYTAJ_K - Wczytywanie systemu dynamicznego z klawiatury
function wczytaj_k()
    global baza;
    nazwa = input('Podaj nazwę systemu: ', 's');
    A = input('Podaj macierz A: ');
    B = input('Podaj macierz B: ');
    C = input('Podaj macierz C: ');
    D = input('Podaj macierz D: ');
    baza{end+1} = struct('nazwa', nazwa, 'A', A, 'B', B, 'C', C, 'D', D);
end