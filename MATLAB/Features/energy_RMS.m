% RMS = energy_RMS(x)
%
% Calculate  the RMS for each column
% of the input matrix 'x'
%
% Author: Henrik von Coler
% Date:   2013-02-27

function RMS = energy_RMS(x)

RMS = sqrt(sum(x.^2)/size(x,1));


