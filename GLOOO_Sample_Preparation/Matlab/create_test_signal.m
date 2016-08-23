fs      = 96000;

t       = (0:2*fs)'/fs;

x       = rand(size(t))*0.5-0.25;

f0      = 303;

nPart   = 20;

for i = 1:nPart 
    
    x = x+sin(2*pi*i*f0*t+rand*pi)*(1/i);
    
end

x = x*(1/max(x))*0.9;

plot(x)

audiowrite('synth.wav',x,fs)

soundsc(x,fs)