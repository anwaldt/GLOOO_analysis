

%% SET PATHS

paths.inDir         = ['D:\Users\hvcoler_V2\Violin_Library_2015\WAV\SingleSounds\DPA\'];
paths.matDir        = [ rootDIR 'Sinusoidal_Data_MAT/Violin_2015/BuK/'];
paths.txtDir        = [ rootDIR 'Sinusoidal_Data_TXT/Violin_2015/BuK/'];
paths.resDir        = [ rootDIR 'Residual/Violin_2015/BuK/'];
paths.tonDir        = [ rootDIR 'Tonal/Violin_2015/BuK/'];
paths.comDir        = [ rootDIR 'Complete/Violin_2015/BuK/'];


paths.segDIR = '\\NAS-AK\Forschungsprojekte\Klanganalyse_und_Synthese\Violin_Library_2015\Segmentation\SingleSounds';


%% Check for existence of paths
%  and make them, if necessary

fn      = fieldnames(paths);
nFields = length(fn); 

for fieldCNT = 1:nFields
    
     tmpDir = eval(['paths.' fn{fieldCNT}]);
     
     if isdir(tmpDir) == 0
        mkdir(tmpDir);
     end
    
end
