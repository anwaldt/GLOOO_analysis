%% modelling_segments_PATHS.m
%
%
%
% Henrik von Coler
% Created: 2014-02-17
% Edited:  2016-09-21 
%%

 

%% PATHS

% on server
paths.wavPrepared   = '../../../Violin_Library_2015/WAV/TwoNote/DPA/';
paths.segSV         = '../../../Violin_Library_2015/Segmentation/TwoNote/';

% % local
% samplibDIR          = '/media/anwaldt/HVC/GLOOO/GLOOO_Sample_Preparation/';
% paths.wavPrepared   = '/media/anwaldt/HVC/GLOOO/WAV/Two_Note/';
% paths.segSV         = '/media/anwaldt/HVC/GLOOO/GLOOO_Solo_Analysis/Segmentation/';

%  for Master thesis processing
% paths.segSV         = ('/home/anwaldt/Work/PROJECTS/Master_Thesis/Audio/Segmentation/');
% paths.wav           = ('/home/anwaldt/Work/PROJECTS/Master_Thesis/Audio/WAV/');
% paths.wavPrepared   = ('/home/anwaldt/Work/PROJECTS/Master_Thesis/Audio/WAVprepared/');
% paths.features      = ('/media/anwaldt/HVC/Modelling_Expressive_Musical_Content/Features/');
% paths.segments      = ('/media/anwaldt/HVC/Modelling_Expressive_Musical_Content/Segments/');
% paths.notes         = ('/media/anwaldt/HVC/Modelling_Expressive_Musical_Content/Notes/');
% paths.transitions   = ('/media/anwaldt/HVC/Modelling_Expressive_Musical_Content/Transitions/');
% paths.sinusoids     = ('/media/anwaldt/HVC/Modelling_Expressive_Musical_Content/Sinusoids/');
% paths.MIDI          = ('/media/anwaldt/HVC/Modelling_Expressive_Musical_Content/MIDI/');

 
%% Paths for a single file to analyze

% use the two note sequences
% paths.segSV         = '/mnt/forschungsprojekte/Klanganalyse_und_Synthese/Violin_Library_2015/Segmentation/Solo/';

% use the solos
% paths.segSV         = '/mnt/forschungsprojekte/Klanganalyse_und_Synthese/Violin_Library_2015/Segmentation/Solo/';
% paths.wavPrepared   = '/mnt/forschungsprojekte/Klanganalyse_und_Synthese/Violin_Library_2015/SOLOprepared/';



% output
paths.features      = '../Features/';  
paths.segments      = '../Segments/';
paths.notes         = '../Notes/';
paths.transitions   = '../Transitions/';
paths.sinusoids     = '../Sinusoids/';
paths.MIDI          = '../MIDI/';
paths.FILELISTS     = '../../../Violin_Library_2015/File_Lists/';
paths.tonal         = '../Tonal/';
paths.residual      = '../Residual/';
paths.plot          = '../Plots/';

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

 

