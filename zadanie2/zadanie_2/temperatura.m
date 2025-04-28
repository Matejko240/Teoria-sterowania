
%% TEMPERATURA - Regulacja temperatury pomieszczenia

clear all;
close all;

%% Parametry modelu zrównoważonego (liniowy model stanu)
alpha1 = 0.5; alpha2 = 1; alpha3 = 0.1; alpha4 = 0.2;
beta1 = 0.1;
gamma1 = 0.7; gamma2 = 0.05;

A = [-alpha1,       0,        0;
      alpha2, -alpha2,   alpha3;
           0,  alpha4,  -alpha4];

B1 = [beta1; 0; 0];      % wpływ sygnału sterującego u
B2 = [alpha1; 0; 0];     % wpływ temperatury otoczenia To
C  = [0, -gamma2, gamma1]; % pomiar wysokości słupka rtęci h

%% Pobudzenie: To = skok jednostkowy
To = @(t) 1 * (t >= 0);
u_zero = @(t) 0;

%% System bez sterowania 
u = @(t) 0;  % brak sterowania
sys = SystemDynamiczny("Bez sterowania", A, B2, C, 0, @(t) To(t));
x0 = [0; 0; 0];
tk = 100;
[x, y, u_val, t] = sys.trajektoria(tk, x0);

figure;
plot(t, x);
legend("T_p", "T_sz", "T_Hg");
title("Temperatury bez sterowania (To=1, u=0)");
xlabel("Czas"); grid on;

figure;
plot(t, y);
title("Odpowiedź h - reakcja odwrotna");
xlabel("Czas"); ylabel("h"); grid on;

%% System ze sterowaniem proporcjonalnym 
Kp = 0.5;  
u = @(t, x) Kp * (C * x); % u = Kp * h

% A_bar = A + B1 * Kp * C
Abar = A + B1 * Kp * C;
sys_p = SystemDynamiczny("Sterowanie proporcjonalne", Abar, B2, C, 0, @(t) To(t));

[x, y, u_val, t] = sys_p.trajektoria(tk, x0);

figure;
plot(t, x);
legend("T_p", "T_sz", "T_Hg");
title("Temperatury - sterowanie proporcjonalne");
xlabel("Czas"); grid on;

figure;
plot(t, y);
title("h - sterowanie proporcjonalne");
xlabel("Czas"); ylabel("h"); grid on;

%% System z regulatorem PI
Kp = 0.5; Ki = 0.1;

% Stany rozszerzone: x = [Tp; Tsz; THg], z = całka(h)
Atilde = [A, zeros(3,1); C, 0];
Btilde1 = [B1; 0];
Btilde2 = [B2; 0];
Ctilde = [C, 0];
Ktilde = [Kp * C, Ki];

Ahat = Atilde + Btilde1 * Ktilde;

sys_PI = SystemDynamiczny("Sterowanie PI", Ahat, Btilde2, Ctilde, 0, @(t) To(t));
x0_PI = [0; 0; 0; 0]; % 3 stany temperatur + 1 całkowany
[x, y, u_val, t] = sys_PI.trajektoria(tk, x0_PI);

figure;
plot(t, x(:,1:3));
legend("T_p", "T_sz", "T_Hg");
title("Temperatury - sterowanie PI");
xlabel("Czas"); grid on;

figure;
plot(t, y);
title("h - sterowanie PI");
xlabel("Czas"); ylabel("h"); grid on;
