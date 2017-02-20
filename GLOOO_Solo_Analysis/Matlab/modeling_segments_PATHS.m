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
if strcmp(setToDo,'TwoNote') ==1

    paths.wavPrepared   = 'D:\Users\hvcoler_V2\Violin_Library_2015\WAV\TwoNote\DPA\';
    paths.segSV         = 'D:\Users\hvcoler_V2\Violin_Library_2015\Segmentation\TwoNote\';
    paths.FILELISTS     = 'D:\Users\hvcoler_V2\Violin_Library_2015\File_Lists\';

elseif strcmp(setToDo,'SingleSounds') ==1
    

    
    % input for single
%    paths.wavPrepared   = 'D:\Users\hvcoler_V2\Violin_Library_2015\WAV\SingleSounds\DPA\';
%   paths.segSV         = 'D:\Users\hvcoler_V2\Violin_Library_2015\Segmentation\SingleSounds\';
%   paths.FILELISTS     = 'D:\Users\hvcoler_V2\Violin_Library_2015\File_Lists\';

 paths.wavPrepared   = '../../../Violin_Library_2015/WAV/SingleSounds/DPA/';
   paths.segSV         ='../../../Violin_Library_2015/Segmentation/SingleSounds/';
   paths.FILELISTS     = '../../../Violin_Library_2015/File_Lists/';

    

end

% output paths are WITHIN the 'outPath'
paths.features      = [outPath 'Features/'];
paths.segments      = [outPath 'Segments/'];

paths.sinusoids     = [outPath 'Sinusoids/'];
paths.statSMS       = [outPath 'StatisticalSMS/'];



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


