% SORTUJ_N - Sortowanie według normy wybranej macierzy
function sortuj_N(macierz)
    global baza;

    norms = cellfun(@(x) norm(x.(macierz)), baza);
    [~, idx] = sort(norms);

    for i = idx
        fprintf('%s\n', baza{i}.nazwa);
    end
end
