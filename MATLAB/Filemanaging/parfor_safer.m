%% function parfor_safer( fname, x )
%
%  very simple function for storing mat-Files
%  (since parfor wont allow it)
%
%  Henrik von Coler
%  2013-07-14

function parfor_safer( fname, x, dataName )
 
  eval([dataName '=x;'])

  save( fname, dataName);
  
end