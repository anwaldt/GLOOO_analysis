%%  IFFT_Prepare_Kernels.m
%
%   Calculate spectral kernels for
%   the Blackman-Harris window and
%   and store them!
%
%
%   Henrik von Coler
%   2014-09-11
%
%% Basic setup

close all
clearvars

restoredefaultpath
addpath Functions/


%% BASIC PARAMETERS

% this starts the animated plot, if set to '1'
plotit = 1;

% sampling frequency
fs      = 44100;

% number of frames to synthesize
nFrames = 100;

% synthesis frame length
nFrame  = 2^9;

% synthesis hop size
nHop    = nFrame/4;

% hop size in seconds
hop_s  = (nHop/fs);

% time axis within one frame
t       = (0:nFrame-1)/fs;

% delta frequency (bin distance)
df    =  fs/nFrame;

%% Windows

close all

% upsample the Window for better interpolation
resFactor = 1;

% for time truncation

% win = hann(nFrame);

win =  calculate_BH92_complete(nFrame) ;

WIN =   real(fftshift(fft(win) ));

% WIN = 0.5*sinc(linspace(-nFrame/2, nFrame/2-1,nFrame*resFactor))';
% win =  ( (ifft(WIN,'symmetric')));

% boxcar with FFT
% win = ones(nFrame,1);
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

vibDepth = 0;
fVib     = 2;

 
F0 = linspace(10,11,nFrames);
% plot(F0);shg

 %%

s.a   = 1;
s.phi = 0;% rand*pi;
    


%% Framewise synthesis

if plotit==1
    figure('units','normalized','outerposition',[0 0 1 1])
end

out = zeros(nFrames*nHop+nFrame,1);

fracVec = zeros(1,nFrames);
kernels = cell(11,nFrames);

kkk =zeros(11,nFrames);
%% FOR DIFFERENT FREQUENCY SLOPES

nSlopes = 100;
fm = ones(size(t));

%% FOR DIFFERENT POSITIONS BETWEEN THE BINS
for frameCnt=1:nFrames
  
        
        % partial frequency
        s.f0  = F0(frameCnt)*df;
        
        tmpFrame = sin(2*pi*s.f0.*t +s.phi)'.*win;
        
        FRAME = fft(tmpFrame);
        % THE complex SINE:
        compSine =    exp(1i * s.phi);
        
        % 'floating point position' of this partial
        s.fracBin = s.f0 / df;
        
        % closest bin
        centerBin   = floor(s.fracBin)+1;
        
        % offset
        offset      = 1 + (s.fracBin-centerBin);
        
        % SHIFT WINDOW TO POSITION
        for shiftCnt = -4:4
            
            %             % the fractional position of the window function which has to
            %             % go there:
            winPos     = ( (nFrame/2+1) + shiftCnt)*resFactor + offset;
            
            %             % the position in the spectrum which is treated:
            framePos = centerBin - shiftCnt;
            
            %
        end
        
        % UPDATE the PHASE
        %         s.phi =   rem( s.phi + (s.f0 * hop_s) * (2*pi),2*pi);
        
        
        inds = frameCnt*nHop:frameCnt*nHop+nFrame-1;
        
        out(inds) =     out(inds) + tmpFrame;
        
        tmpInds =  centerBin-5:centerBin+5;
        
        
        tmpKernel = FRAME(tmpInds);
        
        fracVec(frameCnt) = offset;
        kernels{frameCnt} = tmpKernel;
        kkk(:,frameCnt) = tmpKernel;
    
    %     tmpFrame    =  1/nFrame * (ifft(FRAME,'symmetric'));
    
    
    
    % FRAMEWISE ANIMATION
    
    if plotit==1
        
        % plot the  frame
        subplot(2,2,1)
        plot(real(FRAME(1:50)),'r')
        hold on
        plot(imag(FRAME(1:50)),'g')
        plot(abs(FRAME(1:50)))
        hold off
        
        % plot the real-imag decomposition
        % plot(real(FRAME)),hold on, plot(imag(FRAME),'r'), hold off
        ylim([-100 100]);
        xlabel('Frequency Bin'), ylabel('|X|[n], real(X), imag(X)')
        title('Spectral Frame (zoom)')
        
        
        subplot(2,2,2)
        plot(tmpFrame)
        % ylim(0.5*[-10e-3 10e-3]);
        xlabel('Sample'), ylabel('x[i]')
        title('Frame in Time Domain');
        
        
        subplot(2,2,3)
        plot(F0,'r')
        hold on
        YY = ylim();
        line([frameCnt,frameCnt], [YY(1) YY(2)])
        hold off
        xlabel('Frame Index'), ylabel('Frequency / \Delta f')
        title('Fundamental Frequeny Trajectory');
        
        subplot(2,2,4)
        plot(real(tmpKernel),'g' )
        hold on
        ylim([-100 100]);
        
        plot(imag(tmpKernel),'r' )
        plot(abs(tmpKernel),'b' )
        grid on
        xlabel('f/Bin')
        ylabel('')
        title('Kernel')
        hold off
        
        pause(0.1)
        %         drawnow
        shg
        
    end
    
end

%% 

dlmwrite('kernels',kkk,'delimiter','\t')
dlmwrite('fracVec',fracVec,'delimiter','\t')


save('kernel_data','fracVec','kernels')

