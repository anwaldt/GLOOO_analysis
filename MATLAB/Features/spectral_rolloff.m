%%   [ro] =  spectral_rolloff(x, thresh, fs ,freqVec)
%
%   Calculates the spectral rolloff for each column in 'x'.
%   Columns of 'x' hold amplitude spectra from 0 to fs/2 !
%
%   If freqVecv is passed do the
%
%   See: "A large set of audio features for sound description (Cuidado Project), G. Peeters"
%
%   Author : von Coler
%   Date   : 2013-02-30

function [roMat] =  spectral_rolloff(x, thresh, fs ,modus)

% get length and number of signals
N    = size(x,1);
nSig = size(x,2);

% allocate output
roMat   = zeros(1,nSig);

% intagrate spectrum
if   strcmp(modus,'squared')
    sumMAT = cumsum(x.^2,1) ;
elseif strcmp(modus,'linear')
    sumMAT = cumsum(x,1) ;   
end

% only if we have a valid distribution function (not zeros)
% if max( max(sumMAT))~=0
    
    % normalize
    sumMAT = sumMAT./repmat(max(sumMAT),N,1);
    % get indices
    [rowIND, colIND]= (find(sumMAT>thresh));
    % TODO: BAD STYLE: find each columns first "1"
    for i=1:nSig
        try
            roMat(i) = rowIND(find(colIND==i, 1 ));
        catch
            roMat(i) =1;
        end
    end
 
        roMat = roMat/N;
  
% end
