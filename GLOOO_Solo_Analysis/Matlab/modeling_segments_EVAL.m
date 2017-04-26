%% modelling_segments_EVAL.m
%
%   Script for evluating anaysis 
%   results (manually) with plots etc.
%
%
% Author : Henrik von Coler
%
% Created: 2017-03-27


%% RESET

close all
clearvars
restoredefaultpath


%% Decide which file should be processed

setToDo     = 'TwoNote';

% filesToDo = 'SampLib_DPA_10.wav';
filesToDo = 'TwoNote_BuK_22.wav';

%filesToDo = 'All';

partIDX = 1:5;

%% Set the 'output' path for this set
%  which is actually the INPUT for this script

%outPath = '../../../Violin_Library_2015/Analysis/2017-04-22-15-50/';
outPath = '../Results/SingleSounds/2017-04-23/';


% set another path to use the results from the server 
% outPath = '/mnt/forschungsprojekte/Klanganalyse_und_Synthese/Violin_Library_2015/Analysis/2017-03-26/';

%% SET

modeling_segments_STARTUP
modeling_segments_PATHS
modeling_segments_PARAM


%% get list of files

directoryFiles = dir(paths.wavPrepared);
% only get the wave files out of the folder into the list of audio files
% which should be processed
validFileidx    = 1;
fileNames       = cell(1);

for n = 1:length(directoryFiles);
    [pathstr,name,ext] = fileparts(directoryFiles(n).name);
    if strcmp(ext,'.wav')
        fileNames{validFileidx} = directoryFiles(n).name;
        validFileidx = validFileidx + 1;
    end
end


% resort filenames
numVec              = regexprep(fileNames,'SampLib_BuK_','');
numVec              = str2double(regexprep(numVec,'.wav',''));


[s,i]               = sort(numVec);
fileNames           = fileNames(i);

% get number of files
nFiles   = length(fileNames);

% create file list
if strcmp(filesToDo,'All')==1
    filesToDo = 1:nFiles;
else
    filesToDo =  find(ismember(fileNames,filesToDo));
end


%%



        
plot_control_trajectories('TwoNote_BuK_22', paths);


%%
        
plot_sinusoid_trajectories('TwoNote_BuK_22', partIDX, paths);


%% plot mod

close all

figure 
plot(MOD.SUS.P_1.AMP.xval,MOD.SUS.P_1.AMP.dist)
hold on
plot(MOD.SUS.P_2.AMP.xval,MOD.SUS.P_2.AMP.dist,'r')
plot(MOD.SUS.P_3.AMP.xval,MOD.SUS.P_3.AMP.dist,'g')
plot(MOD.SUS.P_4.AMP.xval,MOD.SUS.P_4.AMP.dist,'m')
plot(MOD.SUS.P_5.AMP.xval,MOD.SUS.P_5.AMP.dist,'y')
plot(MOD.SUS.P_6.AMP.xval,MOD.SUS.P_6.AMP.dist,'k')
plot(MOD.SUS.P_7.AMP.xval,MOD.SUS.P_7.AMP.dist,'c')

xlabel('a_i')
ylabel('CDF')
print( '-djpeg', 'stat-1')





figure 
 
% plot(MOD.SUS.P_6.FRE.xval,MOD.SUS.P_6.FRE.dist,'k')
plot(MOD.SUS.P_7.FRE.xval,MOD.SUS.P_7.FRE.dist,'c')

xlabel('f_i')
ylabel('CDF')
print( '-djpeg', 'stat-3')





