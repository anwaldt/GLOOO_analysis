%%   [decr] =  spectral_decrease(x,fs ,freqVec)
%
%   Calculates the spectral decrease for each column in 'x'.
%   Columns of 'x' hold amplitude spectra from 0 to fs/2 !
%
%   See: "A large set of audio features for sound description (Cuidado Project), G. Peeters"
%
%   Author : von Coler
%   Date   : 2013-02-30
    %decr = (1./sum(x(2:end,:))) .* sum((x(2:end)-repmat(x(1,:),L-1,1))./repmat((2:L)',1,N));

function [decr] =  spectral_decrease(x,fs ,freqVec)

% get size of input matrix
L    = size(x,1);
N    = size(x,2);

if nargin<3
    freqVec = repmat(linspace(0,fs/2,L)',1,N);
end

% if ~isempty(find(x, 1))
    
     decr = (1./sum(x(2:end))) * sum(  (x(2:end) - x(1))  ./ ((2:L)'-1)  );

    %decr = (1./sum(x(2:end,:))) .* sum((x(2:end)-repmat(x(1,:),L-1,1))./repmat((2:L)',1,N));
    
% else
    
%     decr = zeros(1,N);
% end


% if ~isempty(find(isnan(decr), 1)) || ~isempty(find(isinf(decr), 1))
%     decr = zeros(1,N);
% end
