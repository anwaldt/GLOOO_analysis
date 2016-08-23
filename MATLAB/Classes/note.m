classdef note < segment
    
    %NOTE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        
        
        MIDI
        
        vibrato
        
    end
    
    methods
        
        function obj = note(start, stop, vibrato)
            
            obj.start = start;
            obj.stop = stop;
            obj.vibrato = vibrato;
        end
    end
    
end

