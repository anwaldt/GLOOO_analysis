%% Function to create a bezier polynomial
%
%
% Formulas from Master thesis chapter 2.2.2 Bezier Curve
%
% Input: x : x - Values of points for interpolation
%        y : y - Values of points for interpolation
%    Restricitons:
%    Both Vectors must have the same size and at least a length of 3
%
% Ouput: pp - Matlab polynomial structure
%
% author: Moritz Götz

function [ coeffs, control_points ] = bezier_poly( x, y )

% Check Input
if (size(x) ~= size(y))
    error('Input vectors must have the same size');
end

if (length(x) < 3 )
    error('Input must have at least a length of 3');
end

% Init matrix A and vetor a
n = length(x);
A = zeros(n);

% Build Matrix A
for i = 1 : n
    for j = 1 : n
        tmp_coeff = bernstein_poly((j - 1), (n - 1));
        A(i,j) = poly_eval(x(i), tmp_coeff);
    end
end

% Build vector a 
a = y;

% Solve Equation System
b = A \ a;

% Generate Polynomial:
coeffs = zeros(n,1);

for i = 1 : n
   coeffs = coeffs + b(i) .*  bernstein_poly(i - 1,n - 1);   
end

% Save control Points
control_points = [x,b];

end