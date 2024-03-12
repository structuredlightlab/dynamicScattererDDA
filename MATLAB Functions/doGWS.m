if do_GWS
    tic
    switch alpha_type
        case 'x'
            disp('GWS derivative w.r.t. x.')
            Delta_alpha = delta_alpha*movement_stdev;
    
            z_total_dipole_positions = [static_dipole_positions; moving_dipole_positions + Delta_alpha];
            transmission_matrix_type = 'square';
            [t_1, ~,~] ...
                = calculateTransmissionMatrix(transmission_matrix_type,k0,alpha,z_full_2d,...
                z_detectors,z_sources,z_total_dipole_positions,exclusion_radius);
    
            z_total_dipole_positions = [static_dipole_positions; moving_dipole_positions - Delta_alpha];
            [t_2, ~,~] ...
                = calculateTransmissionMatrix(transmission_matrix_type,k0,alpha,z_full_2d,...
                z_detectors,z_sources,z_total_dipole_positions,exclusion_radius);
    
            delta_Q = t_1 - t_2;
        case 'y'
            disp('GWS derivative w.r.t. y.')
            Delta_alpha = 1i*delta_alpha*movement_stdev;
    
            z_total_dipole_positions = [static_dipole_positions; moving_dipole_positions + Delta_alpha];
            transmission_matrix_type = 'square';
            [t_1, ~,~] ...
                = calculateTransmissionMatrix(transmission_matrix_type,k0,alpha,z_full_2d,...
                z_detectors,z_sources,z_total_dipole_positions,exclusion_radius);
    
            z_total_dipole_positions = [static_dipole_positions; moving_dipole_positions - Delta_alpha];
            [t_2, ~,~] ...
                = calculateTransmissionMatrix(transmission_matrix_type,k0,alpha,z_full_2d,...
                z_detectors,z_sources,z_total_dipole_positions,exclusion_radius);
    
            delta_Q = t_1 - t_2;
        case 'random'
            disp('GWS derivative w.r.t. random movements.')
            Delta_alpha = (randn(size(moving_dipole_positions))+1i*randn(size(moving_dipole_positions)))*movement_stdev;
    
            z_total_dipole_positions = [static_dipole_positions; moving_dipole_positions + Delta_alpha];
            transmission_matrix_type = 'square';
            [t_1, ~,~] ...
                = calculateTransmissionMatrix(transmission_matrix_type,k0,alpha,z_full_2d,...
                z_detectors,z_sources,z_total_dipole_positions,exclusion_radius);
            
            Delta_alpha = (randn(size(moving_dipole_positions))+1i*randn(size(moving_dipole_positions)))*movement_stdev;
            z_total_dipole_positions = [static_dipole_positions; moving_dipole_positions - Delta_alpha];
            [t_2, ~,~] ...
                = calculateTransmissionMatrix(transmission_matrix_type,k0,alpha,z_full_2d,...
                z_detectors,z_sources,z_total_dipole_positions,exclusion_radius);
    
            delta_Q = t_1 - t_2;
        case 'alpha'
            disp('GWS derivative w.r.t. polarizability not available yet.')
            z_total_dipole_positions = [static_dipole_positions; moving_dipole_positions];
            transmission_matrix_type = 'square';
            [t_1, ~,~] ...
                = calculateTransmissionMatrix(transmission_matrix_type,k0,alpha,z_full_2d,...
                z_detectors,z_sources,z_total_dipole_positions,exclusion_radius);
    
            z_total_dipole_positions = static_dipole_positions;
            [t_2, ~,~] ...
                = calculateTransmissionMatrix(transmission_matrix_type,k0,alpha,z_full_2d,...
                z_detectors,z_sources,z_total_dipole_positions,exclusion_radius);
    
            delta_Q = t_1 - t_2;
            Delta_alpha = 1;
    end
    
    [transmission_matrix,desired_field_points,transmission_matrix_type] ...
            = calculateTransmissionMatrix(transmission_matrix_type,k0,alpha,z_full_2d,...
            z_detectors,z_sources,[static_dipole_positions; moving_dipole_positions],exclusion_radius);
    inverse_transmission_matrix = ctranspose(transmission_matrix);
    
    Q_alpha = -1i*inverse_transmission_matrix*(delta_Q)/(2*delta_alpha);
    disp(['GWS calculation took ' num2str(toc) ' seconds.']);
    
    tic
    [eigenvectors,eigenvalues] = eig(Q_alpha);
    real_eigvals = (diag(real(eigenvalues)));
    abs_eigvals = (diag(abs(eigenvalues)));
    imag_eigvals = (diag(imag(eigenvalues)));  
    
    idx_to_plot = round(linspace(1,length(abs_eigvals),8));
    
    
    disp(['Calculating and plotting GWS eigenfields took ' num2str(toc) ' seconds.']);
end