classdef note < segment
    
    %NOTE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        MIDI
        vibrato
        
    end
    
    methods
        
        function obj = note(start, stop, vibrato)
            
            obj.startSEC    = start;
            obj.stopSEC     = stop;
            obj.vibrato     = vibrato;
        end
    end
    
end

