function [source_on_dipoles,source_on_grid] = sourceEverywhere(k_0,...
    incident_field,z_dipole_positions,z_2D,z_sources)
% Build the field on each dipole due to all of the sources, and the field
% at every point on the grid due to all of the sources.
k_02 = k_0;

n_dipoles = size(z_dipole_positions,1);
n_points_1D = size(z_2D,1);
n_sources = size(z_sources,1);

x_sources = real(z_sources);
y_sources = imag(z_sources);

x_2D = real(z_2D);
y_2D = imag(z_2D);

source_on_dipoles = complex(zeros(n_dipoles,1));
source_on_grid = complex(zeros(n_points_1D));
for n = 1:1:n_sources
    r_0(1) = x_sources(n);          r_0(2) = y_sources(n);    
    
    rad_dist_dipoles = ((real(z_dipole_positions)-r_0(1)).^2 + ...             % distance from all dipoles to nth source
        (imag(z_dipole_positions)-r_0(2)).^2).^0.5; 
    source_on_dipoles = source_on_dipoles + incident_field(n)...
        *((1i/4)*besselh(0,1,k_0*rad_dist_dipoles)*k_02);
    
    rad_dist_grid = (((r_0(1)-x_2D).^2) + ((r_0(2)-y_2D).^2)).^0.5;         % distance from nth source to everywhere on grid
    source_on_grid = source_on_grid + incident_field(n)...
        *((1i/4)*besselh(0,1,k_0*rad_dist_grid)*k_02); 
end 
end