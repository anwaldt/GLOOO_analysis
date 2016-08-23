% model_partial_trajectories.m
%
% Function for extracting some values from the patial trajectories!
% The basic idea is to decompose the trajectories into a deterministic
% part (mean freq. and amplitude) and stochastic deviations!
% Also, attack and release have to be captured!
%
% HVC
% 2015-07-26


function [partMod] = model_partial_trajectories(A, F)

nPartials = size(A,1);
nFrames   = size(A,2);

partMod.mean    = mean(A');

partMod.median  = median(A');



meanA = repmat(ones(nPartials,1).*partMod.mean',1,nFrames);
medA = repmat(ones(nPartials,1).*partMod.median',1,nFrames);


% just a trial for one partial
tmpTraj = A(1,:);

difTraj = diff(tmpTraj);

smoothDiff = smooth(difTraj,70);

filtTraj = cumtrapz(smoothDiff)';


plot(tmpTraj);
hold on
plot(filtTraj,'r');
hold off
legend({'partial amplitude 1','smoothed'});


deviationTraj = (tmpTraj(2:end)-filtTraj);
deviationTraj = deviationTraj-mean(deviationTraj);

figure
plot((deviationTraj));
hold on
plot(xcorr(deviationTraj),'r');

figure
plot(abs(fft((deviationTraj))));
title('deviation')

figure
[n,x] = hist(deviationTraj,100);
plot(x,smooth(n,5));

% figure
% plot(A');
% hold on
% plot(meanA','LineStyle','--');
% plot(medA','LineStyle','-.');
% hold off
% 
% figure
% plot(diff(smooth(A(1,:),10)));