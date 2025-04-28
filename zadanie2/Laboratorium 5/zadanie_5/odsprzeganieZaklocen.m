%% Odsprzeganie zaklocen
% clear all;
close all;
syms a0 a1 a2 a3 b0 b1 b2 b3 e3 e2 e1 e0 s

%% Modelowanie matematyczne
disp('system matrices')

A=[0,0,0,-a0; ...
   1,0,0,-a1; ...
   0,1,0 -a2; ...
   0,0,1,-a3];
B=[b0; ...
   b1; ...
   b2; ...
   b3];
E=[e0; ...
   e1; ...
   e2; ...
   e3];

C=[0,0,0,1];

pA=poly([-0.5, -1, -1.5, -2]); pA(1)=[];
pB=poly([-3, -5]); pB=[zeros(1:4-length(pB)), pB];
pE=poly([5]); pE=[zeros(1:4-length(pE)), pE];
% Wielokrotnie wywolac ten skrypt dla nastepujacych przypadkow:
% pA=poly([-0.5, -1, -1.5, -2]); - system stabilny
% pA=poly([0.5, 1, -1.5, -2]); - system niestabilny
% pB=poly([-3, -5]); - system minimalnofazowy
% pB=poly([ 3, -5]); - system nieminimalnofazowy
% pE=poly([5]);
% pE=poly([-5]);
% closedLoopEigenValues=[-1,-1]
% closedLoopEigenValues=[-10,-10]
An=double(subs(A,[a3, a2, a1, a0], pA));
Bn=double(subs(B,[b3, b2, b1, b0], pB));
En=double(subs(E,[e3, e2, e1, e0], pE));

%% Projektowanie sterownika

% wyznaczanie stopni wzglednych (warunek konieczny istnienia
% sterownika)

disp('relative degrees')

rho=1; % stopien wzgledny systemu
cA=C;

while cA*Bn == 0
    cA=cA*An;
    rho=rho+1;
end
sprintf('--> rho = %d\n',rho)

cA=C;
sigm=1;
while cA*En == 0
    cA=cA*An;
    sigm=sigm+1;
end

sprintf('--> sigma = %d\n',sigm)

if rho < sigm

% wyznaczanie wartosci parametrow F i G w prawie sterowania
% u=F*x+G*v

    F=-double(inv(C*An^(rho-1)*Bn)*C*An^rho);
    G= double(inv(C*An^(rho-1)*Bn));

    r=@(t)sign(sin(0.1*t))*10; % sygnal referencyjny
    d=@(t)100*cos(0.5*t);      % zaklocenie

%% Symulacje

    x0=[1,1,1,1]';
    tf=200;

    options = odeset('RelTol',1e-10,'AbsTol',1e-12);

    close all

% przypadek bez sterownika odsprzegajacego zaklocenie     
    M1=@(t,x)An*x + Bn*r(t)+En*d(t);
    [t,x]=ode45(M1,[0,tf],x0, options);
    y=x*C';

    figure(1);
    plot(t,y);
    xlabel('t'), ylabel('u'), title('system bez sterownika odsprzegajacego: wyjscie');
    figure(2);
    plot(t,x);
    xlabel('t'), ylabel('x'), title('system bez sterownika odsprzegajacego: stan');

 % przypadek ze sterownikiem odsprzegajacym zaklocenie

    closedLoopEigenValues=[-10,-10];
    p=poly(closedLoopEigenValues);
    Acl=An+Bn*F+Bn*G*(-p(end)*C-p(end-1)*C*An);
    Bcl=Bn*G*p(end);

    M2=@(t,x)Acl*x + Bcl*r(t)+En*d(t);

    [t,x]=ode45(M2,[0,tf],x0, options);
    y=x*C';
    figure(3);
    plot(t,y);
    xlabel('t'), ylabel('u'), title('system ze sterownikiem odsprzegajacym: wyjscie');
    figure(4);
    plot(t,x);
    xlabel('t'), ylabel('x'), title('system ze sterownikiem odsprzegajacym: stan');
else
    sprintf("--> w przypadku tego system odsprzeganie zaklocenia jest niewykonalne\n");
end

% ZADANIE

% 1) Figure 1 i Figure 3: okreslic wplyw prawa sterowania odsprzegajacego 
% zaklocenie na zachowanie sie systemu (sledzenie trajektori)
% 2) Figure 2 i Figure 4 (dynamika zerowa): czy prawo sterowania 
% odsprzegajace zaklocenie zapewnia stabilnosc wejsciowo-wyjsciowa
% gdy system jest minimalnofazowy? 
% Czy identyczny wniosek mozna sformulowac gdy system nie jest
% minimalnofazowy?
% 3) Figure 3: jaki jest wplyw wartosci zmiennej closedLoopEigenValues 
% na czas ustalania sie sygnalun wyjsciowego?
% 4) Jaki jest zwiazek pomiedzy wartosciami wlasnymi Acl, 
% zerami pB i zerami wielomianu p?