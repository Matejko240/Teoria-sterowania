%INICJALIZACJA_BD - skrypt czyszczący przestrzeń roboczą Matlaba,
%dopisujący odpowiednią ścieżkę dostępu do zmiennej PATH, deklarujący
%zmienne globlny, jak np. baza - zmienna reprezentująca bazę danych, czy A,
%B, C, D - pewne zmienne pomocnicze.

clear all;
close all;
clc;
global baza A B C D;
baza = struct('zmienna1',{},'A',{},'B',{},'C',{},'D',{});
addpath(pwd);
A=[];
B=[];
C=[];
D=[];