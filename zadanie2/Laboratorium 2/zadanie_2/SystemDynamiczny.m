classdef SystemDynamiczny
    % SYSTEMDYNAMICZNY jest klasa, ktora reprezentuje system dynamiczny 
    % liniowy, ciagly w czasie, stacjonarny, SISO,
    % typu wejscie/stan/wyjscie
  
    properties 
        nazwa="bezNazwy";
        A=[0];
        B=[0];
        C=[0];
        D=[0];
        u=@(t)0
    end
    properties (Dependent=true)
        M
    end
	  
    methods
        function obj=SystemDynamiczny(val0, val1, val2, val3, val4, val5)
          % SYSTEMDYNAMICZNY jest konstruktorem parametrycznym.
	  % Umozliwia on utworzenie obiektu tej klasy, ktorego
	  % pola maja przypisane nastepujace wartosci:
	  % nazwa=val0, A=val1, B=val2, C=val3, D=val4, u=val5
            if nargin==6
                obj.nazwa=val0;
                obj.A=val1;
                obj.B=val2;
                obj.C=val3;
                obj.D=val4;
                obj.u=val5;
            end
        end
        function m=get.M(obj)
            % Funkcja jest scisle powiazana z polem zaleznym M. Jej cialo
	    % zawiera odwzorowanie wejscie/stan systemu dynamicznego 
	    % reprezentowanego przez klase. Zmienna m jest uchwytem funkcji
            % stowarzyszonej z odwzorowaniem.
                m=@(t,x)obj.A*x+obj.B*obj.u(t);
        end
        function [x,y,u,t]=trajektoria(obj, tk, x0)
            % TRAJEKTORIA zwraca wartosci stanu, wyjscia i wejscia,
	    % przypisane zmiennym x,y,u odpowiednio, ktore odpowiadaja  
	    % chwilom czasu zapisanym pod zmienna t, z zakresu od 0 do tk,
            % dla warunku poczatkowego x0.
            [t,x]=ode45(obj.M,[0,tk],x0);
            y=(obj.C*x'+obj.D*obj.u(t'))';
            u=obj.u(t');
        end
        function dsplots(obj,tk,x0)
            % DSPLOTS wykresla przebiegi stanu x, wyjscia y i wejscia u
            % jako funkcji czasu na przedziale [0,tk]
	    % dla warunku poczatkowego x0
            [x,y,u,t]=obj.trajektoria(tk, x0);   
            subplot(3,1,1); ... 
                plot(t,y), grid on, xlabel('t'), ylabel('y'), title(obj.nazwa);
            subplot(3,1,2); ... 
                plot(t,x), grid on, xlabel('t'), ylabel('x'), title(obj.nazwa);
            subplot(3,1,3); ...
                plot(t,u), grid on, xlabel('t'), ylabel('u'), title(obj.nazwa);
        end
    end
end
