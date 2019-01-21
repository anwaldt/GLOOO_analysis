



p=genpath('../../../MATLAB/');
addpath(p)

%%

fileName = '/home/anwaldt/WORK/GLOOO/Violin_Library_2015/Analysis/TwoNote_ BuK_ swipe/Sinusoids/TwoNote_BuK_22.mat';

load(fileName);


%%

close all

mapC = [];

for partCNT=1:20
    
    xxx =plot( (SMS.FRE(partCNT,10:10:end-10)));
    
    colVec = [1 1 1] * partCNT/30;
    
    set(xxx,{'linew'},{1.0},'Color',colVec)
    
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

 
 matlab2tikz(['partial_freq_22_ORIGINAL.tex'],'width','0.9\textwidth','height','0.5\textheight', ...
     'tikzFileComment','created from: plot_partial_trajectories_MAIN.m ', ...
     'parseStrings',false,'extraAxisOptions',axoptions);

%%

close all

mapC =[];

for partCNT=1:20
    
    xxx =semilogy( (SMS.AMP(partCNT,10:10:end-10)));
    
    colVec = [1 1 1] * partCNT/30;
    
    set(xxx,{'linew'},{1.0},'Color',colVec)
    
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

 
 matlab2tikz(['partial_amp_22_ORIGINAL.tex'],'width','0.9\textwidth','height','0.5\textheight', ...
     'tikzFileComment','created from: plot_partial_trajectories_MAIN.m ', ...
     'parseStrings',false,'extraAxisOptions',axoptions);
 
 
 
 
 
 
 %% PHASES

close all

mapC =[];

for partCNT=1:20
    
    xxx =plot( unwrap(SMS.PHA(partCNT,10:10:end-10)));
    
    colVec = [1 1 1] * partCNT/30;
    
    set(xxx,{'linew'},{1.0},'Color',colVec)
    
    hold on
    
    
    mapC = [mapC;colVec];
    
    
    
end



xlabel('$Frame $');
ylabel('$\varphi$')


colormap(mapC)
caxis([0 30]);

h=colorbar

set(get(h,'title'),'string','Partial index');

axoptions={'scaled y ticks = false',...
    'y tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=2}'};

 
 matlab2tikz(['partial_phas_22_ORIGINAL.tex'],'width','0.9\textwidth','height','0.5\textheight', ...
     'tikzFileComment','created from: plot_partial_trajectories_MAIN.m ', ...
     'parseStrings',false,'extraAxisOptions',axoptions);
 
 
 
 
 
 
 
 
 %% BARK
 
close all

mapC =[];

for barkCNT=1:10
    
    xxx =semilogy( (SMS.BET(10:10:end-10, barkCNT)));
    
    colVec = [1 1 1] * barkCNT/24;
    
    set(xxx,{'linew'},{1.0},'Color',colVec)
    
    hold on
    
    
    mapC = [mapC;colVec];
    
    
    
end



xlabel('$Frame $');
ylabel('$a_i$')


colormap(mapC)
caxis([0 24]);

h=colorbar

set(get(h,'title'),'string','Bark band');

axoptions={'scaled y ticks = false',...
    'y tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=2}'};

 
 matlab2tikz(['bark_22_ORIGINAL.tex'],'width','0.9\textwidth','height','0.5\textheight', ...
     'tikzFileComment','created from: plot_partial_trajectories_MAIN.m ', ...
     'parseStrings',false,'extraAxisOptions',axoptions);

 