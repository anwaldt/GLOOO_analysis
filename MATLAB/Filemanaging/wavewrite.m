function wavewrite(file,data,fs,nbits)
% wavewrite(file,data,fs,nbits)
%
% writes a data block to a wave file
% the number of data channels (number of columns) must not change between calls to wavewrite. 
% The wave file will be closed if an empty file name or an empty data array is provided.
% needs getWaveDataOffset.m

% Author: Harald Mundt, FhG IIS.
if nargin<4|isempty(nbits)
   nbits=16;
end
if nargin<2
   data=[];
   file='';
end
globalstr='global wavewrite_fid wavewrite_samples_clipped wavewrite_samples_written wavewrite_nbits';
eval(globalstr);
file=lower(file);
if ~isempty(wavewrite_fid) & (isempty(file)|isempty(data)) 
   % write data size into the file header
   headersize=getWaveDataOffset(wavewrite_fid);
   fseek(wavewrite_fid,0,'eof');
   datasize=ftell(wavewrite_fid)-headersize;
   fseek(wavewrite_fid,headersize-4,'bof');
   fwrite(wavewrite_fid,datasize,'int32');
   
   % and close the file
   disp(['Closing ',fopen(wavewrite_fid)])
   fclose(wavewrite_fid);
   if wavewrite_samples_clipped
   	clipping_rate=wavewrite_samples_clipped*100/wavewrite_samples_written;
      disp(sprintf('Warning: data clipped for %d %% of the written samples',round(clipping_rate)))
	end
   eval(['clear ',globalstr])
	return
elseif ~isempty(data) & isempty(findstr(lower(fopen(wavewrite_fid)),file)) % file not open
   % write first data block 
   disp(['Open ',file])
	wavwrite(data,fs,nbits,file);
   % re-open the wave file for reading and writing 
   % and go to the beginning of data
   wavewrite_fid=fopen(file,'r+b');
   fseek(wavewrite_fid,0,'eof');
	wavewrite_samples_written=0;
   wavewrite_samples_clipped=0;
   wavewrite_nbits=nbits; 
   return
end
% write data to the file
if ~isempty(data)
   scale=2^(wavewrite_nbits-1);
   data=round(data.'*(scale-1));
   data_scaled=max(min(data,scale-1),-scale);
   count=fwrite(wavewrite_fid,data_scaled(:),sprintf('int%d',wavewrite_nbits));
   wavewrite_samples_clipped=wavewrite_samples_clipped+length(find(data(:)~=data_scaled(:)));
   wavewrite_samples_written=wavewrite_samples_written+length(data_scaled(:));
end
