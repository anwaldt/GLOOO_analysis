



p=genpath('../../MATLAB/');
addpath(p)

%%

fileName = '/home/anwaldt/WORK/GLOOO/Violin_Library_2015/Analysis/SingleSounds_ BuK_ yin/Sinusoids/SampLib_BuK_136.mat';

load(fileName);


%%

close all

mapC =[];

for partCNT=1:30
    
    xxx =plot( (SMS.FRE(partCNT,10:10:end-10)));
    
    colVec = [1 1 1] * partCNT/30;
    
    set(xxx,{'linew'},{1.2},'Color',colVec)
    
    hold on
    
    
    mapC = [mapC;colVec];
    
    
    
end



xlabel('$Frame $');
ylabel('$f / Hz$')


colormap(mapC)
caxis([0 30]);  

h=colorbar

set(get(h,'title'),'string','Partial index');

axoptions={'scaled y ticks = false',...
    'y tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=2}'};

 
 matlab2tikz(['partial_freq.tex'],'width','0.9\textwidth','height','0.5\textheight', ...
     'tikzFileComment','created from: plot_partial_trajectories_MAIN.m ', ...
     'parseStrings',false,'extraAxisOptions',axoptions);

%%

close all

mapC =[];

for partCNT=1:30
    
    xxx =semilogy( (SMS.AMP(partCNT,10:10:end-10)));
    
    colVec = [1 1 1] * partCNT/30;
    
    set(xxx,{'linew'},{1.2},'Color',colVec)
    
    hold on
    
    
    mapC = [mapC;colVec];
    
    
    
end



xlabel('$Frame $');
ylabel('$a_i$')


colormap(mapC)
caxis([0 30]);

h=colorbar

set(get(h,'title'),'string','Partial index');

axoptions={'scaled y ticks = false',...
    'y tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=2}'};

 
 matlab2tikz(['partial_amp.tex'],'width','0.9\textwidth','height','0.5\textheight', ...
     'tikzFileComment','created from: plot_partial_trajectories_MAIN.m ', ...
     'parseStrings',false,'extraAxisOptions',axoptions);

 