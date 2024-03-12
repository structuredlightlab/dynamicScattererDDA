if do_fast_opt_2    
    tic
    progressbar('Fast optimiser, v2 progress'); set(gcf,'Visible','on');

    forward_field = source_field;
    figure_of_merit = zeros(n_iter,1);
    intensity = zeros(n_iter,1);
    standard_dev = zeros(n_iter,1);
    xi_fast_1 = zeros(n_iter,1);
    for n = 1:n_iter
        % Calculate average of phase conj of field at detectors over time
        forward_source = sourceAtDetectors(k0,forward_field,z_sources,z_detectors);
        field_at_detectors = zeros(n_detectors,n_movements);
        for nn = 1:n_movements
            moved_dipole_positions(:,nn) = moving_dipole_positions ...
                + movement_stdev.*(randn(size(moving_dipole_positions))...
                + 1i*randn(size(moving_dipole_positions)));
            [field_at_detectors_nn, ~] = DDA_true2D_onlyOutputs(k0,alpha,...
                z_detectors,z_sources,forward_field,forward_source,...
                [static_dipole_positions; moved_dipole_positions(:,nn)]);
            field_at_detectors(:,nn) = conj(field_at_detectors_nn);
            norm_factors(nn) = normalisationFOM(field_at_detectors_nn);
        end
        
        figure_of_merit(n) = figureOfMerit(field_at_detectors,norm_factors);
        intensity(n) = mean(abs(field_at_detectors).^2,'all');
        standard_dev(n) = mean(std(abs(field_at_detectors),0,2));
        xi_fast_1(n) = standard_dev(n)./intensity(n);

        avg_conj_field = mean(field_at_detectors,2);
        avg_conj_field = avg_conj_field./norm(avg_conj_field);
    
        % Propagate this avg field back to sources, using same dipole
        % configurations
        back_prop_field = zeros(n_sources,n_movements);
        for nn = 1:n_movements
            % Comment out the next line to use the same dipole positions as
            % for average
            moved_dipole_positions(:,nn) = moving_dipole_positions ...
                + movement_stdev.*(randn(size(moving_dipole_positions))...
                + 1i*randn(size(moving_dipole_positions)));
            overlap_factor = real(sum((field_at_detectors(:,nn)...
                ./norm_factors(nn)).*avg_conj_field,'all'));
            adjusted_field = ((avg_conj_field ...
                - field_at_detectors(:,nn)./norm_factors(nn))*overlap_factor)...
                ./norm_factors(nn);
            adjusted_field = adjusted_field./norm(adjusted_field);
            back_prop_source = sourceAtDetectors(k0,adjusted_field,z_detectors,z_sources);
            [back_prop_field_nn, ~] = DDA_true2D_onlyOutputs(k0,alpha,...
                z_sources,z_detectors,adjusted_field,back_prop_source,...
                moved_dipole_positions(:,nn));
            back_prop_field(:,nn) = back_prop_field_nn;
        end
        avg_back_prop_field = mean(back_prop_field,2);
        optimised_phase_changes = angle(avg_back_prop_field);
        forward_field = forward_field - dj*exp(-1i*optimised_phase_changes);  
        forward_field = forward_field./norm(forward_field);      
        if rem(n,5); progressbar(n/n_iter); end
    end
    progressbar(1)

    optimised_field = forward_field;
    normalised_fom = figure_of_merit-2*max(figure_of_merit);

    

    disp(['Fast optimiser v2 took ' num2str(toc) ' seconds.'])
end