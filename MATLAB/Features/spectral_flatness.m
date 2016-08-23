%%  [ flat ] = spectral_flatness(spec)
%
%
%   Calculates the spectral flatness for each column in 'x'.
%   Columns of 'x' hold amplitude spectra from 0 to fs/2 !
%
%   From: "ROBUST MATCHING OF AUDIO SIGNALS USING SPECTRAL FLATNESS
%   FEATURES" [Herre et. al.]
%
% Author: Henrik von Coler
% Date    2012-12-10 ... 2013-02-06

function [ flat ] = spectral_flatness(spec)

% signals length
N = size(spec,2);
L = size(spec,1);

% old method (WHERE found?)
% flat = exp(1/N * sum(log(spec))) ./ (1/N * sum(spec));

% if ~isempty(find((spec), 1));
    flat = exp(1/L * sum( log(spec)) ) ./ (1/L * sum(spec));
   %flat  = ((prod(spec)).^(1/N)) ./ (1/N * sum(spec)); 
   %    the herre method causes
%     underflow !!!
% else
%     flat = zeros(1,L);   
% end

end

