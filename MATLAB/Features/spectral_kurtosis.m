% spectral_kurtosis()
%
%   Calculates the spectral kurtosis for each column in 'x'.
%   Columns of 'x' hold amplitude spectra from 0 to fs/2 !
%
%   See: "A large set of audio features for sound description (Cuidado Project), G. Peeters"
%   and:     "The spectral kurtosis: a useful tool for characterising non-stationary signals"
%
%   Author : Henrik von Coler
%   Date   : 2013-02-27

function [kurt] =  spectral_kurtosis(x ,fAxis)

% normalize
x = x/sum(x);

N       = length(x);
freqVec = (1:N)';

% get mu
mu = sum(freqVec.*x);

% get sigma
sigma = sqrt( sum((freqVec-mu).^2 .* x) );

 

% Peeters
kurt = (1/(N)) * (sum((freqVec-mu).^4 .*x) / (sigma^4));

% kurt = 1/N * sum((freqVec-mu).^4.*x) /sigma^4;

%% VARIATIONS / REMARKS

% (Alex' Book) - not happy with this one:
%kurt    = (1/N) *   sum((x-mu).^4) / (sigma^4);

% CATCH ERRORS ?
% if ~isempty(find(isnan(kurt), 1)) || ~isempty(find(isinf(kurt), 1))
    %kurt = 0;
% end
 
