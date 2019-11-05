
%% residual_synth_PLOT.m
%
%
% Henrik von Coler
% 2019-11-05
%
%%

clearvars
restoredefaultpath

%%


addpath('../../common');

p=genpath('../MATLAB/');
addpath(p)

p = genpath('../GLOOO_Solo_Analysis/Matlab');
addpath(p);
 

%%

fs      = 48000;

order   = 3;
ripple  = 0.5;

% this cell structure is for use in MATLAB
C       = make_bark_filterbank(fs,order,ripple);

%%

close all

figure

hold on

nBands = length(C);

for bandCNT = 1:nBands
    
    [h,f] = freqz(C{bandCNT}.b,C{bandCNT}.a,2^11,fs);
    
    H =  (abs(h));
    
    xxx = semilogx( f,20*log10(H) );
    
    colVec = [1 1 1] * (bandCNT/nBands*0.75)^1;
    
    set(xxx,{'linew'},{0.4},'Color',colVec)
    
end
    
    
%set(gca, 'XScale', 'log')
%set(gca, 'YScale', 'log')
ylim([-30 0])

%xlim([1 1000])
