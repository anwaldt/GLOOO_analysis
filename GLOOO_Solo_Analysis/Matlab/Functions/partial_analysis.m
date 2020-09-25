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

tmpName = regexprep(regexprep(baseName, '_BuK', ''),  '_DPA', '');

load([paths.features tmpName])

param = CTL.param;

tmpName = regexprep(regexprep(baseName, '_BuK', ''),  '_DPA', '');


partialName = [paths.sinusoids tmpName '.mat'];

if  exist(partialName,'file') == 0
    
    
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
    psVec = (smooth(CTL.f0.swipe.strength,100));
    
    [f0vec, SMS, noiseFrames, residual, tonal]  = get_partial_trajectories(x, param, CTL);
    
    
    [BET]  = get_residual_trajectories(noiseFrames, param, CTL);
    
    
    SMS.BET = BET;
    
    SMS.param = param;
    
    save(partialName, 'SMS');
    
    %% export wav
    
    % only if selected
    if param.PART.getWav ==1        
        
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
     
    end
    
    %% export text
    
    
    
    outName     =[ paths.txtDir tmpName '.F0'];
    fid         = fopen(outName,'w');
    fprintf(fid, '%e ;\n', f0vec );
    fclose(fid);
    
    outName     =[ paths.txtDir tmpName '.AMPL'];
    fid         = fopen(outName,'w');
    fprintf(fid, [repmat('%e ', 1, size(SMS.AMP, 1) ), ';\n'], SMS.AMP );
    fclose(fid);
    
    outName     =[ paths.txtDir tmpName '.FREQ'];
    fid         = fopen(outName,'w');
    fprintf(fid, [repmat('%e ', 1, size(SMS.FRE, 1) ), ';\n'], SMS.FRE );
    fclose(fid);
    
    outName     =[ paths.txtDir tmpName '.PHA'];
    fid         = fopen(outName,'w');
    fprintf(fid, [repmat('%e ', 1, size(SMS.FRE, 1) ), ';\n'], SMS.PHA );
    fclose(fid);
    
    outName     =[ paths.txtDir tmpName '.BBE'];
    fid         = fopen(outName,'w');
    fprintf(fid, [repmat('%e ', 1, size(SMS.BET', 1) ), ';\n'], SMS.BET' );
    fclose(fid);
    
    
else
    
    load(partialName)
    
end

end


