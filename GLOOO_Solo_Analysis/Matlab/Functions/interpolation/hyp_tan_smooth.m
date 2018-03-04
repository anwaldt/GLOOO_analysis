%% Hyperbolic Tangens Smoothing
% Create a smooth trasnition between two points (y0,y1) 
%
% Input: y0 - start value 
%        y1 - end value
%        n  - number of points for output
% 
% Output y - smoothed output transition of length n
%
% author: Moritz Götz

function [ y ] = hyp_tan_smooth (y0, y1, slope, n) 

y = zeros(n,1);

if y0 > y1
    sign = -1;
else
    sign = 1;
end

% X vector 
x_0 = 0;
x_1 = 1;
x = linspace(x_0,x_1,n);

a = abs(x_0 - x_1) / 2;
b = slope;
d = .5*abs(y0-y1);
c = min(y0,y1) + d;


for idx = 1 : n
    y(idx) = c + d * sign*tanh( ( x(idx) - a ) / b );
end

end