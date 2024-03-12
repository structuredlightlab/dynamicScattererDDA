function [total_field, total_scatter] = DDA_true2D_onlyOutputs(k_0,alpha,...
    z_detectors,z_sources,incident_field,source_at_detectors,z_dipole_positions)
%  This function calculates the optical field at detector locations

k_02 = k_0^2;

n_sources = size(z_sources,1);
n_detectors = size(z_detectors,1);
n_dipoles = size(z_dipole_positions,1);

source_on_dipoles = complex(zeros(n_dipoles,1));
for n = 1:1:n_sources
    distance_dipoles_to_source = abs(z_dipole_positions - z_sources(n));
    source_on_dipoles = source_on_dipoles + incident_field(n)...
        *(k_02*(1i/4)*besselh(0,1,k_0*distance_dipoles_to_source));
end

coupling_matrix = couplingMatrix(z_dipole_positions,alpha,k_0);
inverse_coupling_matrix = inv(coupling_matrix);

polarisations = inverse_coupling_matrix*source_on_dipoles;

distances_dipoles_to_detectors = distanceAToB(z_dipole_positions,z_detectors);
total_scatter = zeros(n_detectors,1);
for n = 1:1:n_dipoles
    new_scatter = polarisations(n)*(k_02*(1i/4)*...
        besselh(0,1,k_0*distances_dipoles_to_detectors(:,n)));
    total_scatter = total_scatter + new_scatter;
end
total_field = source_at_detectors + total_scatter;

end