% statistical_sms.m
%
% Function for extracting some values from the patial trajectories!
% The basic idea is to decompose the trajectories into a deterministic
% part (mean freq. and amplitude) and stochastic deviations!
% Also, attack and release have to be captured!
%
% HVC
% 2017-02-20

function [MOD] = statistical_sms(baseName, param, paths)


%% load partial data

inName     = [paths.sinusoids baseName '.mat'];
load(inName);

%% Read text labels

load([paths.segments  regexprep(baseName,'BuK','DPA') '.mat']);
% C   = textscan(fid, '%f %s');
% fclose(fid);
%

bounds = [0 0];
bounds(1) =SOLO.SEG{2}.startSEC;
bounds(2) =SOLO.SEG{2}.stopSEC;

bSamp   =  round( bounds /(SOLO.param.lHop / SOLO.param.fs));

startSamp   = max(1,bSamp(1));
stopSamp    =   bSamp(2);

%% Sustain part




SUS = struct();

for partCNT = 1:param.PART.nPartials
    
    
    fSteady = SMS.FRE(:,startSamp:stopSamp);
    fS  = fSteady(partCNT,: );
    [h,x]=hist(fS,50);
    distFun = cumsum(h);
    
    SUS(partCNT).FRE.dist = distFun;
    SUS(partCNT).FRE.vals = x;
    
    aSteady = SMS.AMP(:,startSamp:stopSamp);
    aS  = aSteady(partCNT,:);
    
    [h,x]=hist(aS,50);
    distFun = cumsum(h);
    SUS(partCNT).AMP.dist = distFun;
    SUS(partCNT).AMP.vals= x;
    
    %     plot(distFun)
    %     drawnow
    %     pause(1)
    
end


%% attack

ATT = struct();

for partCNT = 1:param.PART.nPartials
    
    
    ATT(partCNT).FRE.trajectory = SMS.FRE(partCNT,1:startSamp);
    
    ATT(partCNT).AMP.trajectory = SMS.AMP(partCNT,1:startSamp);
    
end


%% release

REL = struct();

for partCNT = 1:param.PART.nPartials
    
    
    REL(partCNT).FRE.trajectory = SMS.FRE(partCNT,stopSamp:end);
    
    REL(partCNT).AMP.trajectory = SMS.AMP(partCNT,stopSamp:end);    
end


%% Put together and export

MOD.param = param;
MOD.ATT = ATT;
MOD.SUS = SUS;
MOD.REL = REL;

name = [paths.statSMS baseName '.yml'];
%S = YAML.dump(MOD);
YAML.write(name,MOD);

