%% function [noteModel] = analyze_transition( features,param, start,stop )
%
% Analyzes the features between the boundaries
% 'start' and 'stop' [in samples].
%
% Henrik von Coler
% 2014-02-17

function [transModel] = analyze_transition(transModel, features,param )


% select the f0-trajectory
switch param.F0.f0Mode
    case 'swipe'
        f0vec = features.f0swipe;
    case 'yin'        
        f0vec = features.f0yin;
end

start = transModel.start;
stop  = transModel.stop;

% get related frame positions of features
featStartInd = round(start /(param.lHop/param.fs));
featStopInd  = min(length(f0vec),     round(stop  /(param.lHop/param.fs)));

 %% F0
 
f0seg                       = f0vec(featStartInd:featStopInd);
 
transModel.F0.trajectory = f0seg;

% xVal = linspace(min(f0seg),max(f0seg),round(length(f0seg)/5));
% [h,x] = hist(f0seg,xVal);


f0seg = upfirdn(f0seg,4);

transModel.F0.median = median(f0seg);
transModel.F0.mean   = mean(f0seg);

f0segSmooth  = smooth(f0seg,10);
 

%% RMS

AmpSeg = features.rmsVec(featStartInd:featStopInd);

transModel.AMP.trajectory = AmpSeg;

% model the amplitue trajectory with a 4th order polynominal
 
P = polyfit((1:length(AmpSeg))',AmpSeg,4);
F = polyval(P,(1:length(AmpSeg))');
 
% plot trajectory + polynominal?
% plot(AmpSeg),hold on, plot(F,'r'), hold off

transModel.AMP.polynom = P;

transModel.startIND = featStartInd;
transModel.stopIND  = featStopInd;

transModel.param = param;

end

