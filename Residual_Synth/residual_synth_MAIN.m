
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

%% make filters

fs      = 48000;

order   = 3;
ripple  = 0.5;

% this cell structure is for use in MATLAB
C       = make_bark_filterbank(fs,order,ripple);


%% make gaussian models for frequency response

nBands = 24;

options = fitoptions('Method', 'LinearLeastSquares');


G = cell(nBands,1);

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
    else bandCNT < 16;
        [h,f] = freqz(C{bandCNT}.b,C{bandCNT}.a,2^8,fs);
    end
    
    H       =  (abs(h));
    
    gausmod = fit(f,H,'gauss1',options);
    
    gaussout.mu    = gausmod.b1;
    gaussout.sigma = gausmod.c1;
    
    G(bandCNT)     = {gaussout};
    
    z = exp(-((f-gausmod.b1)/gausmod.c1).^2);
    
    %xxx = plot( f,  (20*log10(H)) );
    
    yyy = plot( f ,  (20*log10(z)));
    
    colVec = [1 1 1] * (bandCNT/nBands*0.85)^1;
    
    %set(xxx,{'linew'},{0.4},'Color',colVec);
    
    set(yyy,{'linew'},{0.4},'Color',colVec);
    
    mapC = [mapC;colVec];
    
end


set(gca, 'XScale', 'log')
%set(gca, 'YScale', 'log')
ylim([-60 1])

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


matlab2tikz('bark_bank_gaussian_models.tex','width','0.7\textwidth','height','0.35\textwidth', ...
    'floatFormat', '%.1f' , ...
    'tikzFileComment','created from: residual_synth_MAIN.m ', ...
    'parseStrings',false,'extraAxisOptions',axoptions);

%%

for bandCNT = 1:2:nBands
    
    fprintf([num2str(bandCNT) ' & %6.2f & %6.2f & '],G{bandCNT}.mu, G{bandCNT}.sigma);
    
    fprintf([num2str(bandCNT+1) ' & %6.2f & %6.2f  \\\\ \n'],G{bandCNT+1}.mu, G{bandCNT+1}.sigma);
    
end


%% export to yaml with unique names for use in synthesis
bark_filterbank_to_YAML(C,G,['bark-bank_' num2str(fs) '.yml'], fs, order)


%% import from .mat files

P =  '/home/anwaldt/WORK/GLOOO/Violin_Library_2015/Analysis/2019-08-12/Sinusoids/';

nr = '01';

load([P 'SampLib_BuK_' nr '.mat'])


%[x,fs] = audioread([P 'Residual_BuK_' nr '.wav']);

lHop = SMS.param.lHop*0.5;
lWin = SMS.param.lWinNoise;

%axis x line=bottom,
%axis y line=left,

%% import from txt data

nr  = '01';

X   = importfile('/home/anwaldt/WORK/GLOOO/Violin_Library_2015/Analysis/2019-08-12/SinusoidsTXT/SampLib_BuK_08.BBE');

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



for bandCNT = [1 2 4 8 16]
    
    h = figure;

    
    t = linspace(0,4,length(X));
    
    tmp = smooth(abs(X(1:622,bandCNT)),10);
    
    % downsample by 4 when plotting
    xxx = plot(t(100:4:2200),smooth(X(100:4:2200,bandCNT),4));
    
    set(xxx,{'linew'},{1.1},'Color',[0 0 0])
    
    
    
    set(xxx,{'linewidth'},{1})
    set(xxx,'MarkerEdgeColor',[0 0 0 ]);
    set(xxx,'MarkerFaceColor',[0.7 0.7 0.7 ]);
    
    %ylim([10e-7,0.01])
    ylabel(['$RMS_{' num2str(bandCNT) '}$'])
    
    axoptions={'axis on top',...
        'scaled y ticks = false',...
        'y tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=0}'
        };
    
    
    matlab2tikz(['bark-energies_' num2str(bandCNT) '.tex'],'width','0.6\textwidth','height','0.2\textwidth', ...
        'tikzFileComment','created from: residual_synth_MAIN. ', ...
        'parseStrings',false,'extraAxisOptions',axoptions);
    
    
end
