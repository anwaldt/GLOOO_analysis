function [out,eof,fs,channels,samples]=waveread(file,blocklen)
% [out,eof,fs,channels,samples]=waveread(file,blocklen)
% 
% reads blocks of data from a wave file
%
% If blocklen is omitted the whole file is read
% If all samples have been read the file is closed automatically and the
% end-of-file flag (eof) is set to 1.
% The file will be closed by providing an empty character string as file
% name or if blocklen==0.
% needs getWaveDataOffset.m

% Author: Harald Mundt, FhG IIS.
globalstr='global waveread_fs waveread_fid waveread_channels waveread_samples waveread_samples_read waveread_scale waveread_prec';
eval(globalstr);
out=[];
eof=0;
channels=0;
samples=0;
fs=0;
file=lower(file);
if isempty(file)
   eof=wclose(globalstr);
   return;
elseif isempty(findstr(lower(fopen(waveread_fid)),file)) % file not open
   % try to open the file
   if exist(file)~=2 
      disp([file,' does not exist'])
      return;
   end
   waveread_fid=fopen(file,'rb');
   if waveread_fid==-1
      disp(['Could not open ',file])
      return;
   end
   disp(['Open ',file])
   [dataoffset,waveread_fs,waveread_channels,bitsPerSample,waveread_samples]=getWaveDataOffset(waveread_fid);
   waveread_samples_read=0;
   waveread_scale=2^(bitsPerSample-1);
   waveread_prec=sprintf('int%d',bitsPerSample);
end
if nargin<2|isempty(blocklen)
   blocklen=waveread_samples; % read until end of file
end

% local variables for output
fs=waveread_fs;
channels=waveread_channels;
samples=waveread_samples;


readlen=min(blocklen,waveread_samples-waveread_samples_read);
if readlen
	out=fread(waveread_fid,[waveread_channels,readlen],waveread_prec)'/waveread_scale;
   waveread_samples_read=waveread_samples_read+readlen;
end
if ~readlen | waveread_samples_read==waveread_samples
   eof=wclose(globalstr);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function eof=wclose(globalstr)
eof=0;
eval(globalstr);
if ~isempty(waveread_fid) && waveread_fid~=-1
   disp(['Closing ',fopen(waveread_fid)])
   fclose(waveread_fid);
   eval(['clear ',globalstr])
   eof=1;
end


