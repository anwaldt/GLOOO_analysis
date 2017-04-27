%%  test whether simple addition of the lobes values suffices DC stuff
%
%   Henrik von Coler
%   2015-03-05

close all
clearvars

addpath Functions/

%% BASIC PARAMETERS

% this starts the animated plot, if set to '1'
plotit = 1;

% sampling frequency
fs      = 44100;

% number of kernels to calculate
nFrames = 100;

% synthesis frame length
lWin  = 2^10;

% synthesis hop size
nHop    = lWin/4;

% hop size in seconds
hop_s  = (nHop/fs);

% time axis within one frame
t = (0:lWin-1)/fs;

% delta frequency (bin distance)
df    =  fs/lWin;

%% Windows

close all

% upsample the Window for better interpolation
resFactor = 1;

% for time truncation

% win = hann(nFrame);

win =  calculate_BH92_complete(lWin) ;

WIN =   real(fftshift(fft(win) ));

% WIN = 0.5*sinc(linspace(-nFrame/2, nFrame/2-1,nFrame*resFactor))';
% win =  ( (ifft(WIN,'symmetric')));

% boxcar with FFT
% win = ones(nFrame,1);
% WIN = fftshift(  fft(win));


 

% figure
% plot(win)
% shg

%% Control Parameters

vibDepth = 0;
fVib     = 2;

% F0 = 10 + vibDepth * sin((1:nFrames)*(nHop/fs)*fVib);

F0 = 21;
% plot(F0);shg

%% SINUSOIDAL PARAMETERS

nPart = 1;

for partCnt=1:nPart
    
    s(partCnt).a   = 1/(partCnt);
    s(partCnt).phi = 0;% rand*pi;
    
    %     plot(abs(fft(   sin(2*pi*s(partCnt).f0*t)' .*win  )),'m');
end


%% Framewise synthesis

if plotit==1
    figure%('units','normalized','outerposition',[0 0 1 1])
end

out = zeros(nFrames*nHop+lWin,1);

fracVec_LF = zeros(1,nFrames);
kernels_LF = cell(11,nFrames);

for frameCnt=1:nFrames
    
    
    % loop over all partials
    for partCnt = 1:nPart
        
        % partial frequency
        s(partCnt).f0  = F0*df * partCnt;
        
        tmpFrame = sin(2*pi*s(partCnt).f0.*t +s(partCnt).phi)'.*win;
        
        FRAME = fft(tmpFrame);
        % THE complex SINE:
        compSine =    exp(1i * s(partCnt).phi);
        
        % 'floating point position' of this partial
        s(partCnt).fracBin = s(partCnt).f0 / df;
        
        % closest bin
        centerBin   = floor(s(partCnt).fracBin)+1;
        
        % offset
        offset      = 1 + (s(partCnt).fracBin-centerBin);
        
        % SHIFT WINDOW TO POSITION
        for shiftCnt = 1:11
            
            %             % the fractional position of the window function which has to
            %             % go there:
            winPos     = ( (lWin/2+1) + shiftCnt)*resFactor + offset;
            
            %             % the position in the spectrum which is treated:
            framePos =   shiftCnt;
            
            %
        end
        
        % UPDATE the PHASE
        %         s(partCnt).phi =   rem( s(partCnt).phi + (s(partCnt).f0 * hop_s) * (2*pi),2*pi);
        
        
        inds = frameCnt*nHop:frameCnt*nHop+lWin-1;
        
        out(inds) =     out(inds) + tmpFrame;
        
        tmpInds =  centerBin-5:centerBin+5;
        
        badInds = tmpInds;
        badInds(tmpInds>0) = [];
        
        goodInds = tmpInds;
        goodInds(tmpInds<=0) = [];
        
        tmpKernel = FRAME(goodInds);
        
        
        tstFRAME = zeros(size(FRAME));
        
        tstFRAME(goodInds) = tmpKernel;
        
        fracVec_LF(frameCnt) = s(partCnt).fracBin;
        kernels_LF{frameCnt} = tmpKernel;
        
    end
    
    %     tmpFrame    =  1/nFrame * (ifft(FRAME,'symmetric'));
    
    
    
    % FRAMEWISE ANIMATION
    
    if plotit==1
        
        % plot the  frame
        subplot(2,2,1)
        plot(real(FRAME),'r')
        hold on
        plot(imag(FRAME),'g')
        plot(abs(FRAME))
        
        plot(abs(tstFRAME),'m--')
        plot(real(tstFRAME),'m--')
        plot(imag(tstFRAME),'m--')
        
        xlim([1 50]);
        hold off
        
        
        % plot the real-imag decomposition
        % plot(real(FRAME)),hold on, plot(imag(FRAME),'r'), hold off
        ylim([-100 500]);
        xlabel('Frequency Bin'), ylabel('|X|[n], real(X), imag(X)')
        title('Spectral Frame (zoom)')
        
        
        subplot(2,2,2)
        plot(tmpFrame)
        hold on
                plot(ifft(tstFRAME,'symmetric'),'m--');
        % ylim(0.5*[-10e-3 10e-3]);
        xlabel('Sample'), ylabel('x[i]')
        title('Frame in Time Domain');
        
        
        subplot(2,2,3)
        
        subplot(2,2,4)
        plot(real(tmpKernel),'g' )
        hold on
         ylim([-100 500]);
        
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


save('kernel_data_LF','fracVec_LF','kernels_LF')
