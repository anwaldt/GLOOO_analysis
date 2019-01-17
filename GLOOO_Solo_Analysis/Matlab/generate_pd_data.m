

clearvars
close all

load('/home/anwaldt/WORK/GLOOO/Violin_Library_2015/Analysis/TwoNote_ BuK_ yin/Features/TwoNote_BuK_22.mat')


p_start = 150;
p_end   = 200;

rms = smooth(CTL.rmsVec(p_start:end-p_end),300).^1;

plot(rms)
fid = fopen('TwoNote_BuK_22_rms','w');
fprintf(fid, '%f;\n',rms);

p_start = 250;
p_end   = 200;

f0 = CTL.f0.swipe.f0(p_start:end-p_end);
figure, plot(f0)

fid = fopen('TwoNote_BuK_22_f0','w');
fprintf(fid, '%f;\n',f0);

