%% Get Interval for F0
%
% This function returns an interval in which a f0 trajectory should be
% The Information comes out of the INF Object and gets the beginning and
% the ending note of the transition
%
% Input: - INF Object (defined in function load_solo_properties())
%        - cent deviation for frequncies in cent
%
% Ouput: - [lower_note - cent,  higher_note + cent]  in Hz
%
% author: Moritz Goetz

function [ f_interval ] = get_f_interval( INF , cent)

if length(fieldnames(INF))>1
    note1 = get_frequency_for_note(INF.note1.char{1});
    note2 = get_frequency_for_note(INF.note2.char{1});
    
    % Threshold for Deviation from the notes
    max_dev = cent; % (Deviation per Note in cent )
    
    note_low  = min(note1,note2);
    note_high = max(note1,note2);
    
    % Only Notes inside this interval are treated as valid notes
    f_interval =[change_f_in_cent(note_low, -max_dev), ...
        change_f_in_cent(note_high, max_dev) ];
    
else
   1; 
end

end

