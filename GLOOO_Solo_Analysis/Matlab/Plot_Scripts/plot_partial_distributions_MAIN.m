%% plot CMFs 
% - for partial amplitude and frequency 
% - for bark energies   

%% RESET

close all
clearvars
restoredefaultpath


p=genpath('../../../MATLAB/');
addpath(p)


%% LOAD YAML FILE

P =  '/home/anwaldt/WORK/GLOOO/GLOOO_synth/MODEL/yaml/';

nr = '57';

MOD = YAML.read([P 'SampLib_BuK_' nr '.yml']);

%% Frequencies

close all

P = struct2cell(MOD.SUS.PARTIALS);

figure
hold on

mapC =[];

for partCNT= 1:30
    
    
    
    xxx = plot(P{partCNT}.FRE.xval,P{partCNT}.FRE.dist);
    
    colVec = [1 1 1] * partCNT/30;
    set(xxx,{'linew'},{1.2},'Color',colVec)

    mapC = [mapC;colVec];
    
    
    set(xxx,{'linewidth'},{1})
    
    
    
    %     ylim([10e-7,0.01])
    %     ylabel(['$RMS_{' num2str(bandCNT) '}$'])
    
    
    
    
    
end

xlim([0.95, 1.05])

xlabel('$f_i / (f_1  i)$');
ylabel('CMF')
hold off


colormap(mapC)
caxis([0 30]);

h=colorbar
set(get(h,'title'),'string','Partial index');

axoptions={'scaled y ticks = false',...
    'y tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=2}'};


matlab2tikz(['cmf-freq.tex'],'width','0.9\textwidth','height','0.5\textheight', ...
    'tikzFileComment','created from: plot_partial_distributions_MAIN.m ', ...
    'parseStrings',false,'extraAxisOptions',axoptions);


%% AMPLITUDES

close all

P = struct2cell(MOD.SUS.PARTIALS);

F = axes
hold on

mapC =[];

for partCNT= 1:30
    
    
    
    xxx = plot(P{partCNT}.AMP.xval,P{partCNT}.AMP.dist);
    
    colVec = [1 1 1] * partCNT/30;
    set(xxx,{'linew'},{1.2},'Color',colVec)

    mapC = [mapC;colVec];
    
    
    set(xxx,{'linewidth'},{1})
    
    
end

set(F,'xscale','log')

xlim([10e-7, 0.1])

xlabel('$\log(a_i)$');
ylabel('CMF')
hold off


colormap(mapC)
caxis([0 30]);

h=colorbar

set(get(h,'title'),'string','Partial index');

axoptions={'scaled y ticks = false',...
    'y tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=2}'};


matlab2tikz(['cmf-amp.tex'],'width','0.9\textwidth','height','0.5\textheight', ...
    'tikzFileComment','created from: plot_partial_distributions_MAIN.m ', ...
    'parseStrings',false,'extraAxisOptions',axoptions);



%% BARK

close all

P = struct2cell(MOD.SUS.RESIDUAL);

F = axes
hold on

mapC =[];

for partCNT= 1:24
    
    
    
    xxx = plot(P{partCNT}.AMP.xval,P{partCNT}.AMP.dist);
    
    colVec = [1 1 1] * partCNT/24;
    set(xxx,{'linew'},{1.2},'Color',colVec)

    mapC = [mapC;colVec];
    
    
    set(xxx,{'linewidth'},{1})
    
    
end

set(F,'xscale','log')

xlim([2*10e-7, 0.005])

xlabel('$\log(rms_i)$');
ylabel('CMF')
hold off


colormap(mapC)
caxis([0 24]);

h=colorbar

set(get(h,'title'),'string','Bark index');

axoptions={'scaled y ticks = false',...
    'y tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=2}'};


matlab2tikz(['cmf-bark.tex'],'width','0.9\textwidth','height','0.5\textheight', ...
    'tikzFileComment','created from: plot_partial_distributions_MAIN.m ', ...
    'parseStrings',false,'extraAxisOptions',axoptions);
