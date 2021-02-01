

%%




[x,fs] = audioread(inFile);




x = x(1000:end-1000,:);

nPart  = size(x,2);
L      = size(x,1);
1



% swipe
overlap = 0.5;


% rms
nWIN    = 512;

lWin    = 0.5*nWIN/fs;

nHOP    = nWIN*overlap;

%%

close all

mapC =[];


LL = length(x);

for partCNT = 1:30
    
    tmpX        = x(:,partCNT);
    
    % tmpX = tmpX(1:LL);
    
    if partCNT ==1
        [f0Vec,t,s] = swipep(tmpX, fs, [100 fs],lWin,[],1/20, 0.5, 0.2);
    end
    
    
    tmpX   = [zeros(nWIN,1); tmpX];
    L      = length(tmpX);
    rmsVec = [];
    
    
    idx         = 1:nWIN;
    frameCNT    = 1;
    
    
    while max(idx) < L
        
        try
            frame = tmpX(idx);
        catch
            1;
        end
        
        rmsVec(frameCNT) = rms(frame);
        
        idx      = idx+nHOP;
        frameCNT = frameCNT+1;
    end
    
    xplot = smooth(f0Vec*partCNT,50);
    
    yplot = smooth(rmsVec,50);
    
    xxx = semilogx( xplot(10:10:end) , smooth(yplot(10:10:end),3)  ,'k');
    
    colVec = [1 1 1] * (partCNT/30)^0.3;
    
    set(xxx,{'linew'},{0.4},'Color',colVec)
    
    
    mapC = [mapC;colVec];
    
    hold on
    
    LL = LL/2;
    
end


xlim([100, 10e3])
ylim([0,0.12])


xlabel('$f / Hz $');
ylabel('$a_i(f)$')


colormap(mapC)
caxis([0 30]);

h=colorbar;

set(get(h,'title'),'string','Partial index');

axoptions={'axis on top',...
    'scaled y ticks = false',...
    'y tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=2}'
    };

 

% another version with peak labels

% peaks =[ 283.5938    0.1379
%     414.8838    0.0773
%     500.3906    0.1346
%     708.9293    0.0350
%     871.8750    0.0546
%     1170       0.0348
%     1326       0.0352];
% 
% 
% for i=1:length(peaks)
%     
%     plot((peaks(i,1)),peaks(i,2),'or','MarkerSize',12)
%     text(peaks(i,1),peaks(i,2)+0.005,[num2str(round(peaks(i,1))) ' Hz'])
%     
% end



% rectangle('Position',[1800 0.005 1500 0.04],'EdgeColor','r')




%  matlab2tikz(outFile,'width','0.35\textwidth','height','0.125\textwidth', ...
%      'smoothed', ...
%      'tikzFileComment','created from: analyze_sem_Single.m ', ...
%      'parseStrings',false,'extraAxisOptions',axoptions);
