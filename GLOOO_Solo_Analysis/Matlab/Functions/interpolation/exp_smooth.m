%% Exponential Smoothing 
% Create a smooth trasnition between two points (y0,y1) 
%
% Input: y0 - start value 
%        y1 - end value
%        dt - time span between points ( delta x between y0 and y1 divided
%             by number of points n - 1) in samples
%        tau - time constant, in this time (1 - 1/e) of y1 is reached in
%               samples
%        n  - number of points for output
% 
% Output y - smoothed output transition of length n
%
% author: Moritz Götz

function [ y ] = exp_smooth( y0, y1, dt, tau, n )

alpha = 1 - exp(-dt/tau);

y = zeros(n,1);

y(1) = y0;

for idx = 2 : n 
    y(idx) = alpha*y1 + (1 - alpha) * y(idx - 1);
end

end

