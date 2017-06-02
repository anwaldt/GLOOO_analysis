%% render_solo_PATHS
%
%
%
%
%
%
% Author:  Henrik von Coler
% Created: 2016-08-16

% paths.SAMPLES   = '../../../Violin_Library_2015/WAV/SingleSounds/DPA/';
% paths.SINMOD    = '../../GLOOO_Sample_Preparation/Results/1/Sinusoidal_Data_MAT/Violin_2015/BuK/';
% paths.SINMOD    = '../../Violin_Library_2015/Analysis/2017-04-22-15-50/Sinusoids/';
% % paths.LOOP    = '../../GLOOO_Sample_Preparation/Loop_Points/';
% 

% paths.features  = '../../GLOOO_Solo_Analysis/Results/1/Features/';
%  
paths.KERNELS   = '../../IFFT_Synthesis/Data/';
% 
% 
% paths.FILELISTS =  '../../../Violin_Library_2015/File_Lists/';


%% SET PATHS
 
paths.wavDir         = ['../../../Violin_Library_2015/Prepared/WAV/SingleSounds/BuK/'];
paths.matDir        = [ libDIR 'Sinusoids/'];
paths.txtDir        = [ libDIR 'Sinusoidal_Data_TXT/Violin_2015/BuK/'];
paths.resDir        = [ libDIR 'Residual/Violin_2015/BuK/'];
paths.tonDir        = [ libDIR 'Tonal/Violin_2015/BuK/'];
paths.comDir        = [ libDIR 'Complete/Violin_2015/BuK/'];

paths.listDIR       = [ '../../../Violin_Library_2015/File_Lists/'];
paths.segDir        = [ soloDIR 'Segments/'];

%paths.segDIR = '\\NAS-AK\Forschungsprojekte\Klanganalyse_und_Synthese\Violin_Library_2015\Segmentation\SingleSounds';

paths.OUTPUT    = '../WAV/';



%% Check for existence of paths
%  and make them, if necessary

% fn      = fieldnames(paths);
% nFields = length(fn); 
% 
% for fieldCNT = 1:nFields
%     
%      tmpDir = eval(['paths.' fn{fieldCNT}]);
%      
%      
%      if isdir(tmpDir) == 0
%         mkdir(tmpDir);
%      end
%     
%     
% end

