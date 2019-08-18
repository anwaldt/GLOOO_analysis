% get_transition_probabilities(in, N_distributions, N_icmf)
%
% Generates a markov model for the
%
% HVC
% 2017-02-20

function [H, ICMF, cmf_support, tmpAmps] = get_transition_probabilities(in, N_distributions, N_icmf)


% use soma filter (maybe?)
% in = soma_filter(in,0.2);



% the standard support points for the ICMF
cmf_support = linspace(0,1,N_icmf);

% we are assuming normal distribution, here


maxval = max(in);%prctile(in,99);
minval = min(in);%median(in) + (median(in) - prctile(in,99));

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




ICMF            = struct();



valid = zeros(1,N_distributions);


for distCNT = 1:N_distributions
    
    %% create cmf
    
    [pmf,x_values]   = hist(H{distCNT}, tmpAmps);
    
    if sum(pmf)==0
        valid(distCNT) = 0;
    else
        valid(distCNT) = 1;
    end
    
    % normalize
    pmf       = pmf./sum(pmf);
    
    % create cmf
    cmf     = cumsum(pmf);
    
    %% INVERT
    
    
    
    icmf    = zeros(1,N_icmf);
    
    
    for icmfCNT = 1: N_icmf-1
        
        % get support point
        tmpH    = cmf_support(icmfCNT);
        
        
        higherIDXs = find(cmf>tmpH);
        
        
        if ~isempty(higherIDXs)
            
            tmpIDX = higherIDXs(1);
            
            icmf(icmfCNT) =  x_values(tmpIDX);
            
            
        end
        
    end
    
    
    icmf(end) = icmf(end-1);
    % close all, plot(x_values,pmf), figure ,plot(x_values,cmf), figure, plot(cmf_support,icmf)
    
    
    if(valid(distCNT)==1)
        eval(['ICMF.icmf_' num2str(distCNT) ' = icmf;']);
        %eval(['ICMF.dist_' num2str(distCNT) '.xval = x_values;']);
    end
    
end

% remove empty cumulants
validIDX    = cellfun(@(x) ~isempty(x), H);
tmpAmps     = tmpAmps(validIDX);
H           = H(validIDX);

%cmf_support = cmf_support(validIDX);


N_distributions = length(H);
ICMF.support    = cmf_support;
ICMF.values     = tmpAmps;

xxx = 666;



%     CMF{distCNT}.XVAL = x_values;
%     CMF{distCNT}.ICMF = icmf;


end



