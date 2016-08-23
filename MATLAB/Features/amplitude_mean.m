%% [meanVal] = amplitude_mean(x, modus)
%
%  Though included as a Matlab builtin this function
%  calculates the mean of the amplitude distribution  
%  for a given vector 'frame'
%
%  modus: 'builtin' : use the Matlab builtin function
%                     (MUCH more performant)
%
%         'selfmade': use the self programmed version
%                     (can be adjusted easily)
%
% Author:   Henrik von Coler
% Date:     2013-02-05


function [meanVal] = amplitude_mean(x,modus)


if strcmp( modus , 'builtin')==1
    meanVal = mean(x);
    
elseif strcmp( modus , 'selfmade')==1

N    = size(x,1);

meanVal = 1/N * sum(x,1);    

end
end