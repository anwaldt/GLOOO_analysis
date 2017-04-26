function [] = plot_sinusoid_trajectories(baseName, partIDX ,paths)


load([paths.sinusoids baseName '.mat'])



%%

figure
%subplot(3,1,1)
plot(SMS.AMP(partIDX,:)')
xlabel('t[frame]')
ylabel('a_i(t)')
print( '-djpeg', [baseName '_a' ])

figure
%subplot(3,1,2)
plot(SMS.FRE(partIDX,:)')
xlabel('t[frame]')
ylabel('f_i(t)')
print( '-djpeg', [baseName '_f' ])


figure
%subplot(3,1,2)
plot(unwrap(SMS.PHA(partIDX,:)'))
xlabel('t[frame]')
ylabel('f_i(t)')
print( '-djpeg', [baseName '_p' ])

%%
figure
%subplot(3,1,2)
plot(diff(unwrap(SMS.PHA(1,:))))
xlabel('t[frame]')
ylabel('f_i(t)')
print( '-djpeg', [baseName '_pd' ])