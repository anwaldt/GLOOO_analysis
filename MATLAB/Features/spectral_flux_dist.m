%  [flux] =  spectral_flux_dist(x, x_prev)
%
%   Calculates the spectral flux between each column of 
%   'x' and 'x_prev' based on the distance measure.
%   Columns of 'x' hold amplitude spectra from 0 to fs!
%   flux based on the distance measure
%   
%   SEE: "A Tutorial on Onset Detection in Music Signals"
%           (Bello et. al.)
%   (yet with less modifications)
%
%   input   -> 2 frames of spectrogram (x, x-1) 
%   output  -> value for spectral flux
%
%   Author : Henrik von Coler
%   Date   : 2009-01-08 ... 2013-02-05


function [flux] =  spectral_flux_dist(x, xPrev)

    flux = sqrt(sum((x-xPrev).^2))  /size(x,1);
    
end