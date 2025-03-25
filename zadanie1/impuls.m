% IMPULS - Definicja funkcji impulsowej
function y = impuls(t)
    sigma = 0.005;
    y = 1 / sqrt(2 * pi * sigma^2) * exp(-t.^2 / (2 * sigma^2));
end