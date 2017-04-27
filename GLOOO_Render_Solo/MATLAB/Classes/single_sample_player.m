%% classdef single_sample_player.m
%
%
%
% HvC
% 2014-04-22
%%

classdef single_sample_player
    
    
    properties
        
        
        
        resamp;
        param;
        fileName;
        x;
        fs;
        
        nn;
        vel;
        
        % is st to '1' when the note is released
        isReleased = 0;
        % is set to '1' if release is finished
        isFinished = 0;
        
    end
    
    properties (Access = protected)
        currPos     = 1;
        releasePos  = 1;
        releaseEnv;
    end
    
    methods
        
        function obj        = single_sample_player(n, v, resamp,  fileName, paths, p)
            obj.param       = p;
            obj.resamp      = resamp;
            
            [obj.x, obj.fs] = wavread([paths.SAMPLES fileName]);
            obj.fileName    = fileName;
                        
            obj.nn          = n;
            obj.vel         = v;
            
            obj.releaseEnv  = (((((1*44100:-1:0)/(44100*0.6)))).^2)';
            
        end
        
        
          
        function [obj] = process_controls(expMod)
            
            
        end
        
        
        
        function [obj,frame] = get_frame(obj)
            
            % get frame for this position
            frame = obj.x(obj.currPos:obj.currPos+obj.param.lWin_synth-1);
            
            if obj.isReleased == 0
                
                % if not released - do nothing esle
                
            else
                
                thisReleaseInds = obj.releasePos:obj.releasePos+obj.param.lWin_synth-1;
                % get release indices
                
                % if we are within relese rang
                if thisReleaseInds(end)<=length(obj.releaseEnv)
                    
                    thisEnvPart = obj.releaseEnv(thisReleaseInds);
                    
                    % if we exceed it
                else
                    % zero pad the envelope
                    goodInds    = thisReleaseInds(find(thisReleaseInds<=length(obj.releaseEnv)));
                    thisEnvPart = [obj.releaseEnv(goodInds);zeros( obj.param.lWin_synth - length(goodInds),1)];
                    
                    % and set note object to 'finished' state
                    obj.isFinished = 1;
                end
                
                % apply envelope
                frame = frame .* thisEnvPart;
                
                % increment release counter
                obj.releasePos = obj.releasePos + obj.param.lWin_synth ;
            end
            
            % increment counter
            obj.currPos = obj.currPos+ obj.param.lWin_synth;
            
        end
        
        
      
    end
    
end

