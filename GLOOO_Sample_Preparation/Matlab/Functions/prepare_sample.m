% for fileCnt = 1:nFiles
function  [x, tonal, noise] = prepare_sample(inFile, paths, param)



[x,fs] = audioread([paths.inDir inFile '.wav']);


[f0coarse, ~, ~]  = get_f0_trajectories(x, fs, param.lHop, 2*param.lHop, 30, 3000, 'swipe');

%
%     f0med             = median(f0coarse);
%
%     [f0fine, t, s]        =  get_f0_trajectories(x, fs, param.lHop, 2*param.lHop, f0med*(2^(4/-12)), f0med*(2^(4/+12)), 'swipe');


%% CALL the main partial analysis
[f0vec, partials, noiseFrames, noise, tonal]  =  ...
    get_partial_trajectories(x, param, f0coarse);


% using the average spectral distribution+spectral energy results in
% a good estimation of the residual signal
meanNoise   = mean(noiseFrames,1);
noiseEnergy = mean(noiseFrames,2);


% segmentMarkers = intra_note_segmentation(inFile,p);


%% Model the trajectories

% close all
% [partMod] = model_partial_trajectories(partialAmp, partialFre);


%% this reassambles the noise from the average-representation and the
% energy
lOut        = length(x);
noiseSynth  = residual_synth_tester(noiseFrames, lOut, param);


%% Work on the residual

% using the average spectral distribution+spectral energy results in
% a good estimation of the residual signal
meanNoise   = mean(noiseFrames,1);
noiseEnergy = mean(noiseFrames,2);



%% save .MAT data

if param.writeMat == true
    
    outName     = [paths.matDir inFile];
    parfor_safer_2(outName,  ...
        param, f0vec, partials, meanNoise, noiseEnergy);
    
end

%% Export TXT files for other purposes
% current formating is compatible to the PD object 'qlist'


if param.writeTxt == true
    
    tmpName     =[ paths.txtDir inFile '.F0'];
    fid         = fopen(tmpName,'w');
    fprintf(fid, '%e ;\n', f0vec );
    fclose(fid);
    
    tmpName     =[ paths.txtDir inFile '.AMPL'];
    fid         = fopen(tmpName,'w');
    fprintf(fid, [repmat('%e ', 1, size(partials.AMPL, 1) ), ';\n'], partials.AMPL );
    fclose(fid);
    
    tmpName     =[ paths.txtDir inFile '.FREQ'];
    fid         = fopen(tmpName,'w');
    fprintf(fid, [repmat('%e ', 1, size(partials.FREQ, 1) ), ';\n'], partials.FREQ );
    fclose(fid);
    
    tmpName     =[ paths.txtDir inFile '.NENV'];
    fid         = fopen(tmpName,'w');
    fprintf(fid, [repmat('%e ', 1, length(meanNoise) ), ';\n'], meanNoise );
    fclose(fid);
    
    tmpName     = [ paths.txtDir inFile '.NAMP'];
    fid         = fopen(tmpName,'w');
    fprintf(fid, '%e ;\n', noiseEnergy );
    fclose(fid);
    
end


%% EXPORT wave files?

if param.writeWav == true
    
    % write audio for checking analysis results
    audiowrite([paths.resDir inFile '.wav'], noise,       param.fs)
    audiowrite([paths.tonDir inFile '.wav'], tonal,       param.fs)
    audiowrite([paths.comDir inFile '.wav'], tonal+noise, param.fs)
    
    
    % audiowrite('../Test_Audio/noise.wav',           noise,            param.fs)
    % audiowrite('../Test_Audio/noise_synth.wav',     noiseSynth,       param.fs)
    % audiowrite('../Test_Audio/tonal.wav',           tonal,            param.fs)
    % audiowrite('../Test_Audio/complete.wav',        tonal+noise,      param.fs)
    % audiowrite('../Test_Audio/complete_synth.wav',  tonal+noiseSynth, param.fs)
    % audiowrite('../Test_Audio/original.wav',        x,                param.fs)
    
end