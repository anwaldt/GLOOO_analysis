function [] = plot_control_trajectories(baseName, paths)

load([paths.features baseName '.mat'])




figure

plot(CTL.f0swipe);
xlabel('t[frame]')
ylabel('f0')
print( '-djpeg', [baseName '_f0' ])


figure
plot(CTL.rmsVec);
xlabel('t[frame]')
ylabel('RMS')
print( '-djpeg', [baseName '_rms' ])


figure
plot(CTL.pitchStrenght);
xlabel('t[frame]')
ylabel('Pitch-Strength')
print( '-djpeg', [baseName '_ps' ])