function [ allNames ] = get_filenames( DIR , relevantString, showOutput )

if nargin<3
    showOutput='silent';
end

% get all segmentation file names
p = cd(DIR);
allNames=dir;
cd(p);

% take only relevants
allNames = {allNames.name};
namePos  = strfind(allNames,relevantString);
allNames((cellfun('isempty',namePos))) = [];

% print all Names for
if strcmpi(showOutput, 'printNames')
    allNames(:)
end

end

