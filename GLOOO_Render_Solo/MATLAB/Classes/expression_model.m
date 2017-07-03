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
        
        transMODE;
        
    end
    
    methods
        
        function obj = expression_model(transMODE)
            
            % set some defaults
            obj.lTrans  = 50;
            
            obj.fVib    = 7;
            obj.pVib    = 0;
            obj.aVib    = 2;
            
            obj.transMODE = transMODE;
            
        end
        
        
        %% Returns a mofified note Model
        % including amplitude and frequency trajectories for the partials
        % during the transition
        
        function [noteModel] = calculate_attack_segment(obj, noteModel , attackSegment)
            
            
            
        end
        
        %% Returns a mofified note Model
        % including amplitude and frequency trajectories for the partials
        % during the transition
        
        function [F0_trans, A_trans] = calculate_glissando_trajectories(obj, smsPlayer, lastSMSplayer, inTrans)
            
            
            
            % delete attack segment
            smsPlayer.A(:,1:smsPlayer.loop.points(1))   = [];

            smsPlayer.noteModel.F0.trajectory(1:smsPlayer.loop.points(1)) = [];

            
            nPart       = smsPlayer.nPart;
            
            % get the last f0-value of the preceeding note:
            f0_start    = lastSMSplayer.noteModel.F0.trajectory(lastSMSplayer.smsPOS);
            f0_end      = smsPlayer.noteModel.F0.trajectory(1);
            
            % get the transition length
            % this needs to be corrected by the ration of the sampling
            % rates (sinusoids/soloanalyspis)
            obj.lTrans      =  round( (inTrans.stopIND - inTrans.startIND)*0.5);
            
            if  f0_start <= f0_end
                
                inTrans.startIND
                % f0-trajectory - transition
                F0_trans = f0_start + abs(f0_start-f0_end) * 1./(1+exp(-1*(linspace(-5,5,obj.lTrans) )));
                
            else
                
                
                F0_trans = f0_start - abs(f0_start-f0_end) * 1./(1+exp(-1*(linspace(-5,5,obj.lTrans) )));
                
            end
            
            % create a sigmoidal amplitude glissando
            A_trans = zeros(nPart,obj.lTrans);
            
            for i=1:nPart
                
                if   lastSMSplayer.s2{i}.a <= smsPlayer.A(i,1)
                    A_trans(i,:) =  lastSMSplayer.s2{i}.a + abs( lastSMSplayer.s2{i}.a-smsPlayer.A(i,1)) * 1./(1+exp(-1*(linspace(-5,5,obj.lTrans) )));
                else
                    A_trans(i,:) =  lastSMSplayer.s2{i}.a - abs( lastSMSplayer.s2{i}.a-smsPlayer.A(i,1)) * 1./(1+exp(-1*(linspace(-5,5,obj.lTrans) )));
                end
                % additional damping of (higher!?) partials during the transition:
                % Atrans(i,:) =   Atrans(i,:).* (1- (4*i/nPart)* sin(linspace(0,pi,obj.lTrans)));
                
            end
           
            %% PRE-pend
            
            % smsPlayer.A = [A_trans smsPlayer.A ];
            
            % smsPlayer.noteModel.F0.trajectory = [F0_trans'; smsPlayer.noteModel.F0.trajectory ]; 
 
        end
        
        
        
        function [obj, vibTraj] = get_vibrato_trajectory(obj)
            
            
            
        end
        
        
        
    end
end

