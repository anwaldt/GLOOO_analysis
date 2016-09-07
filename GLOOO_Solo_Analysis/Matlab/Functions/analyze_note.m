%% function [noteModel] = analyze_note( features,param, noteModel.noteModel.start,noteModel.stop )
%
% Analyzes the f0-trajectory 'foVec' between the boundaries
% 'noteModel.start' and 'noteModel.stop' [in samples].
%
% Henrik von Coler
% 2014-02-17

function [noteModel] = analyze_note(noteModel, CTL, param, paths )


% select the f0-trajectory
switch param.F0.f0Mode
    case 'swipe'
        f0vec = CTL.f0swipe;
    case 'yin'
        f0vec = CTL.f0yin;
        
end


% get frame positions of features as indices:
featStartInd = round(noteModel.startSEC /(param.lHop/param.fs));
featStopInd  = min(length(f0vec),     round(noteModel.stopSEC  /(param.lHop/param.fs)));

noteModel.startIND = featStartInd;
noteModel.stopIND  = featStopInd;


%% F0

f0seg                   = f0vec(featStartInd:featStopInd);

% intercept formant/octave errors
f0segPOST   = soma_filter(f0seg)+f0seg(1);
f0clean     = remove_octave_errors(f0seg);


[tmpF0, f0_cor, f0_mod] = decompose_trajectory(f0segPOST, param);




noteModel.F0.trajectory = f0seg;

noteModel.F0.vibTrajectory        = f0_mod;

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


% model the clean trajectory with a 4th order polynominal
[P, S]                  = polyfit((1:length(f0_cor))',f0_cor,3);
F                       = polyval(P,(1:length(f0_cor))');
noteModel.F0.polynom    = P;

% for debugging, maybe
% plot(f0segSmooth),hold on, plot(F,'r'),ylim([0 2000]), hold off

%noteModel.F0.AC    =  1200*log2((f0_mod+noteModel.F0.median) ./f0seg );

%% model vibrato

if strcmp(noteModel.vibrato,'true') == 1
    
    % the frequency (considered fixed at this stage)
    modFFT          = abs(fft(f0_mod));
    modFFT          = modFFT(1:round(length(f0_mod)/2));
    % get rough position
    [~,modPeak]     = max(modFFT);
    % refine position
    [truePeakVal, truePeakPos]  =  get_peak_hight(modFFT,modPeak);
    noteModel.F0.fVib = (truePeakPos/length(f0seg))*(  param.fs/param.lHop);
    
    
    % the amplitude (considered varying/envelope)
    y = hilbert(f0_mod);
    env = smooth(abs(y),50);
    noteModel.F0.vibStrength    = env;
    
    [P, S]                  = polyfit((1:length(f0_cor))',env,3);
    F                       = polyval(P,(1:length(env))');
    noteModel.F0.polynom    = P;
    
    
    
end

%% RMS and co

noteModel.AMP.trajectory    = CTL.rmsVec(featStartInd:featStopInd);

noteModel.AMP.median        = median(CTL.rmsVec(featStartInd:featStopInd));



%% MIDI

noteModel.MIDI.nn       = round(12*log2(noteModel.F0.median/440) +69);

noteModel.MIDI.vel      = 64;

noteModel.param = param;


%% PLOT?

if param.plotit == true
    
    figure
    subplot(2,1,1)
    plot(f0_mod)
    hold on
    plot(env,'r','LineWidth',2)
    plot(F,'g')
    hold off
    ylabel('F0')
    legend({'trajectory','envelope','polynom'})
    text(10,-1,['vib-freq= ' num2str( noteModel.F0.fVib) ' Hz'])
    suptitle(['Note Trajectory Modeling: Vibrato = ' noteModel.vibrato]);
 
    subplot(2,1,2)
    plot(noteModel.AMP.trajectory)
    ylabel('RMS')
    
    print([paths.plot 'vib_trajectory_1.pdf'],'-dpdf');
end

end

