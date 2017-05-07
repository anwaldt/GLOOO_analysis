%% function I = load_tone_properties(baseName, paths)
%
%   JUST FOR THE Single Notes
%
% Author : HvC
% Created: 2017-02-14

function I = load_tone_properties(baseName, paths)

% tuning frequency should NOT be hard-coded:
tuningFreq = 443;

% load file
f1 = fopen([paths.FILELISTS 'list_Single.txt'],'r');
A  = textscan(f1,'%s %s %s %s %s %s',inf);
fclose(f1);

% get index
IDX = find(ismember(A{1},(baseName)));

if isempty(IDX)
    IDX = find(ismember(A{1},regexprep(baseName,'BuK','DPA')));
end

prop = [A{1}(IDX) A{2}(IDX) A{3}(IDX) A{4}(IDX) A{5}(IDX) A{6}(IDX)];

tmpMidi = str2double(prop{4});

n = tmpMidi-69;
I.note.f0 = 2^(n/12)*tuningFreq;

