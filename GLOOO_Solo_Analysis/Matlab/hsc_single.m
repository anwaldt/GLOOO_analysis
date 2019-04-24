

[x,fs] = audioread(inFile);


%%


offEnd      = 100;

L           = length(x);

yy          = linspace(0,10000,length(x));


[f0Vec,t,s] = swipep(x(:,1), fs, [100 4000]);

f0          = median(f0Vec);
fVEC        = (1:50)*f0;


for bandCNT = 1:size(x,2)
    
    x(:,bandCNT) = smooth(abs(x(:,bandCNT)),1000);
    
end






%%

HSC = [];

 
for indCNT=2000:L/50:L
  
    spec    = x(indCNT, 1:50) ;


    hsc     = sum((1:length(spec)).*spec) / sum(spec);

    

    HSC     = [HSC, hsc];
    
end


 