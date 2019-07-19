% statistical_sms.m
%
% Function for extracting and stochastic parxameters
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

bounds      = [0 0];
bounds(1)   = SOLO.SEG{2}.startSEC;
bounds(2)   = SOLO.SEG{2}.stopSEC;

bSamp       = round( bounds /(SMS.param.lHop / SMS.param.fs));

startSamp   = max(1,bSamp(1));
stopSamp    = bSamp(2);


%% Sustain part

%
%   figure

SUS = struct();

% get FRE partial trajectory for sustain part
fSteady = SMS.FRE(:,startSamp:stopSamp);



for partCNT = 1:param.PART.nPartials
    
    % get segment and normalize to: deviation from f / (f0*N)
    fS      = fSteady(partCNT,: );
    fS      = fS./ mean(CTL.f0.swipe.f0(startSamp:stopSamp))'./partCNT;
    
    %  get standard distribution features
    tmpMed  = median(fS);
    tmpMean = mean(fS);
    tmpStd  = std(fS);
    
    
    
    [H, CMF, cmf_values] = get_transition_probabilities(fS, param.MARKOV.N_distributions, param.MARKOV.N_icmf);
    
    
    % write to struct
    
    % basic parameters
    eval(['SUS.PARTIALS.P_' num2str(partCNT) '.FRE' '.med  = tmpMed;']);
    eval(['SUS.PARTIALS.P_' num2str(partCNT) '.FRE' '.std  = tmpStd;']);
    eval(['SUS.PARTIALS.P_' num2str(partCNT) '.FRE' '.mean  = tmpMean;']);
    
    % the direct distribution
    eval(['SUS.PARTIALS.P_' num2str(partCNT) '.FRE' '.ICMF = CMF;']);
    %eval(['SUS.PARTIALS.P_' num2str(partCNT) '.FRE' '.xval = cmf_values;']);
    
    
    % get AMP partial trajectory for sustain part
    aSteady = SMS.AMP(:,startSamp:stopSamp);
    aS      = aSteady(partCNT,:);
    
    % normalize to: contribution to overall harmonic amplitude
    %aS = aS./smooth(sum(SMS.AMP(:,startSamp:stopSamp)),10)';
    
    
    % get standard distribution features
    tmpMed  = median(aS);
    tmpMean = mean(aS);
    tmpStd  = std(aS);
    
    [tmp_a, a_cor, a_mod, a_fluct] = decompose_trajectory(aS', param);
    
    
    [H, CMF, cmf_values] = get_transition_probabilities(a_fluct, param.MARKOV.N_distributions, param.MARKOV.N_icmf);
    
    % write to struct
    
    % write basic parameters
    eval(['SUS.PARTIALS.P_' num2str(partCNT) '.AMP' '.med  = tmpMed;']);
    eval(['SUS.PARTIALS.P_' num2str(partCNT) '.AMP' '.std  = tmpStd;']);
    eval(['SUS.PARTIALS.P_' num2str(partCNT) '.AMP' '.mean  = tmpMean;']);
    
    % the direct distribution
    eval(['SUS.PARTIALS.P_' num2str(partCNT) '.AMP' '.ICMF = CMF;']);
    %%eval(['SUS.PARTIALS.P_' num2str(partCNT) '.AMP' '.xval = cmf_values;']);
    
    
end


for bandCNT = 1:size(SMS.BET,2)
    
    % the noise bands
    nSteady = SMS.BET(startSamp:stopSamp,:);
    nS      = nSteady(:,bandCNT);
    
    tmpMed  = median(nS);
    tmpMean = mean(nS);
    tmpStd  = std(nS);
    
    [tmp_e, e_cor, e_mod, e_fluct] = decompose_trajectory(nS, param);
     
    [H, CMF, cmf_values] = get_transition_probabilities(e_fluct, param.MARKOV.N_distributions, param.MARKOV.N_icmf);
    
    % write to struct
    
    % basic parameters
    eval(['SUS.RESIDUAL.BARK_' num2str(bandCNT) '.NRG' '.med  = tmpMed;']);
    eval(['SUS.RESIDUAL.BARK_' num2str(bandCNT) '.NRG' '.std  = tmpStd;']);
    eval(['SUS.RESIDUAL.BARK_' num2str(bandCNT) '.NRG' '.mean  = tmpMean;']);
    
    % the direct distribution
    eval(['SUS.RESIDUAL.BARK_' num2str(bandCNT) '.NRG' '.ICMF = CMF;']);
    %%eval(['SUS.RESIDUAL.BARK_' num2str(bandCNT) '.NRG' '.xval = cmf_values;']);
    
    
end

%% attack

ATT = struct();

% main parameters
ATT.start   =  SOLO.SEG{1}.startIND;
ATT.stop    =  SOLO.SEG{1}.stopIND;
ATT.duration =  SOLO.SEG{1}.stopSEC - SOLO.SEG{1}.startSEC;

for partCNT = 1:param.PART.nPartials
    
    % partial frequencies
    tmpF    = SMS.FRE(partCNT,1:startSamp);
    tmpVal  = tmpF./mean(CTL.f0.swipe.f0(startSamp:stopSamp))./partCNT;
    
    tmpVal  = tmpVal./tmpVal(end);
    tmpL    = length(tmpVal);
    %eval(['ATT.PARTIALS.P_' num2str(partCNT) '.FRE' '.trajectory = tmpVal;']);
    eval(['REL.PARTIALS.P_' num2str(partCNT) '.length = tmpL;']);
    
    % partial amplitudes
    tmpTra = SMS.AMP(partCNT,1:startSamp);
    
    if length(find(tmpTra==0)) ~= length(tmpTra)
        if tmpTra(end) == 0
            
            lastVal = find(tmpTra>0,1,'last') ;
            tmpTra(lastVal+1:end)=tmpTra(lastVal);
            
        end
        tmpTra = tmpTra./(tmpTra(end));
        
    end
    
    %eval(['ATT.PARTIALS.P_' num2str(partCNT) '.AMP' '.trajectory = tmpTra;']);
    
    if any(isnan(tmpF)) || any(isnan(tmpTra))
        error(['NaN in: ' baseName])
    end
    
end

% for the noise bands
for bandCNT = 1:size(SMS.BET,2)
    
    %
    tmpTra     = SMS.BET(1:startSamp,bandCNT);
    
    if length(find(tmpTra==0)) ~= length(tmpTra)
        if tmpTra(end) == 0
            
            lastVal = find(tmpTra>0,1,'last') ;
            tmpTra(lastVal+1:end)=tmpTra(lastVal);
            
        end
        tmpTra = tmpTra./(tmpTra(end));
        
    end
    
    tmpTra(isnan(tmpTra)) = 0;
    tmpL    = length(tmpF);
    
    %eval(['ATT.RESIDUAL.BARK_' num2str(bandCNT) '.AMP' '.trajectory = tmpTra;']);
    eval(['REL.RESIDUAL.BARK_' num2str(bandCNT) '.length = tmpL;']);
    
end

%% release

REL = struct();

REL.duration =  SOLO.SEG{3}.stopSEC - SOLO.SEG{3}.startSEC;


REL.start   =  SOLO.SEG{3}.startIND;
REL.stop   =  SOLO.SEG{3}.stopIND;

for partCNT = 1:param.PART.nPartials
    
    % partial frequencies
    tmpF    = SMS.FRE(partCNT,stopSamp:end);
    tmpVal  = tmpF./mean(CTL.f0.swipe.f0(startSamp:stopSamp))./partCNT;
    tmpVal  = tmpVal./tmpVal(1);
    
    tmpL    = length(tmpF);
    
    eval(['REL.PARTIALS.P_' num2str(partCNT) '.length = tmpL;']);
    
    %
    %     eval(['REL.PARTIALS.P_' num2str(partCNT) '.FRE' '.trajectory = tmpVal;']);
    %
    %     % partial amplitudes
    %     tmpTra = SMS.AMP(partCNT,stopSamp:end);
    %
    %     if length(find(tmpTra==0)) ~= length(tmpTra)
    %
    %         if tmpTra(1) == 0
    %
    %             firstVal = find(tmpTra>0,1);
    %             tmpTra(1:firstVal-1)=tmpTra(firstVal);
    %
    %         end
    %
    %         tmpTra = tmpTra./(tmpTra(1));
    %
    %     end
    %
    %
    %     eval(['REL.PARTIALS.P_' num2str(partCNT) '.AMP' '.trajectory = tmpTra;']);
    %
    %     if any(isnan(tmpF)) || any(isnan(tmpTra))
    %         error(['NaN in: ' baseName])
    %     end
    %
    %
    
end



for bandCNT = 1:size(SMS.BET,2)
    
    % partial frequencies
    tmp = SMS.BET(stopSamp:end,bandCNT);
    
    tmpTra = tmp./(tmp(1));
    
    if length(find(tmpTra==0)) ~= length(tmpTra)
        
        if tmpTra(1) == 0
            
            firstVal = find(tmpTra>0,1);
            tmpTra(1:firstVal-1)=tmpTra(firstVal);
            
        end
        
        tmpTra = tmpTra./(tmpTra(1));
        
    end
    
    tmpTra(isnan(tmpTra)) = 0;
    
    tmpL    = length(tmpF);
    
    %     eval(['REL.RESIDUAL.BARK_' num2str(bandCNT) '.AMP' '.trajectory = tmpTra;']);
    
    eval(['REL.RESIDUAL.BARK_' num2str(bandCNT) '.length = tmpL;']);
    
    
end

%% Put together and export

if param.info == true
    disp(['Writing output: ',baseName]);
end


MOD.param   = param;
MOD.INF     = INF;
MOD.ATT     = ATT;
MOD.SUS     = SUS;
MOD.REL     = REL;

YAMLname = [paths.yaml baseName '.yml'];
%S = YAML.dump(MOD);
YAML.write(YAMLname,MOD);

MATname = [paths.statSMS baseName '.mat'];
save(MATname, 'MOD');
