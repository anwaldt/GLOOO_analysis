%% classdef single_sinmod_player.m
%
%
%
% HvC
% 2014-11-25
%
%%

classdef single_sinmod_player
    
    
    properties
        
        % the note to be played
        noteModel;
        
        % this is the counter for the position within the frames of the
        % partial trajectories:
        smsPOS;
        
        % this is the counter for the position within the
        % trajectories of the note model:
        ctlPOS;
        
        % this one can chage the speed we index through the note:
        noteStretchFactor;
        
        % this is the mean power spectral density of the noise
        meanNoise;
        
        % and the trajectory of the noise energy
        noiseEnergy;
        
        % the instantaneous vibrato extent in the recent frame
        vibCent;
        
        % number of total frames in the matrices
        nFrames
        
        % the f0synth-trajectory for the transitional segment (if needed)
        %         f0_trans;
        
        % when a glissando is played, the index is counted
        %         gliss_IDX;
        
        
        % the fluctuations of the lowest partial around the fundamental
        % frequency
        f0Dev;
        
        % the synthesis parameters
        paramSynth;
        
        % the analysis parameters
        paramAna;
        
        % the audio file name
        fileName;
        
        % the signal vector
        x;
        
        % the sample rate
        fs;
        
        % the recent synthesis frequency
        % should be set/advanced in every frame
        f0synth;
        
        % the recent synthesis amplitude
        ampSynth;
        
        % the amplitude factor induced in the release
        releaseAmp;
        
        % the mean/median sample f0
        f0samp;
        
        % ther number of partials
        nPart;
        
        loop;
        inTrans;
        
        expressMod;
        
        kernels;
        kernels_LF
        fracVec;
        fracVec_LF
        
        win;
        %         WIN;
        winTD;
        win3;
        % time axis within one frame
        t;
        
        hop_s;
        
        % delta frequency (bin distance)
        df;
        
        % the amplitude trajectories
        A;
        
        % the frequency trajectories
        F;
        
        % only attack
        TRA_attack;
        
        % only release
        TRA_release;
        
        
        l_attack;
        l_release;
        
        % for the stochastic mode:
        MOD;
        
        s2 = {};
        
        % MIDI note number
        nn;
        
        % MIDI velocity
        vel;
        
        % is st to '1' when the note is released
        isReleased = 0;
        % is set to '1' if release is finished
        isFinished = 0;
        
        
        currPos     = 1;
        releasePos  = 0;
        releaseEnv;
        
        attackPos   = 0;
        
    end
    
    %%
    methods
        
        
        function obj = single_sinmod_player(noteModel, lastNoteModel, transition ,SM, expMod, fileName, paths, paramSynth)
            
            % load the  sinusoidal model and put it into the object
            
            
            try
                load([paths.matDir regexprep(fileName,'BuK','DPA') '.mat']);
                
                load([paths.staDir regexprep(fileName,'BuK','DPA') '.mat']);
                
            catch
                load([paths.matDir regexprep(fileName,'DPA','BuK') '.mat']);
                load([paths.staDir regexprep(fileName,'DPA','BuK') '.mat']);
            end
            
            
            % the statistical model
            obj.MOD         = MOD;
            
            % obvious stuff comes first!
            obj.fileName    = fileName;
            obj.inTrans     = transition;
            obj.paramSynth  = paramSynth;
            %            obj.paramAna    = param;
            obj.nPart       = paramSynth.nPartials;
            obj.kernels     = SM.kernels;
            obj.kernels_LF  = SM.kernels_LF;
            obj.fracVec_LF  = SM.fracVec_LF;
            obj.fracVec     = SM.fracVec;
            % the initial note values
            obj.nn          = noteModel.MIDI.nn;
            obj.vel         = noteModel.MIDI.vel;
            obj.vibCent     = 0;
            
            obj.noteModel   = noteModel;
            
            
            % the noise envelope must be  zero padded
            obj.meanNoise   = [obj.meanNoise  zeros(1,length(obj.meanNoise ))]';
            % @TODO: this is tuned HEURISTICALLY
            obj.noiseEnergy = obj.meanNoise  * 50;
            
            
            %% all the windows
            
            obj.win     = calculate_BH92_complete(paramSynth.lWin) ;
            %             obj.WIN     = fftshift(    fft(obj.win) );
            % the time-domain window, regarding the freq-win, too
            obj.winTD    = (triang(paramSynth.lWin))./obj.win;
            % the mere time domain window
            obj.win3    = (triang(paramSynth.lWin));
            
            % the hopsize in seconds
            obj.hop_s   = (paramSynth.lHop/paramSynth.fs);
            
            %
            %obj.t  = (0:paramSynth.lWin-1)/paramSynth.fs;
            
            % delta frequency (between two dft-bins)
            obj.df      =  paramSynth.fs/paramSynth.lWin;
            
            
            
            %% f0 stuff
            
            
            %obj.f0samp      = median(f0vec);
            
            %obj.f0Dev       = obj.f0vec / obj.f0samp;
            
            %obj.f0Dev (obj.f0Dev < 0.5) = 1;
            
            
            %% prepare the amplitude trajectories
            
            % @TODO: careful, this should be done in the analysis stage
            obj.A           = SMS.AMP(1:paramSynth.nPartials, 2:end-1); %#ok<*COLND>
            obj.F           = SMS.FRE(1:paramSynth.nPartials, 2:end-1);
            
            % get length
            obj.l_attack  = length(obj.MOD.ATT.P_1.AMP.trajectory);
            obj.l_release = length(obj.MOD.REL.P_1.AMP.trajectory);
            
            
            obj.TRA_attack =  struct2array(obj.MOD.ATT);
            obj.TRA_release =  struct2array(obj.MOD.REL);
            % read the samples infos
            obj.loop        = SM.samples(ismember({SM.samples.name},fileName));
            
            
            obj.loop.points(1) = 50;
            obj.loop.points(2) = length(obj.A)-50;
            
            
            obj.releasePos = 1;
            %% initialize note
            
            % al notes need this
            obj.smsPOS              = 1;
            obj.ctlPOS              = 1;
            obj.noteStretchFactor   = 1;
            
            
            % if note is detached from preceeding event
            if ~isempty(lastNoteModel)
                % PREpend the glissando stuff
                [obj]  =  expMod.calculate_glissando_trajectories(obj, lastNoteModel, obj.inTrans );
            else
                
                % PREpend the attack segment
                
                
                obj.attackPos = 1;
                
                
            end
            
            % start from the very beginning and
            % initialize partials
            for partCnt=1:obj.paramSynth.nPartials
                
                obj.s2    = cell(obj.nPart,1);
                
                for partCNT=1:obj.nPart
                    
                    obj.s2{partCNT} = sinusoid(partCNT *  obj.f0synth);
                    
                end
                
                
            end
            
            % if note is played glissando with preceeding note
            
            
            
            
            %% release stuff and co. HAS TO GO TO THE EXPRESSION MODEL
            
            % release duration in seconds
            Lrelease = 3;
            % responding number of samples
            Nrelease = ceil(Lrelease / (obj.paramSynth.lHop/obj.paramSynth.fs));
            
            % for now, it is just one global envelope: @TODO: one for each partial
            obj.releaseEnv  = (((((0.6 * Nrelease:-1:0)/(Nrelease * 0.6)))).^2)';
            
        end
        
        
        
        function [obj] = process_controls(obj, cntrlIn)
            
            obj.vibCent = mean(cntrlIn(:,2));
            
        end
        
        
        %% Get the next frame
        
        function [obj,frame] = get_frame_TD(obj)
            
            % allocate output frame
            frame       = zeros(obj.paramSynth.lWin,1);
            
            obj.f0synth =  obj.noteModel.F0.trajectory(obj.ctlPOS);
            
            tmpParts = struct2cell(obj.MOD.SUS);
            
            
            % loop over all partials
            for partCNT = 1:obj.paramSynth.nPartials
                
                
                if obj.isReleased == 0
                    
                    % do either the fixed method (partial trajectories from matrix)
                    % or the stochastic mode
                    switch obj.paramSynth.smsMode
                        
                        case 'fixed'
                            % each partial frequency (is always exactly N*f0synth)
                            obj.s2{partCNT}.f   = (obj.f0synth * partCNT)  ;
                            
                            % get amplitude from matrix at interpolated POSITION
                            % (linear)
                            
                            obj.s2{partCNT}.a   = obj.A(partCNT,obj.smsPOS);
                            
                        case 'stochastic'
                            
                            % if we are within the attack segment
                            if obj.attackPos>0 && obj.attackPos<= obj.l_attack
                                
                                obj.s2{partCNT}.f = obj.TRA_attack(partCNT).FRE.trajectory(obj.attackPos);
                                
                                obj.s2{partCNT}.a = obj.TRA_attack(partCNT).AMP.trajectory(obj.attackPos);
                                
                                % otherwise
                            else
                                
                                obj.s2{partCNT}.f = pick_inverse(tmpParts{partCNT}.FRE.dist', tmpParts{partCNT}.FRE.xval', 'closest');
                                
                                obj.s2{partCNT}.a = pick_inverse(tmpParts{partCNT}.AMP.dist', tmpParts{partCNT}.AMP.xval', 'closest');
                                
                            end
                            
                            
                    end
                    
                    %% if released - enter this:
                else
                    
                    
                    
                    
                    % if we are within release range
                    if obj.releasePos<=length(obj.releaseEnv)
                        
                        switch obj.paramSynth.smsMode
                            
                            case 'fixed'
                                
                                obj.releaseAmp      = obj.releaseEnv(obj.releasePos);
                                obj.ampSynth        = obj.ampSynth * obj.releaseAmp;
                                
                                obj.s2{partCNT}.a   = obj.s2{partCNT}.a * obj.releaseAmp;
                                obj.s2{partCNT}.f   = obj.s2{partCNT}.f;
                                
                                
                            case 'stochastic'
                                
                                try
                                    
                                    obj.s2{partCNT}.f = obj.TRA_release(partCNT).FRE.trajectory(obj.releasePos);
                                    obj.s2{partCNT}.a = obj.TRA_release(partCNT).AMP.trajectory(obj.releasePos);
                                    
                                catch
                                    
                                    disp('Minor problems creating the release ...');
                                    
                                end
                                
                                % if we exceed the release trajectory
                                
                        end
                    else
                        
                        % drop dead
                        obj.s2{partCNT}.a = 0;
                        
                        % and set note object to 'finished' state
                        obj.isFinished = 1;
                    end
                    
                    
                    
                end
                
                
                
                
                %% get snippet
                
                [obj.s2{partCNT}, tmpFrame]  = obj.s2{partCNT}.get_frame(obj.paramSynth.lWin,44100);
                
                
                if isempty(find(isnan(tmpFrame)))
                    
                    frame                       = frame + tmpFrame;
                    
                else
                    %disp('NaNs in the partials!!!')
                end
                
            end
            
            
            frame = frame .* triang(length(frame));
            
            
            
            
            
            %% increment counter(s)
            
            % take care that the stepsize regards the ratio of analysis and synthesis
            % hopsize AND the respective samplerates
            if obj.smsPOS <   size(obj.A,2)
                obj.smsPOS     = obj.smsPOS   + 1;
            end
            
            if obj.ctlPOS < length(obj.noteModel.F0.trajectory)
                
                % for now, we work with analysis=snthesis hop-size
                obj.ctlPOS    = obj.ctlPOS  + 1;
                
                % this is for the case wher we have different hop-sizes
                %  obj.ctlPOS    = obj.ctlPOS  +obj.noteStretchFactor *  ...
                %  2/( (obj.noteModel.param.lHop * obj.noteModel.param.fs) / (obj.paramAna.lHop * obj.paramAna.fs)  );
                
            else
                
                obj.ctlPOS = obj.ctlPOS ;
            end
            
            % increment release counter if neccessary
            if obj.isReleased == 1
                obj.releasePos = obj.releasePos + 1;
            end
            
            % increment attack counter if needed
            if obj.attackPos ~= 0 &&  obj.attackPos<obj.l_attack
                obj.attackPos = obj.attackPos + 1;
            end
            
        end
        
    end
    
end