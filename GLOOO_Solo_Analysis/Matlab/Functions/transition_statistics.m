%% function  [] =  transition_statistics(fileNames, param, paths)
%
%
%
% Author : HvC
% Created: 2020-09-18

function [] = transition_statistics(fileNames, param, paths)

nPart = param.PART.nPartials;


%% collect all lanbda values for the groups in the timbre plain

P_MAT = cell(nPart,5,2);

for fileCNT = 1:length(fileNames)
    
    [~,baseName,~] = fileparts(fileNames{fileCNT});
    
    % remove microphone identifier for the data set:
    tmpName = regexprep(regexprep(baseName, '_BuK', ''),  '_DPA', '');
    
    if param.info == true
        disp(['gathering release statistics for: ',tmpName]);
    end
    
    MATname = [paths.statSMS tmpName '.mat'];
    load(MATname, 'MOD');
    
    
    INF = load_tone_properties(regexprep(baseName,'BuK','DPA') , param, paths, 'x', 'x');
    
    if(INF.midinote < 67)
        tmp_note = 1;
    elseif(67 <= INF.midinote && INF.midinote < 78)
        tmp_note = 2;
    elseif(78 <= INF.midinote && INF.midinote < 90)
        tmp_note = 3;
    elseif(INF.midinote >= 91)
        tmp_note = 4;
    end
    
    if(strcmp(INF.intensity,'pp')==1)
        tmp_dyn = 1;
    elseif(strcmp(INF.intensity,'mp')==1)
        tmp_dyn = 1;
    elseif(strcmp(INF.intensity,'mf')==1)
        tmp_dyn = 2;
    elseif(strcmp(INF.intensity,'ff')==1)
        tmp_dyn = 2;
    end
    
    for partCNT = 1:nPart
        
        eval(['tmp = MOD.REL.PARTIALS.P_' num2str(partCNT) ';']);
        
        P_MAT{partCNT, tmp_note, tmp_dyn} = [P_MAT{partCNT, tmp_note, tmp_dyn}, tmp.lambda];
        
    end
    
end

%% get group statistics

mean_lambda = zeros(nPart,4);
std_lambda  = zeros(nPart,2);

for partCNT=1:nPart
    
    
    if param.info == true
        disp(['grouping release statistics for partial : ', num2str(partCNT)]);
    end
    
    for (noteCNT = 1:4)
        
        for (dynCNT = 1:2)
            
            tmp_mean = mean(P_MAT{partCNT,noteCNT,dynCNT});
            
            tmp_std  = std(P_MAT{partCNT,noteCNT,dynCNT});
            
            
            mean_lambda(partCNT, noteCNT, dynCNT) = tmp_mean;
            std_lambda(partCNT, noteCNT, dynCNT)  = tmp_std;
        end
    end
    
end



%% Plot ?!

close all;

axoptions={'scaled y ticks = false', ...
    'y tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=0}', ...
    'axis line style ={shorten <=-5pt}', ...
    'axis x line=bottom', ...
    'axis y line=left', ...
    'axis on top', ...
    'tick align=outside', ...
    'xtick style={color=black,thick}', ...
    'ytick style={color=black,thick}',...
    'xmax = 85'
    };

if(param.TRANS.plot == 'groups')
    
    
    for noteCNT = 1:4
        
        for dynCNT = 1:2
            
            
            
            figure;
            plot(tmp_mean,'Color', 0.75 * [1 1 1 ], 'LineWidth', 1.0);
            hold on;
            plot(smooth_mean,'Color', 0.0 * [1 1 1 ]);
            
            
            xlabel('Partial')
            ylabel('$\mu(\lambda)$')
            
            matlab2tikz(['lambda_mean_' num2str(noteCNT) '_' num2str(dynCNT) '.tex'],'width','0.45\textwidth','height','0.25\textwidth', ...
                'tikzFileComment','created from: transition_statistics.m ', ...
                'parseStrings',false,'extraAxisOptions',axoptions);
            
        end
        
    end
    
    
end


%% Export to mat files

for fileCNT = 1:length(fileNames)
    
    [~,baseName,~] = fileparts(fileNames{fileCNT});
    
    % remove microphone identifier for the data set:
    tmpName = regexprep(regexprep(baseName, '_BuK', ''),  '_DPA', '');
    
    if param.info == true
        disp(['evaluating release statistics for: ',tmpName]);
    end
    
    MATname = [paths.statSMS tmpName '.mat'];
    load(MATname, 'MOD');
    
    
    INF = load_tone_properties(regexprep(baseName,'BuK','DPA') , param, paths, 'x', 'x');
    
    if(INF.midinote < 67)
        tmp_note = 1;
    elseif(67 <= INF.midinote && INF.midinote < 78)
        tmp_note = 2;
    elseif(78 <= INF.midinote && INF.midinote < 90)
        tmp_note = 3;
    elseif(INF.midinote >= 91)
        tmp_note = 4;
    end
    
    if(strcmp(INF.intensity,'pp')==1)
        tmp_dyn = 1;
    elseif(strcmp(INF.intensity,'mp')==1)
        tmp_dyn = 1;
    elseif(strcmp(INF.intensity,'mf')==1)
        tmp_dyn = 2;
    elseif(strcmp(INF.intensity,'ff')==1)
        tmp_dyn = 2;
    end
    
    tmp_mean    =  (mean_lambda(:,tmp_note,tmp_dyn));
    smooth_mean = smooth(tmp_mean,5);
    
    tmp_std    =  (std_lambda(:,tmp_note,tmp_dyn));
    smooth_std = smooth(tmp_std,5);
    
    for partCNT=1:nPart
        
        tm = smooth_mean(partCNT);
        ts = smooth_std(partCNT);
        
        eval(['MOD.REL.PARTIALS.P_' num2str(partCNT) '.mean = ' num2str(tm) ';']);
        eval(['MOD.REL.PARTIALS.P_' num2str(partCNT) '.std = '  num2str(ts) ';']);
        
    end
    
    save(MATname, 'MOD');
    
end