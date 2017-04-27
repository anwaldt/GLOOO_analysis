%% function [] = get_note_parameters(paths,param)
%
% wrapper to call the function 'analyze_note()' for all
% notes in the input structure
%
% Henrik von Coler
% 2014-02-17

function [noteModels] = get_note_parameters(noteBounds, features, I, param)


nNotes = length(noteBounds);




for noteCount = 1:nNotes
    
    [noteModels(noteCount)] =  analyze_note(noteBounds(noteCount),  features, param);
    
    
end




