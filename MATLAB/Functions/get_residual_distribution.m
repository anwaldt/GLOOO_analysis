%%  resFrame = get_residual_distribution(residual)
%
%   Arguments
%       residual:   Time-domain residual signal windowed)
%               
%
%   Henrik von Coler
%   2015-01-21


function RESabs = get_residual_distribution(residual)

resEnv      = cepstral_smoothing(residual,0.99);
resEnv      = resEnv(1:length(resEnv)/2);

N           = length(residual);

RES         = fft(residual); 
RES         = RES(1:length(RES)/2);
% RESph a = angle(RES);
RESabs      = abs(RES);

% smooth in the log domain   
REStmp      = smooth(log(RESabs),5);

% and return to linear
RESsmooth   = exp(REStmp);

% IPMORTANT: use random phase !!!!!
% (everything else will lead to choppy sound)
randPhase   = (rand(size(RES))-0.5)*2*pi;

% compose imaginary and real spectra separately,
% so that the phase is not affected by the window function
rP = RESsmooth .* cos(randPhase);
iP = RESsmooth .* 1i.*sin(randPhase);

compSpec    = rP+iP;

resFrame    = fftshift( ifft([compSpec; zeros(N/2,1)] ,'symmetric'));

resFrame    = resFrame.*triang(N);

corFac      = sum(abs(residual))/ sum(abs(resFrame));

resFrame    = resFrame*corFac;

%% PLOTS for debugging

% plot(RESabs), hold on, plot(abs(fft(resFrame)),'r'),hold off

% plot(RESabs), hold on, plot(RESsmooth,'r'), hold off

% plot(RESsmooth); hold on

end

