%% render_solo_PATHS
%
%
%
%
%
%
% Author:  Henrik von Coler
% Created: 2016-08-16

paths.SAMPLES   = '../../../Violin_Library_2015/WAV/SingleSounds/DPA/';
paths.SINMOD    = '../../GLOOO_Sample_Preparation/Results/1/Sinusoidal_Data_MAT/Violin_2015/BuK/';
% paths.LOOP    = '../../GLOOO_Sample_Preparation/Loop_Points/';

paths.segments  = '../../GLOOO_Solo_Analysis/Results/1/Segments/';
paths.features  = '../../GLOOO_Solo_Analysis/Results/1/Features/';
 
paths.KERNELS   = '../../IFFT_Synthesis/Data/';


paths.FILELISTS =  '../../../Violin_Library_2015/File_Lists/';

paths.OUTPUT    = '../WAV/';



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

