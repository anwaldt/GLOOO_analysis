function  [SEG] = get_segment_parameters(SEG, controlTrajectories, param)

nSeg = length(SEG);

for segCNT = 1:nSeg
    
    tmpSeg  = SEG{segCNT};
    c       = class(tmpSeg);
    
    switch c
        
        case 'note'
          tmpSeg = analyze_note(tmpSeg,  controlTrajectories, param);
        
        case 'trans'
          tmpSeg = analyze_transition(tmpSeg, controlTrajectories,param);
    
        otherwise 
              
              error('Unknown Segment Type!');
    end
    
    SEG{segCNT} = tmpSeg;
    
    
    
end



