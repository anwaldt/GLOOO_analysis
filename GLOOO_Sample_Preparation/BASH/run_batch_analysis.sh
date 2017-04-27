#!/bin/sh 
eval cd ../Matlab/
nohup matlab -nosplash -nodisplay -r "prepare_samples_BATCH" > prepare.out &
