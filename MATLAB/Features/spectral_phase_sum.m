%%   [phaseSum] =  spectral_phase_sum(FRAMEphas)
% 
%   Calculates the sum for each absolute unwrapped phase spectrum in 'x'.
%   Columns of 'x' hold phase spectra from 0 to fs !
%
%   Designed after experiments by HvC.
%   This has been done before in a similar way - REF ?
%
%   Author : von Coler
%   Date   : 2013-03-08

function phaseSum = spectral_phase_sum(FRAMEphas)

% get length and number of signals
% N    = size(FRAMEphas,1);
N = size(FRAMEphas,2);

% get the AC content
xxx = smooth(FRAMEphas)-FRAMEphas;

% simply get the sum of the absolute unwrapped phase
% phaseSum  = sum(abs(unwrap(FRAMEphas))) /N;
phaseSum = sum(abs(xxx.^0.1));
% ALTERNATIVE: abs(sum(((unwrap(angle(FRAME))))));