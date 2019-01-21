



p=genpath('../../MATLAB/');
addpath(p)

%%

fileName = '/home/anwaldt/WORK/GLOOO/Violin_Library_2015/Analysis/SynthResults_ BuK_ yin/Sinusoids/int-sweep-2.mat';

load(fileName);


%%

close all

offEnd = 100;
mapC   = [];

L = length(SMS.AMP);

for indCNT=1:10:900
    
    x = (interp( log([0.001; SMS.AMP(1:2:end,indCNT);0.0001]),5));
    
    yy = linspace(0,20000,length(x));
    
    xxx     = plot(yy,x ,'k','linewidth',0.1);
    
    colVec = [1 1 1] - [1 1 1] * (indCNT/L).^1;
    
    set(xxx,'Color',colVec)
    
    hold on
    
    mapC = [mapC;colVec];
    
end


% xlim([1, 33])
ylim([-10,-2])


xlabel('$f / Hz $');
ylabel('$\log(amp)$')


colormap(mapC)
caxis([0 126]);

h=colorbar;

set(get(h,'title'),'string','Intensity');


%%

axoptions={'scaled y ticks = false',...
    'y tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=2}'};

matlab2tikz(['int-sweep.tex'],'width','0.9\textwidth','height','0.5\textheight', ...
    'tikzFileComment','created from: analyze-int_MAIN.m ', ...
    'parseStrings',false,'extraAxisOptions',axoptions);
