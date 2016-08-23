%   [skew] =  spectral_slope(x,fs ,freqVec)
%
%   Calculates the spectral slope for each column in 'x'.
%   Columns of 'x' hold amplitude spectra from 0 to fs/2 !
%
%   See: "A large set of audio features for sound description (Cuidado Project), G. Peeters"
%
%   Author : von Coler
%   Date   : 2013-02-27

function [slope] =  spectral_slope(x,fs ,freqVec)

L = size(x,1);
N = size(x,2);

if nargin<3
    freqVec = repmat( (1:L)',1,size(x,2));
end

% if ~isempty(find(x, 1))
    
    slope  = (1./sum(x)) ...
        .* ((L * sum(freqVec.*x) - sum(freqVec).*sum(x)) ...
        ./ ( L*sum(freqVec.^2)- sum(freqVec).^2));
    
% else
%     
%     slope  = zeros(1,N);
%     
% end

% 
% if ~isempty(find(isnan(slope), 1)) || ~isempty(find(isinf(slope), 1))
%     slope = zeros(1,N);
% end
