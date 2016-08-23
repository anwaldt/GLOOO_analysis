%%   [spread] =  spectral_spread(x,fs ,freqVec)
% 
%   Calculates the spectral spread for each column in 'x'.
%   Columns of 'x' hold amplitude spectra from 0 to fs/2 !
%
%   See: "A large set of audio features for sound description (Cuidado Project), G. Peeters"
%        and Lerch
%
%   Author : von Coler
%   Date   : 2013-02-27

function [spread] =  spectral_spread(x,fs ,freqVec)

% get length and number of signals
N    = size(x,1);
nSig = size(x,2);

% check for input frequency
if nargin<3
	freqVec = repmat(linspace(0,fs/2,N)',1,nSig);   
end

% calculate the centroid first
centroid = (sum( (1:N)'.*x) ./ sum(x));

% then the spread
spread   =  sqrt(sum( ((1:N)'- centroid ).^2  .*  x.^2) / sum(x.^2) );

end
