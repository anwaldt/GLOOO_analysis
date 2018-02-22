%% Normalize f0 trajectory
% a trajectory from note1 to note1 is normalized to a transition between
% 0 and 1.
%
% Input:   f0    : values of trajectory in Hz 
%          note1 : starting note in Hz 
%          note2 : ending note in Hz 
%
% Output : f0_norm    : normalized f0 trajectory inside the Intervall [0,1]
%          trans_cent : deviation from note1 to note2 in cent 
%
% author: Moritz Götz

function [f0_norm , trans_cent] = normalize_f0( f0, note1, note2)
    
    trans_cent = get_deviation_cent(note1,note2);
    
    f0_norm = (f0 - min(note1,note2)) / abs(note1 - note2);    

end
