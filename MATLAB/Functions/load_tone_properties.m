%% function I = load_tone_properties(baseName, paths)
%
%   JUST FOR THE Single Notes
%
% Author : HvC
% Created: 2017-02-14

function I = load_tone_properties(baseName, param, paths, setToDo, micToDo)

% tuning frequency should NOT be hard-coded:
tuningFreq = param.tuningFreq;

% load file
f1 = fopen([paths.listDIR 'list_Single.txt'],'r');
A  = textscan(f1,'%s %s %s %d %s %s %s',inf,'HeaderLines',1);
fclose(f1);

% get index
IDX = find(ismember(A{1},(baseName)));

if isempty(IDX)
    IDX = find(ismember(A{1},regexprep(baseName,'BuK','DPA')));
end

prop = [A{1}(IDX) A{2}(IDX) A{3}(IDX) A{4}(IDX) A{5}(IDX) A{6}(IDX)];

tmpMidi =  double(prop{4});

n = tmpMidi-69;

I.note.f0 = 2^(n/12)*tuningFreq;

I.midinote = tmpMidi;

I.intensity = prop{6};