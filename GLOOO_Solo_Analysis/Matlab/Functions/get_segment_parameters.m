%% function  [SEG] = get_segment_parameters(SEG, CTL, param)
%
%   Calls the individual analysis functions for all
%   notes + trans in the SEG cell array
%
%   Henrik von Coler
%
%   Created : 2016-08-08
%
%%

function  [SEG] = get_segment_parameters(SEG, CTL, SMS, param, paths)

if param.info == true
    disp('    get_segment_parameters(): Starting...');
end

nSeg = length(SEG);

for segCNT = 1:nSeg
    
    if param.info == true
        disp(['    get_segment_parameters(): Segment ' num2str(segCNT) ' of ' num2str(nSeg)]);
    end
    
    tmpSeg  = SEG{segCNT};
    c       = class(tmpSeg);
    
    % use the relevant function for either 'note' or 'trans'
    switch c
        
        case 'note'
            tmpSeg = analyze_note(tmpSeg, CTL, param, paths);
            
        case 'trans'
            tmpSeg = analyze_transition(tmpSeg, CTL, SMS, param);
            
        otherwise
            error('Unknown Segment Type!');
    
    end
    
    SEG{segCNT} = tmpSeg;
    
end



