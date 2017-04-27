%% AddingTwoSines.m
%
%   Just a small experiment:
%
%   Find the matching counterpart to a sine
%   in order to make it windowed by a (triangular) window
%
%   @TODO: 
%
%
%   Henrik von Coler
%   2014-09-19

fs      = 44100;
f       = 300;
t       = (0:2^10)/fs;

x       = sin(2*pi*t*f);

XFACTOR = 1.14335; % something like 't(end)/f'
xC      = sin(2*pi*t*f*XFACTOR +pi);
out     = x+xC;

plot(out);


%% oi

fs = 44100;
f  = 54;
t  = (0:110000)/fs;

x  = sin(2*pi*t*f*1)+sin(2*pi*t*f*1.2+pi);

plot(x)



%%

f=300;

t = (0:1100)/fs;


    x = sin(2*pi*t*f*1);
    
for i=1:10



x = x+sin(2*pi*t*f*(1+i/10)+pi*i/4)*(1/i);

end

plot(x)