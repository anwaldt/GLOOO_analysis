%% IFFT_Analysis_Experiments_VARYING.m
%
%   Frequency-domain (IFFT) synthesis
%   with varying fundamental frequency,
%   using the pre-calculated main-lobe kernels.
%
%   Kind of working  - ... But only with large overlap:
%                     
%   TODO: Phase increment and or correctness of lobe position
%   might be the reason.
%
%   Henrik von Coler
%   2014-09-11

close all
clearvars


%% BASIC PARAMETERS

% this starts the animated plot, if set to '1'
plotit = 0;

% sampling frequency
fs      = 44100;

% number of frames to synthesize
nFrames = 800;

% synthesis frame length
lWin  = 2^11;

% synthesis hop size
lHop    = lWin/8;

% hop size in seconds
hop_s  = (lHop/fs);

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


WIN =   real(fftshift(    fft(win) ));
%  WIN = 0.5*sinc(linspace(-nFrame/2, nFrame/2-1,nFrame*resFactor))';
%  win =  ( (ifft(WIN,'symmetric')));

% boxcar with FFT
%  win = ones(nFrame,1);
%  WIN = fftshift(  fft(win));

if plotit==1
    figure
    plot(real(WIN),'g')
    hold
    plot(imag(WIN),'r')
    plot(abs(WIN),'b--')
end

% figure
% plot(win)
% shg

%% Control Parameters

vibDepth = 0.1;
fVib     = 40;

% F0 = 10 + vibDepth * sin((1:nFrames)*(nHop/fs)*fVib);

F0 = linspace(300, 2000, nFrames);
% plot(F0);shg

%% SINUSOIDAL PARAMETERS

nPart = 1;

for partCnt=1:nPart
    
    s(partCnt).a   = (1/(partCnt))^2;
    s(partCnt).phi = 0; % rand*pi;
    
    %     plot(abs(fft(   sin(2*pi*s(partCnt).f0*t)' .*win  )),'m');
end

%% Load kernel data

load kernel_data

%% Framewise synthesis

if plotit==1
    figure('units','normalized','outerposition',[0 0 1 1])
end

Y   = [];

for frameCnt=1:nFrames
    
    % allocate memory
    FRAME       = zeros(lWin,1);
    
    % loop over all partials
    for partCnt = 1:nPart
        
        % partial frequency
        % Case 1 (bin-related):
        % s(partCnt).f0  = F0(frameCnt)*df * partCnt;
        % Case 2 (simple frequency):
        s(partCnt).f0  = F0(frameCnt);
        
        % THE complex SINE:
        compSine =    exp(1i * s(partCnt).phi);
        
        % 'floating point position' of this partial
        s(partCnt).fracBin = s(partCnt).f0 / df;
        
        % closest bin
        centerBin   = floor(s(partCnt).fracBin);
        
        % offset
        offset      = s(partCnt).fracBin-centerBin;
        
        
        [~,tmpInd] =     min(abs(fracVec-offset));
        
        % PICK KERNEL
        tmpKernel = kernels{tmpInd};
        
        % SHIFT WINDOW TO POSITION
        for shiftCnt = -5:5
            
            % the fractional position of the window function which has to
            % go there:
            winPos     = ( (lWin/2+1) + shiftCnt)*resFactor + offset;
            
            
            % the position in the spectrum which is treated:
            framePos = centerBin - shiftCnt;
            
            % interpolation boundaries:
            lowBound    = floor(winPos) ;
            highBound   = ceil(winPos);
            
            % make shure we are within bounds:
            % TODO: There is a problem with low
            %       frequencies - when the lobe
            %       goes beyond bin 1 --
            if (framePos)>1 && framePos <= lWin
               
                % the window value taken from the kernel:
                interpComp = tmpKernel(6-shiftCnt);%;(1-offset) * WIN(lowBound) + offset * WIN(highBound);
                
                %  apply window to sine
                FRAME(framePos) = FRAME(framePos) + s(partCnt).a * compSine  * interpComp;
                
            end
            
        end
        
        % UPDATE the PHASE
        s(partCnt).phi =   rem( s(partCnt).phi + (s(partCnt).f0 * hop_s) * (2*pi),2*pi);
        
    end
    
    tmpFrame    =  (ifft(FRAME,'symmetric'));
    
    Y           = [Y tmpFrame];
    
    % FRAMEWISE ANIMATION
    
    if plotit==1
        
        % plot the  frame
        subplot(2,2,1)
        plot(real(FRAME(1:500)),'r')
        hold on
        plot(imag(FRAME(1:500)),'g')
        plot(abs(FRAME(1:500)))
        hold off
        % plot the real-imag decomposition
        % plot(real(FRAME)),hold on, plot(imag(FRAME),'r'), hold off
        ylim([-100 200]);
        xlabel('Frequency Bin'), ylabel('|X|[n], real(X), imag(X)')
        title('Spectral Frame (zoom)')
        
        
        subplot(2,2,2)
        plot(tmpFrame)
        ylim([-1 1]);
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
        plot(compSine,'.')
        grid on
        line([0 real(compSine)],[0 imag(compSine)])
        axis square
        xlim([-1,1])
        ylim([-1,1])
        xlabel('Real')
        ylabel('Imag')
        title('Instantaneous Phase')
        hold off
        
        pause(0.1)
        %         drawnow
        shg
        
    end
    
end

%% Assemble output

out = zeros(nFrames*lHop+lWin,1);


for frameCnt=1:nFrames
    
    inds = frameCnt*lHop:frameCnt*lHop+lWin-1;
    
    out(inds) =     out(inds) + Y(:,frameCnt) /8;
    
end


%%
if plotit==1
    figure
    hold on
    figure
    plot(out)
    
    
    nPlots = 4;
    figure
    hold on
    
    for frameCnt=1:nPlots
        
        y = zeros(nPlots*lHop+lWin,1);
        
        inds = frameCnt*lHop:frameCnt*lHop+lWin-1;
        
        y(inds) =     y(inds) + Y(:,frameCnt).*win ;
        
        subplot(nPlots,1,frameCnt);
        plot(y)
        
        shg,
    end
    
    
end

