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

%% STARTUP

render_solo_START;
render_solo_PATHS;
render_solo_PARAM;



%% get file list

inFiles      = dir(paths.segments);
inFiles      = inFiles(~[inFiles.isdir]);
wavNames     = cellfun(@(x)regexprep(x, '.wav',''),  {inFiles.name}, 'UniformOutput', false);


nFiles = length(wavNames);% length(unproc);



%%

parfor fileCNT = 1:nFiles
    
    % FILE
    baseName    = 'TwoNote_DPA_13';
    
    % info
    disp(['Rendering' baseName ': '  num2str(fileCNT) ' of ' num2str(nFiles)]);
    
    % RUN 
    y = render_solo_wrapper(baseName, paramSynth,  paths);

end

