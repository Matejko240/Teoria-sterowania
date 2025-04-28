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
sD=@(t,x)[
    x(2,:); ...
    -k./(x(1,:).^2) + x(1,:).*(omega+x(4,:)).^2 + (1/m)*(ur(t)+dr(t)); ...
    x(4,:); ...
    -(2*x(2,:)*(omega+x(4,:)))./x(1,:) + (1/(m*x(1,:).^2))*(uth(t)+dth(t))
];

%% A.4.3 analiza punktu rownowagi
disp('A.4.3')

x0=[rR;0;0;0];
test1=sD(0,x0);

%% A.4.4 Przyblizenie liniowe
A= ...
[        0,             1, 0,          0; ...
 3*omega^2,             0, 0, 2*omega*rR; ...
         0,             0, 0,          1; ...
         0, -(2*omega)/rR, 0,          0 ...
];

B = [ 
    0, 0, 0, 0;
    1/m, 0, 1/m, 0;
    0, 0, 0, 0;
    0, 1/(m*rR^2), 0, 1/(m*rR^2)
];

C = [0 0 1 0];

sLD=@(t,x) A*x + B*[ur(t); uth(t); dr(t); dth(t)];

%% A.4.5 Analiza modelu
disp('A.4.5')
disp('stability:')
ev=eig(A);
disp(ev)
%% A.4.6 Symulacje
% badania symulacyjne dynamiki satelity

% 0
% system w punkcie rownowagi
x0=[rR;0;0;0];
x0L=x0-[rR;0;0;0];

[ts,ys] = ode45(sD, [0 T], x0);
figure
subplot(2,1,1)
plot(ts,ys)
title("Model nieliniowy - punkt rownowagi")
xlabel("t[s]"), ylabel("x")

[tsL,ysL] = ode45(sLD, [0 T], x0L);
subplot(2,1,2)
plot(tsL,ysL)
title("Model liniowy - punkt rownowagi")
xlabel("t[s]"), ylabel("x")

% 1
% 1%-we zaburzenie r(0)
x0=[rR*1.01;0;0;0];
x0L=x0-[rR;0;0;0];

[ts,ys] = ode45(sD, [0 T], x0);
figure
subplot(2,1,1)
plot(ts,ys)
title("Model nieliniowy - 1% zaburzenie r(0)")
xlabel("t[s]"), ylabel("x")

[tsL,ysL] = ode45(sLD, [0 T], x0L);
subplot(2,1,2)
plot(tsL,ysL)
title("Model liniowy - 1% zaburzenie r(0)")
xlabel("t[s]"), ylabel("x")
% 2
% 1%-we zaburzenie phi(0)
x0=[rR;0;2*pi/100;0];
x0L=x0-[rR;0;0;0];

[ts,ys] = ode45(sD, [0 T], x0);
figure
subplot(2,1,1)
plot(ts,ys)
title("Model nieliniowy - 1% zaburzenie phi(0)")
xlabel("t[s]"), ylabel("x")

[tsL,ysL] = ode45(sLD, [0 T], x0L);
subplot(2,1,2)
plot(tsL,ysL)
title("Model liniowy - 1% zaburzenie phi(0)")
xlabel("t[s]"), ylabel("x")


% 3
% radialne zaklocenie skokowe 5%
x0=[rR;0;0;0];
x0L=x0-[rR;0;0;0];
dr=@(t)(sign(t)+1)*m*9.81/2*0.05;

% aktualizacja sD i sLD
sD=@(t,x)[
    x(2,:); ...
    -k./(x(1,:).^2) + x(1,:).*(omega+x(4,:)).^2 + (1/m)*(ur(t)+dr(t)); ...
    x(4,:); ...
    -(2*x(2,:)*(omega+x(4,:)))./x(1,:) + (1/(m*x(1,:).^2))*(uth(t)+dth(t))
];

sLD=@(t,x) A*x + B*[ur(t); uth(t); dr(t); dth(t)];

[ts,ys] = ode45(sD, [0 T], x0);
figure
subplot(2,1,1)
plot(ts,ys)
title("Model nieliniowy - skokowe zaburzenie dr")
xlabel("t[s]"), ylabel("x")

[tsL,ysL] = ode45(sLD, [0 T], x0L);
subplot(2,1,2)
plot(tsL,ysL)
title("Model liniowy - skokowe zaburzenie dr")
xlabel("t[s]"), ylabel("x")


% 4
% radialne zaklocenie okresowe 5%
dr=@(t)cos(2*pi/T*t)*m*9.81*0.05;

% aktualizacja sD i sLD
sD=@(t,x)[
    x(2,:); ...
    -k./(x(1,:).^2) + x(1,:).*(omega+x(4,:)).^2 + (1/m)*(ur(t)+dr(t)); ...
    x(4,:); ...
    -(2*x(2,:)*(omega+x(4,:)))./x(1,:) + (1/(m*x(1,:).^2))*(uth(t)+dth(t))
];

sLD=@(t,x) A*x + B*[ur(t); uth(t); dr(t); dth(t)];

[ts,ys] = ode45(sD, [0 T], x0);
figure
subplot(2,1,1)
plot(ts,ys)
title("Model nieliniowy - okresowe zaburzenie dr")
xlabel("t[s]"), ylabel("x")

[tsL,ysL] = ode45(sLD, [0 T], x0L);
subplot(2,1,2)
plot(tsL,ysL)
title("Model liniowy - okresowe zaburzenie dr")
xlabel("t[s]"), ylabel("x")