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

HSC_ALL = [];

for i=1:length(files)
    
    if  files(i).isdir~=1
        
        inFile  = [files(i).folder '/'  files(i).name];
        
        [~,baseName,~] = fileparts(files(i).name);
        
        
        hsc_single
        
        HSC_ALL = [HSC_ALL; HSC];
        
        xVec    = linspace(1,127,length(HSC));
        
        colVec = [1 1 1] - [1 1 1]./(5-CNTR)^1.5;
        
        xxx = plot(xVec, HSC,'k','linewidth',0.5);
        hold on
        
        CNTR = CNTR + 1;
        
        set(xxx,'Color',colVec);
        
        mapC = [mapC;colVec];
    end
end

%%



leg  =legend({'$\SI{180}{Hz}$','$\SI{358}{Hz}$','$\SI{715}{Hz}$','$\SI{1429}{Hz}$'},'Location','eastoutside');

%title(leg,'MIDI pitch')
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

axoptions={'axis on top',
    'axis on top',
    'scaled x ticks = false',
    'scaled y ticks = false',
    'axis line style ={shorten <=-5pt}',
    'axis x line=bottom',
    'axis y line=left',
    'tick align=outside',
    'xtick style={color=black,thick}',
    'ytick style={color=black,thick}'
    %'y tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=2}'
    };

matlab2tikz('hsc.tex','width','0.95\textwidth','height','0.25\textheight', ...
    'tikzFileComment','created from: hsc_MAIN.m ', ...
    'parseStrings',false,'extraAxisOptions',axoptions);


%%

M = cell(4,1);

for i=1:4
   
   M{i} =  fitlm(xVec',HSC_ALL(i,:)','linear');
  
end



%%

r = zeros(1,4);
p = zeros(1,4);

for i=1:4
   
   [r(i), p(i)] =  corr(xVec',HSC_ALL(i,:)');
  
end

