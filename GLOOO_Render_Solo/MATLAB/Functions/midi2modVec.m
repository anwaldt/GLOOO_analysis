%% function [vibMatrix] = midi2modVec(inName)
%
% read a midi file and generate a vector of modulation wheel
%
% HvC
% 2011-06-01 ... 2014-04-11

function [contrlTrajectory] = midi2modVec(inName, midiString)

%% get data

midiData = readmidi(inName);

% write text
midiInfo(midiData,'tmpMidi.txt');

% use grep to create a txt file with only mod wheel info
unix(['cat tmpMidi.txt | grep ''' midiString '''> tmpMidiPure.txt']);

fid = fopen('tmpMidiPure.txt');
C   = textscan(fid,'%s %s %s %s %s %s %s %s', 'Delimiter','\t');
fclose(fid);

%% prepare data in loop

nValues     = length(C{1});
contrlTrajectory   = [];

data = C{1};


for i=1:nValues
    
    tmpLine     = data{i};
    
    lister      = strsplit(' ',tmpLine,'omit');
    
    resLine={};
    for k=1:length(lister)
        
        if strcmp(lister(k),'')==0
            resLine = [resLine,lister(k) ];
        end
        
    end
    
    timeString = resLine(3);
    
    timeVal=0;
    %make it seconds
    [h,res]=strtok(timeString,':');
    h = str2double(h);
    
    res = regexprep(res,':','');
    [min,sec]=strtok(res,'.');
    min      =str2double(min);
    
    sec = str2double(sec);
    
    timeVal = h*60+min+sec;
    
    if midiString~='Pitch Bend'
        valVal = str2double(regexprep(resLine(8),'value=',''));
    else
        valVal =  (regexprep(resLine(6),'change=',''));
        valVal = str2double(regexprep(valVal,'?',''));
        
    end
    
    contrlTrajectory=[contrlTrajectory; [timeVal, valVal]];
    
    
end

delete('tmpMidi.txt')
delete('tmpMidiPure.txt')



