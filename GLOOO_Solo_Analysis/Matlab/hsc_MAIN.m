%%
%
%
%
%


clearvars

p = genpath('../../MATLAB/');
addpath(p)

close all
%%

path  =  '/home/anwaldt/WORK/GLOOO/GLOOO_synth/Recordings/IntSweeps';

files = dir(path);


%%

CNTR = 1;
mapC = [];

for i=1:length(files)
    
    if  files(i).isdir~=1
        
        inFile  = [files(i).folder '/'  files(i).name];
        
        [~,baseName,~] = fileparts(files(i).name);
 
        
        hsc_single
        
        xVec    = linspace(1,127,length(HSC));
        
        colVec = [1 1 1] - [1 1 1]./(5-CNTR)^1.5;
        
        xxx = plot(xVec, HSC,'k','linewidth',1);
        hold on

        CNTR = CNTR + 1;
        
        set(xxx,'Color',colVec);
        
        mapC = [mapC;colVec];
    end
end

%%


 
leg  =legend({'55','67','79','93'},'Location','eastoutside');

title(leg,'MIDI pitch')
leg.Title.Visible = 'on';
leg.Title.NodeChildren.Position = [0.5 1.5 0];

%xlim([min(fVEC), max(fVEC)])
%ylim([-10,-2])

axis tight
xlabel('Intensity');
ylabel('$HSC$');


% colormap(mapC)
% caxis([1 4]);
% 
% h = colorbar;

% set(get(h,'title'),'string','Intensity');


%%

axoptions={'axis on top', ...
    'scaled x ticks = false', ...
    'scaled y ticks = false', ...
    %'y tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=2}'
    };

matlab2tikz('hsc.tex','width','0.45\textwidth','height','0.25\textwidth', ...
    'tikzFileComment','created from: hsc_MAIN.m ', ...
    'parseStrings',false,'extraAxisOptions',axoptions);
