% S_STABILNE - Wyszukiwanie stabilnych systemów
function s_stabilne()
    global baza;
    for i = 1:length(baza)
        if all(real(eig(baza{i}.A)) < 0)
            fprintf('%s\n', baza{i}.nazwa);
        end
    end
end