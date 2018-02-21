%% Function to calculate the Natural Spline 
%
% Calculate a piecewise natural cubic spline 
% Formula used from:  Engeln-Müllges Niederdrenk und Wodicka 2011 - Numerik-Algorithmen
%                     p.410 & 411
%
% Input: x : x - Values of points for interpolation
%        y : y - Values of points for interpolation
%    Restricitons:
%    Both Vectors must have the same size and at least a length of 4
%
% Ouput: pp - Matlab polynomial structure
%
% author: Moritz Götz

function [ pp ] = natural_spline( x, y )

% Check Input
if (size(x) ~= size(y))
    error('Input vectors must have the same size');
end

if (length(x) < 4 )
    error('Input must have at least a length of 4');
end

% Init matrix A and vetor a
n = length(x) - 1;
A = zeros(n - 1);
a = zeros(n - 1,1);

% Helping vectors h_x & h_y( h_i = x_{i+1} - x_i )
h_x = zeros(n,1);
h_y = zeros(n,1);

for idx = 1 : n
    h_x(idx) = x(idx + 1) - x(idx);
    h_y(idx) = y(idx + 1) - y(idx);
end
    
%% Build Matrix A
% first values at idx i = 1 ( A(i,j) )
A(1,1) = 2 * ( h_x(1) + h_x(2) ); 
A(1,2) = h_x(1);

% next values for idx i = 2 : n - 2
for idx = 2 : n - 2

    A(idx,idx - 1) = h_x(idx); 
    A(idx,idx)     = 2 * ( h_x(idx) + h_x(idx + 1) );
    A(idx,idx + 1) = h_x(idx + 1);

end 
% last values for idx i = n - 1
A(n - 1, n - 2) = h_x(n - 1);
A(n - 1, n - 1) = 2 * (h_x(n - 1) + h_x(n) );

% Build Vector a
for idx = 1 : n - 1

    a(idx) = 3 * ( h_y(idx + 1) / h_x(idx + 1) ) ...
        - 3 * ( h_y(idx) / h_x(idx) );

end

% Solve Equation System Ac = a
c = A \ a;

% Build Polynomial coefficients ( c(1) & c (n + 1) = 0 ):
a_i = zeros(n,1);
b_i = zeros(n,1); 
c_i = [0 ; c ; 0];
d_i = zeros(n,1);

for idx = 1 : n
    
    a_i(idx) = y(idx);
    b_i(idx) = h_y(idx)/h_x(idx) ...
            - h_x(idx) * (c_i(idx + 1) + 2*c_i(idx)) / 3;
    d_i(idx) = (c_i(idx + 1) - c_i(idx))/ (3*h_x(idx));
    
end

% Generate Matlab polynomial structure
coeffs = zeros(n,4); % 4 is the number of polynomial coefficients, for cubic = 4

for idx = 1 : n    
    coeffs(idx,1) = d_i(idx);
    coeffs(idx,2) = c_i(idx);
    coeffs(idx,3) = b_i(idx);
    coeffs(idx,4) = a_i(idx);
end

pp = mkpp(x,coeffs);

end

