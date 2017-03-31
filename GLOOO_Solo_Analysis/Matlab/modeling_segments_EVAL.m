%% modelling_segments_EVAL.m
%
%   Script for evluating anaysis 
%   results (manually) with plots etc.
%
%
% Author : Henrik von Coler
%
% Created: 2017-03-27



%% RESET

close all
clearvars
restoredefaultpath



%% Decide which file should be processed

setToDo     = 'SingleSounds';

  filesToDo = 'SampLib_DPA_01.wav';
%filesToDo = 'All';

partIDX = 22:24;

%% Set the 'output' path for this set
%  which is actually the INPUT for this script

outPath = '../Results/SingleSounds/2017-03-26/';

% set another path to use the results from the server 
outPath = '/mnt/forschungsprojekte/Klanganalyse_und_Synthese/Violin_Library_2015/Analysis/2017-03-26/';

%% SET

modeling_segments_STARTUP
modeling_segments_PATHS
modeling_segments_PARAM


%% get list of files

directoryFiles = dir(paths.wavPrepared);
% only get the wave files out of the folder into the list of audio files
% which should be processed
validFileidx    = 1;
fileNames       = cell(1);

for n = 1:length(directoryFiles);
    [pathstr,name,ext] = fileparts(directoryFiles(n).name);
    if strcmp(ext,'.wav')
        fileNames{validFileidx} = directoryFiles(n).name;
        validFileidx = validFileidx + 1;
    end
end


% resort filenames
numVec              = regexprep(fileNames,'SampLib_DPA_','');
numVec              = str2double(regexprep(numVec,'.wav',''));


[s,i]               = sort(numVec);
fileNames           = fileNames(i);

% get number of files
nFiles   = length(fileNames);

% create file list
if strcmp(filesToDo,'All')==1
    filesToDo = 1:nFiles;
else
    filesToDo =  find(ismember(fileNames,filesToDo));
end


%%


[~,baseName,~]    = fileparts(fileNames{1});
        
plot_sinusoid_trajectories(baseName, partIDX, paths);

