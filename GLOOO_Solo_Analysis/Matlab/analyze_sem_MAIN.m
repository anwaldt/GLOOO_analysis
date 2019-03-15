

clearvars

p = genpath('../../MATLAB/');
addpath(p)


%%

path  =  '/home/anwaldt/WORK/GLOOO/GLOOO_synth/Recordings/FreqSweeps';

files = dir(path);

for i=1:length(files)
    
    if  files(i).isdir~=1
        
        inFile  = [files(i).folder '/'  files(i).name];
        
        [~,baseName,~] = fileparts(files(i).name);
        
        outFile = [baseName '.tex'];
        
        analyze_sem_Single
        
    end
    
end
 