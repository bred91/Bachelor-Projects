function y = rgb2hsi(x);
    x = double(x);
    x = x/255;
    r = x(:,:,1); g = x(:,:,2); b = x(:,:,3);

    % componente H
    num = 0.5*((r-g) + (r-b));
    den = sqrt((r-g).^2 + (r-b).*(g-b));
    theta = acos(num./(den + eps));
    H = theta;
    H(b>g) = 2*pi - H(b>g);
    H = H/(2*pi); % normalizzazione componente H

    % componente S
    num = min(min(r,g),b);
    den = r+g+b;
    den(den == 0) = eps;
    S = 1-3.*num./den;
    H(S==0) = 0;

    % componente I
    I = (r+g+b)/3;

    % ricostruzione
    y = cat(3,H,S,I);
end