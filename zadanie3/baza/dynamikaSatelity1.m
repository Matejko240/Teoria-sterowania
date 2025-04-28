%% A.4 DYNAMIKA SATELITY
clear all
close all

%% A.4.2 Modelowanie matematyczne

% definiowanie parametrow satelity
T=24*60*60;           % s, okres obrotu Ziemi
m=2;                  % kg
k=4e14;               % m^3/s^2
omega=2*pi/T;         % rad/s
rR=(k/omega^2)^(1/3); % m, średnica orbity satelity

% definicje typowych sygnalow wejsciowych uzywanych podczas badan symulacyjnych 
% dynamiki satelity

ur=@(t)0; 
uth=@(t)0; 
dr=@(t)0; 
dth=@(t)0;

% tworzenie kodu dla dynamiki satelity (sD)
% x'=f(x,u)
% derivation of f:
sD=@(t,x)[...
    x(2,:); ...
    -k./(x(1,:).^2)+ x(1,:).*(omega+x(4,:)).^2 + 1.0./(m).*(ur(t)+dr(t));
    0; ...  % jest nieprawidlowo (w celu zapewnienia wykonywalnosci skryptu)
    0  ...  % jest nieprawidlowo 
    ];

%% A.4.3 analiza punktu rownowagi
% weryfikacja wybranych rozwiazan ukladu rownan satelity ze zmiennymi stanu


disp('A.4.3')

x0=[rR;0;0;0];
test1=sD(0,x0);


%% A.4.4 Przyblizenie liniowe
% wyliczanie parametrow A, B, C przyblizenia liniowego
% x'=f(x,u)
% y =h(x,u)
% w punkcie rownowagi

A= ...
[        0,             1, 0,          0; ...
 3*omega^2,             0, 0, 2*omega*rR; ...
         0,             0, 0,          1; ...
         0, -(2*omega)/rR, 0,          0 ...
];

B= ...
[ ...
...
];

C= [];

% tworzenie kodu dla przyblizenia liniowego (sLD)  dynamiki satelity 
% f(x,u) w postaci fl(x,u):=A*x + B*u
sLD=@(t,x)zeros(4,1);  % jest nieprawidlowo (w celu zapewnienia wykonywalnosci skryptu)

%% A.4.5 Analiza modelu
% stabilnosc przyblizenia liniowego
disp('A.4.5')
disp('stability:')
disp('eigenvalues of A')
ev=eig(A)


%% A.4.6 Symulacje
% badania symulacyjne dynamiki satelity

% 0
% system w punkcie rownowagi

% warunki poczatkowe i zaklocenie radialne
x0=[rR;0;0;0]; 
x0L=x0-[rR;0;0;0];

% tworzenie kodu dla dynamiki satelity (sD)
sD=@(t,x)[0; ... % jest nieprawidlowo (w celu zapewnienia wykonywalnosci skryptu)
    0; ... % jest nieprawidlowo
    0; ... % jest nieprawidlowo
    0; ... % jest nieprawidlowo
    ];
% tworzenie kodu dla przyblizenia liniowego dynamiki satelity (sLD)
sLD=@(t,x)zeros(4,1); % jest nieprawidlowo (w celu zapewnienia wykonywalnosci skryptu)

% symulacja i kreslenie wykresow dla dynamiki satelity (sD)
[ts,ys] = ode45(sD,[0 T],x0);
figure(1)
subplot(2,1,1)
plot(ts,ys)
title("nonlinear model")
xlabel("t[s]"), ylabel("x")
% symulacja i kreslenie wykresow dla aproksymacji liniowej dynamiki satelity (sLD)
[tls,yls] = ode45(sLD,[0 T],x0L);
subplot(2,1,2)
plot(tls,yls)
title("linearized model")
xlabel("t[s]"), ylabel("x")

% 1
% 1%--we zaburzenie r(0) wzgledem promienia orbity geostacjonarnej

% warunki poczatkowe (radialne zaklocenie jest niezmienione)
x0=[rR*1.01;0;0;0]; % warunek poczatkowy dla systemu nieliowego
x0L=x0-[rR;0;0;0];  % warunek poczatkowy dla aproksymacji liniowej

% ZADANIE 1
% symulacja i kreslenie wykresow dla dynamiki satelity (sD)

% symulacja i kreslenie wykresow dla aproksymacji liniowej dynamiki satelity (sLD)


% 1%-we zaburzenie phi(0) wzgledem pelnego obrotu Ziemi wzgledem swojej osi

% warunki poczatkowe (radialne zaklocenie jest niezmienione)
x0=[rR;2*pi/100;0;0];
x0L=x0-[rR;0;0;0];

% ZADANIE 2
% symulacja i kreslenie wykresow dla dynamiki satelity (sD)

% symulacja i kreslenie wykresow dla aproksymacji liniowej dynamiki satelity (sLD)


% 2
% radialne zaklocenie skokowe o wartosci 5% grawitacyjnego przyciagania 
% satelity przez ziemie

% warunki poczatkowe i radialne zaklocenie
x0=[rR;0;0;0];
x0L=x0-[rR;0;0;0];
dr=@(t)(sign(t)+1)*m*9.81/2*0.05; 

% ZADANIE 3
% tworzenie kodu dla dynamiki satelity (sD)

% tworzenie kodu dla aproksymacji liniowej dynamiki satelity (sLD)

% symulacja i kreslenie wykresow dla dynamiki satelity (sD)

% symulacja i kreslenie wykresow dla aproksymacji liniowej dynamiki satelity (sLD)


% 3
% radialne zaklocenie o charakterze okresowym z amplituda rowna 5%  
% grawitacyjnego przyciagania satelity przez Ziemie o okresie rownym okresowi
% obrotu Ziemi

% warunki poczatkowe i radialne zaklocenie
dr=@(t)cos(2*pi/T*t)*m*9.81*0.05; 

% ZADANIE 4
% tworzenie kodu dla dynamiki satelity (sD)

% tworzenie kodu dla aproksymacji liniowej dynamiki satelity (sLD)

% symulacja i kreslenie wykresow dla dynamiki satelity (sD)

% symulacja i kreslenie wykresow dla aproksymacji liniowej dynamiki satelity (sLD)
