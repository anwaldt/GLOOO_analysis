%% modelling_segments_PATHS.m
%
%
%
% Henrik von Coler
% Created: 2014-02-17
% Edited:  2016-09-21 
%
%%

%% SET PATHS

% input for TWO NOTE
paths.wavPrepared   = '../../../Violin_Library_2015/WAV/TwoNote/DPA/';
paths.segSV         = '../../../Violin_Library_2015/Segmentation/TwoNote/';
paths.FILELISTS     = '../../../Violin_Library_2015/File_Lists/';



% output paths are WITHIN the 'outPath'
paths.features      = [outPath 'Features/'];  
paths.segments      = [outPath 'Segments/'];

paths.sinusoids     = [outPath 'Sinusoids/'];


paths.tonal         = [outPath 'Tonal/'];
paths.residual      = [outPath 'Residual/'];

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


