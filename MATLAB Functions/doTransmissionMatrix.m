if do_transmission_matrix
    tic
    
    [transmission_matrix, desired_field_points,transmission_matrix_type] ...
        = calculateTransmissionMatrix(transmission_matrix_type,k0,alpha,z_full_2d,...
        z_detectors,z_sources,z_dipole_positions,exclusion_radius);

    disp(['Calculating transmission matrix took ' num2str(toc) ' seconds.']);
end