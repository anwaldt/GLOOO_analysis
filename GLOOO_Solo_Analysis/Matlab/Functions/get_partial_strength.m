function [strength] = get_partial_strength(param, lastPartAmp, lastPartFre, lastPartPha, AMPL, FREQ, PHA)

dt = param.lHop / param.fs;

if lastPartFre~=0
    
    estPhas = lastPartPha + 2*pi*lastPartFre* dt;
    strength=abs(PHA-estPhas);
    
else
    
    strength= 0;
    
end





