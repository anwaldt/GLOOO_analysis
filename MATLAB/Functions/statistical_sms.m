% statistical_sms.m
%
% Function for extracting   and stochastic parxameters
% fom the sustain!
% Also, attack and release are captured!
%
% Writes the output to a yaml file.
%
% HVC
% 2017-02-20

function [MOD] = statistical_sms(baseName, param, paths)


%% load partial data

inName     = [paths.sinusoids baseName '.mat'];
load(inName);

%% load control features

load( [paths.features regexprep(baseName,'.wav','.mat')] );

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

% 
% figure
% hold on

SUS = struct();

for partCNT = 1:param.PART.nPartials
    
    % get FRE partial trajectory for sustain part
    fSteady = SMS.FRE(:,startSamp:stopSamp);
    fS      = fSteady(partCNT,: );
    
    % normalize to: deviation from f / (f0*N)
    fS      = fS./ mean(CTL.f0swipe(startSamp:stopSamp))'./partCNT;
    
    % decompose ?!
    
    
    % create cmf
    [h,x]=hist(fS,50);

    % normalize
    h = h./sum(h);
    
    % create cdf
    cdf = cumsum(h);
    
    % write to struct
    %SUS(partCNT).FRE.dist = cdf;
    %SUS(partCNT).FRE.vals = x;
    eval(['SUS.P_' num2str(partCNT) '.FRE' '.dist = cdf;']);
    eval(['SUS.P_' num2str(partCNT) '.FRE' '.xval = x;']);

    
    
%       plot(x,cdf)
%          drawnow
%          pause(1)
         
    % get AMP partial trajectory for sustain part    
    aSteady = SMS.AMP(:,startSamp:stopSamp);
    aS      = aSteady(partCNT,:);
    
    % normalize to: contribution to overall harmonic amplitude
    aS = aS./smooth(sum(SMS.AMP(:,startSamp:stopSamp)),10)';
    
    % create cmf
    [h,x]=hist(aS,50);

    % normalize
    h = h./sum(h);
    
    % get cdf
    cdf = cumsum(h);

    % write to struct
%    SUS(partCNT).AMP.cdf  = cdf;
%    SUS(partCNT).AMP.xVal = x;
    
    eval(['SUS.P_' num2str(partCNT) '.AMP' '.dist = cdf;']);
    eval(['SUS.P_' num2str(partCNT) '.AMP' '.xval = x;']);
    
    
end


%% attack

ATT = struct();

for partCNT = 1:param.PART.nPartials
    
    tmpF = SMS.FRE(partCNT,1:startSamp);
    tmpVal = tmpF./mean(CTL.f0swipe(startSamp:stopSamp))./partCNT;
    eval(['ATT.P_' num2str(partCNT) '.FRE' '.trajectory = tmpVal;']);
    
    
    tmpTra = SMS.AMP(partCNT,1:startSamp);
    eval(['ATT.P_' num2str(partCNT) '.AMP' '.trajectory = tmpTra;']);
         
end


%% release

REL = struct();

for partCNT = 1:param.PART.nPartials
    
            tmpF = SMS.FRE(partCNT,stopSamp:end);
    tmpVal = tmpF./mean(CTL.f0swipe(startSamp:stopSamp))./partCNT;
    eval(['REL.P_' num2str(partCNT) '.FRE' '.trajectory = tmpVal;']);
    
    
    tmpTra = SMS.AMP(partCNT,stopSamp:end);
    eval(['REL.P_' num2str(partCNT) '.AMP' '.trajectory = tmpTra;']);

end



%% Put together and export

if param.info == true
    disp(['Writing output: ',baseName]);
end


MOD.param = param;
MOD.ATT = ATT;
MOD.SUS = SUS;
MOD.REL = REL;

YAMLname = [paths.statSMS baseName '.yml'];
%S = YAML.dump(MOD);
YAML.write(YAMLname,MOD);

MATname = [paths.statSMS baseName '.mat'];
save(MATname, 'MOD');