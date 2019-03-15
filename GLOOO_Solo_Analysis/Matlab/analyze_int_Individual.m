 



inFile  = [files(6).folder '/'  files(6).name];
 
 

%%

[~,baseName,~] = fileparts(inFile);
        


[x,fs] = audioread(inFile);




x = x(1000:end-1000,:);

nPart  = size(x,2);
L      = size(x,1);




% swipe
overlap = 0.5;


% rms
nWIN    = 512;

lWin    = 0.5*nWIN/fs;

nHOP    = nWIN*overlap;

%%

close all

mapC = [];
LL   = length(x);

for partCNT = 1
    
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
    
    xxx = semilogx(   xplot(10:10:end), yplot(10:10:end)  ,'k');
    
    colVec = [1 1 1] * (partCNT/30)^0.33;
    
    %set(xxx,{'linew'},{1},'Color',colVec)
    
   
    
    xlabel('$f / Hz $');
    ylabel('$a_i(f)$')
    
    
    axoptions={'axis on top',...
        'scaled y ticks = false',...
        'y tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=2}'};
    
    
    outFile = [baseName '_' num2str(partCNT) '.tex'];

    
    
        matlab2tikz(outFile,'width','0.375\textwidth','height','0.175\textwidth', ...
        'tikzFileComment','created from: analyze_sem_Single.m ', ...
        'parseStrings',false,'extraAxisOptions',axoptions);
    
    
    
    
end



