%% modelling_segments_BATCH.m
%
%   Does the solo analysis for a batch of files.
%
%   This project needs the audio files to be segmented
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


%% Decide which parts of the script should be executed

do_basic_analysis       = 0;
do_partial_analysis     = 1;
do_modeling_segments    = 0;
do_statistical_sms      = 0;
do_move_files_to_erver  = 0;

%% Decide which files should be processed

setToDo     = 'SingleSounds';
%  setToDo     = 'TwoNote';

%  filesToDo = 'SampLib_DPA_269.wav';
filesToDo = 'All';


%% Set the output path for this set

% outPath = '../Results/SingleSounds/2017-03-24/';

outPath = '/mnt/forschungsprojekte/Klanganalyse_und_Synthese/Violin_Library_2015/Analysis/2017-03-25/';

%% SET

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


%% LOOP over all files

if do_basic_analysis == true
    parfor (fileCNT = filesToDo,parMode)
        
        if param.info == true
            disp(['starting basic analysis for: ',fileNames{fileCNT}]);
        end
        
        [~,baseName,~]    = fileparts(fileNames{fileCNT});
        
        % Get gontrol- and   trajectories and features
        [CTL]           = basic_analysis(baseName, paths, param, setToDo);
        
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
        
        % Get partial trajectories
        [SMS]               = partial_analysis(baseName,  paths);
        
        
    end
end


%% Segment preparation LOOP

if do_modeling_segments == true
    parfor (fileCNT = filesToDo,parMode)
        
        if param.info == true
            disp(['starting modeling for: ',fileNames{fileCNT}]);
        end
        
        [~,baseName,~]    = fileparts(fileNames{fileCNT});
        
        % Analysis
        modeling_segments(baseName, paths, setToDo);
        
        if param.info == true
            disp(['finished analysis for: ',fileNames{fileCNT}]);
        end
        
    end
end




%% Transition modeling LOOP
% MORITZ:



%% note modeling

if do_statistical_sms == true
    parfor (fileCNT = filesToDo,parMode)
        
        if param.info == true
            disp(['starting statistical SMS for: ',fileNames{fileCNT}]);
        end
        
        [~,baseName,~]   = fileparts(fileNames{fileCNT});
        
        % Analysis
        MOD = statistical_sms(baseName, param, paths, setToDo);
        
    end
end


%% Push files

if do_move_files_to_erver == true

    copyfile(outPath,[paths.server datestr(now,'yyyy-mm-dd')])

end