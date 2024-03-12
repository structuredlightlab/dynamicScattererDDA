function polarisations_2D = polarisationHeatmap(z_2D,z_dipole_positions,...
    polarisations,exclusion_radius)
x_2D = real(z_2D);
y_2D = imag(z_2D);

n_points_1D = size(z_2D,1);
n_dipoles = size(z_dipole_positions,1);

pol_plot = ones(n_points_1D,n_points_1D,n_dipoles);
for n = 1:1:n_dipoles
    distance_x2 = x_2D - real(z_dipole_positions(n));
    distance_y2 = y_2D - imag(z_dipole_positions(n));
    r22 = distance_x2.^2 + distance_y2.^2;
    pol_plot(:,:,n) = double(r22<exclusion_radius).*abs(polarisations(n));
end
polarisations_2D = sum(pol_plot,3);

% Can't have a value for polarisations in the heatmap larger than the
% maximum polarisation of the individual dipoles:
polarisations_2D(polarisations_2D > max(abs(polarisations))) = max(abs(polarisations));

end
