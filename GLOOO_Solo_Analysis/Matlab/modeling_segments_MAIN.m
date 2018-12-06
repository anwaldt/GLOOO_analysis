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
%
%
%% RESET

close all
clearvars
restoredefaultpath


%%  SET



% Set the (output) path for this set
ds = datestr(now,'yyyy-mm-dd'); 


% set this false for debugging
% (enables breakpoints in parfor loops)
run_parallel             = 0;

% overwrite existing results
renew_all                = 0;

% Decide which parts should be executed:
do_basic_analysis        = 1;
do_partial_analysis      = 1;
do_modeling_segments     = 0;

% only for single sounds:
do_statistical_sms       = 0;


% use remote folders (to be removed)
remote_results           = 0;

do_move_files_to_server  = 0;

% Decide which files should be processed
% setToDo     = 'SynthResults';
% setToDo     = 'SingleSounds';
setToDo     = 'TwoNote';

% Decide which microphone to use
%micToDo     = 'DPA';
micToDo     = 'BuK';

% chose whether to process all files,
% a single file by name, or a subset:

 %filesToDo  = 'All';
%filesToDo  = '1-oct-sweep.wav';
% filesToDo  = 'All';
 % filesToDo  = 'SampLib_BuK_136.wav';
 filesToDo   = 'TwoNote_BuK_22.wav';
% filesToDo   = 'SampLib_BuK_301.wav';
% filesToDo   = 'SampLib_BuK_332.wav';
%filesToDo = {'TwoNote_DPA_18.wav'};

%% PARAMETERS AND PATHS

modeling_segments_STARTUP
modeling_segments_PARAM

GLOOO_PATHS

%% start and manage pool

p = gcp('nocreate'); % If no pool, do not create new one.
if isempty(p)
    parpool
else
    disp(['Pool with '   num2str(p.NumWorkers) ' already active!']);
end

if run_parallel == true
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

for n = 1:length(directoryFiles)
    [pathstr,name,ext] = fileparts(directoryFiles(n).name);
    if strcmp(ext,'.wav')
        fileNames{validFileidx} = directoryFiles(n).name;
        validFileidx = validFileidx + 1;
    end
end

% re-sort filenames
%numVec              = regexprep(fileNames,'SampLib_DPA_','');
numVec              = regexprep(fileNames,'SampLib_BuK_','');
%numVec              = regexprep(fileNames,'TwoNote_DPA_','');
%numVec              = regexprep(fileNames,'TwoNote_BuK_','');
numVec              = str2double(regexprep(numVec,'.wav',''));


[s,i]               = sort(numVec);
fileNames           = fileNames(i);

% get number of files
nFiles   = length(fileNames);

% create file list
if strcmp(filesToDo,'All')==1
    filesToDo = 1:nFiles;
else
    if ischar(filesToDo)
        filesToDo =  find(ismember(fileNames,filesToDo));
        if isempty(filesToDo)
            error('The selected file does not exist!')
        end
        
    end
    
    if iscell(filesToDo)
        
        tmp = zeros(size(filesToDo));
        
        for i=1:length(tmp)
            tmp(i) =  find(ismember(fileNames,filesToDo{i}));
        end
        
        filesToDo = sort(tmp)';
        
    end
end



%% LOOP over all files

if do_basic_analysis == true
    
    %  parfor (fileCNT = filesToDo,parMode)
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
    
    %parfor (fileCNT = filesToDo,parMode)
    for fileCNT = filesToDo
        
        
        if param.info == true
            disp(['starting partial analysis for: ',fileNames{fileCNT}]);
        end
        
        [~,baseName,~]      = fileparts(fileNames{fileCNT});
        
        if ~exist([paths.sinusoids baseName  '.mat'],'file') || renew_all == 1
            % Get partial trajectories
            [SMS]               = partial_analysis(baseName,  paths);
        end
        
    end
end




%% Modeling stage 1
%

if do_modeling_segments == true
    
    %    parfor (fileCNT = filesToDo,parMode)
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


%% Single Sound Modeling

if do_statistical_sms == true
    
    % YAML stuff does not like parallel
    % parfor (fileCNT = filesToDo,parMode)
    
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

if do_move_files_to_server == true
    
    copyfile(paths.analysis,paths.server,'f')
    
end