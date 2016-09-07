classdef segment
    
    %SEGMENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        % boundaries in seconds
        startSEC
        stopSEC

        % boundaries in indices
        startIND
        stopIND
        
        % structs for properties of f0 and amplitude
        AMP
        F0
        
        % struct with the analysis parameters
        param
        
    end
    
    methods
        
        function obj = segment(start, stop) 
            
        end
    end
        
end

