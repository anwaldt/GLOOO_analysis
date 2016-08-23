%% function [noteModel] = analyze_note( features,param, noteModel.noteModel.start,noteModel.stop )
%
% Analyzes the f0-trajectory 'foVec' between the boundaries
% 'noteModel.start' and 'noteModel.stop' [in samples].
%
% Henrik von Coler
% 2014-02-17

function [noteModel] = analyze_note(noteModel, features, param )


% select the f0-trajectory
switch param.F0.f0Mode
    case 'swipe'
        f0vec = features.f0swipe;
    case 'yin'        
        f0vec = features.f0yin;
 
end
 

% get frame positions of features as indices:
featStartInd = round(noteModel.start /(param.lHop/param.fs));
featStopInd  = min(length(f0vec),     round(noteModel.stop  /(param.lHop/param.fs)));


%% F0

f0seg = f0vec(featStartInd:featStopInd);

[tmpF0, f0_cor, f0_mod] = decompose_trajectory(f0seg, param);


% intercept formant/octave errors
% f0segPOST = soma_filter(f0seg);
% f0clean = remove_octave_errors(f0seg);

noteModel.F0.trajectory = f0seg;

noteModel.F0.VIB        = f0_mod;

% xVal = linspace(min(f0seg),max(f0seg),round(length(f0seg)/5));
% try
%     [h,x] = hist(f0seg,xVal);
% catch
%     disp('ERROR in "analyze_note" !');
% end

% upsampling
% f0segUP             = upfirdn(f0seg,4);

noteModel.F0.median = median(f0seg);
noteModel.F0.mean   = mean(f0seg);

f0segSmooth         = smooth(f0seg-noteModel.F0.median,10);
f0segMod            = f0segSmooth-smooth(f0segSmooth,300);

f0segCorr           = f0segSmooth-f0segMod;

% model the clean trajectory with a 4th order polynominal
P                       = polyfit((1:length(f0segCorr))',f0segCorr,4);
F                       = polyval(P,(1:length(f0segCorr))');
noteModel.F0.polynom    = P;

% for debugging, maybe
% plot(f0segSmooth),hold on, plot(F,'r'),ylim([0 2000]), hold off

noteModel.F0.AC    =  1200*log2((f0segMod+noteModel.F0.median) ./f0seg );

modFFT          = abs(fft(f0segMod));
modFFT          = modFFT(1:round(length(f0seg)/2));

[~,modPeak]     = max(modFFT);

noteModel.F0.fVib = (modPeak/length(f0seg))*(  param.fs/param.lHop);

%% RMS and co

noteModel.AMP.trajectory    = features.rmsVec(featStartInd:featStopInd);

noteModel.AMP.median        = median(features.rmsVec(featStartInd:featStopInd));

noteModel.startIND = featStartInd;
noteModel.stopIND  = featStopInd;

noteModel.MIDI.nn       = round(12*log2(noteModel.F0.median/440) +69);

noteModel.MIDI.vel      = 64;

noteModel.param = param;

end

