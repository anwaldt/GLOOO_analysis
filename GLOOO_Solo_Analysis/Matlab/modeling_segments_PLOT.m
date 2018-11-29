%% Create the complete/partial decomposed trajectories

%% RESET

close all
clearvars
restoredefaultpath



p=genpath('../MATLAB/');
addpath(p)

%%
    
close all
% make it empty for plotting all notes
noteIndices = 1:2;

[f0] = create_control_trajectories(paths,param,1,noteIndices);

figure
set(gcf,'PaperPositionMode','auto')
set(gcf, 'PaperPosition', [0 0 5 5]);   % Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [5 5]);           % Set the paper to have width 5 and height 5.
plot(f0.dc,'linewidth',2);

ylim([100,180]);
xlabel('t / Frames');
ylabel('f /Hz');
print('-dpdf','-r0','f0_step')


figure
plot(smooth(f0.comp,4),'linewidth',2);
set(gcf,'PaperPositionMode','auto')
set(gcf, 'PaperPosition', [0 0 5 5]);   % Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [5 5]);           % Set the paper to have width 5 and height 5.xlabel('t / Frames');
xlabel('t / Frames');
ylabel('f /Hz');
print('-dpdf','-r0','f0_comp')



%% PLOT single notes
close all

noteInd = 10;
load([paths.notes fileNames{1}])

F = polyval(noteModel(noteInd).F0.polynom, 1:length(noteModel(noteInd).F0.trajectory));

FF = (noteModel(noteInd).F0.trajectory-noteModel(noteInd).F0.median)/noteModel(noteInd).F0.median;

figure
plot(smooth(FF,7),'linewidth',2), hold on
set(gcf,'PaperPositionMode','auto')
set(gcf, 'PaperPosition', [0 0 5 5]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [5 5]); %Set the paper to have width 5 and height 5.xlabel('t / Frames');
xlabel('t / Frames');
ylabel('f / f_{mean}');
print('-dpdf','-r0','note_1')

figure
set(gcf,'PaperPositionMode','auto')
set(gcf, 'PaperPosition', [0 0 5 5]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [5 5]); %Set the paper to have width 5 and height 5.xlabel('t / Frames');
plot(smooth(FF,7)-smooth(FF,30),'linewidth',2);
xlabel('t / Frames');
ylabel('f / f_{mean}');
print('-dpdf','-r0','note_2')



figure
plot(smooth(FF,30),'linewidth',2);
set(gcf,'PaperPositionMode','auto')
set(gcf, 'PaperPosition', [0 0 5 5]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [5 5]); %Set the paper to have width 5 and height 5.xlabel('t / Frames');
xlabel('t / Frames');
ylabel('f / f_{mean}');
print('-dpdf','-r0','note_3')


hold off
% ylim([0 500])0.5;


%% PLOT single transitions

transInd = 7;
load([paths.transitions fileNames{1}])

%F = polyval(transModel(noteInd).F0.polynom, 1:length(transModel(noteInd).F0.trajectory));
%plot(F), hold on
 plot(transModel(transInd).F0.trajectory,'r')
% hold off
% ylim([0 500]);

