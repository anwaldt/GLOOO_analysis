function [] = plot_sinusoid_trajectories(baseName, partIDX ,paths)


load([paths.sinusoids baseName '.mat'])

%%

figure

subplot(3,1,1)
plot(SMS.AMP(partIDX,:)')


subplot(3,1,2)
plot(SMS.FRE(partIDX,:)')