%% function [SEG] = prepare(segBounds, paths,param)
%
%   This function prepares the SEGMENT properties.
%   It creates a cell array of segments, setting only 
%   those attributes mutual to both 'notes' and 'trans'.
%
%   MIND:
%   adjusted to the two-note (T-N-T-N-T) sequences, only ...
%   later, this has to be changed and sequences 
%   of any kind should be processed.
%
%
%   Henrik von Coler
%   Created:  2016-08-18
%
%%

function [SEG] = prepare_segments(segBounds, I, param, features)

% unpack / map transition properties
segINF = cell(1,5);
segINF{1} = 'attack';
segINF(3) = I.trans.articulation;
segINF{5} = 'release';

% unpack / map note properties
segINF{2}.vib = I.note1.vibrato;
segINF{4}.vib = I.note2.vibrato;

% shift segment boundaries by first marker
% because they are already truncated !!!
segBounds(:,1)  = segBounds(:,1) - segBounds(1,1);

segBounds(1,:)      = [];
% segBounds(end,:)    = [];

nSegments           = size(segBounds,1)-1;

SEG = cell(1,nSegments);

for segCNT = 1:nSegments
    
   tmpLabel = segBounds(segCNT,2);
   tmpStart = segBounds(segCNT,1);
   tmpStop  = segBounds(segCNT+1,1);
   
   switch tmpLabel
       
       % create a NOTE
       case 1
           tmpSeg = note(tmpStart, tmpStop, segINF{segCNT}.vib);
           
       % create a TRANS    
       case 2
           
           tmpSeg = trans(tmpStart, tmpStop, segINF{segCNT});
           
   end
   
   SEG{segCNT} = tmpSeg;
       
    
end

end


