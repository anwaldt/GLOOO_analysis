function [  peakLocations] = get_relevant_peaks(YY,peakLocations,thresh)

nPeaks=length(peakLocations);

peakAccepted = zeros(size(peakLocations));

for peakCount = 1:nPeaks
    
    peakVal = YY(peakLocations(peakCount));
    
    % find next lower min
    i=peakLocations(peakCount)-1;
    while YY(i)<=YY(i+1)&&i>2
        i=i-1;
    end
    leftDipPos=i;
    leftDipVal=YY(i);
    % find next lower min
    i=peakLocations(peakCount)+1;
    while YY(i)<=YY(i-1)&&i<length(YY)-2
        i=i+1;
    end
    rightDipPos=i;
   rightDipVal=YY(i);
   
   shorterPath = min(peakVal-rightDipVal,peakVal-leftDipVal);

    
   
   if shorterPath>=thresh
      peakAccepted(peakCount)=1; 
   end
    
end

peakLocations(~peakAccepted)=[];