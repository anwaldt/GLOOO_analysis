%% classdef sample_matrix.m
%
%     - A class for the sample space, using the 2012 violin library
%
%
% HvC
% 2014-04-22
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
        
        velocityBounds = (1:4)*round(127/4) - round(127/8);
        
        vels = {'p' 'mp'  'mf'  'f'};
        
        samples;
        
        id = {
            'C'
            'C#'
            'D'
            'D#'
            'E'
            'F'
            'F#'
            'G'
            'G#'
            'A'
            'A#'
            'B'};
        
        %         octaves = [
        %             0	1	2	3	4	5	6	7	8	9	10	11
        %             12	13	14	15	16	17	18	19	20	21	22	23
        %             24	25	26	27	28	29	30	31	32	33	34	35
        %             36	37	38	39	40	41	42	43	44	45	46	47
        %             48	49	50	51	52	53	54	55	56	57	58	59
        %             60	61	62	63	64	65	66	67	68	69	70	71
        %             72	73	74	75	76	77	78	79	80	81	82	83
        %             84	85	86	87	88	89	90	91	92	93	94	95
        %             96	97	98	99	100	101	102	103	104	105	106	107
        %             108	109	110	111	112	113	114	115	116	117	118	119
        %             120	121	122	123	124	125	126	127	-1  -1  -1  -1];
        
        OCTS = horzcat (ones(1,12), 2*ones(1,12), 3*ones(1,12), ...
            4*ones(1,12), 5*ones(1,12),6*ones(1,12),7*ones(1,12), ...
            8*ones(1,12),9*ones(1,12),10*ones(1,12),11*ones(1,12))-3;
        
        SAMPNAME = cell(127,127);
        
        RESAMP = ones(127,127);
    end
    
    methods
        
        function obj = sample_matrix(sD,paramSynth,paths)
            
            % map parameters
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
            nSamples = length(obj.sampleFiles);
            
            for i=1:nSamples
                
                % prepare the filename
                xxx = strsplit('_',obj.sampleFiles(i).name);
                obj.samples(i).name = regexprep(obj.sampleFiles(i).name,'.wav','');
                
                % read loop info for this sample
                [obj.samples(i).loopPoints, obj.samples(i).loopLabels] = ...
                    textread([paths.LOOP obj.samples(i).name '.txt'],'%f %s','delimiter',' ');
                
                % calculate frame number of loop points from time in
                % seconds
                obj.samples(i).loopPoints = round(obj.samples(i).loopPoints / (paramSynth.lHop/paramSynth.fs));
                
            end
            
            
            
            
            % initialize the input value matrix with all
            % directly matching samples
            
            lastTmpFile = [];
            %lowest      = -1;
            
            for nn=0:127        % count up note number
                for vel=1:127   % count up velocity
                    
                    % get velocity string
                    [ ~ ,velInd] = (min(abs(obj.velocityBounds-vel)));
                    velString = obj.vels{velInd};
                    
                    % get note string
                    noteStr   = obj.id{mod(nn,12)+1};
                    
                    % get octave string
                    octString = num2str(obj.OCTS(nn+1));
                    
                    % the complete filename
                    tmpFile = ['tuned_' velString '_' noteStr octString ];
                    
                    % chek if FILE  with this name  exists
                    ind = find(ismember({obj.samples.name},tmpFile), 1);
                    
                    % if it does:
                    if ~isempty(ind)
                        
                        % remember the lowest sample
                        if isempty(lastTmpFile)
                            lowest = tmpFile;
                        end
                        
                        % paste filename to matrix
                        obj.SAMPNAME{nn,vel} = tmpFile;
                        
                        % remember filename
                        lastTmpFile = tmpFile;
                        
                        % if it does not exist:  pick remembered name
                    else
                        %obj.SAMPNAME{nn,vel} = lastTmpFile;
                        obj.RESAMP(nn+1,vel)   = 1;
                    end
                end
            end
            
            % fill all low notes with the lowest sample
            for nn=60:127
                    if isempty((obj.SAMPNAME{nn,1})) && ~isempty((obj.SAMPNAME{nn-1,1}))
                        obj.SAMPNAME(nn,:) = obj.SAMPNAME(nn-1,:);
                    end
            end
            
            % fill all low notes with the lowest sample
            for nn=70:-1:1
                    if isempty((obj.SAMPNAME{nn,1})) && ~isempty((obj.SAMPNAME{nn+1,1}))
                        obj.SAMPNAME(nn,:) = obj.SAMPNAME(nn+1,:);
                    end
            end
            
            for vel=1:127
                for nn=2:127
                    if isempty((obj.SAMPNAME{nn,vel})) && ~isempty((obj.SAMPNAME{nn-1,vel}))
                        obj.SAMPNAME(nn,vel) = obj.SAMPNAME(nn-1,vel);
                    end
                end
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
