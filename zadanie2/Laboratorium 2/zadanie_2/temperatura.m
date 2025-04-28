%Marcin Sidor 253159

%% Wstęp

clear all;
close all;
clc;

tk=100;
f=0;

%% Parametry macierzy

nazwa="Temperatura";
a1=0.5;
a2=1;
a3=0.1;
a4=0.2;
b1=0.1;
g1=0.7;
g2=0.05;

A=[-a1,0,0;a2,-a2-a3,a3;0,a4,-a4];
B2=[b1;0;0];
B1=[a1;0;0];
B=[B2,B1];
B1_1=[B1;0]
B2_2=[B2;0]

C=[0,-g2,g1];
D=[0];

%Kp=0.2; %Zadanie 3
Kp=0.8; %Zadanie 4 

ki=0.001;
k=[Kp*C ki]

A2=A+(B2.*C)*Kp;
A3=[A [0;0;0];C 0];
C2=[C 0];
A4=A3+B2_2*k;

zero=@(t)0;
skok=@(t)1;
omega=0.0000000000001;
rectangular=@(t)sign(sin(omega*t)); 

ds=SystemDynamiczny(nazwa,A,B1,C,D,skok);

%% Zadanie 2
ds=SystemDynamiczny(nazwa,A,B1,C,D,skok);
x0=[0;0;0];
f=+1; 
figure(f);
ds.dsplots(tk,x0);

%% Zadanie 3
ds=SystemDynamiczny(nazwa,A2,0,C,D,zero);
x0=[1;0;0];
f=+1;
figure(f);
ds.dsplots(tk,x0);

%% Zadanie 4
ds=SystemDynamiczny(nazwa,A2,B1,C,D,skok);
x0=[0;0;0];
f=+1; 
figure(f);
ds.dsplots(tk,x0);

%% Zadanie 5
ds=SystemDynamiczny(nazwa,A4,B1_1,C2,D,skok);
x0=[0;0;0;0];
f=+1; 
figure(f);
ds.dsplots(tk,x0);
