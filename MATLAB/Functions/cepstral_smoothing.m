

function [ Y ] = cepstral_smoothing(x, cutoff)

L = length(x);

cutBin = round(L*cutoff);

X   = ifft(log(abs(fft(x))));

XF  = X;
XF(cutBin:end) = 0;



Y = abs(exp(fft(XF)));


% plot(abs(fft(x))), hold on, plot((abs(Y)),'r'), hold off, xlim([0 1000]);

end


