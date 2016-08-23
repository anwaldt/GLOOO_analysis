% [centroid] =  spectral_centroid(x,fs ,modus)
%
%   Calculates the spectral centroid for each column in 'x'.
%   Columns of 'x' hold amplitude spectra from 0 to fs !
%
%   See: "A large set of audio features for sound description (Cuidado Project), G. Peeters"
%        "Audio Content Analysis" (A. Lerch)
%
%   Author : von Coler
%   Date   : 2013-02-27


function [centroid] =  spectral_centroid(x,fs ,modus)

nSignals = size(x,2);
nSamples = size(x,1);

% if ~isempty(find(sum(x), 1))
    if strcmp(modus, 'squared')
        centroid = (sum((1:nSamples)'.*x.^2) ./ sum(x.^2))/nSamples ;
    elseif strcmp(modus,'linear')
        centroid = (sum( (1:nSamples)'.*x) ./ sum(x))/nSamples ;
    end
% else
%     centroid = zeros(1,nSamples);
% end
