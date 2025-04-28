%% LINEARYZACJA WAHADLA POJEDYNCZEGO Z ELASTYCZNOSCIA W PRZEGUBIE
% Przyklad 6.10 z ksiazki "Applied Nonlinear Control" autorstwa Slotine & Li 
clear all
close all
clc
%% Modelowanie matematyczne
% deklarowanie zmiennych i funkcji symbolicznych
syms t q1(t) q2(t) D2q1 D2q2 
syms x1 x2 x3 x4  
syms X1(t) X2(t) X3(t) X4(t)
syms z1 z2 z3 z4
syms u1 v
syms M1 L1 I1 % parametry ogniwa nr 1 (masa, długośc, moment bezwladnosci)
syms J1       % parametr wirnika (moment bezwladnosci)
syms K1       % parametr elastycznosci przegubu (stala sprezystosci)
syms G        % przyspieszenie ziemskie
syms a1 a2 a3 % wspolczynniki liniowej kombinacji

% nadawanie wartosci parametrom pojedynczego wahadla z elastycznoscia w
% przegubie
m1=10; % kg            masa ogniwa
l1=2;  % m             dlugosc ogniwa          
J=1;   %               moment bezwladnosci wirnika
k=1;   % Nm/rad        stala sprezystosci
gravity=9.81; % m/s^2  przyspieszenie ziemskie
% I1=M1*L1^2

% energia kinetyczna i potencjalna pojedynczego wahadla z elastycznoscia 
% w przegubie
PE=-M1*G*L1*cos(q1)+sym(1)/2*K1*(q1-q2)^2;
KE=sym(1)/2*(M1*L1^2)*diff(q1,t)^2+sym(1)/2*J1*diff(q2,t)^2;

% Funkcja Lagrangea dla pojedynczego wahadla z elastycznoscia 
% w przegubie
L=KE-PE;

% dynamika pojedynczego wahadla z elastycznoscia w przegubie w kategoriach
% rownan Eulera-Lagrangea

% wirnik
D12  = diff(L,diff(q2(t),t));
D22  = diff(L,q2);
eqn2 = diff(D12,t) - D22 == u1;
% ogniwo
D11  = diff(L,diff(q1(t),t));
D21  = diff(L,q1);
eqn1 = diff(D11,t) - D21 == 0;
            
% transformacja rownan dynamiki do rownan ze zmiennymi stanu
            
% krok 1: pod q1, q2, q1', q2' sa podstawiane ... 
% x1, x2, x3, x4 w rownaniach EQN1, EQN2. 
% Pod q1'' i q2'' sa podstawiane D2q1, D2q2 
% odpowiednio. Ostatnie podstawienie ma charakter techniczny na potrzeby
% funkcji solve uzytej ponizej.
E1 = subs(eqn1, ...
    {diff(q1,t,t), diff(q2,t,t), ...
     diff(q1,t),   diff(q2,t), ...
     q1(t),         q2(t)},...
    {D2q1, D2q2, x2, x4, x1, x3});
            
E2 = subs(eqn2, ...
    {diff(q1,t,t), diff(q2,t,t), ...
     diff(q1,t),   diff(q2,t), ...
     q1(t),         q2(t)},...
    {D2q1, D2q2, x2, x4, x1, x3});   

% krok 2: wyrazenie q1'', q2'', reprezentowanych przez D2q1, D2q2, 
% za pomoca zmiennych stanu x1, x2, x3, x4
[F1, F2]=solve([E1, E2], [D2q1, D2q2]);
            
% krok 3: upraszczanie wyrazen otrzymanych w kroku 2
%
F1=simplify(F1);
F2=simplify(F2);
           
% krok 4 (dynamika pojedynczego wahadla z elastycznym przegubem)
% x'=f(x)+g(x)u
% wyprowadzanie f i g:
f=simplify(subs([x2; F1; x4; F2], {u1}, {0}));
g=simplify(subs([x2; F1; x4; F2], {u1}, {1})-f);

% ZADANIE 1: 
% porownaj pola wektorowe uzyskane tutaj z ich odpowiednikami
% prezentowanymi w ksiazce autorstwa Slotine & Lee (zob. strony 243)
disp("Zadanie 1:")
disp("f=")
disp(f)
disp("g=")
disp(g)

%% Analiza modelu
% Badanie istnienia linearyzujacego sprzezenia zwrotnego polaczonego ze 
% zmianą wspolrzednych

% W tym celu nalezy wyliczyc zbior nastepujacych pol wektorowych
% adfg=[ad_f^0g, ad_f^1g, ad_f^2g, ad_f^3g]
% (zebranych ponizej w formie macierzy) i nastepnie sprawdzic czy sa 
% liniowo niezalezne i inwolutywne
x=[x1,x2,x3,x4];
adfg=g;
for i=1:length(x)-1
    adfg=[adfg, jacobian(adfg(1:4,i), x)*f-jacobian(f, x)*adfg(1:4,i)];
end

% ZADANIE 2: 
% porownaj pola wektorowe uzyskane tutaj z ich odpowiednikami
% prezentowanymi w ksiazce autorstwa Slotine & Lee (zob. strony 243)
disp("Zadanie 2:")
disp("[g, ad_g^0g, ad_f^1g, ad_f^2g, ad_f^3g] = ")
disp(adfg)

% liniowosc [ad_f^0g, ad_f^1g, ad_f^2g, ad_f^3g]
if det(adfg) == 0
    disp('[ad_f^0g, ad_f^1g, ad_f^2g, ad_f^3g] sa liniowo zalezne')
else
    disp('[ad_f^0g, ad_f^1g, ad_f^2g, ad_f^3g] sa liniowo niezalezne')
end
% 
% inwolutywnosc [ad_f^0g, ad_f^1g, ad_f^2g]
isinvol=true;
for i=1:3
    for j=i:3
        aux=jacobian(adfg(1:4,i), x)*adfg(1:4,j)- ...
            jacobian(adfg(1:4,j), x)*adfg(1:4,i);
        invol(i,j)=solve(aux==a1*adfg(1:4,1)+a2*adfg(1:4,2)+a3*adfg(1:4,3),a1,a2,a3);
        if ~all(isreal([invol(i,j).a1, invol(i,j).a2, invol(i,j).a3]))
            disp('[ad_f^0g, ad_f^1g, ad_f^2g, ad_f^3g] nie sa inwolutywne')
            isinvol=false;
        end
    end
end
if isinvol
    disp('[ad_f^0g, ad_f^1g, ad_f^2g, ad_f^3g] wydaja sie byc inwolutywne')
end

% ZADANIE 3: 
% porownaj wyniki uzyskane tutaj z wynikami prezentowanymi w ksiazce
% autorstwa Slotine & Lee (zob. strona 243)
disp("Zadanie 3:")
disp(aux)
%% Zmiana wsplrzednych (transformacja zmiennych stanu)

% zmiana wspolrzednych (transformacja zmiennych stanu)
T.z1=x1;
T.z2=transpose(gradient(T.z1,x))*f;
T.z3=transpose(gradient(T.z2,x))*f;
T.z4=transpose(gradient(T.z3,x))*f;
Tt=subs(T,{x1,x2,x3,x4},{X1(t),X2(t),X3(t),X4(t)});


% odwrotna zmiana wspolrzednych (odwrotna transformacja zmiennych stanu)
invT=solve(T.z1==z1, T.z2==z2, T.z3==z3, T.z4==z4, x1, x2, x3, x4);

% ZADANIE 4: 
% porownaj wyniki uzyskane tutaj z wynikami prezentowanymi w ksiazce
% autorstwa Slotine & Lee (zob. strony 244 i 245)
disp("Zadanie 4:")
disp(Tt)

%% Linearyzujace sprzezenie zwrotne
% u=alpha(x)+beta(x) v,
% gdzie beta=1/(L_g L_f^3 T.z1) i alpha=-(L_f^4 T.z1)/(L_g L_f^3 T.z1)

beta =                              simplify(1/(transpose(gradient(T.z4,x))*g));
alpha= simplify(-transpose(gradient(T.z4,x))*f/(transpose(gradient(T.z4,x))*g));
u=alpha+beta*v;

% 1) Zastosuj linearyzujace sprzezenie zwrotne do systemu x'=f(x)+g(x)*u
% Dx ponizej oznacza pochodna czasu zmiennej x
Dx=simplify(subs(simplify(f+g*u), {x1,x2,x3,x4}, {invT.x1, invT.x2, invT.x3, invT.x4}));

% 2) Zastosuj transformacje stanu do systemu x'=f(x)+g(x)*(alpha(x)+beta(x)*v)
% Dz ponizej oznacza pochodna czasu zmiennej z
Dz1=simplify(subs(diff(Tt.z1,t), {diff(X1(t),t), diff(X2(t),t), diff(X3(t),t),diff(X4(t),t), X1(t), X2(t), X3(t), X4(t)},{Dx(1), Dx(2),Dx(3), Dx(4), invT.x1, invT.x2, invT.x3, invT.x4}));
Dz2=simplify(subs(diff(Tt.z2,t), {diff(X1(t),t), diff(X2(t),t), diff(X3(t),t),diff(X4(t),t), X1(t), X2(t), X3(t), X4(t)},{Dx(1), Dx(2),Dx(3), Dx(4), invT.x1, invT.x2, invT.x3, invT.x4}));
Dz3=simplify(subs(diff(Tt.z3,t), {diff(X1(t),t), diff(X2(t),t), diff(X3(t),t),diff(X4(t),t), X1(t), X2(t), X3(t), X4(t)},{Dx(1), Dx(2),Dx(3), Dx(4), invT.x1, invT.x2, invT.x3, invT.x4}));
Dz4=simplify(subs(diff(Tt.z4,t), {diff(X1(t),t), diff(X2(t),t), diff(X3(t),t),diff(X4(t),t), X1(t), X2(t), X3(t), X4(t)},{Dx(1), Dx(2),Dx(3), Dx(4), invT.x1, invT.x2, invT.x3, invT.x4}));
Dz=[Dz1; Dz2; Dz3; Dz4];

% ZADANIE 5: 
% Uzasadnij, ze postac Dz pozwala na stwierdzenie, iz dynamika pojedynczego
% wahadla z elastycznym przegubem po zastosowaniu linearyzujacego
% sprzezenia zwrotnego i zmiany wspolrzednych (transformacji stanu) jest
% nastepujaca:
% z1'=z2, z2'=z3, z3'=z4, z4'=v
% porownaj wyniki uzyskane tutaj z wynikami prezentowanymi w ksiazce
% autorstwa Slotine & Lee (zob. strony 244)
disp("Zadanie 5:")
disp(Dz)

%% Prawo sterowania dla systemu liniowego gdzie z jest stanem a v wejsciem
% stabilizacja w z=0
z=[z1;z2; z3;z4];
A=double(jacobian(Dz,z));
B=double(jacobian(Dz,v));
closedLoopEigenValues=[-1,-1,-1,-1];
F=-acker(A,B,closedLoopEigenValues);
vz=F*z; % stabilizujace prawo sterowania

% ZADANIE 6:
% porownaj procedure zastosowana tutaj z zawartoscia rozdzialu
% CONTROLLER DESIGN BASED ON INPUT-STATE LINEARIZATION w ksiazce
% autorstwa Slotine & Lee (zob. strony 245 i 246)
disp("Zadanie 6:")
disp(vz)

%% Prawo sterowania dla systemu nieliniowego gdzie x jest stanem a u wejsciem

% 1) zmiana wspolrzednych (transformacja stanu) z z na x w prawie 
% sterowania v
vx=simplify(subs(vz, {z1,z2,z3,z4}, {T.z1, T.z2, T.z3, T.z4}));
% 2) podstawienie vx pod zmienna v w prawie sterowania u
ucl=simplify(subs(u,v,vx));

%% Uklad sprzezenia zwrotnego
% Zadanie sterowania polega na stabilizacji systemu w x=0
% fcl - pole wektorowe ukladu sprzezenia zwrotnego 
fcl=simplify(f+g*ucl);

%% Symulacje
x0=[pi;-10;-pi;10];
z0=[x0(1); 
    x0(2);
   -(k*x0(1) - k*x0(3) + gravity*l1*m1*sin(x0(1)))/(l1^2*m1);
    (k*x0(4))/(l1^2*m1) - (x0(2)*(k + gravity*l1*m1*cos(x0(1))))/(l1^2*m1)];

tf=100;

options = odeset('RelTol',1e-10,'AbsTol',1e-12);
model1=@(t,x)(A+B*F)*x;

% system niesterowany: x'=f(x)+g(x)*0
sf=subs(f, {M1, L1, J1, K1, G},{m1,l1,J, k,gravity});
model2 = matlabFunction(sf,'Vars',{t,[x1;x2;x3;x4]});

% uklad sprzezenia zwrotnego ze stabilizujacym sterownikiem opartym na
% linearyzacji przez sprzezenie zwrotne i transformacje stanu

sfcl=subs(fcl, {M1, L1, J1, K1, G},{m1,l1,J, k,gravity});
model3 = matlabFunction(sfcl,'Vars',{t,[x1;x2;x3;x4]});

[t,state]=ode45(model1,[0,tf], z0, options);
figure(1)
plot(t,state)
xlabel('t'), ylabel('x')
title('stabilizacja zlinearyzowanego systemu ze stanem z')

[t,state]=ode45(model2,[0,tf],x0, options);
figure(2)
plot(t,state)
xlabel('t'), ylabel('x')
title('brak stabilizacji systemu nielinowego (u=0)')

[t,state]=ode45(model3,[0,tf],x0, options);
figure(3)
plot(t,state)
xlabel('t'), ylabel('x')
title('stabilizacja systemu nieliniowego na bazie linearyzacji')

% ZADANIE 7
% Porownaj Figure 1 i Figure 2. Jakie wnioski mozna sformulowac na temat
% czasu ustalania sie trajektorii stanu ?
% Porownaj Figure 2 i Figure 3. Co mozna powiedziec o stabilnosci punktu
% rownowagi x0=0 w obydwu przypadkach?