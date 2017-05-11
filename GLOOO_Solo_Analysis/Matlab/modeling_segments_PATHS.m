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
ds = '2017-05-07';


%% SET PATHS
% in a switch case scenario for the 'set to do'
% and the microphone

% input for TWO NOTE
if strcmp(setToDo,'TwoNote') ==1
    
    switch micToDo
        
        case 'BuK'
            outPath             = ['../Results/TwoNote/BuK/' ds '/'];
            paths.wavPrepared   = '../../../Violin_Library_2015/Prepared/WAV/TwoNote/BuK/';
            paths.server        = ['\\NAS-AK\Forschungsprojekte\Klanganalyse_und_Synthese\Violin_Library_2015\Analysis\TwoNote\BuK\' ds '\'];
            
        case 'DPA'
            outPath             = ['../Results/TwoNote/DPA/' ds '/'];
            paths.wavPrepared   = '../../../Violin_Library_2015/Prepared/WAV/TwoNote/DPA/';
            paths.server        = ['\\NAS-AK\Forschungsprojekte\Klanganalyse_und_Synthese\Violin_Library_2015\Analysis\TwoNote\DPA\' ds '\'];
            
    end
    
    paths.segSV         = '../../../Violin_Library_2015/Prepared/Segments/TwoNote/';
    paths.FILELISTS     = '../../../Violin_Library_2015/File_Lists/';
    
    
elseif strcmp(setToDo,'SingleSounds') ==1
    
    switch micToDo
        
        case 'DPA'
            outPath             = ['../Results/SingleSounds/DPA/' ds '/'];
            paths.wavPrepared   = '../../../Violin_Library_2015/Prepared/WAV/SingleSounds/DPA/';
            paths.server        = ['\\NAS-AK\Forschungsprojekte\Klanganalyse_und_Synthese\Violin_Library_2015\Analysis\SingleSounds\DPA\' ds '\'];
            
        case 'BuK'
            outPath             = ['../Results/SingleSounds/BuK/' ds '/'];
            paths.wavPrepared   = '../../../Violin_Library_2015/Prepared/WAV/SingleSounds/BuK/';
            paths.server        = ['\\NAS-AK\Forschungsprojekte\Klanganalyse_und_Synthese\Violin_Library_2015\Analysis\SingleSounds\BuK\' ds '\'];
            
            
            
    end
    
    paths.segSV         ='../../../Violin_Library_2015/Prepared/Segments/SingleSounds/';
    paths.FILELISTS     = '../../../Violin_Library_2015/File_Lists/';
    
    
end

% output paths are WITHIN the 'outPath'
paths.features      = [paths.server 'Features\'];
paths.segments      = [paths.server 'Segments\'];

paths.txtDir        = [paths.server 'SinusoidsTXT\'];

paths.sinusoids     = [paths.server 'Sinusoids\'];
paths.statSMS       = [paths.server 'StatisticalSMS\'];



paths.tonal         = [paths.server 'Tonal\'];
paths.residual      = [paths.server 'Residual\'];
paths.complete      = [paths.server 'Complete\'];

paths.plot          = [paths.server 'Plots\'];


%% Check for existence of paths
%  and make them, if necessary

fn      = fieldnames(paths);
nFields = length(fn);

for fieldCNT = 1:nFields
    
    tmpDir = eval(['paths.' fn{fieldCNT}]);
    
    if isdir(tmpDir) == 0
        mkdir(tmpDir);
    end
    
    
end


