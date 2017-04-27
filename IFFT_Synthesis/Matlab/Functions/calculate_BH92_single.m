%% function out = calculate_BH92_single(N)
%
%   Calculation of the Blackman-Harris window,
%   using the coefficients from DAFX (pp.408)!
%   [With exception of the signs, to shift it –
%   as done by J.O.Smith ...]
%
%   Henrik von Coler
%   2014-08-19

function out = calculate_BH92_single(in,N)
 
     
out = 0.35875 ...
    - 0.48829 *cos((2*pi* (in+N/2)) / N) ...
    + 0.14128 *cos((4*pi* (in+N/2)) / N) ...
    - 0.01168 *cos((6*pi* (in+N/2)) / N);

