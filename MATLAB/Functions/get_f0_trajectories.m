%% [f0] = get_f0_trajectories(x,pFeatEx,outLength,algo)
%
%   From the master thesis - adjusted!
%
%   Henrik von Coler
%   2015-01-20


function [f0,t,s] = get_f0_trajectories(x, fs, lHop, lWinF0, minF0, maxF0, algo)


if strcmpi(algo,'swipe')==1
    
    % parameters
    hopsize = lHop/fs;
    overlap = lHop/lWinF0;
    
    % call
    [f0,t,s] = swipep(x, fs, [minF0 maxF0], hopsize,[],1/20,overlap,0.2);
    
    % delete nans
    f0(isnan(f0))=0;
    
%     % match length
%     if length(f0)<outLength        
%         f0 = [f0;zeros(outLength-length(f0),1)];
%     end
%     if length(f0)>outLength
%         f0=f0(1:outLength);
%     end
%     
%     
elseif strcmpi(algo,'yin')==1
    
    % parameters
    P.hop = lHop;   
    P.sr  = fs;
    
    % call
    YIN = yin(x,P);
    f0  = YIN.f0';
   
    % delete nans
    f0(isnan(f0))=0;
    
    % match length
%     if length(f0)<outLength        
%         f0 = [f0;zeros(outLength-length(f0),1)];
%     end
%     if length(f0)>outLength
%         f0=f0(1:outLength);
%     end
    
end