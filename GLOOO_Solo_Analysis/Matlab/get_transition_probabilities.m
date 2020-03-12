% get_transition_probabilities(in, N_distributions, N_icmf)
%
% Generates a markov model for the
%
% HVC
% 2017-02-20

function [H, ICMF, cmf_support, distribution_centers] = get_transition_probabilities(in, param)



if param.MARKOV.plot == 1
    
    close all
    f1 = figure(1);
    hold on;
    
    f2 = figure(2);
    hold on;
    
    f3 = figure(3);
    hold on;
    
    f4 = figure(4);
    hold on;
    
end

N_distributions = param.MARKOV.N_distributions;


% use soma filter (maybe?)
% in = soma_filter(in,0.2);




% we are assuming normal distribution, here

maxval      = max(in);%prctile(in,99);
minval      = min(in);%median(in) + (median(in) - prctile(in,99));

distribution_centers     = linspace(minval,maxval, N_distributions);
plot_centers     = linspace(minval,maxval, 100);

%% count transitions

%  allocate cell aray for distributions
H           = cell(1, N_distributions);

for frameCNT = 1:length(in)-1
    
    % grab this value
    tmpVal      = in(frameCNT);
    
    if tmpVal >= minval && tmpVal <= maxval
        
        % quantize value
        [~,qIDX]  = min(abs(distribution_centers - tmpVal));
        
        nextVal     = in(frameCNT+1);
        
        if nextVal >= minval && nextVal <= maxval
            
            % put following value into distribution
            H{qIDX}   = [H{qIDX}, nextVal];
        end
        
    end
end



% remove empty cumulants
validIDX    = cellfun(@(x) ~isempty(x), H);
H           = H(validIDX);

distribution_centers     = distribution_centers(validIDX);
N_distributions = length(H);



valid = zeros(1,N_distributions);
valid(validIDX) = 1;


if size(distribution_centers)>1
    PMF = hist(in, distribution_centers);
    PMF = PMF/sum(PMF);
else
        PMF = 1;
end


if param.MARKOV.plot == 1
    
    figure(2)
    stem(distribution_centers, PMF,'Color', [0 0 0]);
    
end


ICMF = struct();

% used for storing and plotting
PMF  = {};
X    = {};

for distCNT = 1:N_distributions
    
    
    % toggle line style for plots
    if rem(distCNT,2) == 0
        linest = '-';
    else
        linest = '--';
    end
    
    
    %% create cmf
    
    tmpValues = H{distCNT};
    
    n_values  = length(tmpValues);
    
    tmpMax      = max(tmpValues);
    
    tmpMin      = min(tmpValues);
    
    if n_values == 0
        
        valid(distCNT) = 0;
        
        % if only one value is in range
    elseif n_values == 1
        
        % needs to be put as cell for yaml compatibility
        icmf        = {tmpValues};
        x_values    = {0.5};
        
        eval(['ICMF.icmf_' num2str(distCNT) '.icmf = icmf;']);
        eval(['ICMF.icmf_' num2str(distCNT) '.support = x_values;']);
        
        
        if param.MARKOV.plot == 1
            
            figure(1)
            line([icmf{1} icmf{1}], [0 1] ,'DisplayName',['$PMF_{' num2str(distCNT) '}$'],'Color',[1 1 1]* distCNT/(N_distributions*1.5),'LineStyle',linest);
            
            figure(3)
            line([icmf{1} icmf{1}], [0 1] ,'DisplayName',['$CMF_{' num2str(distCNT) '}$'],'Color',[1 1 1]* distCNT/(N_distributions*1.5),'LineStyle',linest);
            
            figure(4)
            line([0 1], [icmf{1} icmf{1} ] ,'DisplayName',['$ICMF_{' num2str(distCNT) '}$'],'Color',[1 1 1]* distCNT/(N_distributions*1.5),'LineStyle',linest);
            
        end
        
    elseif n_values > 1
        
        
        % rule of thumb - use sqrt for number of data points:
        %        N_icmf          = ceil(sqrt(n_values));
        % restrict size by parameter settings:
        N_icmf          = min(n_values, param.MARKOV.N_icmf);
        
        cmf_support     = linspace(0,1,N_icmf);
        
        % get density:
        tmp_icmf_val    = linspace(tmpMin, tmpMax, N_icmf);
        [pmf,x_values]  = hist(tmpValues, tmp_icmf_val);
        pmf             = pmf./sum(pmf);
        
        % store PMFs
        PMF = [PMF, pmf];
        X = [X, x_values];
        
        if param.MARKOV.plot == 1
            
            figure(1)
            plot(x_values,pmf,'DisplayName',['$PMF_{' num2str(distCNT) '}$'],'Color',[1 1 1]* distCNT/(N_distributions*1.5),'LineStyle',linest);
            
            
        end
        
        % create cmf by integration:
        cmf     = cumsum(pmf);
        
        if param.MARKOV.plot == 1
            
            figure(3)
            plot(x_values,cmf,'DisplayName',['$CMF_{' num2str(distCNT) '}$'],'Color',[1 1 1]* distCNT/(N_distributions*1.5), 'LineStyle',linest);
            
        end
        
        %% INVERT
        
        icmf    = zeros(1,N_icmf);
        
        
        for icmfCNT = 1: N_icmf-1
            
            % get support point
            tmpH    = cmf_support(icmfCNT);
            
            
            higherIDXs = find(cmf>tmpH);
            
            
            if ~isempty(higherIDXs)
                
                qIDX          = higherIDXs(1);
                
                icmf(icmfCNT)   =  x_values(qIDX);
                
                
            else
                1;
            end
            
        end
        
        
        
        
        % the last value of the ICMF is the last value of the cmf
        icmf(end) = x_values(end);
        
        
        
        % alternative version (only for plots, now)
        icmf2  = sort(tmpValues);
        
        
        eval(['ICMF.icmf_' num2str(distCNT) '.icmf = icmf;']);
        eval(['ICMF.icmf_' num2str(distCNT) '.support = cmf_support;']);
        
        
        
        linestyle = '';
        
        if param.MARKOV.plot == 1
            
            
            figure(4)
            plot(cmf_support,icmf,'DisplayName',['$ICMF_{' num2str(distCNT) '}$'],'Color',[1 1 1]* distCNT/(N_distributions*1.5), 'LineStyle',linest);
            plot(linspace(0,1,length(icmf2)),icmf2)
        end
        
        
        
        
        
        
        
        
        
    end
    
    
    
    %cmf_support = cmf_support(validIDX);
    
    
    N_distributions     = length(H);
    
    %ICMF.support        = cmf_support;
    
    ICMF.dist_centers   = distribution_centers;
    ICMF.valid          = valid;
    
    %     CMF{distCNT}.XVAL = x_values;
    %     CMF{distCNT}.ICMF = icmf;
    
    if param.MARKOV.plot == 1
        
        figure(1)
        axis tight
        xlabel('a')
        ylabel('$P_x(PMF,a)$')
        %legend show
        legend('Location','northeastoutside')
        
        axoptions={'scaled y ticks = false',...
            'y tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=2}'};
        
        matlab2tikz(['multiple-pmfs.tex'],'width','0.9\textwidth','height','0.4\textwidth', ...
            'tikzFileComment','created from: get_transition_probabilites.m ', ...
            'parseStrings',false,'extraAxisOptions',axoptions);
        
        
        figure(2)
        xlabel('a')
        ylabel('$P_x(a)$')
        
        axoptions={'scaled y ticks = false',...
            'y tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=2}'};
        
        matlab2tikz(['single-pmf.tex'],'width','0.75\textwidth','height','0.4\textwidth', ...
            'tikzFileComment','created from: get_transition_probabilites.m ', ...
            'parseStrings',false,'extraAxisOptions',axoptions);
        
        
        figure(3)
        axis tight
        xlabel('a')
        ylabel('$P_x(PMF,a)$')
        legend show
        legend('Location','northeastoutside')
        
        
        axoptions={'scaled y ticks = false',...
            'y tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=2}'};
        
        matlab2tikz(['multiple-cmf.tex'],'width','0.9\textwidth','height','0.4\textwidth', ...
            'tikzFileComment','created from: get_transition_probabilites.m ', ...
            'parseStrings',false,'extraAxisOptions',axoptions);
        
        
        figure(4)
        axis tight
        xlabel('Uniform')
        ylabel('$a_i$')
        %legend hide
        %legend('Location','northeastoutside')
        
        
        axoptions={'scaled y ticks = false',...
            'x tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=2}'};
        
        matlab2tikz(['multiple-icmf.tex'],'width','0.9\textwidth','height','0.4\textwidth', ...
            'tikzFileComment','created from: get_transition_probabilites.m ', ...
            'parseStrings',false,'extraAxisOptions',axoptions);
        
    end
    
end

%% this is for plotting a matrix of transition probabilities



if param.MARKOV.plot == 3
    fid = fopen(    'data.txt', 'w');
    N = length(PMF);
    T = [];
    
    for(i=1:N)
        
        t1 = PMF{i};imagesc(T);
        x1 = X{i};
        
        t2 = interp1(x1,t1,plot_centers);
        
        t2(isnan(t2)) = 0;
        
        T = [T; t2];
    end
    
    T = [zeros(1, size(T,2)) ; T; zeros(1, size(T,2))];
    
    for(i=1:size(T,1))
        
        for(j=1:size(T,2))
            
            s = [num2str(j), ' ',num2str(i), ' ' num2str(T(i,j)), '\n'];
            
            fprintf(fid, s);
            
        end
        
        fprintf(fid, '\n');
        
        
    end
    
    dlmwrite('test.txt', T', 'delimiter', ' ');
    fclose(fid);
    
end

