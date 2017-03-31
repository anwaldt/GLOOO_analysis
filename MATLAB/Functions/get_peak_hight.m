%%  [peakPhase] = get_peak_hight(FRAMEabs,maxInd)
% 
%
%
%   Henrik von Coler
%   2015-01-16
%% 

function     [truePeakVal, truePeakPos] = get_peak_hight(FRAMEabs,maxInd)

 

%% First step: Find local max in the likely range
% this is done by looking for inflections

peakBoundaries = [maxInd, maxInd];

tmpInd = maxInd;

% don't get out of bounds
if  tmpInd>2 && tmpInd<length(FRAMEabs)-10
    
    % get lower minumum position
    if tmpInd>2
        while FRAMEabs(tmpInd) > FRAMEabs(tmpInd-1)   && tmpInd>2
            tmpInd = tmpInd-1;
        end
        peakBoundaries(1)=tmpInd;
    end
    
    % get upper minimum position
    tmpInd = maxInd;
    if tmpInd<length(FRAMEabs)-10
        
        while FRAMEabs(tmpInd) > FRAMEabs(tmpInd+1) && tmpInd < length(FRAMEabs)-1
            tmpInd = tmpInd+1;
        end
        
        peakBoundaries(2)=tmpInd;
    end
    
    %% Second Step: Use Quadratic interpolation, See Smith:
    % https://ccrma.stanford.edu/~jos/parshl/Peak_Detection_Steps_3.html#sec:peakdet
    % using:        p = 1/2 (alpha-gamma)/(alpha-2beta+gamma)
    % with:         y(-1)=alpha , y(0)=beta , y(1)=gamma 
    
    % get the points
    alph    = FRAMEabs(maxInd-1);
    beta    = FRAMEabs(maxInd);
    gamm    = FRAMEabs(maxInd+1);
    
    % parabola peak location
    p       = 0.5 * (alph-gamm)/(alph-2*beta+gamm);
    
    % true peak location
    truePeakPos     = maxInd + p; 
    
    % maximum value
    truePeakVal     = beta-1/4*(alph-gamm)*p;
    
   
else
        
    % true peak location
    truePeakPos = 0; 
    
    % maximum value
    truePeakVal = 0;
    
end
