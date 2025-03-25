% WYKRESY - Generowanie wykresów odpowiedzi systemu
function wykresy(nazwa, tk)
    global baza;
    idx = find(cellfun(@(x) strcmp(x.nazwa, nazwa), baza));
    if isempty(idx)
        error('System nie znaleziony.');
    end
    sys = baza{idx};
    
    % Ustaw A i B dla funkcji dynamika
    global A B
    A = sys.A;
    B = sys.B;

    [T, X] = ode23(@dynamika, [0 tk], zeros(size(sys.A,1),1));
    Y = sys.C * X' + sys.D * impuls(T);
    
    subplot(2,1,1);
    plot(T, Y);
    title(['Odpowiedź systemu: ', nazwa]);
    xlabel('Czas'); ylabel('Wyjście Y');

    subplot(2,1,2);
    if size(X,2) == 2
        plot(X(:,1), X(:,2));
        title('Trajektoria w przestrzeni stanu');
        xlabel('x_1'); ylabel('x_2');
    else
        text(0.5, 0.5, 'dim x > 3 lub dim x < 2', 'HorizontalAlignment', 'center');
    end
end
