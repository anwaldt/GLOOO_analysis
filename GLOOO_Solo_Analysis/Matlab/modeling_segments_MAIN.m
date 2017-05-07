%% modelling_segments_MAIN.m
%
%   Does the solo analysis for a complete 
%   directory or a chosen subset.
%
%   This script needs the audio files to be segmented
%   according to the Note-Rest-Transition model!
%
%
% Author : Henrik von Coler
%
% Created: 2014-02-17
% Edited : 2016-08-08


%% RESET

close all
clearvars
restoredefaultpath


%%  SET

% Decide which parts of the script should be executed:

do_basic_analysis       = 0;
do_partial_analysis     = 0;
do_modeling_segments    = 0;
do_statistical_sms      = 0;
do_move_files_to_erver  = 0;


% Decide which files should be processed
% setToDo     = 'SingleSounds';
setToDo     = 'TwoNote';

% Decide which microphone to use
micToDo     = 'BuK';

% chose whether to process all files,
% a single file by name, or a subset:
%filesToDo  = 'All';
%filesToDo  = 'SampLib_DPA_01.wav';
filesToDo   = 'TwoNote_BuK_100.wav';
%filesToDo  = 24;




% set another path to use the results from the server
% outPath = '/mnt/forschungsprojekte/Klanganalyse_und_Synthese/Violin_Library_2015/Analysis/2017-03-26/';


%% PARAMETERS AND PATHS

modeling_segments_STARTUP
modeling_segments_PATHS
modeling_segments_PARAM

%% start and manage pool

s = matlabpool('size');
if s == 0 && param.parallel == true
    matlabpool
end


if param.parallel == true
    parMode = Inf;
    disp('Running in PARALEL mode!')
else
    parMode = 0;
    disp('Running in SERIAL mode!')
    
end

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
numVec              = regexprep(fileNames,'SampLib_BuK_','');
numVec              = regexprep(fileNames,'TwoNote_DPA_','');
numVec              = regexprep(fileNames,'TwoNote_BuK_','');
numVec              = str2double(regexprep(numVec,'.wav',''));


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



%% LOOP over all files

if do_basic_analysis == true
    
% parfor (fileCNT = filesToDo,parMode)
        for fileCNT = filesToDo
        
        if param.info == true
            disp(['starting basic analysis for: ',fileNames{fileCNT}]);
        end
        
        [~,baseName,~]    = fileparts(fileNames{fileCNT});
        
        % Get control- and   trajectories and features
        [CTL, INF]           = basic_analysis(baseName, paths, param, setToDo);
        
    end
end


%% SMS LOOP

if do_partial_analysis == true
    
    parfor (fileCNT = filesToDo,parMode)
        % for fileCNT = filesToDo
        
        if param.info == true
            disp(['starting partial analysis for: ',fileNames{fileCNT}]);
        end
        
        [~,baseName,~]      = fileparts(fileNames{fileCNT});
        
        % Get partial trajectories
        [SMS]               = partial_analysis(baseName,  paths);
        
    end
end


%% Modeling stage 1

if do_modeling_segments == true
    %parfor (fileCNT = filesToDo,parMode)
        for  fileCNT = filesToDo 
        if param.info == true
            disp(['starting modeling for: ',fileNames{fileCNT}]);
        end
        
        [~,baseName,~]    = fileparts(fileNames{fileCNT});
        
        % Analysis
        modeling_segments(baseName, paths, setToDo, micToDo);
        
        if param.info == true
            disp(['finished analysis for: ',fileNames{fileCNT}]);
        end
        
    end
end




%% Transition modeling LOOP
% MORITZ:



%% note modeling

if do_statistical_sms == true
    %parfor (fileCNT = filesToDo,parMode)
    for fileCNT = filesToDo
        
        
        if param.info == true
            disp(['starting statistical SMS for: ',fileNames{fileCNT}]);
        end
        
        [~,baseName,~]   = fileparts(fileNames{fileCNT});
        
        % Analysis
        MOD = statistical_sms(baseName, param, paths, setToDo, micToDo);
        
    end
end


%% Push files

if do_move_files_to_erver == true
    
    copyfile(outPath,[paths.server ds],'f')
    
end