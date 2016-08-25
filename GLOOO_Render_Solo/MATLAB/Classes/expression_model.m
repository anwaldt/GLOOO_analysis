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
            obj.lTrans  = 100;
            
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
        
        function [noteModel] = calculate_glissando_trajectories(obj, noteModel, lastNoteModel, inTrans)
            
            
            
            % delete attack segment
            noteModel.A(:,1:noteModel.loop.loopPoints(1))   = [];

            noteModel.f0vec(1:noteModel.loop.loopPoints(1)) = [];

            
            nPart       = noteModel.nPart;
            
            % get the last f0-value of the preceeding note:
            f0_start    = lastNoteModel.f0vec(lastNoteModel.smsPOS);
            f0_end      = noteModel.f0vec(1);
            
            % get the transition length
            lTrans      =   inTrans.stopIND - inTrans.startIND;
            
            if  f0_start >= f0_end
                
                inTrans.startIND
                % f0-trajectory - transition
                F0_trans = f0_start + abs(f0_start-f0_end) * 1./(1+exp(-1*(linspace(-5,5,lTrans) )));
                
            else
                
                
                F0_trans = f0_start - abs(f0_start-f0_end) * 1./(1+exp(-1*(linspace(-5,5,lTrans) )));
                
            end
            
            % create a sigmoidal amplitude glissando
            A_trans = zeros(nPart,lTrans);
            
            for i=1:nPart
                
                if   lastNoteModel.s(i).a <= noteModel.A(i,1)
                    A_trans(i,:) =  lastNoteModel.s(i).a +   abs( lastNoteModel.s(i).a-noteModel.A(i,1)) * 1./(1+exp(-1*(linspace(-5,5,lTrans) )));
                else
                    A_trans(i,:) =  lastNoteModel.s(i).a -   abs( lastNoteModel.s(i).a-noteModel.A(i,1)) * 1./(1+exp(-1*(linspace(-5,5,lTrans) )));
                end
                % additional damping of (higher!?) partials during the transition:
                % Atrans(i,:) =   Atrans(i,:).* (1- (4*i/nPart)* sin(linspace(0,pi,obj.lTrans)));
                
            end
           
            %% append
            
            noteModel.A = [A_trans noteModel.A ];
            
            noteModel.f0vec = [F0_trans'; noteModel.f0vec ]; 
 
        end
        
        
        
        function [obj, vibTraj] = get_vibrato_trajectory(obj)
            
            
            
        end
        
        
        
    end
end

