%% call_swipe.m
%
% Wrapper for calling the Swipe function
%
% Author: Henrik von Coler
%
% Date: 2011-10-12
%
%% get f0-trajectory

function [p] = call_swipe(filePath);

 

% read file
[x,fs] = audioread(filePath);

% get name of file
[~,fileName,~] = fileparts(filePath);

% make it mono ?
if size(x,2) >1
    
    x = 0.5*(x(:,1)+x(:,2));

end

% make it short
%sx=x(1:10*fs);

%%

% Swipe Arguments
overlap = 0;     % overlap of the windows
hopsize = 0.01; % length of analysis window in seconds 

% call swipe
% (see swipep.m header for argument details)
[p,t,s] = swipep(x,fs,[30 6000],hopsize,[],1/20,overlap,0.1);

% delete NaNs
p(isnan(p)) = 0;

%% write trajectory for opening in SonicViualiser

% % output matrix (trajectory + time vector)
% outp=[(0:length(p)-1)'*hopsize ,p];
% 
% segmentFile = [fileName '_f0.txt'];
% 
% % write matrix
% dlmwrite(segmentFile,outp)
% 
% % plot
% plot(p)
% xlabel('Time (ms)')
% ylabel('Pitch (Hz)')

%%


 
