%% function [] = create_MIDI_sequence(paths,param,fileIndices)
%
% Creates MIDI files from the note information
%
%   - uses 'matrix2midi()' from the ks-midi toolbox
%
% Henrik von Coler
% 2014-04-12
%%

function [tMID] = create_MIDI_sequence(notes, noteModel, param)
  
  
    
    nNotes = length(noteModel);
    % M: input matrix:
    %   1     2    3  4   5  6  
    %  [track chan nn vel t1 t2] 
    
    M = zeros(nNotes,6);
    
    for noteIDX = 1:nNotes
       
        % always track 1:
        M(noteIDX,1) = 1;
        % always channel 1:
        M(noteIDX,2) = 1;
        
        % note number
        M(noteIDX,3) = round(69+12 * log(abs(noteModel(noteIDX).F0.median)/440)/log(2));
        
        % velocity
        M(noteIDX,4) = round( noteModel(noteIDX).Amp.median/0.3 * 127 );
        
        % start (in seconds)
        M(noteIDX,5) = notes(noteIDX).start;
        
        
        % control parameters within the note
        nPoints = length(noteModel(noteIDX).F0.trajectory);
        %F = polyval(noteModel(noteIDX).F0.polynom, 1:length(noteModel(noteIDX).F0.trajectory));
        
        for ctrIDX = 1:nPoints
            
        end
        
        % stop (in seconds)
        M(noteIDX,6) = notes(noteIDX).stop;
        
        
        
    end
    
    tMID = matrix2midi(M);


 
