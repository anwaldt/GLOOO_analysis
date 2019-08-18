

partialIDX = 1;

dist = 1;

close all

figure

partialIDX = 1;

for dist=1:11
    
    subplot(7,2, dist);
    
    %     hold on
    
    
    %         NOISE:6
    %          eval(['plot(MOD.SUS.RESIDUAL.BARK_' num2str(partialIDX) '.NRG.ICMF.support', ', MOD.SUS.RESIDUAL.BARK_' num2str(partialIDX) '.NRG.ICMF.dist_' num2str(dist) '.icmf)'])
    %          ylabel(['Band ' num2str(partialIDX)])
    
    %         try
    %          eval(['plot(MOD.SUS.PARTIALS.P_' num2str(partialIDX) '.FRE.ICMF.dist_' num2str(dist) '.xval', ', MOD.SUS.PARTIALS.P_' num2str(partialIDX) '.FRE.ICMF.dist_' num2str(dist) '.icmf)'])
    %         catch
    %            disp('No distribution found!')
    %         end
    %
    try
        eval(['plot(MOD.SUS.PARTIALS.P_' num2str(partialIDX) '.AMP.ICMF.support', ', MOD.SUS.PARTIALS.P_' num2str(partialIDX) '.AMP.ICMF.icmf_' num2str(dist) ')'])
        ylabel(['ICMF ' num2str(dist)])
        
        %ylim([4e-4, 6e-4])

    catch
        
        xxx = 666;
    end
    
end

 
 
