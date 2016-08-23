%% [skewVal] = amplitude_skewness(frame,modus)
%
%  Though included as a Matlab builtin this function
%  calculates the skewness of the amplitude distribution
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

function [skewVal] = amplitude_skewness(frame,modus)

% do the builtin style ?
if strcmp( modus , 'builtin')==1
    
    skewVal = skewness(frame);
    
    % perform own algorithm
elseif strcmp( modus , 'selfmade')==1
    
   
mu      = mean(frame);
stdev   = std(frame);

[h,x]   = hist(frame,100);
h       = h/sum(h);
skewVal = sum(h.*(x-mu).^3)/stdev^3;

 
end

if ~isempty(find(isnan(skewVal), 1)) ||...
     isnan( skewVal)
    skewVal=zeros(1,size(frame,2));
end
