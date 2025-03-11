% INICJALIZACJA_BD - Inicjalizacja bazy danych
function inicjalizacja_bd()
    clear;
    global baza A B C D;
    baza = {};
end

% WCZYTAJ_P - Wczytanie bazy danych z pliku
function wczytaj_p(nazwa_pliku)
    global baza;
    fid = fopen(nazwa_pliku, 'r');
    if fid == -1
        error('Nie można otworzyć pliku.');
    end
    while ~feof(fid)
        nazwa = fgetl(fid);
        A = str2num(fgetl(fid));
        B = str2num(fgetl(fid));
        C = str2num(fgetl(fid));
        D = str2num(fgetl(fid));
        baza{end+1} = struct('nazwa', nazwa, 'A', A, 'B', B, 'C', C, 'D', D);
    end
    fclose(fid);
end

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

% ZAWARTOSC_BD - Wyświetlanie zawartości bazy danych
function zawartosc_bd()
    global baza;
    for i = 1:length(baza)
        fprintf('%s\n', baza{i}.nazwa);
    end
end

% WYSZUKAJ_BD - Wyszukiwanie systemów dynamicznych
function wyszukaj_bd(string)
    global baza;
    for i = 1:length(baza)
        if contains(baza{i}.nazwa, string)
            fprintf('%s\n', baza{i}.nazwa);
        end
    end
end

% SORTUJ_N - Sortowanie według normy wybranej macierzy
function sortuj_N(macierz)
    global baza;
    norms = arrayfun(@(x) norm(x.(macierz)), baza);
    [~, idx] = sort(norms);
    for i = idx
        fprintf('%s\n', baza{i}.nazwa);
    end
end

% S_STABILNE - Wyszukiwanie stabilnych systemów
function s_stabilne()
    global baza;
    for i = 1:length(baza)
        if all(real(eig(baza{i}.A)) < 0)
            fprintf('%s\n', baza{i}.nazwa);
        end
    end
end

% IMPULS - Definicja funkcji impulsowej
function y = impuls(t)
    sigma = 0.005;
    y = 1 / sqrt(2 * pi * sigma^2) * exp(-t.^2 / (2 * sigma^2));
end

% DYNAMIKA - Równanie różniczkowe ẋ = Ax + Bu
function xdot = dynamika(t, x)
    global A B;
    xdot = A*x + B*impuls(t);
end

% WYKRESY - Generowanie wykresów odpowiedzi systemu
function wykresy(nazwa, tk)
    global baza;
    idx = find(strcmp({baza.nazwa}, nazwa));
    if isempty(idx)
        error('System nie znaleziony.');
    end
    sys = baza{idx};
    [T, X] = ode23(@dynamika, [0 tk], zeros(size(sys.A,1),1));
    Y = sys.C * X' + sys.D * impuls(T);
    
    subplot(2,1,1);
    plot(T, Y);
    title('Odpowiedź systemu');
    
    subplot(2,1,2);
    if size(X,2) == 2
        plot(X(:,1), X(:,2));
        title('Trajektoria w przestrzeni stanu');
    else
        text(0.5, 0.5, 'dim x > 3 lub dim x < 2', 'HorizontalAlignment', 'center');
    end
end
