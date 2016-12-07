function [MOD] = model_trajectories(inFile, paths)


%% load partial data

inName     = [paths.matDir inFile];
load(inName);

%% Read text labels

fid = fopen([paths.segDIR  regexprep(inFile,'BuK','DPA') '.txt']);
C   = textscan(fid, '%f %s');
fclose(fid);

bound   = [C{:,1}];

bounds  = bound- bound(1);

bSamp   =  round( bounds /(param.lHop / param.fs));

startSamp  = max(1,bSamp(1));
stopSamp = min( bSamp(2),length(partials.FRE));

%%

MOD = [];

 
for partCNT = 1:param.PART.nPartials
    
    fSteady = partials.FRE(:,startSamp:stopSamp); 
    fS  = fSteady(partCNT,: );
    [h,x]=hist(fS,50);
    distFun = cumsum(h);
    MOD.FRE.dist{partCNT} = distFun;
    MOD.FRE.vals{partCNT} = x;
    
    aSteady = partials.AMP(:,startSamp:stopSamp);
    aS  = aSteady(partCNT,:);

    [h,x]=hist(aS,50);
    distFun = cumsum(h);
    MOD.AMP.dist{partCNT} = distFun;
    MOD.AMP.vals{partCNT}= x;

%     plot(distFun)
%     drawnow
%     pause(1)
   
end



% plot(fSteady')
% plot(aSteady')
