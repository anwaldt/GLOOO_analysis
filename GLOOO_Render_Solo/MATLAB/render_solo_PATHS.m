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
paths.matDir        = [ singlesoundDIR 'Sinusoids/'];
paths.txtDir        = [ singlesoundDIR 'Sinusoidal_Data_TXT/Violin_2015/BuK/'];
paths.resDir        = [ singlesoundDIR 'Residual/Violin_2015/BuK/'];
paths.tonDir        = [ singlesoundDIR 'Tonal/Violin_2015/BuK/'];
paths.comDir        = [ singlesoundDIR 'Complete/Violin_2015/BuK/'];

paths.staDir        = [singlesoundDIR 'StatisticalSMS/'];

paths.listDIR       = [ '../../../Violin_Library_2015/File_Lists/'];
paths.segDir        = [ soloDIR 'Segments/'];

%paths.segDIR = '\\NAS-AK\Forschungsprojekte\Klanganalyse_und_Synthese\Violin_Library_2015\Segmentation\SingleSounds';

paths.OUTPUT    = '../WAV/';



%% Check for existence of paths
%  and make them, if necessary

check_paths(paths)

