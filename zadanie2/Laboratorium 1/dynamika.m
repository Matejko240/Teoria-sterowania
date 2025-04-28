%DYNAMIKA - funkcja reprezentująca równanie różniczkowe x=Ax+Bu, gdzie
%u(t)=impuls(t). A, B są zmiennymi globalnymi.

function xdot=dynamika(t,x)
global A B;
xdot=A*x+B*impuls(t);
end