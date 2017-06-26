% statistical_sms.m
%
% Function for extracting   and stochastic parxameters
% fom the sustain - works only for single sounds.
%
% Also, attack and release are captured!
%
% Writes the output to a yaml file.
%
% HVC
% 2017-02-20

function [MOD] = statistical_sms(baseName, param, paths, setToDo, micToDo)


%% load partial data

inName     = [paths.sinusoids baseName '.mat'];
load(inName);


%% load control features

load( [paths.features regexprep(baseName,'.wav','.mat')] );


switch setToDo
    case 'TwoNote'
        INF = load_solo_properties(regexprep(baseName,'BuK','DPA') , paths);
    case 'SingleSounds'
        INF = load_tone_properties(regexprep(baseName,'BuK','DPA') , paths);
end


%% Read text labels

load([paths.segments   baseName  '.mat']);
% C   = textscan(fid, '%f %s');
% fclose(fid);
%

bounds = [0 0];
bounds(1) =  SOLO.SEG{2}.startSEC;
bounds(2) =  SOLO.SEG{2}.stopSEC;

bSamp   =  round( bounds /(SMS.param.lHop / SMS.param.fs));

startSamp   = max(1,bSamp(1));
stopSamp    =   bSamp(2);


%% Sustain part

%
%   figure

SUS = struct();

for partCNT = 1:param.PART.nPartials
    
    % get FRE partial trajectory for sustain part
    fSteady = SMS.FRE(:,startSamp:stopSamp);
    fS      = fSteady(partCNT,: );
    
    % normalize to: deviation from f / (f0*N)
    fS      = fS./ mean(CTL.f0swipe(startSamp:stopSamp))'./partCNT;
    
    % decompose ?!
    
    
     tmpMed  = median(fS);
    tmpMean = mean(fS);
    tmpStd  = std(fS);
    
    
    % create cmf
    [h,x]=hist(fS,50);
    
    % normalize
    h = h./sum(h);
    
    % create cdf
    cdf = cumsum(h);
    
    %
    %       subplot(2,1,1)
    %         hold on
    %
    %      plot(x,cdf)
    %          drawnow
    %            pause(1)
    
    % write to struct
    
    % the direct distribution
    eval(['SUS.P_' num2str(partCNT) '.FRE' '.dist = cdf;']);
    eval(['SUS.P_' num2str(partCNT) '.FRE' '.xval = x;']);
    
    % basic parameters
    eval(['SUS.P_' num2str(partCNT) '.FRE' '.med  = tmpMed;']);
    eval(['SUS.P_' num2str(partCNT) '.FRE' '.std  = tmpStd;']);
    eval(['SUS.P_' num2str(partCNT) '.FRE' '.mean  = tmpMean;']);
    
    
    % get AMP partial trajectory for sustain part
    aSteady = SMS.AMP(:,startSamp:stopSamp);
    aS      = aSteady(partCNT,:);
    
    % normalize to: contribution to overall harmonic amplitude
    %aS = aS./smooth(sum(SMS.AMP(:,startSamp:stopSamp)),10)';
    
    % create cmf
    [h,x]=hist(aS,50);
    
    % normalize
    h = h./sum(h);
    
    % get cdf
    cdf = cumsum(h);
    
    %
    %       subplot(2,1,2)
    %         hold on
    %
    %      plot(x,cdf)
    %          drawnow
    %            pause(1)
    
    
    % write to struct
    %    SUS(partCNT).AMP.cdf  = cdf;
    %    SUS(partCNT).AMP.xVal = x;
    
    tmpMed  = median(aS);
    tmpMean = mean(aS);
    tmpStd  = std(aS);
    
    % write to struct
    
    % the direct distribution
    eval(['SUS.P_' num2str(partCNT) '.AMP' '.dist = cdf;']);
    eval(['SUS.P_' num2str(partCNT) '.AMP' '.xval = x;']);
    
    % basic parameters
    eval(['SUS.P_' num2str(partCNT) '.AMP' '.med  = tmpMed;']);
    eval(['SUS.P_' num2str(partCNT) '.AMP' '.std  = tmpStd;']);
    eval(['SUS.P_' num2str(partCNT) '.AMP' '.mean  = tmpMean;']);

    
end


%% attack

ATT = struct();

for partCNT = 1:param.PART.nPartials
    
    % partial frequencies
    tmpF    = SMS.FRE(partCNT,1:startSamp);
    tmpVal  = tmpF./mean(CTL.f0swipe(startSamp:stopSamp))./partCNT;
    tmpVal  = tmpVal./tmpVal(end);
    
    eval(['ATT.P_' num2str(partCNT) '.FRE' '.trajectory = tmpVal;']);
    
    % partial amplitudes
    tmpTra = SMS.AMP(partCNT,1:startSamp);
    
        if length(find(tmpTra==0)) ~= length(tmpTra)
            if tmpTra(end) == 0
    
                lastVal = find(tmpTra>0,1,'last') ;
                tmpTra(lastVal+1:end)=tmpTra(lastVal);
    
            end
            tmpTra = tmpTra./(tmpTra(end));
    
        end
    
    eval(['ATT.P_' num2str(partCNT) '.AMP' '.trajectory = tmpTra;']);
    
    if any(isnan(tmpF)) || any(isnan(tmpTra))
        error(['NaN in: ' baseName])
    end
    
end


%% release

REL = struct();

for partCNT = 1:param.PART.nPartials
    
    % partial frequencies
    tmpF    = SMS.FRE(partCNT,stopSamp:end);
    tmpVal  = tmpF./mean(CTL.f0swipe(startSamp:stopSamp))./partCNT;
    tmpVal  = tmpVal./tmpVal(1);
    
    eval(['REL.P_' num2str(partCNT) '.FRE' '.trajectory = tmpVal;']);
    
    % partial amplitudes
    tmpTra = SMS.AMP(partCNT,stopSamp:end);
    
    if length(find(tmpTra==0)) ~= length(tmpTra)
                
        if tmpTra(1) == 0
            
            firstVal = find(tmpTra>0,1);           
            tmpTra(1:firstVal-1)=tmpTra(firstVal);
            
        end
        
        tmpTra = tmpTra./(tmpTra(1));
        
    end
    
    
    eval(['REL.P_' num2str(partCNT) '.AMP' '.trajectory = tmpTra;']);
    
    if any(isnan(tmpF)) || any(isnan(tmpTra))
        error(['NaN in: ' baseName])
    end
    
end



%% Put together and export

if param.info == true
    disp(['Writing output: ',baseName]);
end


MOD.param = param;
MOD.INF = INF;
MOD.ATT = ATT;
MOD.SUS = SUS;
MOD.REL = REL;

YAMLname = [paths.statSMS baseName '.yml'];
%S = YAML.dump(MOD);
YAML.write(YAMLname,MOD);

MATname = [paths.statSMS baseName '.mat'];
save(MATname, 'MOD');
