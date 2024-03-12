tic
phase_steps = [-phase_step_size 0 phase_step_size]; % array of +phi, 0, -phi phase steps to use

% Generate some colors to use later:
random_colors = rand(n_movements,1);    [~,~,random_color_idx] = unique(random_colors, 'stable');
colors = default_cmap(round(linspace(1,175,n_movements)),:);

% Calculate all of the positions of moving scatterers
shift_x = movement_stdev*randn(n_moving_dipoles,n_iter,...   % array of random changes in x-positions for moving scatterers
    n_sources,length(phase_steps),n_movements);
shift_y = movement_stdev*randn(n_moving_dipoles,n_iter,...   % array of random changes in y-positions for moving scatterers
    n_sources,length(phase_steps),n_movements);

shifted_x = real(moving_dipole_positions) + shift_x; % array of random x-positions for moving scatterers
shifted_y = imag(moving_dipole_positions) + shift_y; % array of random y-positions for moving scatterers

%Plot histogram of probability of positions of moving scatterers:
hist_of_positions = histogramOfConfigurations(shifted_x+1i*shifted_y,z_full_2d);

fig = figure('Units','centimeters','Position',[10,10,10,7]);
ha = tight_subplot(1,1,.1,.1);      hold on;        box on;
imagesc(x_points./wavelength,x_points./wavelength,hist_of_positions)
plot(real(z_dipole_positions),imag(z_dipole_positions),'.','Color',col2,...
    'LineStyle','none','DisplayName',['Dipoles (' num2str(n_dipoles) ')'],...
    'MarkerSize',10)
axis image;     set(gca, 'YDir','reverse');
xlabel('x, \lambda');   ylabel('y, \lambda');
fig_pos = ha.Position.*[0.5 1.0 1 1];           set(gca,'Position',fig_pos);
set(gca,'XTick',get(gca,'YTick'));
clim([0 max(max(hist_of_positions))]);
c = colorbar;   c.Label.String = 'Probability';   c.Label.FontSize = get(gca,'FontSize');
c.Ticks = [0 max(max(hist_of_positions))];
c.TickLabels = [{'0'},{'max'}];
leg = legend('Location','bestoutside');
set(ha,'Position',[0.05 0.15 0.7 0.7])
set(c,'Position',[0.675 0.15 0.025 0.6])
fig_name = date + ', ' + num2str(n_dipoles) + ' dipoles, position probability';
saveFigure(fig,fig_name,save_path,{'png','fig'},0);

total_num_pos = sum(hist_of_positions,"all");               % total no. of positions for all moving scatterers generated

% Empty arrays generated before the for loops
optimized_phases = zeros(n_sources,1);
iter_phases = zeros(n_sources,1);
stepped_phases = zeros(n_sources,1);
stepped_st_dev = zeros(length(phase_steps),1);
stepped_int = zeros(length(phase_steps),1);
opt_idx = zeros(n_sources,1);
opt_standard_deviation = zeros(n_sources,1);
opt_intensity = zeros(n_sources,1);
opt_objective_func = zeros(n_sources,1);
all_intensities = [];
all_standard_deviations = [];
all_objective_func = [];

%Set up figures for tracking optimiser progress:
progressbar('Optimiser progress'); set(gcf,'Visible','on');
fig_progress = figure('Units','centimeters','Position',[2 2 10 8]);
ha = tight_subplot(2,1,.1,[.1 .2],[.14 .02]);

axes(ha(1));    box on;
p_obj = plot(0,1,'.-'); ylabel(['Obj. func. (' objective_function ')'])
ttl = 'Optimiser progress';     title(ttl);     ylim([0 inf]);
subplot_x = 0.15;       subplot_y = 0.55;
subplot_width = 0.75;    subplot_height = 0.4;
set(ha(1),'Position',[subplot_x subplot_y subplot_width subplot_height]);
set(ha(1),'XTickLabel',[]);

axes(ha(2));    box on; hold on;
p_int = plot(0,1,'.-','Color',col2,'DisplayName','Intensity'); 
p_std = plot(0,1,'.-','Color',col3,'DisplayName','St. dev.');
ylim([0 inf]);
xlabel('Iteration'); ylabel('Normalized value')
legend([p_int p_std],'Location','southwest')
set(ha(2),'Position',[subplot_x subplot_y-0.41 subplot_width subplot_height]);
stop_button = uicontrol('Style','togglebutton','String','Stop','BackgroundColor',[.8 0 0]);
stop_button.Position  = [15 5 60 20];

disp(['Setting up slow optimisation took ' num2str(toc) ' seconds.'])