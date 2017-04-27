
function [] = framewise_animation()

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
ylim([-1 1]);
xlabel('Sample'), ylabel('x[i]')
title('Frame in Time Domain');


subplot(2,2,3)
plot(F0,'r')
hold on
plot(F0meas,'g--')

legend({'Aspired' , 'Measured'});
YY = ylim();
line([frameCnt,frameCnt], [YY(1) YY(2)])
hold off
xlabel('Frame Index'), ylabel('Frequency / \Delta f')
title('Fundamental Frequeny Trajectory');

%         subplot(2,2,4)
%         plot(s(partCnt).compSine,'.')
%         grid on
%         line([0 real(s(partCnt).compSine)],[0 imag(s(partCnt).compSine)])
%         axis square
%         xlim([-1,1])
%         ylim([-1,1])
%         xlabel('Real')
%         ylabel('Imag')
%         title('Instantaneous Phase')
%         hold off

pause(0.01)
%         drawnow
shg