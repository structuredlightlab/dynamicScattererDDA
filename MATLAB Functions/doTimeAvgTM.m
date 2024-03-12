if do_time_avg_tm
    tic
    progressbar('Calculating T_{avg}'); set(gcf,'Visible','on');

    time_avg_transmission_mat = zeros(n_detectors,n_sources);
    for n = 1:n_sources
        probe_field = zeros(n_sources,1);
        probe_field(n) = 1;
        probe_source_at_detectors = sourceAtDetectors(k0,probe_field,...
            z_sources,z_detectors);
        total_field = zeros(n_detectors,1);
        parfor nn = 1:n_movements
            moved_dipole_positions = moving_dipole_positions ...
                + movement_stdev.*(randn(size(moving_dipole_positions))...
                + 1i*randn(size(moving_dipole_positions)));
            [total_field_nn, ~] = DDA_true2D_onlyOutputs(k0,alpha,...
                z_detectors,z_sources,probe_field,probe_source_at_detectors,...
                [static_dipole_positions; moved_dipole_positions]);
            total_field = total_field + total_field_nn;
        end
        average_field = total_field./n_movements;
        time_avg_transmission_mat(:,n) = average_field;
        if rem(n,5); progressbar(n/n_sources); end
    end
    progressbar(1)
    time_avg_operator = ctranspose(time_avg_transmission_mat)...
        *time_avg_transmission_mat;

    [eigenvectors_tavg,eigenvalues_tavg] = eig(time_avg_operator);
    abs_eigvals_tavg = (diag(abs(eigenvalues_tavg)));


    
     
    disp(['Calculating T_avg took ' num2str(toc) ' seconds.']);
end