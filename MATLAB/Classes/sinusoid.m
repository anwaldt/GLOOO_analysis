classdef sinusoid
    
    %NOTE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        thisPhas   
        lastPhas
        f
        a
        
    end
    
    
    
    methods
    
        %% Constructor
        function obj     = sinusoid(f)
            obj.a        = 0;
            obj.f        = f;
 
            obj.lastPhas = rand;
       
        end
        
        
        %% Method for getting a frame
        function  [obj, frame]  = get_frame(obj,L,fs)
        
            
        
            % time axis
            t = (0:1/fs:(L-1)/fs)';

            
            % at zero
            obj.thisPhas =  wrapTo2Pi(obj.lastPhas + (2*pi*obj.f * -t(L/4)));
             
            frame = obj.a * sin(2*pi*obj.f * t + obj.thisPhas);
            
            %obj.thisPhas = wrapTo2Pi(2*pi*obj.f * t(end) + obj.thisPhas);
        
            obj.lastPhas = wrapTo2Pi(2*pi*obj.f * t(3*(L/4)) + obj.thisPhas);
 
            
        end
    end
    
end