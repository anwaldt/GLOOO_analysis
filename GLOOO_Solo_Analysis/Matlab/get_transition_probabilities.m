% get_transition_probabilities(in, N_distributions, N_icmf)
%
% Generates a markov model for the 
%
% HVC
% 2017-02-20

function [H, CMF, cmf_support] = get_transition_probabilities(in, N_distributions, N_icmf)


% use soma filter (maybe?)
% in = soma_filter(in,0.2);



% the standard support points for the ICMF
cmf_support = linspace(0,1,N_icmf);

% we are assuming normal distribution, here


maxval = prctile(in,95);
minval = median(in) + (median(in) - prctile(in,97));

tmpAmps     = linspace(minval,maxval, N_distributions);

%%  allocate cell aray for distributions
H           = cell(1, N_distributions);

for frameCNT = 1:length(in)-1
    
    tmpVal      = in(frameCNT);   
    
    if tmpVal >= minval && tmpVal <= maxval
        
        [~,tmpIDX]  = (min(abs(tmpAmps - tmpVal)));
        
        nextVal     = in(frameCNT+1);
        
        if nextVal >= minval && nextVal <= maxval
            H{tmpIDX}   = [H{tmpIDX}, nextVal];
        end
        
    end
end



CMF = struct();
CMF.support = cmf_support;

CMF.valid = zeros(1,N_distributions);

for distCNT = 1:N_distributions
    
    
    %% create cmf
    
    [pmf,x_values]   = hist(H{distCNT}, tmpAmps);
    
    if sum(pmf)==0
        CMF.valid(distCNT) = 0;
    else
        CMF.valid(distCNT) = 1;
    end
    
    % normalize
    pmf       = pmf./sum(pmf);
    
    % create cmf
    cmf     = cumsum(pmf);
    
    %% INVERT
    
    icmf    = zeros(1,N_icmf);
    
    for icmfCNT = 1: N_icmf
        
        % get support point
        tmpH    = cmf_support(icmfCNT);
        
        
        lowerIDXs = find(cmf<tmpH);
        
        
        if ~isempty(lowerIDXs)
            
            tmpIDX = lowerIDXs(end);
            
            icmf(icmfCNT) =  x_values(tmpIDX);
            
            
        end
        
        
    end
    
    
    eval(['CMF.dist_' num2str(distCNT) '.icmf = icmf;']);
    eval(['CMF.dist_' num2str(distCNT) '.xval = x_values;']);
    
    
    %     CMF{distCNT}.XVAL = x_values;
    %     CMF{distCNT}.ICMF = icmf;
    
    
end



