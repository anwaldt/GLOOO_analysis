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
        % partials:
        smsPOS;
        
        % this is the counter for the position within the
        % trajectories of the note model:
        notePOS;
        
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
        win2;
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
        
        % the sinusoid struct
        s=struct();
        
        % MIDI note number
        nn;
        
        % MIDI velocity
        vel;
        
        % is st to '1' when the note is released
        isReleased = 0;
        % is set to '1' if release is finished
        isFinished = 0;
        
        
        currPos     = 1;
        releasePos  = 1;
        releaseEnv;
    end
    
    %%
    methods
        
        
        function obj = single_sinmod_player(noteModel, lastNoteModel, transition ,SM, expMod, fileName, paths, paramSynth)
            
            % load the  sinusoidal model and put it into the object
            
            load([paths.SINMOD regexprep(fileName,'DPA','BuK') '.mat']);
            
            % obvious stuff comes first!
            obj.fileName    = fileName;
            obj.inTrans     = transition;
            obj.paramSynth  = paramSynth;
            obj.paramAna    = param;
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
            obj.win2    = (triang(paramSynth.lWin))./obj.win;
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
            obj.A           = partialAmp(1:paramSynth.nPartials, 2:end-1); %#ok<*COLND>
            obj.F           = partialFre(1:paramSynth.nPartials, 2:end-1);
            
            
            % read the samples infos
            obj.loop        = SM.samples(ismember({SM.samples.name},fileName));
            
            
            obj.loop.loopPoints(1) = 50;
            obj.loop.loopPoints(2) = length(obj.A)-50;
            
            
            % this smoothing is 'just for fun'
            %             for i=1:obj.nPart
            %                                   obj.A(i,:) = smooth(obj.A(i,:),10);
            %                                   obj.A(i,:) = smooth(obj.A(i,:),10);
            %             end
            
            % normalize using the mean partial amplitude of the sample
            %             obj.A  = (obj.A ./ max(sum(obj.A)));
            
            % the initial synthesis volume:
            %             obj.ampSynth =  obj.vel/127;
            
            
            %% initialize note
            
            % al notes need this
            obj.smsPOS      = 1;
            obj.notePOS     = 1;
            obj.noteStretchFactor = 1;
            
            
            % if note is detached from preceeding event
            if ~isempty(lastNoteModel)
                % PREpend the glissando stuff
                [obj]  =  expMod.calculate_glissando_trajectories(obj, lastNoteModel, obj.inTrans );
            else
                % PREpend the attack segment
                
            end
            
            % start from the very beginning and
            % initialize partials
            for partCnt=1:obj.paramSynth.nPartials
                
                
                if isempty(lastNoteModel)
                    obj.s(partCnt).thisPhas    = rand*pi;
                    obj.s(partCnt).lastPhas    = rand*pi;
                else
                    % if we come from a glissando: get phase
                    obj.s(partCnt).thisPhas    = lastNoteModel.s(partCnt).thisPhas;
                    obj.s(partCnt).lastPhas    = lastNoteModel.s(partCnt).lastPhas;
                    
                end
                
                obj.s(partCnt).compSine =    1;
                % 'floating point position' of this partial
                obj.s(partCnt).fracBin =1;
                
                
                % we use an harmonic model, for the start
                obj.s(partCnt).f0  = obj.f0synth * partCnt; %10.87/hop_ms;
                
                % random phase
                % obj.s(partCnt).phi =  rand*pi;
                
                
                % 'floating point bin' of this frequency
                obj.s(partCnt).bin = obj.s(partCnt).f0 / obj.df +1;
                
            end
            
            % if note is played glissando with preceeding note
            
            
            
            
            %% release stuff and co. HAS TO GO TO THE EXPRESSION MODEL
            %
            %            obj.gliss_IDX   = 1;
            %
            %             obj.f0_trans    =  [];
            %
            % release duration in seconds
            Lrelease = 3;
            Nrelease = ceil(Lrelease / (obj.paramSynth.lHop/obj.paramSynth.fs));
            
            % for now, it is just one global envelope: @TODO: one for each partial
            obj.releaseEnv  = (((((0.6 * Nrelease:-1:0)/(Nrelease * 0.6)))).^2)';
            
        end
        
        
        
        function [obj] = process_controls(obj, cntrlIn)
            
            obj.vibCent = mean(cntrlIn(:,2));
            
            
            
        end
        
        
        %% Get the next frame
        function [obj,frame] = get_frame_IFFT(obj)
            
            
            % allocate output frame
            FRAME       = zeros(obj.paramSynth.lWin,1);
            
            % check for loop point
            if obj.smsPOS >= obj.loop.loopPoints(2)
                % reset frame position, if necessary
                obj.smsPOS = obj.loop.loopPoints(1);
                
                % @TODO: create a smooth transition when jumping
                % @TODO: randomly switch to different A-points
            end
            
            
            
            
            %% fo management            
            
%             if  obj.notePOS <= obj.noteModel.stopIND - obj.noteModel.startIND
%             tmpVal = obj.interp_value(obj.noteModel.F0.AC, obj.notePOS);  
%             else
%                 tmpVal = 
%             end
                
            switch obj.paramSynth.f0mode
                
                case 'original'
                    %                         obj.f0synth =  2^(tmpVal/1200) * (2^((obj.nn-69)/12)*440 );
                    % correction of the sample rate ratios needs to go
                    % her:
                    if obj.notePOS <= obj.noteModel.stopIND - obj.noteModel.startIND
                    obj.f0synth =  obj.noteModel.F0.trajectory(obj.notePOS);
                    else
                      obj.f0synth = obj.f0synth;
                    end
                case 'vib_orig'
                    obj.f0synth =  2^(tmpVal/1200) * (2^((obj.nn-69)/12)*440 );
                    
                case 'plain'
                    obj.f0synth = (2^((obj.nn-69)/12)*440 );
                    
                otherwise
                    error('Unknown FO-Mode!');
            end
            
            
            %% loop over all partials
            for partCnt = 1:obj.paramSynth.nPartials
                
                % if note is not released - do the standard things
                if obj.isReleased == 0
                    
                    % F0 management:
                    % just take the note value if played detatched
                    %                     if isempty(obj.f0_trans)
                    
                    % each partial frequency (is always exactly N*f0synth)
                    obj.s(partCnt).f0   = (obj.f0synth * partCnt)  ;
                    
                    
                    %                         % but use the trajectory if played glissando
                    %                     else
                    %
                    %                         % clear transition stuff when done
                    %                         if obj.gliss_IDX>length(obj.f0_trans)
                    %                             obj.f0_trans =[];
                    %                         else
                    %                             obj.s(partCnt).f0   = obj.f0_trans(obj.gliss_IDX) * partCnt;
                    %                         end
                    %
                    %                     end
                    
                    % get amplitude from matrix at interpolated POSITION
                    % (linear)
                    obj.s(partCnt).a   = obj.A(partCnt,obj.smsPOS);
                    
                    
                    % the fundamental frequency can only change in the
                    % sustain part - e.g. 'not released'
                    
                    
                    % if released - enter this:
                else
                    
                    obj.s(partCnt).f0  = partCnt* obj.f0synth ;
                    
                    % if we are within release range
                    if obj.releasePos<=length(obj.releaseEnv)
                        
                        obj.releaseAmp   = obj.releaseEnv(obj.releasePos);
                        
                        obj.ampSynth     = obj.ampSynth * obj.releaseAmp;
                        
                        obj.s(partCnt).a = obj.s(partCnt).a * obj.releaseAmp;
                        
                        obj.s(partCnt).f0  = obj.s(partCnt).f0;
                        
                        % if we exceed it
                    else
                        
                        % drop dead
                        obj.s(partCnt).a = 0;
                        
                        % and set note object to 'finished' state
                        obj.isFinished = 1;
                    end
                    
                    
                    
                end
                
                % it might be cool to randomize the phase slightly
                %                  obj.s(partCnt).thisPhas = obj.s(partCnt).thisPhas + rand*2;
                
                % add this partial to the spectrum
                
                [tmpFrame, obj.s(partCnt)]  = place_mainlobe( obj.s(partCnt),obj.paramSynth.lWin,obj.paramSynth.fs,obj.kernels,obj.kernels_LF,obj.fracVec, obj.fracVec_LF);
                
                
                FRAME = FRAME + tmpFrame;%./4;
                
            end
            
            
            if obj.isReleased == 1
                % increment release counter
                obj.releasePos = obj.releasePos + 1;
            end
            
            
            % DO IFFT:
            frame  = (ifft(FRAME,'symmetric'));
            
            
            % Apply TimeDomain window:
            frame  = frame.*obj.win2;
            
            
            %%
            
            switch obj.paramSynth.noiseMode
                
                case 'off'
                    % do nothing
                    
                case 'on' 
                    % @TODO: we need to add the NOISE BEFORE the transform - but this is the
                    % easier way :::
                    
                    % create noise spectrum with random phase
                    NOISE = ( exp(2*pi*(rand(size(obj.meanNoise)))*1j) .* obj.meanNoise );
                    
                    % transform
                    noise  = (ifft(NOISE,'symmetric'));
                    
                    % apply windows
                    noise = obj.noiseEnergy(obj.smsPOS) * noise ...
                        .* obj.win3 * obj.ampSynth ;
                    
                    % add the noise with the energy level at this frame
                    frame = frame + noise;
                    
                case 'only'
                    
                    % @TODO: we need to add the NOISE BEFORE the transform - but this is the
                    % easier way :::
                    
                    % create noise spectrum with random phase
                    NOISE = ( exp(2*pi*(rand(size(obj.meanNoise)))*1j) .* obj.meanNoise );
                    
                    % transform
                    noise  = (ifft(NOISE,'symmetric'));
                    
                    % apply windows
                    noise = obj.noiseEnergy(obj.smsPOS) * noise ...
                        .* obj.win3 * obj.ampSynth ;
                    
                    % add the noise with the energy level at this frame
                    frame =     noise ;
                    
            end
            
            % global volume
            %             frame = frame * obj.ampSynth;
            
            %% increment counter(s)
            
            %             obj.currPos     = obj.currPos+obj.paramSynth.lHop;
            % taske care that the stepsize regards the ratio of analysis and synthesis
            % hopsize AND the respective samplerates
            obj.smsPOS     = obj.smsPOS   + 1;
          
             if obj.notePOS <= obj.noteModel.stopIND - obj.noteModel.startIND
            obj.notePOS    = obj.notePOS  + ...
                obj.noteStretchFactor *  2/( (obj.noteModel.param.lHop * obj.noteModel.param.fs) / (obj.paramAna.lHop * obj.paramAna.fs)  );
             else
                obj.notePOS = obj.notePOS ;
                
             end
            
         end
        
        function val =  interp_value(~,vector, index)
            
            lB      = floor(index);
            uB      = ceil(index);
            
            frac    = rem(index,1);
            
            val = (vector(lB) * 1-frac) + (vector(uB) * frac);
            
        end
        
    end
    
end