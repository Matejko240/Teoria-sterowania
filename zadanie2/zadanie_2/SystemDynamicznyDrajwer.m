%% SYSTEMDYNAMICZNYDRAJWER - skrypt do testowania klasy SystemDynamiczny 

%% pomoc
help SystemDynamiczny
help SystemDynamiczny.trajektoria
help SystemDynamiczny.dsplots

%% czynnosci wstepne
clear all
close all

% zmienne pomocnicze
f=0; % licznik wykresow
tk=100; % chwila koncowa symulacji

% parametry liniowego systemu dynamicznego
nazwa="demo";
A=[0,-1;1 -2];
B=[3;1];
C=[0,1];
D=[0];

% uchwyty do wybranych funkcji wejsciowych
sigm=0.005;
impulse=@(t)exp(-t.^2/(2*sigm^2))/(sigm*sqrt(2*pi)); % gaussian function
omega=0.1;
rectangular=@(t)sign(sin(omega*t)); 
zero=@(t)0;
% ZADANIE 1: zdefiniuj uchwyt to funkcji skokowej
step_fun = @(t) double(t >= 0);



%% tworzenie obiektu klasy SystemDynamiczny z nastepujacymi
% parametrami: nazwa, A, B, C, D, zero
ds=SystemDynamiczny(nazwa,A,B,C,D,zero);

%% trajektoria systemu ds (przebiegi y, x, u w czasie) dla x0=[10; 0];
% na przedziale czasu [0,tk] na osobnym rysunku nr f.
x0=[10;0];
f=f+1; figure(f);
ds.dsplots(tk,x0);

%% odpowiedz systemu ds na pobudzenie zerowe, na przedziale czasu [0,tk] dla
% x0=[0;0] (wykresy czasowe y,x,u) na osobnym rysunku nr f.
x0=[0;0];
f=f+1; figure(f);
ds.dsplots(tk,x0);

%% odpowiedz systemu ds na pobudzenie impulsowe
% ZADANIE 2: wykresl odpowiedz systemu ds na pobudzenie impulsowe
% na przedziale czasu [0,tk] dla x0=[0;0] (przebiegi czasowe y,x,u)
% na oddzielnym rysunku nr f.

ds.u = impulse;
f = f + 1; figure(f);
ds.dsplots(tk, [0; 0]);


%% odpowiedz systemu ds na pobudzenie skokowe
% ZADANIE 3: wykresl odpowiedz systemu ds na pobudzenie skokowe
% na przedziale czasu [0,tk] dla x0=[0;0] (przebiegi czasowe y,x,u)
% na oddzielnym rysunku nr f.

ds.u = step_fun;
f = f + 1; figure(f);
ds.dsplots(tk, [0; 0]);


%% odpowiedz systemu ds na pobudzenie sygnalem prostokatnym
% ZADANIE 4: wykresl odpowiedz systemu ds na pobudzenie sygnalem prostokatnym
% na przedziale czasu [0,tk] dla x0=[0;0] (przebiegi czasowe y,x,u)
% na oddzielnym rysunku nr f.
omega = 0.1;
rectangular = @(t) sign(sin(omega * t));
ds.u = rectangular;
f = f + 1; figure(f);
ds.dsplots(tk, [0; 0]);


%% odpowiedz systemu ds na pobudzenie sygnalem prostokatnym
% ZADANIE 5: wykresl odpowiedz systemu ds na pobudzenie sygnalem prostokatnym
% na przedziale czasu [0,tk] dla x0=[0;0] (przebiegi czasowe y,x,u)
% na oddzielnym rysunku nr f. Tym razem parametr omega w definicji
% uchwytu dla sygnalu prostokatnego ma byc wiekszy niz w ZADANIU 4
omega = 1;
rectangular = @(t) sign(sin(omega * t));
ds.u = rectangular;
f = f + 1; figure(f);
ds.dsplots(tk, [0; 0]);



%% trajektoria systemu ds w przestrzeni stanu
% ZADANIE 6: wykresl w przestrzeni stanu trajektorie stanu otrzymana
% w efekcie odpowiedzi systemu na pobudzenie sygnalem prostokatnym
% na przedziale czasu [0,tk] dla x0=[0;0] na oddzielnym rysunku f. 
