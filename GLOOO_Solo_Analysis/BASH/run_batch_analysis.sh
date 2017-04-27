#!/bin/sh 
eval cd ../Matlab/
nohup matlab -nosplash -nodisplay -r "modeling_segments_BATCH" > modeling.out &
