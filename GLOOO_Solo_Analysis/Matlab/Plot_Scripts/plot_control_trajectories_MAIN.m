



p=genpath('../../../MATLAB/');
addpath(p)

%%

fileName = '/mnt/DATA/USERS/HvC/GLOOO/Violin_Library_2015/Analysis/SingleSounds_ BuK_ yin_2019-06-24/Features/SampLib_BuK_01.mat';

load(fileName);

 
%%

close all

 

 
    xxx =plot( (CTL.rmsVec(100:1:end-100)),'k');
    
 
    set(xxx,{'linew'},{1.0} )
 


xlabel('$Frame $');
ylabel('RMS')


  

axoptions={'scaled y ticks = false',...
    'y tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=2}'};

 
%  matlab2tikz(['rms_22_SYN.tex'],'width','0.9\textwidth','height','0.5\textheight', ...
%      'tikzFileComment','created from: plot_partial_trajectories_MAIN.m ', ...
%      'parseStrings',false,'extraAxisOptions',axoptions);

%%

close all

 
    xxx =semilogy( (CTL.f0.yin.f0(245:1:end-200)),'k');
    
 
    
    set(xxx,{'linew'},{1.0} )
    
 


xlabel('$Frame $');
ylabel('$f_0$')

 

axoptions={'scaled y ticks = false',...
    'y tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=2}'};

%  
%  matlab2tikz(['f0_22_SYN.tex'],'width','0.9\textwidth','height','0.5\textheight', ...
%      'tikzFileComment','created from: plot_partial_trajectories_MAIN.m ', ...
%      'parseStrings',false,'extraAxisOptions',axoptions);

 