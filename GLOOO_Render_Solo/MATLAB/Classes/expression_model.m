%%
%
%   The expression Model creates (or will)
%   - control parameters, based on descriptors (legato, etc)
%   - partial trajectoris based on controll trajectories
%
%
%%


classdef expression_model
    
    %EXPRESSION_MODEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        % default length of glissando slopes
        lTrans;
        
        % default frequency of vibrato
        fVib;
        
        % default vibrato phase
        pVib;
        
        % maximal vibrato depth in cent(in realtion to 127 MIDI steps)
        aVib;
        
        MODE;
    
    end
    
    methods
        
        function obj = expression_model(MODE)
            
            % set some defaults
            obj.lTrans  = 100;
            
            obj.fVib    = 7;
            obj.pVib    = 0;
            obj.aVib    = 2;
            
            obj.MODE = MODE;
            
        end
        
        function [F0_trans, Atrans] = calculate_glissando_trajectories(obj, prevSin, targetAmp, f0_end)
            
            
            nPart       = length(prevSin);
            
            % get the last f0-value of the preceeding note:
            f0_start    = prevSin(1).f0;
            
            if  f0_start <= f0_end
                
                % f0-trajectory - transition
                F0_trans = f0_start + abs(f0_start-f0_end) * 1./(1+exp(-1*(linspace(-5,5,obj.lTrans) )));
            
            else
                
                
                F0_trans = f0_start - abs(f0_start-f0_end) * 1./(1+exp(-1*(linspace(-5,5,obj.lTrans) )));
            
            end
            
            % create a sigmoidal amplitude glissando
            Atrans = zeros(nPart,obj.lTrans);
            
            for i=1:nPart
                
                if  prevSin(i).a <= targetAmp(i)
                    Atrans(i,:) = prevSin(i).a +   abs(prevSin(i).a-targetAmp(i)) * 1./(1+exp(-1*(linspace(-5,5,obj.lTrans) )));
                else
                    Atrans(i,:) = prevSin(i).a -   abs(prevSin(i).a-targetAmp(i)) * 1./(1+exp(-1*(linspace(-5,5,obj.lTrans) )));
                end
                % additional damping of (higher!?) partials during the transition:
%                  Atrans(i,:) =   Atrans(i,:).* (1- (4*i/nPart)* sin(linspace(0,pi,obj.lTrans)));
                
            end
            
        end
        
        
        
        function [obj, vibTraj] = get_vibrato_trajectory(obj)
            
            
            
        end
        
        
        
    end
end

