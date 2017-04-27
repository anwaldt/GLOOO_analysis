%% IFFT_Analysis_Experiments_VARYING.m
%
%   Frequency-domain (IFFT) synthesis
%   with varying fundamental frequency.
%
%
%   Henrik von Coler
%   2014-08-20

close all
clearvars


%% BASIC PARAMETERS

% this starts the animated plot, if set to '1'
plotit = 0;

% sampling frequency
fs      = 44100;

% number of frames to synthesize
nFrames = 100;

% synthesis frame length
nFrame  = 2^9;

% synthesis hop size
nHop    = nFrame/2;

% hop size in seconds
hop_s  = (nHop/fs);

% time axis within one frame
t = (0:nFrame-1)/fs;

% delta frequency (bin distance)
df    =  fs/nFrame;

%% Windows

close all

% upsample the Window for better interpolation
resFactor = 1;

% for time truncation

% win = hann(nFrame);

win =  calculate_BH92_complete(nFrame) ;


WIN =   real(fftshift(    fft(win) ));
%WIN = 0.5*sinc(linspace(-nFrame/2, nFrame/2-1,nFrame*resFactor))';
%  win =  ( (ifft(WIN,'symmetric')));

% boxcar with FFT
%   win = ones(nFrame,1);
%   WIN = fftshift(  fft(win));


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

F0 = 10 + vibDepth * sin((1:nFrames)*(nHop/fs)*fVib);

F0 = linspace(10,11,nFrames);
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
    figure('units','normalized','outerposition',[0 0 1 1])
end

Y   = [];

for i=1:nFrames
    
    % allocate memory
    FRAME       = zeros(nFrame,1);
    
    % loop over all partials
    for partCnt = 1:nPart
        
        % partial frequency
        s(partCnt).f0  = F0(i)*df * partCnt;
        
        % THE complex SINE:
        compSine =    exp(1i * s(partCnt).phi);
        
        % 'floating point position' of this partial
        s(partCnt).fracBin = s(partCnt).f0 / df;
        
        % closest bin
        % @TODO: Do the math correctly !
        centerBin   = floor(s(partCnt).fracBin)+1;
        
        % offset
        offset      = s(partCnt).fracBin-centerBin;
        
        % SHIFT WINDOW TO POSITION
        for shiftCnt = -4:4
            
            % the fractional position of the window function which has to
            % go there:
            winPos     = ( (nFrame/2+1) + shiftCnt)*resFactor + offset;
            
            
            % the position in the spectrum which is treated:
            framePos = centerBin - shiftCnt;
            
            % interpolation boundaries:
            lowBound    = floor(winPos) ;
            highBound   = ceil(winPos);
            
            % make shure we are within bounds:
            if((framePos)>=1)
                
                % Complex linear interpolation ? does not solve the problem :
                % interpReal = (1-offset) * real(WIN(lowBound)) + offset * real(WIN(highBound));
                % interpImag = (1-offset) * imag(WIN(lowBound)) + offset * imag(WIN(highBound));
                % interpComp = interpReal + 1i*interpImag;
                
                % the interpolated window value:
                interpComp = (1-offset) * WIN(lowBound) + offset * WIN(highBound);
                
                %  apply window to sine
                FRAME(framePos) = FRAME(framePos) + s(partCnt).a * compSine  * interpComp;
                
            end
            
        end
        
        % UPDATE the PHASE
        %        s(partCnt).phi =   rem( s(partCnt).phi + (s(partCnt).f0 * hop_s) * (2*pi),2*pi);
        
    end
    
    tmpFrame    =  1/nFrame * (ifft(FRAME,'symmetric'));
    
    Y           = [Y tmpFrame];
    
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
        ylim([-100 200]);
        xlabel('Frequency Bin'), ylabel('|X|[n], real(X), imag(X)')
        title('Spectral Frame (zoom)')
        
        
        subplot(2,2,2)
        plot(tmpFrame)
        ylim(0.5*[-10e-3 10e-3]);
        xlabel('Sample'), ylabel('x[i]')
        title('Frame in Time Domain');
        
        
        subplot(2,2,3)
        plot(F0,'r')
        hold on
        YY = ylim();
        line([i,i], [YY(1) YY(2)])
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

out = zeros(nFrames*nHop+nFrame,1);
figure
hold on

for i=1:nFrames
    
    inds = i*nHop:i*nHop+nFrame-1;
    
    out(inds) =     out(inds) + Y(:,i) /8;
    
end

figure
plot(out)

%%

nPlots = 4;
figure
hold on

for i=1:nPlots
    
    y = zeros(nPlots*nHop+nFrame,1);
    
    inds = i*nHop:i*nHop+nFrame-1;
    
    y(inds) =     y(inds) + Y(:,i).*win ;
    
    subplot(nPlots,1,i);
    plot(y)
    
    shg,
end




