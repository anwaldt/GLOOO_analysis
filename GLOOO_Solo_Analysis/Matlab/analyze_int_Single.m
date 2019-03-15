 



[x,fs] = audioread(inFile);





%%


offEnd  = 100;


L       = length(x);

yy      = linspace(0,10000,length(x));
    

[f0Vec,t,s] = swipep(x(:,1), fs, [100 4000]);

f0 = median(f0Vec);

fVEC = (1:50)*f0;


for bandCNT = 1:size(x,2)
   
    x(:,bandCNT) = smooth(abs(x(:,bandCNT)),1000);
    
end



 


%%

close all

mapC    = [];

CNTR = 2;


for indCNT=2000:L/10:L
    
    
    
    
        
    spec =   x(indCNT, 1:50) ;
        
     
    xxx = semilogy(fVEC/1000,spec ,'k','linewidth',1);
    
    colVec = [1 1 1] - [1 1 1]./(12-CNTR);
    
    set(xxx,'Color',colVec);
    
    hold on
    
    mapC = [mapC;colVec];
    
   CNTR = CNTR+1;
    
end


%xlim([min(fVEC), max(fVEC)])
%ylim([-10,-2])

axis tight
xlabel('$f / kHz $');
ylabel('$\log(amp)$');


colormap(mapC)
caxis([0 126]);

h = colorbar;

set(get(h,'title'),'string','Intensity');


%%

axoptions={'axis on top',...
    'scaled x ticks = false',...
    'scaled y ticks = false',...
    %'y tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=2}'
    };

matlab2tikz(outFile,'width','0.35\textwidth','height','0.125\textwidth', ...
    'tikzFileComment','created from: analyze-int_MAIN.m ', ...
    'parseStrings',false,'extraAxisOptions',axoptions);
