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

% input for TWO NOTE
if strcmp(setToDo,'TwoNote') ==1
    
    switch micToDo
        
        case 'BuK'
            outPath             = ['../Results/' ds '/TwoNote/BuK/'];
            paths.wavPrepared   = '../../../Violin_Library_2015/Prepared/WAV/TwoNote/BuK/';
        case 'DPA'           
            outPath             = ['../Results/' ds '/TwoNote/DPA/'];
            paths.wavPrepared   = '../../../Violin_Library_2015/Prepared/WAV/TwoNote/DPA/';
            
    end
    
    paths.segSV         = '../../../Violin_Library_2015/Prepared/Segments/TwoNote/';
    paths.FILELISTS     = '../../../Violin_Library_2015/File_Lists/';    
  

elseif strcmp(setToDo,'SingleSounds') ==1
    
    switch micToDo
        
        case 'DPA'
            outPath             = ['../Results/' ds '/SingleSounds/DPA/'];
            paths.wavPrepared   = '../../../Violin_Library_2015/Prepared/WAV/SingleSounds/DPA/';
        case 'BuK'
            outPath             = ['../Results/' ds '/SingleSounds/BuK/'];
            paths.wavPrepared   = '../../../Violin_Library_2015/Prepared/WAV/SingleSounds/BuK/';
          

    end
    
    paths.segSV         ='../../../Violin_Library_2015/Prepared/Segments/SingleSounds/';
    paths.FILELISTS     = '../../../Violin_Library_2015/File_Lists/';
    
    
end

% output paths are WITHIN the 'outPath'
paths.features      = [outPath 'Features/'];
  paths.segments      = [outPath 'Segments/'];
  
paths.txtDir        = [outPath 'SinusoidsTXT/'];

paths.sinusoids     = [outPath 'Sinusoids/'];
paths.statSMS       = [outPath 'StatisticalSMS/'];



paths.tonal         = [outPath 'Tonal/'];
paths.residual      = [outPath 'Residual/'];
paths.complete      = [outPath 'Complete/'];

paths.plot          = [outPath 'Plots/'];


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


paths.server        = ['\\NAS-AK\Forschungsprojekte\Klanganalyse_und_Synthese\Violin_Library_2015\Analysis\'];
