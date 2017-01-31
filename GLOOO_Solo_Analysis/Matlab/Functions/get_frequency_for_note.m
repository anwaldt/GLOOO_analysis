%% Convert a note character into not value in Hertz
%
% Input: character for note value 
%        e.g. e'
% Ouput: Note Value in Hz
%        e.g. for e' : f = 329,63 
%
% ! NOT EVERY POSSIBLE INPUT CAN BE CONVERTED !
% -> add the correspoding note
%
% author: Moritz Goetz

function [ f ] = get_frequency_for_note( note )
    switch note
        case 'a'            % a
            f = 220;
        case ['d' char(39)] % d'
            f = 293.66 ;
        case ['e' char(39)] % e'
            f = 329.63;
        case ['d' char(39)] % d'
            f = 293.66;
        case ['g' char(39)] % g'
            f = 392;    
        case ['a' char(39)] % a'
            f = 440;
        case ['b' char(39)] % b'
            f = 466.16;
        case ['d' char(39) char(39)] % d''
            f = 587.33;
        case ['e' char(39) char(39)] % e''
            f = 659.26; 
        case ['fis' char(39) char(39)] % fis''
            f = 739.99;
        case ['b' char(39) char(39)] % b''
            f = 932.33;
        otherwise
            f = 0;
            error(['    get_frequency_for_note() failed for ' note])
    end

end

