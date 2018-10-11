%
%
% HvC
% 2017-07-06

function [] = check_paths(paths)

fn      = fieldnames(paths);
nFields = length(fn);

for fieldCNT = 1:nFields
    
    tmpDir = eval(['paths.' fn{fieldCNT}]);
    
    if isdir(tmpDir) == 0
        
        try
            mkdir(tmpDir);
        catch
            warning(['Could not create ''' tmpDir '''!'])
        end
        
        
    end
    
end