%% [ hfc ] = high_frequency_content( X )
%
% get the high frequency content after:
% Bello, J., Monti, G., and Sandler, M. (2000).
% Techniques for automatic music transcription.
%
% HvC
% 2012-12-17


function [ out ] = high_frequency_content( X )

k = 2:length(X);

HFC = sum(X(2:end).^2.*k');
E   = sum(X(2:end).^2);

out =(HFC/E)/length(X);

end
