%% function [noteMatrix] = midi2frequencyTrack(inName)
%
% read a midi file and generate a vector of frequencies
% a lot to do here
%   - works for non overlapping mono midi files only
%
%
% HvC
% 2011-10-20 ... 2014-04-11

function [noteMatrix] = midi2frequencyTrack(inName)

%% get data

midiData = readmidi(inName);

% write text
midiInfo(midiData,'tmpMidi.txt');

% use grep to create a txt file with only Note info
unix('cat tmpMidi.txt | grep ''Note ''> tmpMidiPure.txt');

fid = fopen('tmpMidiPure.txt');
C   = textscan(fid,'%s %s %s %s %s %s %s %s', 'Delimiter','\t');
fclose(fid);


%% prepare data in loop

nEvents = length(C{1});

noteMatrix = [];

data = C{1};

noteOnVec = [];

i=1;

while i<=nEvents
    
    tmpLine=data{i};
    
    lister = strsplit(' ',tmpLine,'omit');
    
    resLine={};
    for k=1:length(lister)
        
        if strcmp(lister(k),'')==0
            resLine= [resLine,lister(k) ];
        end
        
    end
    
    
    %% preapare the time of the event
    timeString  = resLine(3);
    
    timeVal     =0;
    
    %make it seconds
    [h,res]=strtok(timeString,':');
    h = str2double(h);
    
    res = regexprep(res,':','');
    [min,sec]=strtok(res,'.');
    min      =str2double(min);
    
    sec = str2double(sec);
    
    timeVal = h*60+min+sec;
    
    %% get midi values
    noteVal     = str2double(regexprep(resLine(6),'nn=',''));
    
    if strcmpi(resLine(5),'on')==1
        noteVel     = str2double(regexprep(resLine(7),'vel=',''));
    elseif strcmpi(resLine(5),'off')==1
        noteVel     = 0;
    else
        error('Bad MIDI format!!');
    end
    noteMatrix  = [noteMatrix; [timeVal, noteVal, noteVel]];
    
    i=i+1;
    
end

delete('tmpMidi.txt')
delete('tmpMidiPure.txt')



