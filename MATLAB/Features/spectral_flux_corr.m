%   [flux] =  spectral_flux_corr(x, x_prev)
%
%   Calculates the spectral flux between each column of
%   'x' and 'x_prev' based on the correlation method.
%   Columns of 'x' hold amplitude spectra from 0 to fs!
%   flux based on the distance measure
%
%   See: "A large set of audio features for sound description (Cuidado Project), G. Peeters"
%
%   Author : Henrik von Coler
%   Date   : 2013-02-30

function [flux] =  spectral_flux_corr(x, xPrev)

N = size(x,2);

flux = 1 - (sum(xPrev .*x) ./ (sqrt(sum(x.^2)) .* sqrt(sum(xPrev.^2))) );

%  if ~isempty(find(isnan(flux), 1)) || ~isempty(find(isinf(flux), 1))
%      flux = zeros(1,N);
%  end