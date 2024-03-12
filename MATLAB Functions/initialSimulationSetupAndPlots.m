fig = figure('Units','centimeters','Position',[10,10,11,7]);
ha = tight_subplot(1,1,.1,.1); hold on; box on;

x_data = [{x_sources},{x_detectors},{real(static_dipole_positions)},{real(moving_dipole_positions)}];
y_data = [{y_sources},{y_detectors},{imag(static_dipole_positions)},{imag(moving_dipole_positions)}];
axes_labels = [{'x, \lambda'},{'y, \lambda'}];
markers = [{'.'},{'.'},{'.'},{'*'}];
marker_size = [10 10 10 10];
line_colors = [col7; col2; col6; col6];
display_name = [{'Sources'}, {'Detectors'},{['Static dipoles (' num2str(n_static_dipoles) ')']},...
    {['Moving dipoles (' num2str(n_moving_dipoles) ')']}];
plotScatter(x_data,y_data,axes_labels,markers,marker_size,line_colors,display_name)

fig_name = date + ', ' + num2str(n_dipoles) + ' dipoles, positions';
saveFigure(fig,fig_name,save_path,{'png','fig'},0);


%Set up initial complex field:
source_phases = zeros(n_sources,1); % initial phases of sources
source_amps = ones(n_sources,1);    % initial amplitudes of sources
source_field = source_amps.*exp(1i*source_phases);
source_field = source_field./norm(source_field);

%Calculate initial field everywhere:
% Show polarisation plots within the DDA functions?
show_pol_plots = false;

[initial_total_field,~,~,pol_fig_data] = DDA_true2D(k0,alpha,z_full_2d,...
    exclusion_radius,z_sources,source_field,z_dipole_positions,show_pol_plots);

fig = figure('Units','centimeters','Position',[10,10,11,7]);
ha = tight_subplot(1,1,.1,.1); hold on; box on;

subplot_x = 0.025;      subplot_y = 0.15;
subplot_width = 0.65;   subplot_height = 0.8;

field_data = [{x_points},{x_points},{(abs(initial_total_field).^2)./max(max(abs(initial_total_field).^2))}];
x_data = [{x_sources},{x_detectors},{real(z_dipole_positions)}];
y_data = [{y_sources},{y_detectors},{imag(z_dipole_positions)}];
axes_labels = [{'x, \lambda'},{'y, \lambda'}];
markers = [{'.'},{'.'},{'.'}];
marker_size = [10 10 10];
line_colors = [col7; col2; col6];
display_name = [{'Sources'}, {'Detectors'},{['Dipoles (' num2str(n_dipoles) ')']}];
do_colorbar = true;
c = plotFieldWithScatter(field_data,x_data,y_data,axes_labels,markers,marker_size,...
    line_colors,display_name,do_colorbar);
clim([0 1])
set(ha,'Position',[subplot_x subplot_y subplot_width subplot_height]);
% legend('Position',[subplot_x+0.92*subplot_width subplot_y+0.8*subplot_height...
    % 0.45*subplot_width 0.2*subplot_height])
set(c,'Position',[subplot_x+0.92*subplot_width subplot_y ...
    0.05*subplot_width 0.775*subplot_height])

fig_name = date + ', ' + num2str(n_dipoles) + ' dipoles';
saveFigure(fig,fig_name,save_path,{'png','fig'},0);

disp(['Setting up parameters took ' num2str(toc) ' seconds.']);