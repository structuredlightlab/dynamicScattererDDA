if do_fast_opt_3    
    tic
    progressbar('Fast optimiser, v3 progress'); set(gcf,'Visible','on');
    
    forward_field = source_field;
    figure_of_merit = zeros(n_iter,1);
    intensity = zeros(n_iter,1);
    standard_dev = zeros(n_iter,1);
    xi_fast_1 = zeros(n_iter,1);
    for n = 1:n_iter
        % Calculate average of phase conj of field at detectors over time
        forward_source = sourceAtDetectors(k0,forward_field,z_sources,z_detectors);
        field_at_detectors = zeros(n_detectors,n_movements);
        fom = 0;
        for nn = 1:n_movements
            moved_dipole_positions(:,nn) = moving_dipole_positions ...
                + movement_stdev.*(randn(size(moving_dipole_positions))...
                + 1i*randn(size(moving_dipole_positions)));
            [field_at_detectors_nn, ~] = DDA_true2D_onlyOutputs(k0,alpha,...
                z_detectors,z_sources,forward_field,forward_source,...
                [static_dipole_positions; moved_dipole_positions(:,nn)]);
            field_at_detectors(:,nn) = conj(field_at_detectors_nn);
        end
        
        figure_of_merit(n) = figureOfMerit3(field_at_detectors);
        intensity(n) = mean(abs(field_at_detectors).^2,'all');
        standard_dev(n) = mean(std(abs(field_at_detectors),0,2));
        xi_fast_1(n) = standard_dev(n)./intensity(n);

        avg_conj_field = mean(field_at_detectors,2);
        avg_conj_field = avg_conj_field./norm(avg_conj_field);
    
        % Propagate this avg field back to sources, using same dipole
        % configurations
        back_prop_field = zeros(n_sources,n_movements);
        for nn = 1:n_movements
            adjusted_field = conj(field_at_detectors(:,nn)) ...
                - avg_conj_field;
            adjusted_field = adjusted_field./norm(adjusted_field);
            back_prop_source = sourceAtDetectors(k0,adjusted_field,z_detectors,z_sources);
            [back_prop_field_nn, ~] = DDA_true2D_onlyOutputs(k0,alpha,...
                z_sources,z_detectors,adjusted_field,back_prop_source,...
                moved_dipole_positions(:,nn));
            back_prop_field(:,nn) = back_prop_field_nn;
        end
        avg_back_prop_field = sum(back_prop_field,2);
        optimised_phase_changes = angle(avg_back_prop_field);
        forward_field = forward_field - dj*exp(-1i*optimised_phase_changes);  
        forward_field = forward_field./norm(forward_field);       
        if rem(n,5); progressbar(n/n_iter); end
    end
    progressbar(1)
    optimised_field = forward_field;
    
    subplot_x = 0.1;      subplot_y = 0.2;
    subplot_width = 0.5;   subplot_height = 0.75;
    fig = figure('Units','centimeters','Position',[10,10,11,5]);
    ha = tight_subplot(1,1,.1,.15,.15);
    axes(ha);   hold on;    box on;
    plot(1:n_iter,xi_fast_1./max(xi_fast_1),'DisplayName','\xi')
    plot(1:n_iter,intensity./max(intensity),'DisplayName','Mean int.')
    plot(1:n_iter,standard_dev./max(standard_dev),'DisplayName','Mean st. dev.')
    ylabel('Normalised value')
    axis([1 n_iter 0 1])
    plot(1:n_iter,figure_of_merit./max(figure_of_merit),...
        'LineStyle',':','DisplayName','F. O. M.')
    xlabel('Iteration')
    ylabel('Normalised value')
    legend('Location','bestoutside')
    set(ha,'Position',[subplot_x subplot_y subplot_width subplot_height]);

    
    disp(['Fast optimiser v2 took ' num2str(toc) ' seconds.'])
end