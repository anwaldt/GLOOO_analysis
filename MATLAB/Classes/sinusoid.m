classdef sinusoid
    
    %NOTE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        thisPhas
        lastPhas
        compSine
        fracBin
        f
        bin
        a
    end
    
    
    
    methods
    
        %% Constructor
        function obj     = sinusoid(f)
            obj.a        = 0;
            obj.f        = f;
            obj.lastPhas = 0;
        end
        
        
        %% Method for getting a frame
        function  [frame]  = get_frame(obj,L,fs)
        
   
            
            % time axis
            t = (0:1/fs:(L-1)/fs)';
            
            frame = obj.a * sin(2*pi*obj.f*t + obj.lastPhas);
            
            obj.thisPhas = obj.lastPhas+2*pi*obj.f*t(end);
            
        end
    end
    
end