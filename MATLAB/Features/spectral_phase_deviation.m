%% [ phaseDiff ] = spectral_phase_deviation( phas, phas1, phas2 , modus)
%
%   Calculates the spectral phase deviation between
%   phas, phas1, and phas2 for each column.
%   Columns of 'phas' hold amplitude spectra from 0 to fs/2 !
%
%   See: "A Tutorial on Onset Detection in Music Signals" [Bello et. al.]
%   See: "Onset detection Revisited" (Duxburry) for weighted method
%
%
% Author: Henrik von Coler
% Date:   2012-12-17 ... 2013-02-06


function [ phaseDiff ] = spectral_phase_deviation( FRAME, FRAME1, FRAME2 , modus1,modus2)


if nargin<5
    modus2 = 'wighted';
end
if nargin<4
    modus1 = 'simple';
end

phas = unwrap(angle(FRAME));
phas1 = unwrap(angle(FRAME1));
phas2 = unwrap(angle(FRAME2));

%fk = ((angle(X)-angle(lastX))/2*pi*nHop) *fs;

deltaPhi = unwrap(phas,2*pi) -2*unwrap(phas1,2*pi) + unwrap(phas2,2*pi);

if strcmp(modus2,'weighted')
    meanFRAMEabs = mean(abs(FRAME+FRAME1+FRAME2),2);
    deltaPhi     = deltaPhi.*meanFRAMEabs;
end

if strcmp(modus1,'simple')
    % simple method
    phaseDiff = mean(abs(deltaPhi)) ;
elseif strcmp(modus1,'kurt')
    % statistik method
    phaseDiff = kurtosis(deltaPhi);
    
end



