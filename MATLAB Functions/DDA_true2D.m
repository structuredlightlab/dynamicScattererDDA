function [total_field, total_scatter, pol_fig, polarisations_2D] = ...
    DDA_true2D(k_0,alpha,z_2D,exclusion_radius,z_sources,...
    incident_field,z_dipole_positions,do_show_pol_plots)
%  DDA_TRUE2D_PLOT Discrete Dipole Approximation in 2D

k_02 = k_0^2;

x_2D = real(z_2D);
y_2D = imag(z_2D);

n_dipoles = size(z_dipole_positions,1);
n_points_1D = size(x_2D,1);

% Calculate exclusion zones around dipoles and sources
[exclude_dipoles,exclude_sources] = exclusionZone(exclusion_radius,z_2D,...
    z_dipole_positions,z_sources);

% Calculate the source everywhere
[source_on_dipoles,source_on_grid] = sourceEverywhere(k_0,incident_field,...
    z_dipole_positions,z_2D,z_sources);

% Calculate coupling matrix and its inverse
coupling_matrix = couplingMatrix(z_dipole_positions,alpha,k_0); 
inverse_coupling_matrix = inv(coupling_matrix);

% Solve for polarisations of dipoles
polarisations = inverse_coupling_matrix*source_on_dipoles;

if do_show_pol_plots
    pol_fig_1d = figure('Units','centimeters','Position',[10 10 10 5.5]);
    plot(abs(polarisations))
    xlabel('Dipole index');    ylabel('Polarization');
    axis tight
end

polarisations_2D = polarisationHeatmap(z_2D,z_dipole_positions,...
    polarisations,exclusion_radius);

if do_show_pol_plots
    pol_fig_2d = figure('Units','centimeters','Position',[10,10,10,7]);
    ha = tight_subplot(1,1,.1,.1);      hold on;        box on;

    imagesc(x_2D(1,:),y_2D(:,1).',polarisations_2D);
    xlabel('x/\lambda');    ylabel('y/\lambda');
    axis image;     
    set(gca, 'YDir','reverse','XTick',get(gca,'YTick'));
    fig_pos = ha.Position.*[0.5 1.0 1 1];           
    set(gca,'Position',fig_pos);
    c = colorbar;   c.Label.String = 'Polarisation';   
    c.Label.FontSize = get(gca,'FontSize');
    c.Position = [fig_pos(1)+0.825*fig_pos(3) fig_pos(2) ...
        0.03*fig_pos(3) 1*fig_pos(4)];
    clim([0 max(abs(polarisations))])

    pol_fig = [pol_fig_1d pol_fig_2d];    
else
    pol_fig = [];
end

% Loop through dipoles and update/calculate the field scattered from each 
% one of the moving dipoles
total_scatter = zeros(n_points_1D);
distances_grid_to_dipoles = distanceAToB(z_dipole_positions,z_2D);
for n = 1:1:n_dipoles
    new_scatter = polarisations(n)*(k_02*(1i/4)*besselh(0,1,k_0*...
        distances_grid_to_dipoles(:,:,n)));
    total_scatter = total_scatter + new_scatter;
end
total_scatter = total_scatter.*exclude_dipoles.*exclude_sources;

% Calculate the resulting electric field over the whole space at specified
% grid points (excluding dipole and source positions)
total_field = source_on_grid + total_scatter;
total_field = total_field.*exclude_dipoles.*exclude_sources;

end