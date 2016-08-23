%%  IFFT_Prepare_Kernels.m
%
%   Calculate spectral kernels for
%   the Blackman-Harris window and
%   and store them!
%
%   - This version also does FM kernels
%
%
%   Henrik von Coler
%   2015-02-12
%
%% Basic setup

close all
clearvars

restoredefaultpath
addpath Functions/

%% BASIC PARAMETERS

% this starts the animated plot, if set to '1'
plotit  = 1;

% sampling frequency
fs      = 44100;

% number of frames to synthesize
nFrames = 10;

% synthesis frame length
lWin    = 2^9;

% synthesis hop size
nHop    = lWin/4;

% hop size in seconds
hop_s   = (nHop/fs);

% time axis within one frame
t       = (0:lWin-1)/fs;

% delta frequency (bin distance)
df      =  fs/lWin;

%% Windows

close all

% upsample the Window for better interpolation
resFactor = 1;

% for time truncation

% win = hann(lWin);

win =  calculate_BH92_complete(lWin) ;

WIN =   real(fftshift(fft(win) ));

% WIN = 0.5*sinc(linspace(-lWin/2, lWin/2-1,lWin*resFactor))';
% win =  ( (ifft(WIN,'symmetric')));

% boxcar with FFT
% win = ones(lWin,1);
% WIN = fftshift(  fft(win));


figure
plot(real(WIN),'g')
hold
plot(imag(WIN),'r')
plot(abs(WIN),'b--')

% figure
% plot(win)
% shg

%% Control Parameters


F0      = linspace(40,41,nFrames);
s.a     = 1;
s.phi   = 0; 


%% SLOPE (FM) parameter

% maximum difference in frequency (measured at the frame boundaries)
maxOff      = 0.2;

% has to be odd, so that we capture 0-FM, too:
nSlopes     = 21;

% actually half a lobe width
lobeWidth = 6;

%% Framewise synthesis


 
fracVec     = zeros(1,nFrames);
kernels     = cell(nSlopes,nFrames);

slopeVec    = linspace( -maxOff, maxOff, nSlopes);


%% FOR DIFFERENT FREQUENCY SLOPES


if plotit==1
    figure('units','normalized','outerposition',[0 0 1 1])
end

for slopeCnt = 1:nSlopes
    
    
    fm = linspace(1-slopeVec(slopeCnt),1+slopeVec(slopeCnt),lWin);
    
    %% FOR DIFFERENT POSITIONS BETWEEN THE BINS
    for frameCnt=1:nFrames
        
        
        % partial frequency
        s.f0        = F0(frameCnt)*fm*df;
        
        tmpFrame    = sin(2*pi.*s.f0.*t +s.phi)'.*win;
        
        FRAME       = fft(tmpFrame);
        
        % THE complex SINE:
        compSine    =    exp(1i * s.phi);
        
        % 'floating point position' of this partial
        s.fracBin   = (F0(frameCnt)*df) / df;
        
        % HEURISTIC: The center bin needs to be corrected according
        %            to the frequency slope!
        
        % closest bin
        centerBin   = floor(s.fracBin)+1;
        
        % offset
        offset      = 1 + (s.fracBin-centerBin);
     
        
        % calculate center and boundaries of the shifted lobe
        if slopeVec(slopeCnt)~=0
            fracBin_shifted     =  s.fracBin + s.fracBin*slopeVec(slopeCnt);
            width_shifted       =  round(lobeWidth + 20* abs(slopeVec(slopeCnt)));
        else
            fracBin_shifted 	= 0;
            width_shifted       =  lobeWidth;
            
        end
        
        centerBin_shifted   = floor(fracBin_shifted)+1;
        
        tmpInds             =  centerBin_shifted-width_shifted:centerBin_shifted+width_shifted;
        
        if min(tmpInds) >0
            tmpKernel = FRAME(tmpInds);
        else
            tmpInds = tmpInds((tmpInds)>0);
            tmpKernel(1:length(tmpInds))=FRAME(tmpInds);
        end
        
        
        
        fracVec(frameCnt) = offset;
        kernels{slopeCnt, frameCnt} = tmpKernel;
        
        
        %     tmpFrame    =  1/lWin * (ifft(FRAME,'symmetric'));
        
      
        
        % FRAMEWISE ANIMATION
        
        if plotit==1
            
            % plot the  frame
            subplot(3,2,1)
            plot(real(FRAME(1:100)),'r')
            hold on
            plot(imag(FRAME(1:100)),'g')
            plot(abs(FRAME(1:100)))
%             hold off
            
            % plot the real-imag decomposition
            % plot(real(FRAME)),hold on, plot(imag(FRAME),'r'), hold off
            ylim([-100 100]);
            xlabel('Frequency Bin'), ylabel('|X|[n], real(X), imag(X)')
            title('Spectral Frame (zoom)')
            
            
            subplot(3,2,2)
            plot(tmpFrame)
            % ylim(0.5*[-10e-3 10e-3]);
            xlabel('Sample'), ylabel('x[i]')
            title('Frame in Time Domain');
            
            
            subplot(3,2,3)
            plot(F0,'r')
            hold on
            YY = ylim();
            line([frameCnt,frameCnt], [YY(1) YY(2)])
            hold off
            xlabel('Frame Index'), ylabel('Frequency / \Delta f')
            title('Fundamental Frequeny Trajectory');
            
            subplot(3,2,4)
            plot(real(tmpKernel),'g' )
            hold on
            ylim([-100 100]);
            xlim([0 20])
            plot(imag(tmpKernel),'r' )
            plot(abs(tmpKernel),'b' )
            grid on
            xlabel('f/Bin')
            ylabel('')
            title('Kernel')
            hold off
            
            
            subplot(3,2,5)
            plot(fm)
            hold on
            xlabel('n')
            ylabel('f_0');
            title('Frequency Slope')
            ylim([0 2]);
            
            pause(0.1)
            %         drawnow
            shg
            
        end
        
    end
    
end

save('kernel_data','fracVec','kernels')
