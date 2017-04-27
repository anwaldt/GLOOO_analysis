%%  [truePeakVal, truePeakPos] = get_peak_hight(FRAMEabs,maxInd)
%
%   Function for estimating the peak height and position
%   of a sinusoidal within a spectral frame, using the QIFFT method.
%
%
%   Henrik von Coler
%   2015-01-14
%%

function [ truePhase ] = get_peak_phase(supportPoints, p)

R = real(supportPoints);

I = imag(supportPoints);
 

% real
Rint    = R(2)-1/4*(R(1)-R(3))*p;

% real
Rimag   = I(2)-1/4*(I(1)-I(3))*p;

truePhase = angle(Rint+1i*Rimag);
 

% plot(real(supportPoints)), hold on, plot(imag(supportPoints),'r'), hold off
 
% plot(angle(supportPoints))
end

