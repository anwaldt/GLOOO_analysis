%% modelling_segments_PATHS.m
%
%
%
% Henrik von Coler
% Created: 2014-02-17
% Edited:  2016-09-21
%
%%

% Set the output path for this set
% ds = datestr(now,'yyyy-mm-dd');
ds = '2017-08-11';


%% SET PATHS
% in a switch case scenario for the 'set to do'
% and the microphone

% input for TWO NOTE
if strcmp(setToDo,'TwoNote') ==1
    
    switch micToDo
        
        case 'BuK'
            outPath             = ['../Results/TwoNote/BuK/' ds '/'];
            paths.wavPrepared   = '../../../Violin_Library_2015/Prepared/WAV/TwoNote/BuK/';
            paths.server        = ['//NAS-AK/Forschungsprojekte/Klanganalyse_und_Synthese/Violin_Library_2015/Analysis/TwoNote/BuK/' ds '/'];
            paths.local         = ['../../../Violin_Library_2015/Analysis/TwoNote/BuK/' ds '/'];
            
            
        case 'DPA'
            outPath             = ['../Results/TwoNote/DPA/' ds '/'];
            paths.wavPrepared   = '../../../Violin_Library_2015/Prepared/WAV/TwoNote/DPA/';
            paths.server        = ['//NAS-AK/Forschungsprojekte/Klanganalyse_und_Synthese/Violin_Library_2015/Analysis/TwoNote/DPA/' ds '/'];
            paths.local         = ['../../../Violin_Library_2015/Analysis/TwoNote/DPA/' ds '/'];
            
    end
    
    paths.segSV         = '../../../Violin_Library_2015/Prepared/Segments/TwoNote/';
    paths.listDIR     = '../../../Violin_Library_2015/File_Lists/';
    
    
    % input for SingleSounds
elseif strcmp(setToDo,'SingleSounds') ==1
    
    switch micToDo
        
        case 'DPA'
            outPath             = ['../Results/SingleSounds/DPA/' ds '/'];
            paths.wavPrepared   = '../../../Violin_Library_2015/Prepared/WAV/SingleSounds/DPA/';
            paths.server        = ['//NAS-AK/Forschungsprojekte/Klanganalyse_und_Synthese/Violin_Library_2015/Analysis/SingleSounds/DPA/' ds '/'];
            paths.local         = ['../../../Violin_Library_2015/Analysis/SingleSounds/DPA/' ds '/'];
            
        case 'BuK'
            outPath             = ['../Results/SingleSounds/BuK/' ds '/'];
            paths.wavPrepared   = '../../../Violin_Library_2015/Prepared/WAV/SingleSounds/BuK/';
            paths.server        = ['//NAS-AK/Forschungsprojekte/Klanganalyse_und_Synthese/Violin_Library_2015/Analysis/SingleSounds/BuK/' ds '/'];
            paths.local         = ['../../../Violin_Library_2015/Analysis/SingleSounds/BuK/' ds '/'];
            
            
            
    end
    
    paths.segSV         ='../../../Violin_Library_2015/Prepared/Segments/SingleSounds/';
    paths.FILELISTS     = '../../../Violin_Library_2015/File_Lists/';
    
end

% output paths are WITHIN the 'outPath'

switch remote_results
    
    case 1
        tmpPath = paths.server;
    case 0
        tmpPath = paths.local;
end

paths.features      = [tmpPath 'Features/'];
paths.segments      = [tmpPath 'Segments/'];

paths.txtDir        = [tmpPath 'SinusoidsTXT/'];

paths.sinusoids     = [tmpPath 'Sinusoids/'];
paths.statSMS       = [tmpPath 'StatisticalSMS/'];



paths.tonal         = [tmpPath 'Tonal/'];
paths.residual      = [tmpPath 'Residual/'];
paths.complete      = [tmpPath 'Complete/'];

paths.plot          = [tmpPath 'Plots/'];


%% Check for existence of paths
%  and make them, if necessary

check_paths(paths)

