function [transmission_matrix, desired_field_points,transmission_matrix_type] ...
    = calculateTransmissionMatrix(transmission_matrix_type,k0,alpha,z_2D,...
    z_detectors,z_sources,z_dipole_positions,exclusion_radius)

n_sources = size(z_sources,1);
switch transmission_matrix_type
    case 'square'
        n_detectors = size(z_detectors,1);
        
        transmission_matrix = complex(zeros(n_detectors,n_sources));
        desired_field_points = imag(z_detectors);
        if n_detectors ~= n_sources
            disp('Not a square transmission matrix! Number of detectors is not equal to the number of sources.')
            transmission_matrix_type = 'not square';
        end
        for s = 1:n_sources
            probe_amps = zeros(n_sources,1);    probe_phases = zeros(n_sources,1);
            probe_amps(s) = 1;
            probe_field = probe_amps.*exp(1i*probe_phases);
            probe_field = probe_field./norm(probe_field);
    
            probe_source_at_detectors = sourceAtDetectors(k0,probe_field,z_sources,z_detectors);

            [total_field, ~] = DDA_true2D_onlyOutputs(k0,alpha,z_detectors,z_sources,...
                probe_field,probe_source_at_detectors,z_dipole_positions);

            transmission_matrix(:,s) = total_field;
        end
    case 'not square'
        n_points_1D = size(z_2D,1);

        transmission_matrix = complex(zeros(n_points_1D,n_sources));
        desired_field_points = imag(z_2D(:,end));
        for s = 1:n_sources
            probe_amps = zeros(n_sources,1);    probe_phases = zeros(n_sources,1);
            probe_amps(s) = 1;
            probe_field = probe_amps.*exp(1i*probe_phases);
            probe_field = probe_field./norm(probe_field);
    
            [total_field, ~] = DDA_true2D(k0,alpha,z_2D,exclusion_radius,...
                z_sources,probe_field,z_dipole_positions,0);
            transmission_matrix(:,s) = total_field(:,end);
        end
end

end