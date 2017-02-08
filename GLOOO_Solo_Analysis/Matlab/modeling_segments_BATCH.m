%% modelling_segments_BATCH.m
%
%   Does the solo analysis for a batch of files.
%
% This project needs the audio files to be segmented
% according to the Note-Rest-Transition model!
%
%
%
% Author : Henrik von Coler
%
% Created: 2014-02-17
% Edited : 2016-08-08
%
%
%% RESET 
close all
clearvars
restoredefaultpath

%% Decide which parts of the script should be executed
do_basic_analysis    = true;
do_partial_analysis  = true;
do_modeling_segments = true;


%% Decide which files should be processed

filesToDo = 1;
% filesToDo = '44_DPA'
% filesToDo = 'All';


%% Set the outup path for this set

outPath = '../Results/1/';


%% SET

modeling_segments_STARTUP
modeling_segments_PATHS
modeling_segments_PARAM

%% start pool

s = matlabpool('size');
if s == 0 && param.parallel == true
    matlabpool
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

nFiles   = length(fileNames);

%% LOOP over all files
if do_basic_analysis == true
    parfor fileCNT = filesToDo
        
        if param.info == true
            disp(['starting basic analysis for: ',fileNames{fileCNT}]); 
        end

        [~,baseName,~]    = fileparts(fileNames{fileCNT});


        % Get gontrol- and   trajectories and features
        [CTL]           = basic_analysis(baseName, paths, param);

    end  
end    


%% SMS LOOP
if do_partial_analysis == true
    parfor fileCNT = filesToDo
        
        if param.info == true
            disp(['starting partial analysis for: ',fileNames{fileCNT}]);
        end

        [~,baseName,~]    = fileparts(fileNames{fileCNT});

        % Get partial trajectories
        [SMS]           = partial_analysis(baseName,  paths);

        % transform partial data
        % ...

     end   
end 


%% MODELING LOOP
if do_modeling_segments == true
 for fileCNT = filesToDo
     
    if param.info == true
        disp(['starting modeling for: ',fileNames{fileCNT}]);
    end
    
    [~,baseName,~]    = fileparts(fileNames{fileCNT});

    % Analysis
    [SEG, INF]      = modeling_segments(baseName, paths);
        
    if param.info == true
        disp(['finished analysis for: ',fileNames{fileCNT}]);
    end
    
 end
end