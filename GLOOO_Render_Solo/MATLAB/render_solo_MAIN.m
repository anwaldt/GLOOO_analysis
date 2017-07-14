%% render_solo_BATCH.m
%
%
%   This script renders the audio streams
%   from all previously analyzed passages!
%
%
%   HvC
%   Created: 2015-04-10
%   Edited : 2016-11-24
%
%

%% RESET

clearvars
close all
restoredefaultpath

 
%% These have to be set before starting
i
%singlesoundDIR  = '/mnt/forschungsprojekte/Klanganalyse_und_Synthese/Violin_Library_2015/Analysis/SingleSounds/BuK/2017-06-02/';
singlesoundDIR  = '/home/anwaldt/Work/Violin_Library_2015/Analysis/SingleSounds/BuK/2017-06-02/';

soloDIR         = '/mnt/forschungsprojekte/Klanganalyse_und_Synthese/Violin_Library_2015/Analysis/TwoNote/BuK/2017-05-12/';
%soloDIR         ='/home/anwaldt/Work/Violin_Library_2015/Analysis/TwoNote/BuK/2017-06-02/';

libDIR          = '/home/anwaldt/Work/Violin_Library_2015/';


%% STARTUP

render_solo_START;
render_solo_PATHS;
render_solo_PARAM;

%%
% chose whether to process all files,
% a single file by name, or a subset:
%filesToDo = 'All';
%filesToDo = 'SampLib_DPA_01.wav';
filesToDo = 'TwoNote_BuK_24.mat';
% filesToDo = 'TwoNote_BuK_100.mat';


%% get list of filesi

directoryFiles = dir(paths.segDir);
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


% resort filenames
numVec              = regexprep(fileNames,'SampLib_DPA_','');
numVec              = regexprep(fileNames,'SampLib_BuK_','');
numVec              = regexprep(fileNames,'TwoNote_DPA_','');
numVec              = regexprep(fileNames,'TwoNote_BuK_','');
numVec              = str2double(regexprep(numVec,'.mat',''));


[s,i]               = sort(numVec);
fileNames           = fileNames(i);

% get number of files
nFiles   = length(fileNames);

% create file list
if strcmp(filesToDo,'All')==1
    filesToDo = 1:nFiles;
else
    if isstr(filesToDo)
        filesToDo =  find(ismember(fileNames,filesToDo));
        if isempty(filesToDo)
            error('The selected file does not exist!')
        end
        
    end
end


%% Load Sample Library

sampMAT = sample_matrix(paths, paramSynth);


%%

for fileCNT = filesToDo
    
    % FILE
    [~,baseName,~]   = fileparts( fileNames{fileCNT});
    
    % info
    disp(['Rendering' baseName ': '  num2str(fileCNT) ' of ' num2str(nFiles)]);
    
    % RUN 
    y = render_solo_wrapper(baseName, paramSynth, sampMAT, paths);

end

