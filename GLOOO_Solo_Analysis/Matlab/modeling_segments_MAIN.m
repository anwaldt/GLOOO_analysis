%% modelling_segments_MAIN.m
%
%  Does the solo analysis for a complete
%  directory or a chosen subset.
%
%  This script needs the audio files to be segmented
%  according to the Note-Rest-Transition model!
%
%
% Author : Henrik von Coler
%
% Created: 2014-02-17
%
%% RESET


close all
clearvars
restoredefaultpath


%%  SET Parameters


% Set the (output) path for this set
% either by actual date
% ds = datestr(now,'yyyy-mm-dd');

% work on specific set, instead:
ds = '2020-09-24';

% set this false for debugging
% (enables breakpoints in parfor loops)
run_parallel             = 1;

% overwrite existing results
renew_all                = 1;

% Decide which parts should be executed:
do_basic_analysis        = 1;
do_partial_analysis      = 1;
do_modeling_segments     = 1;

% only for single sounds:
do_statistical_sms         = 1;

do_transition_statistics   = 1;

do_export_yaml             = 1;

% automatically copy files (legacy)
do_move_files_to_server  = 0;

% Decide which files should be processed
% setToDo     = 'SynthResults';
setToDo     = 'SingleSounds';
setToDo     = 'TwoNote';

% Decide which microphone to use
% micToDo     = 'DPA';
micToDo     = 'BuK';



%% Files to do?!
% chose whether to process all files,
% a single file by name, or a subset:

filesToDo  = 'All';

filesToDo   = 'TwoNote_BuK_22.wav';
% filesToDo   = 'SampLib_BuK_01.wav';


% filesToDo  = {'SampLib_BuK_01.wav','SampLib_BuK_02.wav','SampLib_BuK_03.wav','SampLib_BuK_04.wav', ...
% 'SampLib_BuK_05.wav','SampLib_BuK_06.wav','SampLib_BuK_07.wav','SampLib_BuK_08.wav' };


%% PARAMETERS AND PATHS

modeling_segments_STARTUP
modeling_segments_PARAM

GLOOO_PATHS

% Check for existence of paths
%  and make them, if necessary
check_paths(paths)

% sampling rate of the audio files in the library
param.fs = 96000;

%% start and manage pool

p = gcp('nocreate'); % If no pool, do not create new one.
if isempty(p)
    parpool()
else
    disp(['Pool with '   num2str(p.NumWorkers) ' already active!']);
end

if run_parallel == true
    parMode = Inf;
    disp('Running in PARALEL mode!')
else
    parMode = 12;
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
        
        tmp = zeros(size(filesToDo))';
        
        for i=1:length(tmp)
            tmp(i) =  find(ismember(fileNames,filesToDo{i}));
        end
        
        filesToDo = sort(tmp)';
        
    end
end



%% LOOP over all files

if do_basic_analysis == true
    
    % parfor (fileCNT = filesToDo,parMode)
          for fileCNT = filesToDo
        
        
        [~,baseName,~]    = fileparts(fileNames{fileCNT});
        
        
        if ~exist([paths.features baseName  '.mat'],'file') || renew_all == 1
            
            if param.info == true
                disp(['starting basic analysis for: ',fileNames{fileCNT}]);
            end
            
            % Get control- and   trajectories and features
            [CTL, INF]           = basic_analysis(baseName, paths, param, setToDo);
            
        end
    end
    
end


%% SMS LOOP

if do_partial_analysis == true
    
   %  parfor (fileCNT = filesToDo,parMode)
        
      for fileCNT = filesToDo
        
        
        
        [~,baseName,~]      = fileparts(fileNames{fileCNT});
        
        if ~exist([paths.sinusoids baseName  '.mat'],'file') || renew_all == 1
            % Get partial trajectories
            [SMS]               = partial_analysis(baseName,  paths);
            
            if param.info == true
                disp(['starting partial analysis for: ',fileNames{fileCNT}]);
            end
        else
            if param.info == true
                disp(['Analysis for: ',fileNames{fileCNT} ' is already done!']);
            end
            
        end
        
    end
    
end


%% Modeling stage 1
%  - generate the segments
%    with all metadata

if do_modeling_segments == true
    
   % parfor (fileCNT = filesToDo,parMode)
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
   %  parfor (fileCNT = filesToDo,parMode)
    
    for fileCNT = filesToDo
        
        if param.info == true
            disp(['starting statistical SMS for: ',fileNames{fileCNT}]);
        end
        
        %             if ~exist([paths.statSMS baseName '.mat'],'file') || renew_all == 1
        
        [~,baseName,~]   = fileparts(fileNames{fileCNT});
        
        % Analysis
        MOD = statistical_sms(baseName, param, paths, setToDo, micToDo);
        
        %         end
        
    end
    
end


%% Release modeling

% transition statistics are calculated
% in a second loop over all files

% NOTE: This only works if all single sounds 
%       have been processed, before.

if setToDo     == 'SingleSounds'


if do_transition_statistics == true
    
    transition_statistics(fileNames, param, paths);
    
    % Fragments of an alternative version:
    % transition_statistics_partial_2(fileNames, param, paths);
    
end

end

%% Export to YAML

if setToDo     == 'SingleSounds'


if do_export_yaml == true
    
%    parfor fileCNT = 1:length(fileNames)
    for fileCNT = 1:length(fileNames)
        
        [~,baseName,~] = fileparts(fileNames{fileCNT});
        tmpName = regexprep(regexprep(baseName, '_BuK', ''),  '_DPA', '');

        if param.info == true
            disp(['Exporting statistical YAML model for: ',tmpName]);
        end
        
        MATname = [paths.statSMS tmpName '.mat'];
        load(MATname, 'MOD');
        
        
        YAMLname = [paths.yaml tmpName '.yml'];
        %S = YAML.dump(MOD);
        YAML.write(YAMLname,MOD);
        
    end
    
end

end

%% Push files

if do_move_files_to_server == true
    
    copyfile(paths.analysis,paths.server,'f')
    
end