%% function [noteModel] = analyze_transition( features,param, start,stop )
%
% Analyzes the features between the boundaries
% 'start' and 'stop' [in samples].
%
% Henrik von Coler
% 2014-02-17

function [transModel] = analyze_transition(transModel, CTL, SMS, INF, param )

if param.info == true
    disp('    analyze_transition(): Starting...');
end

% select the f0-trajectory
switch param.F0.f0Mode
    
    case 'swipe'
        f0vec = CTL.f0.swipe.f0;
        
    case 'yin'
        f0vec = CTL.f0.yin.f0;
    case 'eckf'
        f0vec = CTL.f0.eckf.f0;
        
end

start = transModel.startSEC;
stop  = transModel.stopSEC;

% get related frame positions of features
featStartInd = max(1,round(start /(param.lHop/param.fs)));

featStopInd  = min(length(CTL.rmsVec),     round(stop  /(param.lHop/param.fs)));

%% extract F0 properties

f0seg                       = f0vec(featStartInd:featStopInd);

transModel.F0.trajectory    = f0seg;

transModel.F0.strength      = CTL.f0.swipe.strength(featStartInd:featStopInd);

% xVal  = linspace(min(f0seg),max(f0seg),round(length(f0seg)/5));
% [h,x] = hist(f0seg,xVal);


% f0 Interpolation
transModel.F0.interpolation = interpolate_f0(f0seg, INF, param,false);

f0seg = upfirdn(f0seg,4);

transModel.F0.median = median(f0seg);
transModel.F0.mean   = mean(f0seg);

f0segSmooth  = smooth(f0seg,10);


%% extract RMS properties

try
    AmpSeg = CTL.rmsVec(featStartInd:featStopInd);
catch
    error('Possibly out of range!')
end

transModel.AMP.trajectory = AmpSeg;

% model the amplitue trajectory with a 4th order polynominal

P = polyfit((1:length(AmpSeg))',AmpSeg,4);
F = polyval(P,(1:length(AmpSeg))');

% plot trajectory + polynominal?
% plot(AmpSeg),hold on, plot(F,'r'), hold off

transModel.AMP.polynom = P;

% Interpolate the amplitude
transModel.AMP.interpolation = interpolate_amp(AmpSeg,param.AMP.numPoints,false);

transModel.startIND = featStartInd;
transModel.stopIND  = featStopInd;

transModel.param = param;


%% Grab transition partial

% take care not to get out of bounds:
featStopInd = min(featStopInd, size(SMS.FRE,2));

transModel.partials.FRE =  SMS.FRE(:,featStartInd:featStopInd);

transModel.partials.AMP =  SMS.AMP(:,featStartInd:featStopInd);

%% PLOT ?

if param.plotit == true
    CTL.pitchStrenght
    figure
    
    subplot(3,1,1)
    plot(transModel.F0.trajectory);
    % glissando should be focussed in y-axis
    if ~strcmp(transModel.type,'glissando')
        ylim([0, max(transModel.F0.trajectory)*1.2]);
    end
    ylabel('F0')
    
    subplot(3,1,2)
    hold on
    plot(transModel.F0.strength);
    ylim([0, 1]);
    ylabel('Pitch Strength (SWIPE)')
    line(xlim, 0.3*[ 1 1],'color','r');
    hold off
    
    subplot(3,1,3)
    plot(transModel.AMP.trajectory);
    % ylim([0, max(transModel.AMP.trajectory)*1.2]);
    ylabel('rms')
    
    title(['Transition Trajectory Modeling: ' transModel.type]);
    
end

end

