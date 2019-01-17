



p=genpath('../../MATLAB/');
addpath(p)

%%

fileName = '/home/anwaldt/WORK/GLOOO/Violin_Library_2015/Analysis/SynthResults_ BuK_ yin/Sinusoids/1-oct-sweep.mat';

load(fileName);


%%

close all

offEnd = 100;
mapC =[];

for partCNT=1:30
    
    xxx =semilogx(smooth(SMS.FRE(partCNT,100:10:end-offEnd),5),smooth(SMS.AMP(partCNT,100:10:end-offEnd),5),'k');
    
    colVec = [1 1 1] * partCNT/30;
    
    set(xxx,{'linew'},{1},'Color',colVec)
    
    hold on
    
    
    mapC = [mapC;colVec];
    
    
    
end


xlim([100, 10e3])
ylim([0,0.15])


xlabel('$f / Hz $');
ylabel('$a_i(f)$')


colormap(mapC)
caxis([0 30]);

h=colorbar

set(get(h,'title'),'string','Partial index');

axoptions={'scaled y ticks = false',...
    'y tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=2}'};


matlab2tikz(['sem-sweep.tex'],'width','0.9\textwidth','height','0.5\textheight', ...
    'tikzFileComment','created from: analyze-sem_MAIN.m ', ...
    'parseStrings',false,'extraAxisOptions',axoptions);


% another version with peak labels

peaks =[ 283.5938    0.1379
    414.8838    0.0773
    500.3906    0.1346
    708.9293    0.0350
    871.8750    0.0546
    1170       0.0348
    1326       0.0352];


for i=1:length(peaks)
    
    plot((peaks(i,1)),peaks(i,2),'or','MarkerSize',12)
    text(peaks(i,1),peaks(i,2)+0.005,[num2str(round(peaks(i,1))) ' Hz'])
    
end



rectangle('Position',[1800 0.005 1500 0.04],'EdgeColor','r')




matlab2tikz(['sem-sweep_PEAKS.tex'],'width','0.9\textwidth','height','0.5\textheight', ...
    'tikzFileComment','created from: analyze-sem_MAIN.m ', ...
    'parseStrings',false,'extraAxisOptions',axoptions);

%%

close all

offEnd = 100;


for partCNT=1:30
    
    xxx =semilogx(smooth(SMS.FRE(partCNT,100:10:end-offEnd),5),smooth(SMS.AMP(partCNT,100:10:end-offEnd),5),'k');
    
    colVec = [1 1 1] * 0.5;
    
    set(xxx,{'linew'},{1.0},'Color',colVec)
    
    
    
    xlim([100, 10e3])
    ylim([0, 0.15]);
    
    xlabel('$f / Hz $');
    ylabel(['$a_{' num2str(partCNT) '}(f)$'])
    hold off
    
    
    
    axoptions={'scaled y ticks = false',...
        'y tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=2}'};
    
    
    matlab2tikz(['sem-sweep_' num2str(partCNT) '.tex'],'width','0.9\textwidth','height','0.5\textheight', ...
        'tikzFileComment','created from: analyze-sem_MAIN.m ', ...
        'parseStrings',false,'extraAxisOptions',axoptions);
    
    
    
end

%%



