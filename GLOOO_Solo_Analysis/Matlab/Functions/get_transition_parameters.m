%% function [] = get_note_parameters(paths,param)
%
%
%
% Henrik von Coler
% 2014-02-17

function [transModel] = get_transition_parameters(trans, features, param)


nTrans = length(trans);
for transCount=1:nTrans
    
 
    
    [transModel(transCount)] =  ...
        analyze_transition(features,param, trans(transCount).start, trans(transCount).stop);
    
end



end


