%IMPULS - funkcja matlabowa, która reprezentuje matematyczną funkcję
%impuls(t). Wstępnie przyjąć, że sigma~0,005

function y=impuls(t)
sigma=0.005;
y=(1/sqrt(2*(sigma^2)*pi))*exp((-t.^2)/(2*(sigma^2)));
end