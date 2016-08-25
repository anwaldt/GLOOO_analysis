%% create_control_trajectories().m
%
%
%
%
%
% Henrik von Coler
% Created: 2014-11-28


function [C] = create_control_trajectories(thisName, paths, expMod)


thisName = regexprep(thisName,'DPA','BuK');


%% load the data
%load([paths.NOTES regexprep(thisName,'.txt','.mat')]);
%load([paths.TRANS regexprep(thisName,'.txt','.mat')]);

load([paths.segments regexprep(thisName,'.txt','.mat')]);

nSegments = length(SEG);
% 
% nNotes      = length(noteModels);
% noteIndices =  1:nNotes;


% Depending on the MODE of the expression model,
% the control trajectories are composed, differently:
switch expMod.transMODE
    
    %% just copy the original trajectories
    case 'original'
        
        % F0
        
        C.f0.dc     = [];
        C.f0.comp   = [];
        C.a.dc      = [];
        C.a.comp    = [];
        
        for segCNT = 1:nSegments
            
            tmpSEG = SEG{segCNT};
            
            % switch segment types

            %switch class(tmpSEG);
                       
            %C.f0.dc(tmpSEG.startInd:tmpSEG.stopInd)   = tmpSEG.F0.median;
            
            C.f0.comp(tmpSEG.startIND:tmpSEG.stopIND) = tmpSEG.F0.trajectory;
            
            C.a.comp(tmpSEG.startIND:tmpSEG.stopIND) = tmpSEG.AMP.trajectory;
            
            
            
            
        end
        
%         C.f0.dc(1:noteModels(noteIndices(1)).startInd)    = [];
%         C.f0.comp(1:noteModels(noteIndices(1)).startInd)  = [];
        
end






