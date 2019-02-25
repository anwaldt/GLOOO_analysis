
%% RESET

close all
clearvars
restoredefaultpath

%%

modeling_segments_STARTUP


%%


param.bark.smooth = 200;


%%
inpath  = '/home/anwaldt/WORK/GLOOO/Violin_Library_2015/Analysis/SinusoidsTXT/';

outpath = '/home/anwaldt/WORK/GLOOO/Violin_Library_2015/Analysis/SinusoidsTXT_processed/';

if ~isdir(outpath)
    mkdir(outpath)
end

%%

directoryFiles  = dir(inpath);

validFileidx    = 1;

fileNames       = cell(1);

for n = 1:length(directoryFiles)
    [pathstr,name,ext] = fileparts(directoryFiles(n).name);
    if strcmp(ext,'.BBE')
        fileNames{validFileidx} = directoryFiles(n).name;
        validFileidx = validFileidx + 1;
    end
end



%% 



parfor (fileCNT = 1:336)
%for fileCNT = 1:336
    
    
    
    %%[~,baseName,~]      = fileparts(fileNames{fileCNT});
    
    trajectory_postprocessing([inpath fileNames{fileCNT}], [outpath fileNames{fileCNT}], param);    
    
    
end
