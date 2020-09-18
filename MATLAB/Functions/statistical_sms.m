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
    
    
    [tmp_s, s_cor, s_mod, s_fluct] = decompose_trajectory(fS', param);
    
    
    
    if strcmp(param.MARKOV.plot, 'f0-dist')
        
        f1 = figure;
        
        hold on
        
        plot(fS ,'Color', 0.8 * [1 1 1 ], 'LineWidth', 1.5);
        
        xlabel('Frame')
        ylabel('$f_i$')
        axoptions={'scaled y ticks = false',...
            'y tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=2}'};
        
        matlab2tikz(['decomp_t_freq_p' num2str(partCNT) '_' baseName '.tex'],'width','0.9\textwidth','height','0.4\textwidth', ...
            'tikzFileComment','created from: statistical_sms.m ', ...
            'parseStrings',false,'extraAxisOptions',axoptions);
        
        close(f1)
        
        
        f1 = figure;
        
        hold on
        
        [h1, x1] = hist(fS,50);
        plot(x1, h1 / sum(h1) ,'Color', 0.8 * [1 1 1 ], 'LineWidth', 1);
        
        xlim([0.95,1.05]);
        
        hold off
        
        xlabel('$f_i / f_0$')
        ylabel('PMF')
        axoptions={'scaled y ticks = false',...
            'y tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=2}'};
        
        
        matlab2tikz(['decomp_h_freq_p' num2str(partCNT) '_' baseName '.tex'],'width','0.4\textwidth','height','0.3\textwidth', ...
            'tikzFileComment','created from: statistical_sms.m ', ...
            'parseStrings',false,'extraAxisOptions',axoptions);
        
        close(f1)
        
    end
    
    
    [H, CMF, cmf_values, support] = get_transition_probabilities(fS, param, baseName);
    
    
    % write to struct
    
    % basic parameters
    eval(['SUS.PARTIALS.P_' num2str(partCNT) '.FRE' '.med  = tmpMed;']);
    eval(['SUS.PARTIALS.P_' num2str(partCNT) '.FRE' '.std  = tmpStd;']);
    eval(['SUS.PARTIALS.P_' num2str(partCNT) '.FRE' '.mean  = tmpMean;']);
    
    % the direct distribution
    eval(['SUS.PARTIALS.P_' num2str(partCNT) '.FRE' '.ICMF = CMF;']);
    eval(['SUS.PARTIALS.P_' num2str(partCNT) '.FRE' '.xval = support;']);
    
    
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
    
    
    
    if strcmp(param.MARKOV.plot, 'amp-decomp')
        
        f1 = figure;
        
        hold on
        
        
        plot(aS ,      'Color', 0.8 * [1 1 1 ], 'LineWidth', 0.75, 'DisplayName','$a$');
        plot(a_fluct , 'Color', 0.1 * [1 1 1 ], 'LineWidth', 0.75, 'DisplayName','$a_\mathit{AC} + a_\mathit{fluct}$');
        
        
        
        xlabel('Frame')
        ylabel('$a[n]$')
        
        legend show
        
        axoptions={
            'axis on top', ...
            'axis x line=bottom' , ...
            'axis y line=left', ...
            'scaled x ticks = false',...
            'scaled y ticks = false',...
            'y tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=4 , 1000 sep = {}}', ...
            'x tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=0 , 1000 sep = {}}', ...
            'legend style={at={(1.03,1)}, anchor=north west, legend cell align=left, align=left, draw=white!15!black}'};
        
        
        
        matlab2tikz(['decomp_t_amp_p' num2str(partCNT) '_' baseName '.tex'],...
            'width','0.75\textwidth','height','0.4\textwidth', ...
            'tikzFileComment','created from: statistical_sms.m ', ...
            'parseStrings',false,'extraAxisOptions',axoptions);
        
        close(f1)
        
        
        f1 = figure;
        
        hold on
        
        [h1, x1] = hist(aS,50);
        plot(x1, h1 / sum(h1) ,'Color', 0.8 * [1 1 1 ], 'LineWidth', 1);
        
        [h2, x2] = hist(a_fluct,50);
        plot(x2, h2 / sum(h2) ,'Color', 0.1 * [1 1 1 ], 'LineWidth', 1);
        
        hold off
        
        xlabel('a')
        ylabel('PMF')
        axoptions={'scaled y ticks = false',...
            'y tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=2}'};
        
        
        %legend('$f_0$', '$f_{0_{AC}} f_{0_{fluct}} $')
        
        matlab2tikz(['decomp_h_amp_p' num2str(partCNT) '_' baseName '.tex'],'width','0.4\textwidth','height','0.3\textwidth', ...
            'tikzFileComment','created from: statistical_sms.m ', ...
            'parseStrings',false,'extraAxisOptions',axoptions);
        
        close(f1)
        
    end
    
    
    
    
    [H, CMF, cmf_values] = get_transition_probabilities(a_fluct, param, baseName);
    
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
    
    
    if param.MARKOV.plot == 'noise-decomp'
        
        f1 = figure;
        
        hold on
        
        plot(nS ,'Color', 0.8 * [1 1 1 ], 'LineWidth', 1, 'DisplayName','$\mathit{RMS}$');
        
        plot(e_fluct ,'Color', 0.1 * [1 1 1 ], 'LineWidth', 1, 'DisplayName', '$\mathit{RMS}_\mathit{AC} + \mathit{RMS}_\mathit{fluct}$');
        
        
        xlabel('Frame')
        ylabel('$\mathit{RMS}[n]$')
        axoptions={'axis x line=bottom' , ...
            'axis y line=left', ...
            'scaled x ticks = false',...
            'scaled y ticks = false',...
            'y tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=3 , 1000 sep = {}}', ...
            'x tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=0 , 1000 sep = {}}'};
        
        
        legend('RMS', '$RMS_{AC} + RMS_{fluct} $')
        
        
        matlab2tikz([
            'decomp_t_noise' num2str(bandCNT) '_' baseName '.tex'], ...
            'width','0.5\textwidth','height','0.3\textwidth', ...
            'tikzFileComment','created from: statistical_sms.m ', ...
            'parseStrings',false,'extraAxisOptions',axoptions);
        
        close(f1)
        
        
        f1 = figure;
        
        hold on
        
        [h1, x1] = hist(nS,50);
        plot(x1, h1 / sum(h1) ,'Color', 0.8 * [1 1 1 ]);
        
        [h2, x2] = hist(e_fluct,50);
        plot(x2, h2 / sum(h2) ,'Color', 0.1 * [1 1 1 ]);
        
        hold off
        
        xlabel('RMS')
        ylabel('PMF')
        axoptions={
            'axis x line=bottom' , ...
            'axis y line=left', ...
            'scaled x ticks = false',...
            'scaled y ticks = false',...
            'y tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=2}', ...
            'x tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=3}'};
        
        
        legend('RMS', '$RMS_{AC} + RMS_{fluct} $')
        
        
        matlab2tikz(['decomp_h_noise' num2str(bandCNT) '_' baseName '.tex'],...
            'width','0.4\textwidth','height','0.3\textwidth', ...
            'tikzFileComment','created from: statistical_sms.m ', ...
            'parseStrings',false,'extraAxisOptions',axoptions);
        
        close(f1)
        
    end
    
    
    
    [H, CMF, cmf_values] = get_transition_probabilities(e_fluct, param, baseName);
    
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
ATT.start    =  SOLO.SEG{1}.startIND;
ATT.stop     =  SOLO.SEG{1}.stopIND;
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

L_rel = REL.stop - REL.start;

eval(['REL.length = L_rel;']);


for partCNT = 1:param.PART.nPartials
    
    % partial frequencies
    tmpF    = SMS.FRE(partCNT,stopSamp:end);
    tmpVal  = tmpF./mean(CTL.f0.swipe.f0(startSamp:stopSamp))./partCNT;
    tmpVal  = tmpVal./tmpVal(1);
    
    tmpL    = length(tmpF);
 
    %
    %     eval(['REL.PARTIALS.P_' num2str(partCNT) '.FRE' '.trajectory = tmpVal;']);
    %
    % partial amplitudes
    tmpTra = SMS.AMP(partCNT,REL.start:end);
    
    % get lambda value
    
    
    tmpTra = tmpTra./max(tmpTra);
    
    L = length(tmpTra);
    
    NN = 200;
    
    errors = zeros(1,NN);
    
    for lambda = 1:NN
        
        a_model = exponential_release(L,lambda);
        
        errors(lambda) = (1/L)   * sum(  (a_model-tmpTra).^2 );
        
    end
    
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
    [~, lambda_min] = min(errors);
    
    
    eval(['REL.PARTIALS.P_' num2str(partCNT) '.lambda = lambda_min;']);
    
    
    
    
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
