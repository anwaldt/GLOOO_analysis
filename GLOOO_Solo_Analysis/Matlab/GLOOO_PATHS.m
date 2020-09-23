%% modelling_segments_PATHS.m
%
%
%
% Henrik von Coler
% Created: 2014-02-17
% Edited:  2016-09-21
%

%% set basic directories


% this string is used to create a subdirectory for
% the results
version_string  = [ setToDo '_' micToDo '_'  param.F0.f0Mode  '_' ds '/'];

% set the path to the library

%libDIR  = '/media/DATA/USERS/HvC/GLOOO/Violin_Library_2015/';

% should be irrelevant, now
libDIR     = '/home/anwaldt/WORK/TU-Note_Violin/';
%'../../../../Violin_Library_2015/';


% tunoteDIR  = '/mnt/wintermute/mnt/DATA/USERS/HvC/TU-Note_Violin/';
% tunoteDIR  = '/mnt/DATA/USERS/HvC/TU-Note_Violin/';
tunoteDIR  = '/home/anwaldt/WORK/TU-Note_Violin/';

%'/media/DATA/USERS/HvC/GLOOO/Violin_Library_2015/';

% This is only needed for accessing the raw recordings
libDIRemote     = '/mnt/forschungsprojekte/Klanganalyse_und_Synthese/Violin_Library_2015/';


%% SET PATHS
% in a switch case scenario for the 'set to do'
% and the microphone


paths.listDIR  = [libDIR 'File_Lists/'];

% input for Solo
if strcmp(setToDo,'Solo') ==1
    
    paths.wavRaw                = [libDIRemote '/Cubase/Tag_2/Violin_Recordings-von_Coler-2015_3/Audio/'];
    
    % use the prepared segmentation files
    paths.segmentationPrepared  = [libDIRemote 'Segments/Solo/'];
    
    
    paths.segmentationRAW       = [libDIR 'Segmentation/Solo/'];
    
    switch micToDo
        
        case 'BuK'
            %             outPath             = ['../Results/TwoNote/BuK/' ds '/'];
            paths.wavPrepared   = [libDIR 'WAV/Solo/BuK/'];
             
        case 'DPA'
            %             outPath             = ['../Results/TwoNote/DPA/' ds '/'];
            paths.wavPrepared   = [libDIR 'WAV/Solo/DPA/'];
                         
    end
    
    
    % input for TWO NOTE
elseif strcmp(setToDo,'TwoNote') ==1
    
    paths.wavRaw                = [libDIR '/Cubase/Tag_2/Violin_Recordings-von_Coler-2015_2/Audio/'];
    
    % use the prepared segmentation files
    paths.segmentationPrepared  = [libDIR 'Segments/TwoNote/'];
    
    
    paths.segmentationRAW       = [libDIR 'Segmentation/TwoNote/'];
    
    
    switch micToDo
        
        case 'BuK'
            %             outPath             = ['../Results/TwoNote/BuK/' ds '/'];
            paths.wavPrepared   = [libDIR 'WAV/TwoNote/BuK/'];
            
             
        case 'DPA'
            %             outPath             = ['../Results/TwoNote/DPA/' ds '/'];
            paths.wavPrepared   = [libDIR 'WAV/TwoNote/DPA/'];
            
             
    end
    
    
    % input for SingleSounds
elseif strcmp(setToDo,'SingleSounds') ==1
    
    paths.wavRaw                = [libDIR 'Cubase/Tag_1/Violin_Recordings-von_Coler-2015/Audio/'];
    
    paths.segmentationRAW       = [libDIR 'Segmentation/SingleSounds/'];
    
    % use the prepared segmentation files
    paths.segmentationPrepared  = [tunoteDIR 'Segments/SingleSounds/'];

    
    
    switch micToDo
        
        case 'DPA'
            %             outPath             = ['../Results/SingleSounds/DPA/' ds '/'];
            paths.wavPrepared   = [tunoteDIR 'WAV/SingleSounds/DPA/'];
            
            
        case 'BuK'
            %             outPath             = ['../Results/SingleSounds/BuK/' ds '/'];
            paths.wavPrepared   = [tunoteDIR 'WAV/SingleSounds/BuK/'];
            
            
           
            
    end
    
elseif strcmp(setToDo,'SynthResults') ==1
    paths.wavPrepared = '/home/anwaldt/Desktop/Synth_Results/';
    paths.analysis = '/home/anwaldt/Desktop/Synth_Results/Analysis/';
end



paths.analysis         = [libDIR 'Analysis/' version_string];


tmpPath = paths.analysis;

% tmpPath = '/home/anwaldt/WORK/GLOOO/Violin_Library_2015/Analysis/2019-08-12/';

paths.features      = [tmpPath 'Features/'];
paths.segments      = [tmpPath 'Segments/'];

paths.txtDir        = [tmpPath 'SinusoidsTXT/'];

paths.sinusoids     = [tmpPath 'Sinusoids/'];
paths.statSMS       = [tmpPath 'StatisticalSMS/'];
    
 paths.yaml             = [tmpPath 'yaml/'];

paths.tonal         = [tmpPath 'Tonal/'];
paths.residual      = [tmpPath 'Residual/'];
paths.complete      = [tmpPath 'Complete/'];

paths.plot          = [tmpPath 'Plots/'];

