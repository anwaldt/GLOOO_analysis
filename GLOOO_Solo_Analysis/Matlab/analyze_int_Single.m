



[x,fs] = audioread(inFile);





%%

f_max = 22000;

offEnd  = 100;

n_partials = 80;

L       = length(x);

yy      = linspace(0,10000,length(x));


[f0Vec,t,s] = swipep(x(:,1), fs, [100 4000]);

f0 = median(f0Vec);

fVEC = (1:n_partials)*f0;

fVEC = fVEC(fVEC<=f_max);

for bandCNT = 1:size(x,2)
    
    x(:,bandCNT) = smooth(abs(x(:,bandCNT)),1000);
    
end




disp(length(fVEC));

disp(f0);

%%

close all

mapC    = [];

CNTR = 2;


for indCNT=2000:L/10:L
    
    
    
    
    
    spec =   x(indCNT, 1:length(fVEC));
    
    
    xxx = semilogy(spec ,'k','linewidth',0.5);
    
    colVec = [1 1 1] - [1 1 1]./(12-CNTR);
    
    set(xxx,'Color',colVec);
    
    hold on
    
    mapC = [mapC;colVec];
    
    CNTR = CNTR+1;
    
end


%xlim([min(fVEC), max(fVEC)])
%ylim([-10,-2])

axis tight
xlabel('$f / \si{kHz} $');
ylabel('$\log(a_i)$');


colormap(mapC)
caxis([0 126]);

h = colorbar;

set(get(h,'title'),'string','Intensity');


%%

% axoptions={
%     %'scale only axis',
%     'axis on top',
%     'scaled x ticks = false',
%     'scaled y ticks = false',
%     %
%     'axis line style ={shorten <=-5pt}', 
%     'axis x line=bottom', 
%     'axis y line=left', 
%     'axis on top', 
%     'tick align=outside', 
%     'xtick style={color=black,thick}', 
%     'ytick style={color=black,thick}', 
%     %
%     'yminorticks=false'
%     %'y tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=2}'
%     };
% 
% matlab2tikz(outFile, ...
%     'linewidth', '0.5pt', ...
%     'xmin','0', ...
%     'xmax', '20', ...
%     'width', '0.9\textwidth', ...
%     'height','0.25\textwidth', ...
%     'tikzFileComment','created from: analyze-int_MAIN.m ', ...
%     'parseStrings',false, ...
%     'extraAxisOptions',axoptions);
