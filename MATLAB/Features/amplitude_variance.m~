%% [varVal] = amplitude_variance(frame,modus)
%
%  Though included as a Matlab builtin this function
%  calculates the variance of the amplitude distribution
%  for a given vector 'frame'
%
%  modus: 'builtin' : use the Matlab builtin function
%                     (more performant)
%
%         'selfmade': use the self programmed version
%                     (can be adjusted easily)
%
% Author:   Henrik von Coler
% Date:     2013-02-05

function [varVal] = amplitude_variance(frame,modus)

if strcmp( modus , 'builtin')==1
    varVal = var(frame);
    
elseif strcmp( modus , 'selfmade')==1
    
  
mu = mean(frame);

[h,x]= hist(frame,100);
h=h/sum(h);
varVal = sum(h.*(x-mu).^2);
 
end
