function [fileNames] = create_file_list(pat)

directoryFiles = dir(pat);
% only get the wave files out of the folder into the list of audio files
% which should be processed
validFileidx    = 1;
fileNames       = cell(1);

for n = 1:length(directoryFiles);
    [pathstr,name,ext] = fileparts(directoryFiles(n).name);
    if strcmp(ext,'.mat')
        fileNames{validFileidx} = directoryFiles(n).name;
        validFileidx = validFileidx + 1;
    end
end


inFiles = fileNames;

nFiles      = length(inFiles);

% resort filenames
numVec              = regexprep(inFiles,'SampLib_DPA_','');
numVec              = regexprep(inFiles,'SampLib_BuK_','');
numVec              = regexprep(inFiles,'TwoNote_DPA_','');
numVec              = regexprep(inFiles,'TwoNote_BuK_','');

numVec              = str2double(regexprep(numVec,'.mat',''));


[s,i]               = sort(numVec);

fileNames           = fileNames(i);
