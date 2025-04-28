%% A.6 STABLIZACJA PODWOJNEGO WAHADLA NA WOZKU
clear all
close all

%% A.6.1 Modelowanie matematyczne
% deklarowanie zmiennych symbolicznych i funkcji symbolicznych
syms t q(t) th1(t) th2(t) D2q D2th1 D2th2 x1 x2 x3 x4 x5 x6 u M M1 M2 L1 L2 g

% definiowanie parametrow podwojnego wahadla na wozku
m=100; % kg            masa wozka
m1=10; % kg            masa pierwszego ogniwa wahadla
m2=10; % kg            masa drugiego ogniwa wahadla
l1=2;  % m             dlugosc pierwszego ogniwa wahadla
l2=1;  % m             dlugosc drugiego ogniwa wahadla
gravity=9.81; % m/s^2  przyspieszenie ziemskie

% energia potencjalna i kinetyczna podwojnego wahadla na wozku
PE=M1*g*L1*cos(th1)+M2*g*(L1*cos(th1)+L2*cos(th1+th2));
KE=sym(1)/2*M*diff(q,t)^2+...
    sym(1)/2*M1*( ...
    (diff(q,t)+L1*diff(th1,t)*cos(th1))^2 ...
    + (L1*diff(th1,t)*sin(th1))^2 ) + ...
    sym(1)/2*M2*( ...
    (diff(q,t)+L1*diff(th1,t)*cos(th1) ...
    + L2*(diff(th1,t)+diff(th2,t))*cos(th1+th2))^2 ... 
    + (L1*diff(th1,t)*sin(th1)...
    + L2*(diff(th1,t)+diff(th2,t))*sin(th1+th2))^2 );

% funkcja Lagrangea dla podwojnego wahadla na wozku
L=KE-PE;

% dynamika dwuwahadla na wozku w formie rownan Eulera-Lagrangea
D11  = diff(L,diff(q(t),t));
D21  = diff(L,q);
eqn1 = diff(D11,t) - D21 == u;

D12  = diff(L,diff(th1(t),t));
D22  = diff(L,th1);
eqn2 = diff(D12,t) - D22 == 0;

D13  = diff(L,diff(th2(t),t)); % blednie, wpisz tutaj poprawne wyrazenie
D23  = diff(L,th2); % blednie, wpisz tutaj poprawne wyrazenie
eqn3 = diff(D13,t)-D23==0; % blednie, wpisz tutaj poprawne wyrazenie

% transformacja rownan dynamiki do rownan ze zmiennymi stanu
%
% krok 1: Pod q, th1, th2, q', th1', th2' sa podstawiane ... 
% x1, x2, x3, x4, x5, x6 w rownaniach EQN1, EQN3, EQN2. 
% Pod q'', th1'' and th2'' sa podstawiane D2r, D2th1, D2th2 
% odpowiednio. Ostatnie podstawienie ma charakter techniczny na potrzeby 
% funkcji solve, uzytej ponizej.
E1 = subs(eqn1, ...
    {diff(q,t,t), diff(th1,t,t), diff(th2,t,t), ...
     diff(q,t),   diff(th1,t),   diff(th2,t), ...
     q(t),        th1(t),         th2(t)},...
    {D2q, D2th1, D2th2, x4, x5, x6, x1, x2, x3});

E2 = subs(eqn2, ...
    {diff(q,t,t), diff(th1,t,t), diff(th2,t,t), ...
     diff(q,t),   diff(th1,t),   diff(th2,t), ...
     q(t),        th1(t),         th2(t)},...
    {D2q, D2th1, D2th2, x4, x5, x6, x1, x2, x3});

E3 = sym(0); % blednie, wpisz tutaj poprawne wyrazenie

% krok 2: Wyrazenie q'', th1'', th2'', reprezentowanych przez D2q, D2th1, D2th2, 
% poprzez zmienne stanu x1, x2, x3, x4, x5, x6
[F1, F2, F3]=solve([E1, E2, E3], [D2q, D2th1, D2th2]);

% krok 3: Upraszczanie wyrazen otrzymanych w kroku 2
%
F1=simplify(F1); % blednie, napisz: simplify(F1);
F2=simplify(F2); % blednie, wpisz tutaj poprawne wyrazenie
F3=simplify(F3); % blednie, wpisz tutaj poprawne wyrazenie

% krok 4 (dynamika dwuwahadla na wozku)
% x'=f(x,u)
% y =h(x,u)
% Definiowanie f i h:
f=[x4; x5; x6; F1; F2; F3];
h=[x1;L1*sin(x2); x1+L1*sin(x2)+L2*sin(x2+x3)];

%% A.6.2 Linearyzacja (aproksymacja liniowa)
% weryfikacja wybranych rozwiazan rownania dynamiki dwuwahadla na wozku

% x(t)=[0;0;0;0;0;0];, u(t)=0;
test1=simplify(diff([0;0;0;0;0;0],t)...
    -subs(f,{x1,x2,x3,x4,x5,x6,u},...
    {0,0,0,0,0,0,0}));
if all(test1==0) 
    disp('x(t)=[0;0;0;0;0;0] is a solution of the double pendulum on the cart state space equations');
end

% wyznaczanie macierzy A, B, C przyblizenia liniowego
% x'=f(x,u)
% y =h(x,u)
% w punkcie rownowagi

% krok 1: Wyznaczanie Jacobianow
JA=jacobian(f,[x1,x2,x3,x4,x5,x6]);
JB=jacobian(f,u); % blednie, wpisz tutaj poprawne wyrazenie
JC=jacobian(h,[x1,x2,x3,x4,x5,x6]); % blednie, wpisz tutaj poprawne wyrazenie

% krok 2: Wyznaczanie symbolicznych macierzy A, B, C, stowarzyszonych
% z punktem rownowagi [0,0,0,0,0,0]'
SA=simplify(subs(JA,{x1,x2,x3,x4,x5,x6,u},{0,0,0,0,0,0,0}));
SB=simplify(subs(JB,{x1,x2,x3,x4,x5,x6,u},{0,0,0,0,0,0,0})); % blednie, wpisz tutaj poprawne wyrazenie
SC=simplify(subs(JC,{x1,x2,x3,x4,x5,x6,u},{0,0,0,0,0,0,0})); % blednie, wpisz tutaj poprawne wyrazenie

% 
% krok 3: Wyznaczanie numerycznych macierzy A, B, C poprzez podstawienie
% numerycznych wartości parametrów dynamiki dwuwahadla na wozku pod
% odpowiadajace im zmienne w symbolicznych macierzach, 
% otrzymanych w kroku 2.
A=double(simplify(subs(SA, {M,M1,M2,L1,L2,g},{m,m1,m2,l1,l2,gravity})));
B=double(simplify(subs(SB, {M,M1,M2,L1,L2,g},{m,m1,m2,l1,l2,gravity}))); % blednie, wpisz tutaj poprawne wyrazenie
C=double(simplify(subs(SC, {M,M1,M2,L1,L2,g},{m,m1,m2,l1,l2,gravity}))); % blednie, wpisz tutaj poprawne wyrazenie

%
% krok 4:
% x'=A*x + B*u
% Liniowa aproksymacja f(x,u) przez fl(x,u):=A*x + B*u
fl=sym(0); % blednie, napisz: A*[x1;x2;x3;x4;x5;x6]+B*u;

%% A.6.3 Analiza modelu
% stablilność aproksymacji liniowej
disp('A.6.3')

disp('testowanie stabilnosci:')
nA=size(A,1);
ev=eig(A);
if all(real(ev)<0) disp("aproksymacja liniowa (A,B) jest asymptotycznie stabilna"); 
else
    if any(real(ev)>0) disp("aproksymacja liniowa (A,B) jest niestabilna (re eig(A) >0)");
    else
        stability=true; 
        for i=1:length(ev)
            evm(i,1)=ev(i);
            evm(i,2)=sum(ev==ev(i));
            evm(i,3)=rank(null(eye(nA)*ev(i)-A));
            if all([real(evm(i,1))==0, evm(i,2)~=evm(i,3)])
                stability=false;
            end
        end
        if stability 
            disp("aproksymacja liniowa (A,B) jest stabilna"); 
        else
            disp("aproksymacja liniowa (A,B) jest niestabilna");
        end
    end
end
% disp('badanie sterowalnosci:')
% if rank(ctrb(A,B)) == size(A,1) disp('aproksymacja liniowa (A,B) jest sterowalna'); end;
% if rank(ctrb(A,B))  < size(A,1) disp('aproksymacja liniowa (A,B) jest niesterowalna'); end;

%% A.6.4 Symulacja
% badania symulacyjne dynamiki dwuwahadla na wozku

T=10; % czas koncowy symulacji

% % definicja sygnalu sterujacego - sprzezenia zwrotnego od stanu -   
% % stabilizujacego dwuwahadlo na wozku w xe=0
% % u=K*x
% 
% P=[-7.5+0.3i, -7.5-0.3i, -6.5+0.9*i,...
%     -6.5-0.9*i, -3.3+2.3i, -3.3-2.3i]; % pozadane bieguny ukladu
%     sprzezenia zwrotnego
% K=-acker(A,B,P); % wzmocnienie sprzezenia zwrotnego (rozmieszczanie 
%     biegunow, formula Ackermanna)
% Su=K*[x1;x2;x3;x4;x5;x6]; % prawo sterowania w postaci symbolicznej
% fcl=subs(f,{u},{Su}); % fcl(x)=f(x, K*x)
% fcl=simplify(fcl);
% flcl=subs(fl,{u},{Su}); % flcl=A*x+B*K*x
% flcl=simplify(flcl);

% % 0
% % stan systemu w puncie rownowagi
% 
% % warunek poczatkowy
% x0=[0;0;0;0;0;0];
% 
% % utworzenie dynamiki dwuwahadla na wozku (dpcD)
% dpcDf=subs(fcl,{M,M1,M2,L1,L2,g},{m,m1,m2,l1,l2,gravity});
% dpcD = matlabFunction(dpcDf,'Vars',{t,[x1;x2;x3;x4;x5;x6]});
% % utworzenie dynamiki aproksymacji liniowej dwuwahadla na wozku (dpcLD)
% dpcLDfl=subs(flcl,{M,M1,M2,L1,L2,g},{m,m1,m2,l1,l2,gravity});
% dpcLD = matlabFunction(dpcLDfl,'Vars',{t,[x1;x2;x3;x4;x5;x6]});
% 
% % symulacja dynamiki wahadla na wozku (dpcD) i tworzenie wykresow
% [ts,ys] = ode45(dpcD,[0 T],x0);
% figure(1)
% subplot(2,1,1)
% plot(ts,ys)
% title("model nieliniowy")
% xlabel("t[s]"), ylabel("x")
% % symulacja dynamiki aproksymacji liniowej dwuwahadla na wozku (dpcD) i tworzenie wykresow
% [ts,ys] = ode45(dpcLD,[0 T],x0);
% subplot(2,1,2)
% plot(ts,ys)
% title("model liniowy")
% xlabel("t[s]"), ylabel("x")
% 
% 
% % 1
% % stan systemu w otoczeniu punktu rownowagi
% 
% x0=[-0.5;0;0;0;0;0];
% % symulacja dynamiki wahadla na wozku (dpcD) i tworzenie wykresow
% [ts,ys] = ode45(dpcD,[0 T],x0);
% figure(2)
% subplot(2,1,1)
% plot(ts,ys)
% title("model nieliniowy")
% xlabel("t[s]"), ylabel("x")
% % symulacja dynamiki aproksymacji liniowej dwuwahadla na wozku (dpcD) i tworzenie wykresow
% [ts,ys] = ode45(dpcLD,[0 T],x0);
% subplot(2,1,2)
% plot(ts,ys)
% title("model liniowy")
% xlabel("t[s]"), ylabel("x")
