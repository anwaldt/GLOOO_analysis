%% function [ y ] = render_solo( freqTrack, vibTrack, SM, expMod, paramSynth )
%
%   - generates a solo based on
%
%
% HvC
% Created:  2016-02-18
% Modified: 2016-08-04
%
%

function [ y ] = render_solo(C, SEG, SM, expMod, paths, paramSynth)


t = (0:(SEG{end}.stop)*paramSynth.fs-1)/paramSynth.fs;

% a zero padded output stream
y = [zeros(size(t))'; zeros(paramSynth.fs,1)];


L           = length(y);
lWin        = paramSynth.lWin;
lHop        = paramSynth.lHop;
nWin        = floor((L-2*lWin)/lHop);
targetInds  = 1:lWin;
%nNotes      = size(notes,2);

SP          = [];
SMSP        = [];

% this array keeps track of processed messages
% usedNotes    = zeros(nNotes,1);
% and this one of controllers
% usedCntrls  = zeros(nControls,1);

nSeg    = length(SEG);
segCNT = 1;

%% LOOP over all frames

for frameIDX = 1:nWin
    
    % times (in sec.) to be filled in this loop run
    targetTimes = (targetInds-1)/paramSynth.fs;
    
    % indices of onsets which are within this frame
    if segCNT<=nSeg
        newSegment = ...
            intersect(find([SEG{segCNT}.start]>=targetTimes(1)),  ...
            find([SEG{segCNT}.start]<=targetTimes(end)));
        
        
        % get next segment
        if ~isempty(newSegment)
            
            tmpSeg = SEG{segCNT};
            
            % if it is a transition
            if strcmp(class(tmpSeg),'trans') == 1
                
                
                switch tmpSeg.type
                    
                    % ATTACK AND legato and release do not create
                    % independent transitions
                    case 'attack'
                        disp('Got an attack!')
                        
                        % use next note at once
                        segCNT = segCNT+1;
                        tmpSeg = SEG{segCNT};
                        
                        % get new notes midi params
                        recMIDInote = tmpSeg.MIDI.nn;
                        recMIDIvel  = tmpSeg.MIDI.vel;
                        
                        % pick responding sample
                        [tmpName, ~]  = SM.pick_sample(recMIDInote,recMIDIvel);
                        
                        % create new player
                        preNote = [];
                        smsp = single_sinmod_player(tmpSeg, SM, [], expMod, tmpName,paths, paramSynth);
                        SMSP = [SMSP smsp];
                        
                        
                        
                    case 'legato'
                        disp('Got a legato!')
                        % kill old note
                        SMSP.isReleased = 1;
                        
                        % use next note at once
                        segCNT = segCNT+1;
                        tmpSeg = SEG{segCNT};
                        
                        
                        % get new notes midi params
                        recMIDInote = tmpSeg.MIDI.nn;
                        recMIDIvel  = tmpSeg.MIDI.vel;
                        
                        % pick responding sample
                        [tmpName, ~]  = SM.pick_sample(recMIDInote,recMIDIvel);
                        
                        % create new player
                        preNote = [];
                        smsp = single_sinmod_player(tmpSeg, SM, [], expMod, tmpName,paths, paramSynth);
                        SMSP = [SMSP smsp];
                        
                    case 'glissando'
                        % connect with next note at once
                        % kill last note at once
                        disp('Got a glissando!')
                        
                          SMSP.isFinished = 1;
                          
                          inTrans = SEG{segCNT};
                         
                          % use next note at once
                        segCNT = segCNT+1;
                        tmpSeg = SEG{segCNT};
                        
                        
                        % get new notes midi params
                        recMIDInote = tmpSeg.MIDI.nn;
                        recMIDIvel  = tmpSeg.MIDI.vel;
                        
                        % pick responding sample
                        [tmpName, ~]  = SM.pick_sample(recMIDInote,recMIDIvel);
                        
                        % create new player
                        preNote = [];
                        smsp = single_sinmod_player(tmpSeg, SM, inTrans, expMod, tmpName,paths, paramSynth);
                        SMSP = [SMSP smsp];
                          
                        
                    case 'release'
                        disp('Got a release!')
                        
                        SMSP.isReleased = 1;
                
                end
                
                
                % if it is a note
            elseif strcmp(class(tmpSeg),'note') == 1
                
                disp('Got a note!')
                
            end
            
            segCNT = segCNT+1;
        end
        
    end
    
    
    %% render all active  notes
    
    for noteIDX = 1:length(SMSP)
        
        % process the expressive controls of the active note
        % (the one NOT released)
        if SMSP(noteIDX).isReleased == 0
            
            % somehow this function won't work
            %             SMSP(noteIDX).process_controls(pitchBend(cntrlsInFrame,:));
            
            % so we do it the dirty way
            %             if ~isempty(cntrlsInFrame)
            %                 SMSP(noteIDX).vibCent = mean( pitchBend(cntrlsInFrame,2) );
            %             else
            %                 %                 SMSP(noteIDX).vibCent = 0;
            %             end
            %             usedCntrls(cntrlsInFrame,:) = 1;
        end
        
        % [SP(noteIDX),tmpFrame]    = SP(noteIDX).get_frame();
        if SMSP(noteIDX).isFinished == 0
            
            switch paramSynth.synthMode
                
                case 'IFFT'
                    
                    [SMSP(noteIDX),tmpFrame2] = SMSP(noteIDX).get_frame_IFFT();
                    
                case 'TD'
                    
                    [SMSP(noteIDX),tmpFrame2] = SMSP(noteIDX).get_frame_FD();
                    
            end
            y(targetInds)             = y(targetInds) + tmpFrame2;
            
        end
    end
    
    % kill finished notes
    if~isempty(SMSP)
        
        [~, finished]   = find([SMSP.isFinished]== 1);
        
        %SP(finished) = [];
        SMSP(finished) = [];
        
    end
    
    % increment indices
    targetInds = targetInds + paramSynth.lHop;
    
end

