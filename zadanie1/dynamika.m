% DYNAMIKA - Równanie różniczkowe ẋ = Ax + Bu
function xdot = dynamika(t, x)
    global A B;

    [n, m] = size(B);
    u_scalar = impuls(t);
    u = u_scalar * ones(m, 1);

    % sprawdź, czy rozmiary się zgadzają
    if size(B,2) ~= size(u,1)
        error('Niepoprawny wymiar: B ma %d kolumn, u ma %d wierszy.', size(B,2), size(u,1));
    end

    xdot = A * x + B * u;
end
