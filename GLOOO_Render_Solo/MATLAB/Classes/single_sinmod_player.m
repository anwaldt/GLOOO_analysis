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
        
        % this is put in FRONT of the
        % stochastic part (attack, glissando, etc)
        inTransTrajectories;
        
        
        % the target values for all partials
        % are needed for the attack and glissando scaling
        targetAmplitudes;
        targetFrequencies;
        % the initials, too:
        initialAmplitudes;
        initialFrequencies
        
        releaseAmplitudes;
        
        % only release
        TRA_release;
        
        
        l_inTrans;
        l_release;
        
        % for the stochastic mode:
        statMod;
        
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
        
        inTransPos   = 0;
        
        
        % file to write matrices to:
        trajectoryFile;
        
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
            obj.statMod     = MOD;
            
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
            %obj.A           = SMS.AMP(1:paramSynth.nPartials, 2:end-1);
            %obj.F           = SMS.FRE(1:paramSynth.nPartials, 2:end-1);
            
            % get lengths of attack and release
            
            obj.l_release  = length(obj.statMod.REL.P_1.AMP.trajectory);
            
            
            obj.TRA_release =  struct2array(obj.statMod.REL);
            % read the samples infos
            obj.loop        = SM.samples(ismember({SM.samples.name},fileName));
            
            
            obj.loop.points(1) = 50;
            obj.loop.points(2) = length(obj.A)-50;
            
            
            obj.releasePos = 1;
            
            
            
            %% initialize partials
            
            for partCnt=1:obj.paramSynth.nPartials
                
                obj.s2    = cell(obj.nPart,1);
                
                for partCNT=1:obj.nPart
                    
                    obj.s2{partCNT} = sinusoid(partCNT *  obj.f0synth);
                    
                end
                
                
            end
            
            %% initialize note
            
            % al notes need this
            obj.smsPOS              = 1;
            obj.ctlPOS              = 1;
            obj.noteStretchFactor   = 1;
            
            %
            tmpParts = struct2cell(obj.statMod.SUS);
            
            
            % switch the transition type
            switch transition.type
                
                case 'glissando'
                    
                    % go into in-transition
                    obj.inTransPos = 1;
                    
                    % allocate target amplitude and frequency array
                    obj.targetAmplitudes  = zeros((obj.paramSynth.nPartials),1);
                    obj.targetFrequencies = zeros((obj.paramSynth.nPartials),1);
                    
                    obj.initialAmplitudes   = zeros((obj.paramSynth.nPartials),1);
                    obj.initialFrequencies  = zeros((obj.paramSynth.nPartials),1);
                    
                    
                    for i=1:obj.paramSynth.nPartials
                        
                        obj.initialAmplitudes(i)    = lastNoteModel.s2{i}.a;
                        obj.initialFrequencies(i)   = lastNoteModel.s2{i}.f;
                        obj.targetAmplitudes(i)     = tmpParts{i}.AMP.med;
                        obj.targetFrequencies(i)    = obj.noteModel.F0.median;
                        
                    end
                    
                    switch obj.paramSynth.glissandoMode
                        
                        case 'original'
                            
                            for i=1:obj.nPart
                                
                                deltaA = obj.targetAmplitudes(i)  - obj.initialAmplitudes(i);
                                deltaF = obj.targetFrequencies(i) - obj.initialFrequencies(i);
                                
                                obj.inTransTrajectories(i).AMP.trajectory   =  (transition.AMP.trajectory / transition.AMP.trajectory(1)) * obj.initialAmplitudes(i);
                                
                                obj.inTransTrajectories(i).FRE.trajectory   =  transition.F0.trajectory  * i;
                                
                            end
                            
                            obj.l_inTrans  =  obj.inTrans.stopIND - obj.inTrans.startIND;
                            
                        case 'linear'
                            
                                                        obj.l_inTrans  =  obj.inTrans.stopIND - obj.inTrans.startIND;

                                                        
                            for i=1:obj.paramSynth.nPartials
                                
                                obj.initialAmplitudes(i)    = lastNoteModel.s2{i}.a;
                                obj.initialFrequencies(i)   = lastNoteModel.s2{i}.f;
                                obj.targetAmplitudes(i)     = tmpParts{i}.AMP.med;
                                obj.targetFrequencies(i)    = obj.noteModel.F0.median * i;
                                
                            end
                            
                            for i=1:obj.nPart
                                
                                obj.inTransTrajectories(i).AMP.trajectory = linspace(obj.initialAmplitudes(i), obj.targetAmplitudes(i),obj.l_inTrans);
                                
                                obj.inTransTrajectories(i).FRE.trajectory = linspace(obj.initialFrequencies(i), obj.targetFrequencies(i),obj.l_inTrans);
                                
                            end
                            
                    end
                    
                case 'legato'
                    
                    % if there is no attached previous note -
                    % we have an attack
                    
                    % set the attack pointer to the beginning
                    obj.inTransPos = 1;
                    
                    % allocate target amplitude array
                    obj.targetAmplitudes = zeros((obj.paramSynth.nPartials),1);
                    
                    
                    
                    
                    % initialize target amplitudes
                    for i=1:obj.paramSynth.nPartials
                        
                        obj.targetAmplitudes(i) = tmpParts{i}.AMP.med;
                        
                    end
                    
                    % If no note is connected to it:
                    % simply start from the very beginning and
                    % initialize partials
                case 'attack'
                    
                    
                    switch obj.paramSynth.attackMode
                        
                        % this case uses the original trajectories
                        % for each partial
                        case 'original'
                            
                            % get target amplitudes:
                            % initialize target amplitudes
                            for i=1:obj.paramSynth.nPartials
                                
                                obj.targetAmplitudes(i) = tmpParts{i}.AMP.med;
                                
                            end
                            
                            % set the attack pointer to the beginning
                            obj.inTransPos          = 1;
                            obj.inTransTrajectories =  struct2array(obj.statMod.ATT);
                            
                            obj.l_inTrans           =   (  length(obj.inTransTrajectories(1).FRE.trajectory));
                            
                    end
            end
            
            
        end
        
        
        
        function [obj] = process_controls(obj, cntrlIn)
            
            obj.vibCent = mean(cntrlIn(:,2));
            
        end
        
        
        %% Get the next frame
        
        function [obj,frame] = get_frame_TD(obj)
            
            % allocate output frame
            frame   = zeros(obj.paramSynth.lWin,1);
            
            tmpParts = struct2cell(obj.statMod.SUS);
            
            % loop over all partials
            for partCNT = 1:obj.paramSynth.nPartials
                
                
                if obj.isReleased == 0
                    
                    % do either the fixed method (partial trajectories from matrix)
                    % or the stochastic mode
                    switch obj.paramSynth.attackMode
                        
                        case 'fixed'
                            % each partial frequency (is always exactly N*f0synth)
                            obj.s2{partCNT}.f   = (obj.f0synth * partCNT)  ;
                            
                            % get amplitude from matrix at interpolated POSITION
                            % (linear)
                            
                            obj.s2{partCNT}.a   = obj.A(partCNT,obj.smsPOS);
                            
                        case 'original'
                            
                            % if we are within the in-transition segment
                            if obj.inTransPos>0 && obj.inTransPos< obj.l_inTrans
                                
                                
                                switch obj.inTrans.type
                                    
                                    case 'attack'
                                        
                                        obj.s2{partCNT}.f   =  obj.noteModel.F0.median * partCNT ;
                                        
                                        % scale here:
                                        obj.s2{partCNT}.a   = obj.targetAmplitudes(partCNT)*  obj.interpolate(obj.inTransPos, obj.inTransTrajectories(partCNT).AMP.trajectory);
                                        
                                        
                                    case 'glissando'
                                        
                                        obj.s2{partCNT}.f = obj.interpolate(obj.inTransPos,obj.inTransTrajectories(partCNT).FRE.trajectory );
                                        
                                        % scale here:
                                        obj.s2{partCNT}.a =  obj.interpolate(obj.inTransPos, obj.inTransTrajectories(partCNT).AMP.trajectory);
                                        
                                end
                                
                                
                                % otherwise
                            else
                                
                                switch obj.paramSynth.sustainMode
                                    
                                    case 'original'
                                        
                                        % interpolate original F0
                                        lB      = floor(obj.ctlPOS);
                                        uB      = ceil(obj.ctlPOS);
                                        frac    = rem(obj.ctlPOS,1);
                                        
                                        try
                                            obj.f0synth =  (1-frac)*obj.noteModel.F0.trajectory(lB) + frac*obj.noteModel.F0.trajectory(uB);
                                        catch
                                            disp('Problems interpolating the original F0 trajectory!')
                                        end
                                        
                                        
                                        % this is done with a 2 sample averaging to
                                        % avoid quick jumps
                                        obj.s2{partCNT}.f = 0.5* (obj.s2{partCNT}.f + obj.f0synth * partCNT * pick_inverse(tmpParts{partCNT}.FRE.dist', tmpParts{partCNT}.FRE.xval', 'closest'));
                                        
                                        % directly from the distributions:
                                        obj.s2{partCNT}.a = 0.5* (obj.s2{partCNT}.a + pick_inverse(tmpParts{partCNT}.AMP.dist', tmpParts{partCNT}.AMP.xval', 'closest'));
                                        
                                    case 'plain'
                                        
                                        
                                        obj.s2{partCNT}.f = tmpParts{partCNT}.FRE.med * obj.noteModel.F0.median * partCNT;
                                        obj.s2{partCNT}.a = tmpParts{partCNT}.AMP.med;
                                        
                                end
                                
                                
                            end
                            
                            
                    end
                    
                    % if released - enter this:
                else
                    
                    % if we are within release range
                    if obj.releasePos <= obj.l_release
                        
                        
                        % initialize for scaling
                        if obj.releasePos == 1
                            obj.releaseAmplitudes(partCNT) = obj.s2{partCNT}.a;
                            
                            
                        end
                        
                        
                        switch obj.paramSynth.smsMode
                            
                            case 'fixed'
                                
                                obj.releaseAmp      = obj.releaseEnv(obj.releasePos);
                                obj.ampSynth        = obj.ampSynth * obj.releaseAmp;
                                
                                obj.s2{partCNT}.a   = obj.s2{partCNT}.a * obj.releaseAmp;
                                obj.s2{partCNT}.f   = obj.s2{partCNT}.f;
                                
                                
                            case 'stochastic'
                                
                                try
                                    
                                    obj.s2{partCNT}.f ;%= obj.releaseFreq * partCNT * obj.TRA_release(partCNT).FRE.trajectory(obj.releasePos);
                                    
                                    % scale the release trajectories here:
                                    obj.s2{partCNT}.a = obj.releaseAmplitudes(partCNT)* obj.interpolate(obj.releasePos, obj.TRA_release(partCNT).AMP.trajectory);
                                    
                                    
                                    
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
                
                
                if isempty(find(isnan(tmpFrame), 1))
                    
                    frame                       = frame + tmpFrame;
                    
                else
                    disp('NaNs in the partials!!!')
                end
                
            end
            
            
            % add complete frame to output signal:
            frame = frame .* triang(length(frame));
            
            
            
            %% increment counter(s)
            
            % take care that the stepsize regards the ratio of analysis and synthesis
            % hopsize AND the respective samplerates
            if obj.smsPOS <   size(obj.A,2)
                obj.smsPOS     = obj.smsPOS   + 1;
            end
            
            if obj.ctlPOS < length(obj.noteModel.F0.trajectory)
                
                % for now, we work with analysis=snthesis hop-size
                obj.ctlPOS    = obj.ctlPOS  + obj.paramSynth.stepRatioA;
                
                % this is for the case where we have different hop-sizes
                % obj.ctlPOS    = obj.ctlPOS  +obj.noteStretchFactor *  ...
                % 2/( (obj.noteModel.param.lHop * obj.noteModel.param.fs) / (obj.paramAna.lHop * obj.paramAna.fs)  );
                
            else
                
                obj.ctlPOS = obj.ctlPOS ;
            end
            
            % increment release counter if neccessary
            if obj.isReleased == 1 && obj.releasePos < obj.l_release
                obj.releasePos = obj.releasePos  +  obj.paramSynth.stepRatioA;
            end
            
            % increment attack/glissando counter if needed
            if obj.inTransPos ~= 0 &&  obj.inTransPos<obj.l_inTrans
                obj.inTransPos  = obj.inTransPos  +  obj.paramSynth.stepRatioA;
            end
            
        end
        
        %% standard linear interpolation
        % for fractional indices
        
        function   [val] = interpolate(~,fracInd, vector)
            
            % get supprot points
            lB      = floor(fracInd);
            uB      = ceil(fracInd);
            frac    = rem(fracInd,1);
            
            val     = (1-frac)*vector(lB) + frac*vector(uB);
            
            
        end
        
    end
    
    
end