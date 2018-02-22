%% Function to evaluate a polynomial
%
% Input : - x : x value which should be evaluated
%         - coeffs : coefficents c of a polynomial in form:
%           
%           c(1) + c(2)*x + ... + c(n)*x^(n-1)
%
%
% Output : - y : value of the polynomial
%
% author: Moritz Götz
%
function [ y ] = poly_eval( x, coeffs )

y = zeros(size(x));

for idx = 1 : length(coeffs)
   y = y + x.^(idx - 1) * coeffs(idx);
end

end

