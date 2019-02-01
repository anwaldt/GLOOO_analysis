
%% residual_synth_MAIN.m
%
% Test the residual synthesis
% using the bark-band-filtered noise.
%
% Henrik von Coler
% 2018-11-05
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

fs      = 44100;

order   = 2;
ripple  = 1;

% this cell structure is for use in MATLAB
C       = make_bark_filterbank(fs,order,ripple);

% export to yaml with unique names for use in synthesis
bark_filterbank_to_YAML(C,['bark-bank_' num2str(fs) '.yml'], fs, order)


%% import from .mat files

P =  '/home/anwaldt/WORK/GLOOO/Violin_Library_2015/Analysis/SingleSounds_ BuK_ yin_2019-01-21/Sinusoids/';

nr = '136';

load([P 'SampLib_BuK_' nr '.mat'])
    

%[x,fs] = audioread([P 'Residual_BuK_' nr '.wav']);


lHop = SMS.param.lHop*0.5;
lWin = SMS.param.lWinNoise;


%% import from txt data

nr = '03';
X = importfile('/home/anwaldt/WORK/GLOOO/GLOOO_synth/MODEL/txt_60P/SampLib_BuK_03.BBE');

lHop = 128;
lWin = 4096;


%% one band MANUAL



BAND    = 07;

b       = C{BAND}.b;
a       = C{BAND}.a;

N       = length(b);

inBuff  = zeros(length(b),1);
outBuff = zeros(length(a),1);

nSamp   = 48000;
y       = zeros(1,nSamp);

for sampCNT = 1:nSamp
    
 
        % manage input
        in          = randn(1,1);        
        inBuff      =  circshift(inBuff,1);
        inBuff(1)   = in;
        
        out = 0;
        
        for i=1:N        
            out = out+inBuff(i)*b(i);
        end
        
        for i=2:N
            out = out-outBuff(i-1)*a(i);
        end
        
        outBuff      =  circshift(outBuff,1);
        outBuff(1)   = out;
        
       y(sampCNT) = out;
       
     
    
end

soundsc(y,fs)


%% Full re-synthesis


nBands  = size(X,2);
nFrames = size(X,1);

idx = 1;
y   = zeros(1000000,1);


for frameCNT = 1:nFrames
    
    for bandCNT = 1:nBands-1
        
        n   = randn(lWin,1);
        
        tmp = filter(C{bandCNT}.b,C{bandCNT}.a,n);
        
        tmp = 20* tmp.*hann(lWin).*X(frameCNT,bandCNT);
        
        y(idx:idx+lWin-1) =  y(idx:idx+lWin-1) + tmp;
    end
    
    idx=idx+lHop;
    
%     disp(frameCNT/nFrames);
    
end


soundsc(y,fs)

%audiowrite([nr '.wav'],y,fs)

%% PLOT

close all

h = figure;

for bandCNT = 3:10
    
    
    % downsample by 4 when plotting
    xxx = semilogy(X(1:4:end,bandCNT));
    
    set(xxx,{'linew'},{1.2},'Color',[0 0 0])
    
    
    
    set(xxx,{'linewidth'},{1})
    set(xxx,'MarkerEdgeColor',[0 0 0 ]);
    set(xxx,'MarkerFaceColor',[0.7 0.7 0.7 ]);
    
    ylim([10e-7,0.01])
    ylabel(['$RMS_{' num2str(bandCNT) '}$'])
    
    
    axoptions={'scaled y ticks = false',...
        'y tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=2}'};
    
        
    matlab2tikz(['/home/anwaldt/Desktop/UCSD_presentation/tikz/bark-energies_' num2str(bandCNT) '.tex'],'width','0.9\textwidth','height','0.075\textheight', ...
        'tikzFileComment','created from: residual_synth_MAIN. ', ...
        'parseStrings',false,'extraAxisOptions',axoptions);
    
    
end
