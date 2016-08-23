%% modelling_segments_PATHS.m
%
%
%
% Henrik von Coler
% 2014-02-17
%%

%% PARAMETERS

 

%% PATHS


samplibDIR = '/mnt/forschungsprojekte/Klanganalyse_und_Synthese/Violin_Library_2015/';

% GLOOO processing
paths.wavPrepared   = '/mnt/forschungsprojekte/Klanganalyse_und_Synthese/Violin_Library_2015/WAV/TwoNote/';
paths.segSV         = '/mnt/forschungsprojekte/Klanganalyse_und_Synthese/Violin_Library_2015/Segmentation/TwoNote/';


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

paths.FILELISTS     = '../../WAV/File_Lists/';

paths.tonal         = '../Tonal/';
paths.residual      = '../Residual/';

