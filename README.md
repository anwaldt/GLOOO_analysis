-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
HvC
2016-09-30
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

# The Project constists of 4 'Sub-Projects'

	1. Sample Preparation
	2. Solo Analysis
	3. Render Solo
	4. IFFT Synthesis

For working with it, the Project 'Violin_Library_2015' has 
to be cloned into the same base-directory, alongside with 
the respective WAV-folder from the server.

# Folder/Project Descriptions:


## `GLOOO_Sample_Preparation`
 
This part is now obsolete -
`GLOOO_Solo_Analysis` does this, too!

Sub-Project to calculate the partial trajectories for the
single-sound sample library for a later use in the synthesis
engine.


 
## `GLOOO_Solo_Analysis`


Sub-Project to calculate and model the control- and partial trajectories 
for the two-note library. This also includes a segment-wise analysis.

It contains three folders:

	`BASH/`	
	`Matlab/`
	`Results/`

Once a complete analyis is performed, a subdir is created in Results,
containing the following folders:

	Features/	The control trajectories as .mat files  
	Plots/  	pdf-plots of segments, should not be used in BATCH mode
	Residual/  	Wav files containing the residual signal
	Segments/  	The single segment properties as .mat files 
	Sinusoids/  	The sinusoidal data as .mat files  
	Tonal/		Wav files containing the tonal signal


## IFFT_Synthesis
 
This sub-project generates the main-lobe kernels for the IFFT synthesis,
which are needed in the 'GLOOO_Render_Solo', if set to IFFT-mode.


 
## `GLOOO_Render_Solo`
 

Sub-Project for rendering a solo, based on the analysis results of 
`GLOOO_Solo_Analysis`.



 ## `MATLAB`
 
Scripts shared by the sub-projects.

# Contributions

- Henrik von Coler
- Moritz Götz


