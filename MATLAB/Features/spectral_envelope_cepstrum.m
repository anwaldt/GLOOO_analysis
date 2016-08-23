%% Henrik von Coler


function [rcepenvp] = get_spectral_envelope_ceps(frame, fs, f0, nFFT)

% length of the one side spectrum
nspec = floor(nFFT/2+1);

try
    if f0 == 0
        rcepenvp = smooth(frame(1:nspec),10)';
    else
        t0 = round(fs/f0);
    end
catch
    rcepenvp = zeros(nspec,1);
    t0 = 100;
end

% create cepstrum
FRAME   = fft(frame, nFFT);
FRAME2  = 20*log10(abs(FRAME));
CEPS    = ifft(FRAME2);
CEPS    = real(CEPS);

nw = 2*t0-4;        % almost 1 to left and right

if floor(nw/2) == nw/2,
    nw=nw-1;            % make it odd
end;

% smoothen cepstrum
try
    w = boxcar(nw)'; % rectangular window
catch
    disp('OOPS');
end
wzp = [w(((nw+1)/2):nw),zeros(1,nFFT-nw), ...
    w(1:(nw-1)/2)];  % zero-phase version

try
    wrcep       = wzp .* CEPS';                 % window the cepstrum ("lifter")
catch 
    CEPS = [CEPS; zeros(length(wzp)-length(CEPS),1)];  % zero pad in case of tooo short ceps
    wrcep       = wzp .* CEPS';
end

rcepenv     = fft(wrcep);                   % spectral envelope
rcepenvp    = real(rcepenv(1:nspec));       % should be real
rcepenvp    = rcepenvp - mean(rcepenvp);    % normalize to zero mean

end







