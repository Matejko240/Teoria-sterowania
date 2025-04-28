%%% BAZADANYCHDRAJWER - skrypt do testowania klasy BazaDanych

%% dokumentacja toolboksu zadanie_2
help zadanie_2

%% dokumentacja klasy 
disp('++++++++++++ dokumentacja klasy +++++++++++++++++')
help BazaDanych

disp('++++++++++++ dokumentacja metod klasy +++++++++++')
help BazaDanych.wczytaj_P
help BazaDanych.wczytaj_k
help BazaDanych.zapisz_bd
help BazaDanych.zawartosc_bd
help BazaDanych.wyszukaj_BD
help BazaDanych.sortuj_N
help BazaDanych.s_stabilne
help BazaDanych.wykresy

%% czynnosci poprzedzajace
clear all
close all

% addpath(pwd);

%% tworzenie obiektu db klasy BazaDanych z następującym
% parametrem: baza_z.txt

db=BazaDanych('baza_z.txt');

%% podstawowe operacje na obiekcie db
disp("++++++++++++ db1 zawartosc_bd +++++++++++++++++++++++++")
db.zawartosc_bd()
disp("++++++++++++ db1 wyszukaj_BD ++++++++++++++++++++++++++")
db.wyszukaj_BD('system');
disp("++++++++++++ db1 sortuj_N +++++++++++++++++++++++++++++")
db.sortuj_N('B');
disp("++++++++++++ db1 s_stabilne +++++++++++++++++++++++++++")
db.s_stabilne()
disp("++++++++++++ db1 wykresy (the word system in the name)+")
db.wykresy("system",10);
disp("++++++++++++ db1 wczytaj_k ++++++++++++++++++++++++++++")
db.wczytaj_k()
disp("++++++++++++ db1 wykresy (wszystkie wykresy) ++++++++++")
db.wykresy("",10);

%% zapisywanie danych z db na pliku baza_x.txt
disp("++++++++++++ db1 zapisz_bd ++++++++++++++++++++++++++++")
db.zapisz_bd('baza_x.txt')

%% tworzenie obiektu db klasy BazaDanych z domyslnymi parametrami
db2=BazaDanych;

%% podstawowe operacje na obiekcie db2
disp("++++++++++++ db2 zawartosc_bd +++++++++++++++++++++++++")
db2.zawartosc_bd()
disp("++++++++++++ db2 wyszukaj_BD ++++++++++++++++++++++++++")
db2.wyszukaj_BD('system');
disp("++++++++++++ db2 sortuj_N +++++++++++++++++++++++++++++")
db2.sortuj_N('B');
disp("++++++++++++ db2 s_stabilne +++++++++++++++++++++++++++")
db2.s_stabilne()
disp("++++++++++++ db2 wykresy (wszystkie wykresy) ++++++++++")
db2.wykresy("",10);
disp(db2.count)
disp("++++++++++++ db2 wczytaj ++++++++++++++++++++++++++++++")
db2.wczytaj_P('baza_x.txt');
disp("++++++++++++ db2 zawartosc_bd +++++++++++++++++++++++++")
disp(db2.count)
db2.zawartosc_bd()
disp("++++++++++++ db2 wyszukaj_BD ++++++++++++++++++++++++++")
db2.wyszukaj_BD('system');
disp("++++++++++++ db2 sortuj_N +++++++++++++++++++++++++++++")
db2.sortuj_N('B');
disp("++++++++++++ db2 s_stabilne +++++++++++++++++++++++++++")
db2.s_stabilne()
disp("++++++++++++ db2 wykresy (wszystkie wykresy) ++++++++++")
db2.wykresy("",10);
