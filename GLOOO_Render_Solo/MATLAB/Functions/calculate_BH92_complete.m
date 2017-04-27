%% function out = calculate_BH92(N)
%
%   Calculation of the Blackman-Harris window,
%   using the coefficients from DAFX (pp.408)!
%   [With exception of the signs, to shift it –
%   as done by J.O.Smith ...]
%
%   Henrik von Coler
%   2014-08-19

function out = calculate_BH92_complete(in)
 
N = in;
 
out = zeros(N,1);

for i=1:N
    
out(i) = 0.35875 ...
    - 0.48829 *cos((2*pi* (i)) / N) ...
    + 0.14128 *cos((4*pi* (i)) / N) ...
    - 0.01168 *cos((6*pi* (i)) / N);

end