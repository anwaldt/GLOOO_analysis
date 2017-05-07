%% function I = load_solo_properties(baseName, paths)
%
%   JUST FOR THE TWO NOTES
%
% Author : HvC
% Created: 2016-08-11

function I = load_solo_properties(baseName, paths, setToDo, micToDo)

%% this is the structure

% Number 	Note1 	Fret1 	String1 	Note2 	Fret2 	String2 	Semitones 	Direction 	Dynamic 	Articulation 	Vibrato

%%

% load file
f1 = fopen([paths.FILELISTS 'list_TwoNote.txt'],'r');
A  = textscan(f1,'%s %s %s %s %s %s %s %s %s %s %s %s',inf);
fclose(f1);

% % get index
IDX = str2double(regexprep(baseName,'TwoNote_DPA_',''));

if isnan(IDX)
    IDX = str2double(regexprep(baseName,'TwoNote_BuK_',''));
end

% pack into structure
I.note1.char        = A{2}(IDX+1);
I.note1.fret        = A{3}(IDX+1);
I.note1.string      = A{4}(IDX+1);
I.note1.dynamic     = A{10}(IDX+1);

fret1 = str2double(I.note1.fret);
if strcmp(A{12}(IDX+1),'true') && fret1 ~= 0
    I.note1.vibrato     = 'true';
else
    I.note1.vibrato     = 'false';
end


I.note2.char        = A{5}(IDX+1);
I.note2.fret        = A{6}(IDX+1);
I.note2.string      = A{7}(IDX+1);
I.note2.dynamic     = A{10}(IDX+1);

fret2 = str2double(I.note2.fret);
if strcmp(A{12}(IDX+1),'true') && fret2 ~= 0
    I.note2.vibrato     = 'true';
else
    I.note2.vibrato     = 'false';
end



I.trans.semitones   = A{8}(IDX+1);
I.trans.direction   = A{9}(IDX+1);

% special string for legato on one string
if strcmp(    A{4}(1), A{4}(1)) == 1 && strcmp(A{11}(IDX+1),'leagato') == 1
    I.trans.articulation= [A{11}(IDX+1) '_1'];
else
    I.trans.articulation= A{11}(IDX+1);
    
    % Save Neme of File
    I.fileName = baseName;
    
end
