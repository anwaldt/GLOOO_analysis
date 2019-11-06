
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


mapC =[];





figure

hold on

nBands = length(C);

for bandCNT = 1:nBands
    
    if bandCNT < 4
        [h,f] = freqz(C{bandCNT}.b,C{bandCNT}.a,2^11,fs);
    elseif bandCNT < 8
        [h,f] = freqz(C{bandCNT}.b,C{bandCNT}.a,2^10,fs);
    elseif bandCNT < 12
        [h,f] = freqz(C{bandCNT}.b,C{bandCNT}.a,2^9,fs);
    else bandCNT < 16
        [h,f] = freqz(C{bandCNT}.b,C{bandCNT}.a,2^8,fs);
        
    end
    H =  (abs(h));
    
    xxx = semilogx(   (f) ,  (20*log10(H)) );
    
    colVec = [1 1 1] * (bandCNT/nBands*0.85)^1;
    
    set(xxx,{'linew'},{0.4},'Color',colVec);
    
    mapC = [mapC;colVec];
    
    
    
    
end


set(gca, 'XScale', 'log')
%set(gca, 'YScale', 'log')
ylim([-30 1])

xlim([10 18000])




xlabel('$f / Hz $');
ylabel('$20* log_{10}(H)$')


colormap(mapC)
caxis([0 24]);

h=colorbar;

set(get(h,'title'),'string','Band index');

axoptions={'axis on top',...
    'scaled y ticks = false',...
    'y tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=0}'
    };




matlab2tikz('bark_bank_freq_response.tex','width','0.7\textwidth','height','0.35\textwidth', ...
    'floatFormat', '%.2f' , ...
    'tikzFileComment','created from: residual_synth_PLOT.m ', ...
    'parseStrings',false,'extraAxisOptions',axoptions);
