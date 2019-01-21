function [out] = get_phase_min(param, t, partCNT, partAmp, partFre, windowFunction, residual)

sP              = linspace(-pi,pi,param.PART.nPhaseSteps);
minValues       = zeros(1,param.PART.nPhaseSteps);
partialPhase    = zeros(1,param.PART.nPhaseSteps);
searchInd = 1;

% first rough
for searchPhase = sP
    
    thisPartial     = partAmp(partCNT) * sin(2*pi*partFre(partCNT).*t + searchPhase ).*windowFunction;
    tmpResidual     = residual   - thisPartial;
    
    partialPhase(searchInd) = searchPhase;
    minValues(searchInd)    = sum( (tmpResidual).^2);
    searchInd = searchInd+1;
    
end

[~, ind]         = min(minValues);

partPha(partCNT) = partialPhase(ind);


% then fine

if ind>1
    lowerBound = partialPhase(ind-1);
else
    lowerBound = partialPhase(end);
end

if ind<param.PART.nPhaseSteps
    upperBound = partialPhase(ind+1);
else
    upperBound = partialPhase(1);
end

sP              = linspace(lowerBound, upperBound, param.PART.nPhaseSteps);
minValues       = zeros(1,param.PART.nPhaseSteps);
partialPhase    = zeros(1,param.PART.nPhaseSteps);

searchInd = 1;

for searchPhase = sP
    
    thisPartial     = partAmp(partCNT) * sin(2*pi*partFre(partCNT).*t + searchPhase ).*windowFunction;
    tmpResidual     = residual   - thisPartial;
    
    partialPhase(searchInd) = searchPhase;
    minValues(searchInd)    = sum( (tmpResidual).^2);
    searchInd = searchInd+1;
end

[~, ind] = min(minValues);

out = partialPhase(ind);
