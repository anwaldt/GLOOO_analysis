%% classdef sample_matrix.m
%
%   - A class for the sample space, using the 2015 violin library
%
%   TODO: check the matrix of names(it is prob. shifted)
%
% HvC
% 2016-02-09
%%

classdef sample_matrix
    
    
    properties
        
        fracVec_LF;
        fracVec;
        
        param;
        sampleDIR;
        sampleFiles;
        
        kernels;
        kernels_LF;
        
        velocityBounds =[1 ((1:4)*round(128/4) - 1)];%round(127/8);
        
        vels = {'p' 'mp'  'mf'  'f'};
        
        samples;
        
        OCTS = horzcat (ones(1,12), 2*ones(1,12), 3*ones(1,12), ...
            4*ones(1,12), 5*ones(1,12),6*ones(1,12),7*ones(1,12), ...
            8*ones(1,12),9*ones(1,12),10*ones(1,12),11*ones(1,12))-3;
        
        SAMPNAME    = cell(127,127);
        
        RESAMP      = ones(127,127);
        
    end
    
    methods
        
        function obj = sample_matrix(sD,paramSynth)
            
            % get parameters
            obj.sampleDIR = sD.SAMPLES;
            obj.param     = paramSynth;
            
            % Load kernel data
            load([sD.KERNELS 'kernel_data']);
            obj.kernels = kernels;
            obj.fracVec = fracVec;
            load([sD.KERNELS 'kernel_data_LF']);
            %                  = load([sD.KERNELS '']);
            obj.kernels_LF = kernels_LF;
            obj.fracVec_LF = fracVec_LF;
            
            % read sample names
            obj.sampleFiles = dir(obj.sampleDIR);
            obj.sampleFiles = obj.sampleFiles(3:end);
            nSamples        = length(obj.sampleFiles);
            
            sortStrings = zeros(nSamples,1);
            
            for i=1:nSamples
                
                % prepare the filename
                xxx = strsplit('_',obj.sampleFiles(i).name);
                obj.samples(i).name = regexprep(obj.sampleFiles(i).name,'.wav','');
                
                sortStrings(i) = str2double(regexprep(xxx{3},'.wav',''));
                
            end
            
            % SORT THEM
            [~,ind ] = sort(sortStrings);
            obj.samples = obj.samples(ind) ;
            
            % initialize the input value matrix with all
            % directly matching samples
            
            lastTmpFile = [];
            %lowest      = -1;
            %
            
            fileCNT = 1;
            
            fid = fopen('tester.txt','w');
            
            
            fprintf(fid,['note \t pp \t\t mp \t\t mf \t\t ff \n'] );
            
            for nnCNT = 44:127        % count up note number
                
                fprintf(fid,num2str(nnCNT));
                fprintf(fid,'\t');
                
                
                
                for velCNT = 1:4   % count up velocity
                    
                    tmpFile = obj.samples(fileCNT).name;
                    
                    fprintf(fid,tmpFile);
                    fprintf(fid,'\t');
                    
                    
                    
                    for        ttCNT = obj.velocityBounds(velCNT):obj.velocityBounds(velCNT+1)
                        obj.SAMPNAME{nnCNT, ttCNT} = tmpFile;
                    end
                    
                    %                     end
                    fileCNT = fileCNT+1;
                end
                
                fprintf(fid,'\n');
            end
            
            fclose(fid);
          
            for i=1:43
                obj.SAMPNAME(i, :) =  obj.SAMPNAME(44, :);
            end
            
            
        end
        
        function [st, resamp] = pick_sample(obj,nn,vel)
            
            vel = min(vel,127);
            
            try
                picked = obj.SAMPNAME{nn,vel};
            catch
                error('Problem picking the right sample!');
            end
            
            
            st       = picked;
            resamp = 1;
            
        end
        
    end
    
end
