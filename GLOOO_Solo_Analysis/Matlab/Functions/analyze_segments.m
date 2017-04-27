%% function [] = analyze_segments(paths,param)
%
%   Function for preparing the segment structures
%   which are needed for the following analysis!
%
%   Gets note boundaries ('segBounds') from the annotations of the GLOOO!
%
% Henrik von Coler
% Created:  2014-02-17
% Edited :  2016-08-09
%
%%

function [notes, trans, noteTrans] = analyze_segments(segBounds, param, features)



% shift segment boundaries by first marker
segBounds(:,1)  = segBounds(:,1) - segBounds(1,1);
nSeg            = size(segBounds,1);
% set last == 2 for safety
segBounds(end,2) = 2;


noteInds    = find(segBounds(:,2)==1);
nNotes      = length(noteInds);
notes       = struct([]);
noteTrans   = struct([]);

for noteCount = 1:nNotes
    
    disp(['Doing note ' num2str(noteCount) ' of ' num2str(nNotes)]);
    
    % get note boundaries
    notes(noteCount).start = segBounds( noteInds(noteCount),1);
    notes(noteCount).stop  = segBounds( noteInds(noteCount)+1,1);
    
    if noteCount>1
        noteTrans(noteCount-1).start = notes(noteCount-1).stop;
        noteTrans(noteCount-1).stop  = notes(noteCount).start;
    end
    
end

transInds   = find(segBounds(1:end-1,2)==2);
nTrans      = length(transInds);
trans       = struct([]);

for transCount=1:nTrans
    trans(transCount).start = segBounds( transInds(transCount),1);
    trans(transCount).stop  = segBounds( transInds(transCount)+1,1);
end


end


