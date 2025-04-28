%% Sterowanie z rozmieszczaniem biegunow

clear all
close all

%% Pary (A,B) do dalszych badan numerycznych
m=2;                       % kg, masa satelity
omega=2*pi/(24*60*60);       % rad/s
R=(4e14/(omega^2))^(1/3);  % m, promień orbity satelity

A1= ...
[        0,             1, 0,          0; ...
 3*omega^2,             0, 0,  2*omega*R; ...
         0,             0, 0,          1; ...
         0, -(2*omega)/R , 0,          0 ...
];

B1= ...
[ ...
  0,          0; ...
1/m,          0; ...
  0,          0; ...
  0, 1/(m*R^2); ...
];

M=100; % kg            masa wozka
M1=10; % kg            masa pierwszego ogniwa wahadla
M2=10; % kg            masa drugiego ogniwa wahadla
L1=2;  % m             dlugosc pierwszego ogniwa wahadla
L2=1;  % m             dlugosc drugiego ogniwa wahadla
g=9.81; % m/s^2        przyspieszenie ziemskie

A2=[...
 0,                         0,                                      0, 1, 0, 0; ...
 0,                         0,                                      0, 0, 1, 0; ...
 0,                         0,                                      0, 0, 0, 1; ...
 0,          -(g*(M1 + M2))/M,                                      0, 0, 0, 0; ...
 0,  (g*(M + M1 + M2))/(L1*M),                        -(M2*g)/(L1*M1), 0, 0, 0; ...
 0, -(g*(M + M1 + M2))/(L1*M), (g*(L1*M1 + L1*M2 + L2*M2))/(L1*L2*M1), 0, 0, 0 ...
];

B2=[...
        0;...
        0;...
        0;...
      1/M;...
-1/(L1*M);...
 1/(L1*M) ...
 ];

%% Sterowalnosc
disp('========== sterowalnosc ==========')

F1=rand(flip(size(B1)))*mean(mean(A1));
F2=rand(flip(size(B2)))*mean(mean(A2));

eigA1=eig(A1);
eigA1=sort(eigA1,'ComparisonMethod','real');
eigA1B1F1=eig(A1+B1*F1);
eigA1B1F1=sort(eigA1B1F1,'ComparisonMethod','real');

eigA2=eig(A2);
eigA2=sort(eigA2,'ComparisonMethod','real');
eigA2B2F2=eig(A2+B2*F2);
eigA2B2F2=sort(eigA2B2F2,'ComparisonMethod','real');

disp('---eig(A1), eig(A1+B1*F1)----')
disp(eigA1)
disp(eigA1B1F1)
disp('---eig(A2), eig(A2+B2*F2)----')
disp(eigA2)
disp(eigA2B2F2)

Omega1=B1;
for i=1:(size(A1,1)-1)
    Omega1=[B1, A1*Omega1];
end                  % implementacja wlasna [B AB A^B .. A^(n-1)B]
Omega2=ctrb(A2, B2); % funkcja Matlab wyliczajaca [B AB A^B .. A^(n-1)B]

if abs(det(Omega1'*Omega1)) > 0
    disp('(A1,B1) jest sterowalna')
else
    disp('(A1,B1) jest niesterowalna')
end
if abs(det(Omega2'*Omega2)) > 0
    disp('(A2,B2) jest sterowalna')
else
    disp('(A2,B2) jest niesterowalna')
end

% badania symulacyjne dla ukladow sprzezenia zwrotnego 1 i 2 dla roznych F
figure(1)
A=A1;
x0=rand(size(A,1),1);
[t,x]=ode45(@(t,x)A*x, [0,10], x0);
plot(t,x), title('system 1, zerowy sygnal wejsciowy')
figure(2)
A=A2;
x0=rand(size(A,1),1);
[t,x]=ode45(@(t,x)A*x, [0,10], x0);
plot(t,x), title('system 2, zerowy sygnal wejsciowy') 
figure(3)
A=A1+B1*F1;
x0=rand(size(A,1),1);
[t,x]=ode45(@(t,x)A*x, [0,10], x0);
plot(t,x), title('system 1, u=F1*x, F1=random') 
figure(4)
A=A2+B2*F2;
x0=rand(size(A,1),1);
[t,x]=ode45(@(t,x)A*x, [0,10], x0);
plot(t,x) , title('system 2, u=F2*x, F2=random')
%% Zmiana wspolrzednych

disp('========== zmiana wspolrzednych ==========')

T1=rand(size(A1))*mean(mean(A1));
A1t=T1*A1*inv(T1);
T2=rand(size(A2))*mean(mean(A2));
A2t=T2*A2*inv(T2);

eigA1t=eig(A1t);
eigA2t=eig(A2t);
eigA1t=sort(eigA1t,'ComparisonMethod','real');
eigA2t=sort(eigA2t,'ComparisonMethod','real');

disp('---eig(A1), eig(T1*A1*inv(T1))----')
disp(eigA1)
disp(eigA1t)
disp('---eig(A2), eig(T2*A2*inv(T2)----')
disp(eigA2)
disp(eigA2t)

disp('========== postac kanoniczna sterownika ==========')
vT=[zeros(1,size(Omega2,1)-1),1]*inv(Omega2);
T=vT;
for i=1:size(A2,1)-1
    T=[T;vT*A2^i];
end
A2tc=T*A2*inv(T);
B2tc=T*B2;
disp('--- T*A2*inv(T) ---')
disp(A2tc)
disp('--- T*B2 ---')
disp(B2tc)

disp('--- ostatni wiersz -A2tc (odwrocony) i wielomian charakterystyczny A2 ---')
poly1=[1,flip(-A2tc(end,:))];
poly2=charpoly(A2tc);
disp(poly1)
disp(poly2)

%% Formula Ackermanna
disp('========== formula Ackermanna  ==========')
desiredClosedLoopEigenvalues=...
    [-7.5+0.3*i,-7.5-0.3*i,-6.5+0.9*i,-6.5-0.9*i,-3.3+2.3i,-3.3-2.3i];
desiredCLCharPoly=poly(desiredClosedLoopEigenvalues);
desiredCLCharPolyCoeff=flip(desiredCLCharPoly);
desiredCLCharPolyCoeff(end)=[];
Ft=-A2tc(end,:)-desiredCLCharPolyCoeff;
F=Ft*T;
disp('--- A2tc+B2tc*Ft ---')
A2tcB2tcFt=A2tc+B2tc*Ft;
disp(A2tcB2tcFt)

A2B2F=A2+B2*F;

chp1=charpoly(A2tcB2tcFt);
chp2=charpoly(A2B2F);

disp('--- pozadany wielomian charakterystyczny macierzy sprzezenia zwrotnego ---')
disp(desiredCLCharPoly)
disp('--- wielomian charakterystyczny A2tc+B2tc*Ft---')
disp(chp1)
disp('--- wielomian charakterystyczny A2+B2*F---')
disp(chp2)

% badania symulacyjne ukladu sprzezenia zwrotnego
x0=rand(size(A2,1),1);
x0t=T*x0;
figure(5)
A=A2tcB2tcFt;
[t,x]=ode45(@(t,x)A*x, [0,10], x0t);
plot(t,x), title('system 2 (kanon. post. sterow.), u=F*x, rozmieszczanie biegunow')

figure(6)
A=A2B2F;
[t,x]=ode45(@(t,x)A*x, [0,10], x0);
plot(t,x), title('system 2, u=F*x, rozmieszczanie biegunow')
