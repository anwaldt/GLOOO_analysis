#!/bin/sh 
eval cd ../Matlab/
nohup /usr/local/MATLAB-R2013a/bin/matlab -nosplash -nodisplay -r "modeling_segments_BATCH" > modeling.out &
