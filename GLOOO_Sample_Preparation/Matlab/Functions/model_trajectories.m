function [SMS] = model_trajectories(inFile, paths)


%% load partial data

inName     = [paths.matDir inFile];
load(inName);

%%%

relFreq = partials.FRE ./ repmat(partials.FRE(1,:), size(partials.FRE,1) ,1);

partials.FREQ
