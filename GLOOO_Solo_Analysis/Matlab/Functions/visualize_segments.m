function [  ] = visualize_segments(baseName, paths, noteINDS, transINDS)

   load([paths.notes  (baseName)],'noteModels');
    
    load([paths.transitions  (baseName)],'transModels')

f0true  = [];
f0DC    = [];
f0part  = [];
f0comp  = [];

a       = [];

%% the notes
for noteCNT = noteINDS
    
    idxs = noteModels(noteCNT).startInd : noteModels(noteCNT).stopInd ;
    
    f0DC(idxs)      = noteModels(noteCNT).F0.median;
    
    f0true(idxs)    = noteModels(noteCNT).F0.trajectory;
    
    f0part(idxs)    = noteModels(noteCNT).F0.median + noteModels(noteCNT).F0.VIB;
    
    f0comp(idxs)    = noteModels(noteCNT).F0.median + noteModels(noteCNT).F0.AC;
    
    a(idxs)         = noteModels(noteCNT).Amp.trajectory;
    
end

%% the transitions

for transCNT = transINDS
    
    idxs            = transModels(transCNT).startInd : transModels(transCNT).stopInd;
    
    f0DC(idxs)      = transModels(transCNT).F0.trajectory;
    
    f0true(idxs)    = transModels(transCNT).F0.trajectory;
    
    f0part(idxs)    = transModels(transCNT).F0.trajectory;
    
    f0comp(idxs)    = transModels(transCNT).F0.trajectory;
    
    a(idxs)         =transModels(transCNT).Amp.trajectory;
    
end


%% PLOT

figure

plot(f0true);
subplot(2,1,1);
hold on
plot(f0DC,'g');
plot(f0part,'r')
% plot(f0comp,'m')
legend({'measured f0'
    'f0 DC'
    'f0 DC + VIB'
    'f0 DC+AC'})



subplot(2,1,2);
plot(a);
title('Amplitude');



end

