
load('/home/anwaldt/Desktop/Synth_Results/Analysis/Sinusoids/GLOOO_vibrato-output.mat');


figure
hold on
for partCNT=1:30
    plot(SMS.FRE(partCNT,100:end-100),SMS.AMP(partCNT,100:end-100));
end