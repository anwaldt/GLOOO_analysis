%% [ hfc ] = high_frequency_detection( X )
%
% get the high frequency content after:
% Bello, J., Monti, G., and Sandler, M. (2000).
% Techniques for automatic music transcription.
%
% HvC
% 2013-06-11

function [ df ] = high_frequency_detection( X,lastX )


k = 2:length(X);

HFC = sum(X(2:end).^2.*k');
E   = sum(X(2:end).^2);

lastHFC =sum(lastX(2:end).^2.*k');

df = (HFC/lastHFC) * (HFC/E);

end

