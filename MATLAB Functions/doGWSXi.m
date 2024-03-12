if do_GWS
    tic
    progressbar('Calculating \xi for GWS fields'); set(gcf,'Visible','on');

    xi_GWS = zeros(length(abs_eigvals),1);
    intensity = xi_GWS;     stdev = xi_GWS;  
    for idx = 1:length(abs_eigvals)
        field_fluctuations = testDipoleMovement(eigenvectors(:,idx),n_movements,movement_stdev,...
            k0,alpha,z_full_2d,static_dipole_positions,moving_dipole_positions,z_sources,z_detectors);
        xi_GWS(idx) = mean(std(abs(field_fluctuations),0,2))/mean(mean(abs(field_fluctuations).^2,1));
        intensity(idx) = mean(mean(abs(field_fluctuations).^2,1));
        stdev(idx) = mean(std(abs(field_fluctuations),0,2));
        if rem(idx,5); progressbar(idx/length(abs_eigvals)); end
    end
    progressbar(1)
    
    subplot_x = 0.15;      subplot_y = 0.2;
    subplot_width = 0.5;   subplot_height = 0.75;
    fig = figure('Units','centimeters','Position',[10,10,11,5]);
    ha = tight_subplot(1,1,.1,.15,.15);
    axes(ha);   hold on;    box on;
    plot(xi_GWS./max(xi_GWS),'DisplayName','\xi')
    plot(intensity./max(intensity),'DisplayName','Mean int.')
    plot(stdev./max(stdev),'DisplayName','Mean st. dev.')
    xlabel('Index of eigenvalue')
    ylabel('Normalised value')
    legend('Location','bestoutside')
    axis([1 idx 0 1])
    set(ha,'Position',[subplot_x subplot_y subplot_width subplot_height]);

    disp(['Calculating and plotting xi took ' num2str(toc) ' seconds.']);
end