%% function [skew] =  spectral_skewness(x,fs ,freqVec)
%
%   Calculates the spectral skewness for each column in 'x'.
%   Columns of 'x' hold amplitude spectra from 0 to fs/2 !
%
%   See: "A large set of audio features for sound description (Cuidado Project), G. Peeters"
%
%   Author : Henrik von Coler
%   Date   : 2013-02-27

function [skew] =  spectral_skewness(x)

% normalize x to sum(x)=1 , since x==pdf
x = x/sum(x);

N       = length(x);
freqVec = (1:N)';

% get mu
mu = sum(freqVec.*x)/sum(x);

% get sigma
sigma   =    sqrt(sqrt(sum( (freqVec- mu ).^2  .*  x.^2) / sum(x.^2) ));

% Henrik 
skew    = (1/N) *   sum(x.*(freqVec-mu).^3) / (sigma^3);

% Buch  (Alex)
%skew    = (1/N) *   sum((x-mu).^3) / (sigma^3);


end
