%%  [ crest ] = crest_factor( x )
%
% Calculate  the crest factor for each column of 
% the input matrix 'x'.
%
% Crest factor = Maximum to RMS ratio !
% See: "ROBUST MATCHING OF AUDIO SIGNALS USING SPECTRAL FLATNESS FEATURES"
%
% HvC
% 2013-02-27

 

function [ crest ] = amplitude_crest_factor(x)

% get input dimensions
L = size(x, 1);
N = size(x, 2);

if ~isempty(find(x, 1))

crest =  max(abs(x)) / sqrt( sum(x.^2)/ L);

    if ~isempty(find(isnan( crest), 1)) || ... 
       ~isempty(find(isinf( crest), 1))  
        crest = zeros(1,N);
    end

else
    
    crest = zeros(1,N);
    
end
