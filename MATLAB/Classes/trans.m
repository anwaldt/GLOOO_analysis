classdef trans < segment
    
    %NOTE Summary of this class goes here
    %   Detailed explanation goes here
    
    %% PROPERTIES
    properties
        
        % type is either attack / release / transition
        type;
        INF;
        
    end
    
    %% METHODS
    methods
        
        function    obj = trans(start, stop,t, INF)
            
            % assign boundaries
            obj.startSEC = start;
            obj.stopSEC = stop;
            
            %assign Info
            obj.INF = INF;
            
            if      strcmp(t,'attack') == 1 || ...
                    strcmp(t,'release') ==1 || ...
                    strcmp(t,'legato') ==1 || ...
                    strcmp(t,'glissando') ==1 || ...
                    strcmp(t,'detached') ==1
                obj.type = t;
            else
                error('Bad Transition Type')
            end
        end
        
    end
    
end
    
