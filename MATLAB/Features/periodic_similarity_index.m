%% totMaxVal = periodic_similarity_index(frame)
%
% Gets the global maximum of the
% normalized autocorrelation, not regarding
% the "0-lag" maximum for each column of the
% input matrix 'frame'
%
% This feature holds information on the general
% periodicity and stationarity of the analysis frame.
% High values indicate a low tonality and a increase
% in error rate for correlation based f0-detection.
%
%
% Author: Henrik von Coler
% Date:   2013-02-22

function psiVec = periodic_similarity_index(frame)

N = size(frame,2);

psiVec = zeros(1,N);

for colInd=1:N
    
    [yy, lag] = xcorr(frame(:,colInd));
    totMaxVal = 0;
    
    if ~ isnan(yy)       
        if ~max(yy)==0
            
            % Use only right half
            tmp = fix(length(yy)/2)+1:length(yy) ;
            yy  = yy(tmp);
            yy  = yy/max(yy);
            
            % Find global min
            [~, lstart]    = min(yy);
            
            % Find largest peak after first minimum
            [totMaxVal, ~] = max(yy(lstart:end));
         
        end
    end
    
    psiVec(colInd) = totMaxVal;
    
end