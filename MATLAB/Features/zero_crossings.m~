% [crossings] = zero_crossings(x ,meanFree)
%
% Calculate  the zero crossings for each column 
% of the input matix "x"
%
% meanFree = 1 removes the DC before calculation
%
% Author: Henrik von Coler
% Date:   2013-02-27

function [crossings] = zero_crossings(x ,meanFree)

% check switch
if nargin<2
    meanFree = 0;
end

% get input dimensions
N         = size(x ,1);
nSignals  = size(x ,2);


% remove DC ?
if strcmp(meanFree,'meanfree')
    x = x-repmat(mean(x),N,1);
end

% get zero crossings
crossings = sum(abs(diff(sign(x))/2))/N;


end
