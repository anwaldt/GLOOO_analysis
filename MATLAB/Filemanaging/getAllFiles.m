% function for returning all files in a path
% the return values can be determined using the
% "mode" argument:
% 
%  pure: only filenames (no extension, no path)
%  file: only filenames and extension
%  comp: complete (path, name, extension)

% modded by HVC 2011

function fileList2 = getAllFiles(dirName, extension, mode)

fileList2 = {};

  dirData = dir(dirName);      %# Get the data for the current directory
  dirIndex = [dirData.isdir];  %# Find the index for directories
  fileList = {dirData(~dirIndex).name}';  %'# Get a list of the files
  if ~isempty(fileList)
    fileList = cellfun(@(x) fullfile(dirName,x),...  %# Prepend path to files
                       fileList,'UniformOutput',false);
  end
  subDirs = {dirData(dirIndex).name};  %# Get a list of the subdirectories
  validIndex = ~ismember(subDirs,{'.','..'});  %# Find index of subdirectories
                                               %#   that are not '.' or '..'
  for iDir = find(validIndex)                  %# Loop over valid subdirectories
    nextDir = fullfile(dirName,subDirs{iDir});    %# Get the subdirectory path
 
 
        fileList = [fileList; getAllFiles(nextDir,extension, mode)];  %# Recursively call getAllFiles
      
  end

  
  for i = 1:length(fileList)
    
      
      tmpName = fileList{i};
      [pathstr, name, ext] = fileparts(tmpName);
     
     if regexp(tmpName,extension)~=0
     
         if strcmp(mode,'pure')
            fileList2 = [fileList2; name];
         elseif strcmp(mode,'comp')
            fileList2 = [fileList2; tmpName];
         elseif strcmp(mode,'file')
            fileList2 = [fileList2; [name ext]];
         end   
     end
     
     
  end
end
