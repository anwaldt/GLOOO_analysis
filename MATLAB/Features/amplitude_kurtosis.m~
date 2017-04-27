%% [kurtVal] = amplitude_kurtosis(frame,modus)
%
%  Though included as a Matlab builtin this function
%  calculates the kurtosis of the amplitude distribution
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

function [kurtVal] = amplitude_kurtosis(frame,modus)

if strcmp( modus , 'builtin')==1
    kurtVal = kurtosis(frame);
    
    
elseif strcmp( modus , 'selfmade')==1

mu      = mean(frame);
stdev   = std(frame);

[h,x]   = hist(frame,100);
h       = h/sum(h);
kurtVal = sum(h.*(x-mu).^4)/stdev^4;

    
end
 
if ~isempty(find(isnan(kurtVal), 1))
    kurtVal=zeros(1,size(frame,2));
end
