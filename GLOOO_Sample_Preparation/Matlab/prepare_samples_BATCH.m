% prepare_samples_BATCH.m
%
% Script for calling the function 'get_partial_trajectories()'
% for a complete set of audio files!
%
% - Creates all data neccessary for the synthesis!
%
% HVC
% Started :     2014-07-10
% Modified:     2016-08-04

%% RESET

close all
clearvars
restoredefaultpath


%% OUTPUT directory

rootDIR = '../Results/3/';


%% SET

prepare_samples_STARTUP
prepare_samples_PATHS
prepare_samples_PARAM


%% Start Matlab Pool ???

s = matlabpool('size');

if s == 0 && param.parallel == true
    matlabpool
end


%% List of File Names

wavFiles      = dir(paths.inDir);
wavFiles(1:2) = [];
wavNames      = cellfun(@(x)regexprep(x, '.wav',''),  {wavFiles.name}, 'UniformOutput', false);


nFiles = length(wavNames);% length(unproc);


%% Confirm processing


% if nFiles == nSinFiles
%     button = questdlg('A complete set of sinusoids exists. Do you want to start a re-calculation?');
%     if strcmp(button,'No') || strcmp(button,'Cancel')
%         break
%     end
% else
%     button = questdlg([prepare_samples(baseName, paths, param) 'Complete calculation of ' num2str(nFiles) ' ?' ]);
%     if strcmp(button,'No') || strcmp(button,'Cancel')
%         break
%     end
% end



%% Process all files
 

 parfor fileCnt = 1:nFiles
 
    
    % get file name
    disp(['File ' num2str(fileCnt) ' of ' num2str(nFiles)]);
    baseName = wavNames{fileCnt} ;
    
    % the main analysis function
    [original, tonal, noise] = prepare_sample(baseName, paths, param);
    
 %   [SMS] = model_trajectories(baseName, pa    ths);
    
end

 

