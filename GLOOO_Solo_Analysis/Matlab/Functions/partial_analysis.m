%% basic_analysis().m
%
% Get control trajectories, features and sinusoidal trajectories
%
% Henrik von Coler
%
% Created : 2016-09-28
%
%%

function [SMS] = partial_analysis(baseName, paths)



%% load control trajectories

load([paths.features baseName])

param = CTL.param;

partialName = [paths.sinusoids baseName '.mat'];

if 1%exist(partialName,'file') == 0
    
    
    %% READ WAV
    
    audioPath = [paths.wavPrepared baseName '.wav'];
    
    try
        [x,fs]      = audioread(audioPath);
    catch
        [x,fs]      = wavread(audioPath);
    end
    
    
    %% CALL the Partial Analysis
    
    
    
    % only calculate, if not existent
    %
    psVec = (smooth(CTL.pitchStrenght,100));
    
    [f0vec, SMS, noiseFrames, residual, tonal]  = get_partial_trajectories(x, param, CTL.f0swipe, psVec);
    
    
    SMS.param = param;
    
    save(partialName, 'SMS');
    
    %% export wav
    
    % get matlab version
    v = version;
    % as cell array
    V = strsplit(v,'.');
    
    % use wavread or audioread, depending on version
    if str2double(V{1}) < 9
        wavwrite(tonal,    param.fs, [paths.tonal    baseName '.wav']);
        wavwrite(residual, param.fs, [paths.residual baseName '.wav']);
        wavwrite(residual, param.fs, [paths.complete baseName '.wav']);
    else
        audiowrite([paths.tonal    baseName '.wav'],tonal,    param.fs );
        audiowrite([paths.residual baseName '.wav'], residual, param.fs);
        audiowrite([paths.complete baseName '.wav'], residual, param.fs );
    end
    
    
    
    
    %% export text
    
    
    
    tmpName     =[ paths.txtDir baseName '.F0'];
    fid         = fopen(tmpName,'w');
    fprintf(fid, '%e ;\n', f0vec );
    fclose(fid);
    
    tmpName     =[ paths.txtDir baseName '.AMPL'];
    fid         = fopen(tmpName,'w');
    fprintf(fid, [repmat('%e ', 1, size(SMS.AMP, 1) ), ';\n'], SMS.AMP );
    fclose(fid);
    
    tmpName     =[ paths.txtDir baseName '.FREQ'];
    fid         = fopen(tmpName,'w');
    fprintf(fid, [repmat('%e ', 1, size(SMS.FRE, 1) ), ';\n'], SMS.FRE );
    fclose(fid);
    
    tmpName     =[ paths.txtDir baseName '.PHA'];
    fid         = fopen(tmpName,'w');
    fprintf(fid, [repmat('%e ', 1, size(SMS.FRE, 1) ), ';\n'], SMS.PHA );
    fclose(fid);
    
    % noise is not exported at this state
    %     tmpName     =[ paths.txtDir baseName '.NENV'];
    %     fid         = fopen(tmpName,'w');
    %     fprintf(fid, [repmat('%e ', 1, length(SMS) ), ';\n'], meanNoise );
    %     fclose(fid);
    %
    %     tmpName     = [ paths.txtDir baseName '.NAMP'];
    %     fid         = fopen(tmpName,'w');
    %     fprintf(fid, '%e ;\n', noiseEnergy );
    %     fclose(fid);
    
    
else
    
    load(partialName)
    
end

end


