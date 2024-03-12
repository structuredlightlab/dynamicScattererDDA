function [exclude_dipoles,exclude_sources] = exclusionZone(exclusion_radius,...
    z_2D,z_dipole_positions,z_sources)

% Build the exclusion region around the dipoles
exclusion_radius2 = exclusion_radius.^1;
n_points_1D = size(z_2D,1);
n_dipoles = size(z_dipole_positions,1);

x_2D = real(z_2D);
y_2D = imag(z_2D);

exclude_dipoles = ones(n_points_1D);
for n = 1:1:n_dipoles
    distance_x = x_2D - real(z_dipole_positions(n));
    distance_y = y_2D - imag(z_dipole_positions(n));
    r2 = distance_x.^2 + distance_y.^2;
    exclude_dipoles = exclude_dipoles.*double(r2>exclusion_radius2);
end

% Build the exclusion region around the sources
n_sources = size(z_sources,1);
x_sources = real(z_sources);
y_sources = imag(z_sources);

exclude_sources = ones(n_points_1D);
for n = 1:1:n_sources
    r_0(1) = x_sources(n);          r_0(2) = y_sources(n);
    distance_x = x_2D - r_0(1);     distance_y = y_2D - r_0(2);
    r2 = distance_x.^2 + distance_y.^2;
    exclusion_radius_sources = (exclusion_radius*1)^1.2;
    exclude_sources = exclude_sources.*double(r2>exclusion_radius_sources);    
end

end