%% A.4 DYNAMIKA SATELITY
clear all
close all

%% A.4.2 Modelowanie matematyczne
% konstruowanie (deklarowanie) zmiennych symbolicznych i funkcji symbolicznych
syms t r(t) th(t) phi(t) D2r D2phi x1 x2 x3 x4 ur uth dr dth R OMEGA DELTA M K

% definiowanie parametrow satelity
T=24*60*60;           % s, okres obrotu Ziemi 
m=2;                  % kg
k=4e14;               % m^3/s^2
omega=2*pi/T;         % rad/s
rR=(k/omega^2)^(1/3); % m, srednica orbity satelity

% energia kinetyczna i potencjalna satelity
PE=-(K*M)/r;
KE=sym(1)/2*M*(diff(r,t)^2 + r^2*diff(th,t)^2);

% funkcja Lagrange satelity
L=KE-PE;

% dynamika satelity wyrazona przez rownania Eulera-Lagrange'a
D11  = diff(L,diff(r(t),t));
D21  = diff(L,r);
eqn1 = diff(D11,t) - D21 == ur+dr;
% wyrazenie zmiennej th przy uzyciu zmiennej phi poprzez operacje 
% podstawienia
EQN1 = subs(eqn1, th(t), phi(t)+OMEGA*t);

D12  = diff(L,diff(th(t),t));
D22  = diff(L,th);
eqn2 = diff(D12,t) - D22 == uth+dth;
% wyrazenie zmiennej th przy uzyciu zmiennej phi poprzez operacje 
% podstawienia
EQN2 = subs(eqn2, th(t), phi(t)+OMEGA*t);

% przeksztalcenie rownan dynamiki satelity do ukladu rownan ze zmiennymi stanu
%
% krok 1: w miejsce r, r', phi, phi' sa podstawiane x1, x2, x3, x4 w
% rownaniach EQN1 and EQN2. r'' i phi '' sa zastapione przez  D2r i D2phi
% odpowiednio. Ostatnie podstawienie ma charakter techniczny i jest wykonane 
% z uwagi na wymagania funkcji solve, uzytej ponizej
E1 = subs(EQN1, ...
    {diff(r,t,t), diff(phi,t,t), diff(r,t), diff(phi,t), r(t), phi(t)},...
    {D2r, D2phi, x2, x4, x1, x3});

E2 = subs(EQN2, ...
    {diff(r,t,t), diff(phi,t,t), diff(r,t), diff(phi,t), r(t), phi(t)},...
    {D2r, D2phi, x2, x4, x1, x3});

% krok 2: wyrazenie r'', phi'', reprezentowanych przez D2r i D2phi, przez
% zmienne stanu x1, x2, x3, x4
[F1, F2]=solve(E1, E2, D2r, D2phi);

% krok 3: uproszczenie wyrazen otrzymaych w kroku 2
%
F1=simplify(F1);
F2=simplify(F2);

% krok 4 (dynamika satelity telekomunikacyjnego)
% x'=f(x,u)
% y =h(x,u)
% derivation of f and h:
f=[x2;F1;x4;F2];
h=[x1;x3];

%% A.4.3 analiza punktu rownowagi
% weryfikacja wybranych rozwiazan ukladu rownan satelity ze zmiennymi stanu

disp('A.4.3')

% x(t)=[R;0;0;0];
test1=simplify(diff([R;0;0;0],t)...
    -subs(f,{x1,x2,x3,x4,ur,dr,uth,dth,K},...
    {R,0,0,0,0,0,0,0,OMEGA^2*R^3}));
if all(test1==0) 
    disp('x(t)=[R;0;0;0] jest rozwiazaniem ukladu rownan ze zmiennymi stanu satelity');
end

% x(t)=[(K/(OMEGA+DELTA)^2)^(1/3);0;DELTA*t;diff(DELTA*t,t)];
test2=simplify(diff([(K/(OMEGA+DELTA)^2)^(1/3);0;DELTA*t;diff(DELTA*t,t)],t)...
    -subs(f,{x1,x2,x3,x4,ur,dr,uth,dth},...
    {(K/(OMEGA+DELTA)^2)^(1/3),0,DELTA*t,diff(DELTA*t,t),0,0,0,0}));
if all(test2==0) 
    disp('x(t)=[(K/(OMEGA+DELTA)^2)^(1/3);0;DELTA*t;diff(DELTA*t,t)] jest rozwiazaniem ukladu rownan ze zmiennymi stanu satelity');
end

%% A.4.4 Linearyzacja
% wyznaczanie macierzy A, B, C w przyblizeniu liniowym rownania
% x'=f(x,u)
% y =h(x,u)
% w punkcie rownowagi

% krok 1: wyliczanie jakobianow
JA=jacobian(f,[x1,x2,x3,x4]);
JB=jacobian(f,[ur,uth,dr,dth]);
JC=jacobian(h,[x1,x2,x3,x4]);

% krok 2: wyliczanie macierzy symbolicznych A, B, C, stowarzyszonych
% z punktem rownowagi [R,0,0,0]', z uwzglednieniem ze 
% K=OMEGA^2*R^3
SA=simplify(subs(JA,{x1,x2,x3,x4,ur,dr,uth,dth,K},{R,0,0,0,0,0,0,0,OMEGA^2*R^3}));
SB=simplify(subs(JB,{x1,x2,x3,x4,ur,dr,uth,dth},{R,0,0,0,0,0,0,0}));
SC=simplify(subs(JC,{x1,x2,x3,x4},{0,0,0,0}));

% 
% krok 3: wyznaczanie wartosci numerycznych macierzy A, B, C przez podstawienie
% parametrow satelity pod odpowiednie zmienne symboliczne
% w macierzach symbolicznych otrzymanych w kroku 2.
A=double(simplify(subs(SA, {K,M,OMEGA,R},{k,m,omega, rR})));
B=double(simplify(subs(SB, {K,M,OMEGA,R},{k,m,omega, rR})));
C=double(simplify(subs(SC, {K,M,OMEGA,R},{k,m,omega, rR})));

%
% krok 4:
% x'=A*x + B*u
% liniowe przyblizenie f(x,u) przez fl(x,u):=A*x + B*u
fl=A*[x1;x2;x3;x4]+B*[ur;uth;dr;dth];

%% A.4.5 Analiza modelu
% stabilnosc przyblizenia liniowego
% disp('A.4.5')

disp('A.4.5')
disp('testowanie stabilnosci:')
ev=eig(A);
disp(ev);

%% A.4.6 Symulacje
% badania symulacyjne dynamiki satelity

% definicja typowego sygnalu wejciowego uzywanego podczas badan symulacyjnych
% dynamiki satelity
u0=@(t)0;

% 0
% system w punkcie rownowagi

% warunki poczatkowe i zaklocenie radialne
dr0=@(t)0;
x0=[rR;0;0;0];
x0L=x0-[rR;0;0;0];

% tworzenie kodu dla dynamiki satelity (sD)
sDf=subs(f,{K,M,OMEGA,R,dr,dth,ur,uth},{k,m,omega,rR,dr0,u0,u0,u0});
sD = matlabFunction(sDf,'Vars',{t,[x1;x2;x3;x4]});
% tworzenie kodu dla aproksymacji liniowej dynamiki satelity (sLD)
sLDfl=subs(fl,{dr,dth,ur,uth},{dr0,u0,u0,u0});
sLD = matlabFunction(sLDfl,'Vars',{t,[x1;x2;x3;x4]});

% symulacja i kreslenie wykresow dla dynamiki satelity (sD)
[ts,ys] = ode45(sD,[0 T],x0);
figure(1)
subplot(2,1,1)
plot(ts,ys)
title("Model nieliniowy")
xlabel("t [s]");
ylabel("x");
% symulacja i kreslenie wykresow dla aproksymacji liniowej dynamiki satelity (sLD) 
[ts,ys] = ode45(sLD,[0 T],x0L);
subplot(2,1,2)
plot(ts,ys)
title("Aproksymacja liniowa")
xlabel("t[s]");
ylabel("x");

% 1
% 1%--we zaburzenie r(0) wzgledem promienia orbity geostacjonarnej

% warunki poczatkowe (radialne zaklocenie jest niezmienione)
x0=[rR*1.01;0;0;0];
x0L=x0-[rR;0;0;0];

% ZADANIE 1
% symulacja i kreslenie wykresow dla dynamiki satelity (sD)
[ts, ys] = ode45(sD, [0 T], x0);
figure;
subplot(2,1,1);
plot(ts, ys);
title("Model nieliniowy - Zadanie 1");
xlabel("t [s]"), ylabel("x");

% symulacja i kreslenie wykresow dla aproksymacji liniowej dynamiki satelity (sLD)
[ts, ys] = ode45(sLD, [0 T], x0L);
subplot(2,1,2);
plot(ts, ys);
title("Aproksymacja liniowa - Zadanie 1");
xlabel("t [s]"), ylabel("x");

% 1%-we zaburzenie phi(0) wzgledem pelnego obrotu Ziemi wzgledem swojej osi

% warunki poczatkowe (radialne zaklocenie jest niezmienione)
x0=[rR;2*pi/100;0;0];
x0L=x0-[rR;0;0;0];

% ZADANIE 2
% symulacja i kreslenie wykresow dla dynamiki satelity (sD)
[ts, ys] = ode45(sD, [0 T], x0);
figure;
subplot(2,1,1);
plot(ts, ys);
title("Model nieliniowy - Zadanie 2");
xlabel("t [s]"), ylabel("x");

% symulacja i kreslenie wykresow dla aproksymacji liniowej dynamiki satelity (sLD)  
[ts, ys] = ode45(sLD, [0 T], x0L);
subplot(2,1,2);
plot(ts, ys);
title("Aproksymacja liniowa - Zadanie 2");
xlabel("t [s]"), ylabel("x");

% 2
% radialne zaklocenie skokowe o wartosci 5% grawitacyjnego przyciagania 
% satelity przez ziemie

% warunki poczatkowe i radialne zaklocenie
dr1=@(t)(sign(t)+1)*m*9.81/2*0.05;
x0=[rR;0;0;0];
x0L=x0-[rR;0;0;0];

% ZADANIE 3
% tworzenie kodu dla dynamiki satelity (sD)
sDf= 0; %jest nieprawidlowo (zrobione w celu zapewnienia wykonywalnosci skryptu)
sD = 0; %jest nieprawidlowo
% tworzenie kodu dla aproksymacji liniowej dynamiki satelity (sLD)
sLDfl= 0; %jest nieprawidlowo
sLD =  0; %jest nieprawidlowo

% symulacja i kreslenie wykresow dla dynamiki satelity (sD)  

[ts, ys] = ode45(sD, [0 T], x0);
figure;
subplot(2,1,1);
plot(ts, ys);
title("Model nieliniowy - Zadanie 3");
xlabel("t [s]"), ylabel("x");

% symulacja i kreslenie wykresow dla aproksymacji liniowej dynamiki satelity (sLD)  
[ts, ys] = ode45(sLD, [0 T], x0L);
subplot(2,1,2);
plot(ts, ys);
title("Aproksymacja liniowa - Zadanie 3");
xlabel("t [s]"), ylabel("x");


% 3
% radialne zaklocenie o charakterze okresowym z amplituda rowna 5%  
% grawitacyjnego przyciagania satelity przez Ziemie o okresie rownym okresowi
% obrotu Ziemi

% radialne zaklocenie (warunki poczatkowe sa niezmienione)
dr2=@(t)cos(2*pi/T*t)*m*9.81*0.05;


% ZADANIE 4
% tworzenie kodu dla dynamiki satelity (sD)
sDf= 0; %jest nieprawidlowo (zrobione w celu zapewnienia wykonywalnosci skryptu)
sD = 0; %jest nieprawidlowo 
% tworzenie kodu dla aproksymacji liniowej dynamiki satelity (sLD)
sLDfl= 0; %jest nieprawidlowo 
sLD = 0;  %jest nieprawidlowo

% symulacja i kreslenie wykresow dla dynamiki satelity (sD)  

% symulacja i kreslenie wykresow dla aproksymacji liniowej dynamiki satelity (sLD)  

