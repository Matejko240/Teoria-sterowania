%WYKRESY - funkcja, która wyświetla rysunek z dwoma wykresami, jeden na
%drugim. Pierwszy wykres przedstawia wyjście systemu nazwa na przedziale
%czasu [0,tk] przy założeniu zerowych warunków początkowych i pobudzenia
%impulsowego. Drugi, dolny wykres przedstawia trajektorię w przestrzeni
%zmiennych stanu, o ile liczba zmiennych stanu jest równa 2 lub 3. Jeżeli
%ten warunek nie jest sepłniony to w miejscu dolnego wykresu powinien
%pojawić się komunikat o treści: dim x>3 lub dim x<2.
function wykresy(nazwa,tk)
global baza A B C D;
[~, index] = ismember(nazwa, {baza.nazwa});
if index==0
    disp("Brak systemu w bazie danych.");
else
    dim_x=size(baza(index).A,1);
    if dim_x<2 ||dim_x>3
        disp("dim x>3 lub dim x<2.");
    end
    zmienna3=[0 tk];
    x0=zeros(dim_x,1);
    A=baza(index).A;
    B=baza(index).B;
    C=baza(index).C;
    D=baza(index).D;
    [t,y]=ode23(@(t,x)dynamika(t,x),zmienna3,x0);
    output=C.*y+D.*impuls(t);
    figure(1)
    subplot(2,1,1)
    %Wykres nr. 1 - wyjście systemu
    plot(t,output(:,1));
    grid on;
    title(["Wykres sygnału wejściowego: ",nazwa]);
    xlabel("Czas [s]");
    ylabel("Wyjście [-]");
    subplot(2,1,2)
    %wykres nr.2 - trajektoria w przedstrzeni zmiennych stanu
    if dim_x==2
        plot(y(:,1),y(:,2));
        title(["Trajektoria w przestrzeni zmiennych stanu: ",nazwa]);
        xlabel("x1");
        ylabel("x2");
    elseif dim_x==3
        plot3(y(:,1),y(:,2),y(:,3));
        title(["Trajektoria w przestrzeni zmiennych stanu: ",nazwa]);
        xlabel("x1");
        ylabel("x2");
        zlabel("x3");
    else
        disp("dim x>3 lub dim x<2.")
    end
end
end
