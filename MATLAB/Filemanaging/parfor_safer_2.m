%% function parfor_safer_2( fname, x )
%
%  extended function for storing mat-Files
%  (since parfor wont allow it)
%
%   - This version can handle multiple variables:
%     - the actual data comes in the struct
%
%  Henrik von Coler
%  2015-03-18

function parfor_safer_2( fname, varargin )

% check if file exists:
if exist([fname '.mat']) ~= 0
    % if it does, delete it!
    unix(['rm ' fname '.mat']);
end

nArgs = length(varargin);

for i=1 : nArgs
    
    % create variable from varargin input
    eval([ inputname(i+1) '=deal( varargin{i});'])
    
    
    if exist([fname '.mat']) == 0
        % create new file in the first loop-run
        save( fname, inputname(i+1));
    else
        % append, otherwise
        save( fname, inputname(i+1), '-append');
    end
    
end