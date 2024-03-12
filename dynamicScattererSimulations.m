addpath('D:\Research\PhD_Thesis\MATLAB Functions')
% addpath('D:\Research\Simulations & Codes\Moving Scatterer simulations\DDA');

% Set up default settings
run('setFigureSettings.m')

% Where do to save the figures and data
save_path = "D:\Research\PhD_Thesis\Moving scatterers\Results\";
date = string(datetime('today'));
%%
tic
%% Set up simulation:

wavelength = 1; %633e-9;    % wavelength (in m)
n_dipoles = 100;             % no. of scatterers
percent_moving_dipoles = 15;% percentage of all dipoles that will move

scale = 25*wavelength;                                % width/height (in m) encompassing all dipole positions (not including extraspace around edge)
points_per_wavelength = 6;                             % plot resolution (must be at least 4 points per wavelength to capture electric field accurately and avoid aliasing)
run('setupDDAParameters.m')

percent_area = 0.35;
selection_method = 'circle';  
circle_centre = 0*(2 + 5*1i); % Centre of moving pocket of dipoles
[z_dipole_positions,static_dipole_positions,moving_dipole_positions,...
    n_dipoles,n_static_dipoles,n_moving_dipoles] = ...
    generateRandomDipoleConfiguration(n_dipoles,percent_moving_dipoles,...
    dipole_area,percent_area,selection_method,circle_centre);

x_extent_of_dipole_positions = (max(real(z_dipole_positions))-min(real(z_dipole_positions)))/wavelength;
y_extent_of_dipole_positions = (max(imag(z_dipole_positions))-min(imag(z_dipole_positions)))/wavelength;

% StDev of Gaussian motion of moving dipoles
movement_stdev = 1.25*wavelength; %(0.5*percent_area*dipole_area(1)); %*0.5;
n_movements = 55; % no. of random movements 

n_sources = ceil((box_width/wavelength)*4);             % no. of sources
n_detectors = ceil((box_width/wavelength)*4);                                % no. of outputs/detectors
% n_detectors = n_points_1D;                                % no. of outputs/detectors

x_sources = x_start*ones(n_sources,1);                  % x-positions of sources
y_sources = linspace(x_start, -x_start, n_sources)';    % y-positions of sources
z_sources = x_sources + 1i*y_sources;                      % [x y] positions of sources

x_detectors = -x_start*ones(n_detectors,1);             % x-positions of outputs
y_detectors = linspace(x_start, -x_start, n_detectors)';% y-positions of outputs
z_detectors = x_detectors + 1i*y_detectors;             % [x y] positions of sources

distances_dipoles_to_detectors = distanceAToB(z_dipole_positions,z_detectors);
%% 
% Plot everything to check the setup:

fraction_of_max_alpha = 1;
alpha = calculatePolarisability(k0,fraction_of_max_alpha);
run('initialSimulationSetupAndPlots.m')
%% Figure to test for paper supplementary

% fig = figure('Units','centimeters','Position',[10,10,11,7]);
% ha = tight_subplot(1,1,.1,.1); hold on;
% k0x = k0*x_points - min(k0*x_points);
% axes(ha);   hold on;
% imagesc(k0x,k0x,abs(initial_total_field).^2)
% plot(k0*real(z_dipole_positions)- min(k0*x_points), k0*imag(z_dipole_positions)- min(k0*x_points),'LineStyle','none','Marker','.','Color','w')
% viscircles([max(k0*x_points) max(k0*x_points)],percent_area*max(k0*x_points),"Color",'w','LineWidth',0.25);
% axis image
%% Phase conjugation:
% In this section of code, I simulate optical phase conjugation by first creating 
% a focus that I will aim to recreate using OPC. This wavefront is Int. at det. 
% through the scattering region to the sources, where the field on the sources 
% is phase conjugated and launched from the sources back to through the scattering 
% region and ultimately back to the detectors. 

do_phase_conjugation = false;
if do_phase_conjugation
    fraction_of_max_alpha = 1;
    alpha = calculatePolarisability(k0,fraction_of_max_alpha);
    focus_location = [-0.3*scale 0 0.3*scale];
    run('doPhaseConjugation.m')
    fig_name = 'medAlphaPhaseConj';
    saveFigure(fig,fig_name,save_path,{'png','fig'},0);
%% 
% Allow the moving dipoles to move and probe the intensity fluctuations at the 
% detector side of the scattering region.

    fluct_plot_type = 'heatmap';
    run('testPhaseConjugation.m')
    fig_name = 'medAlphaPhaseConjFluctuations';
    saveFigure(fig,fig_name,save_path,{'png','fig'},0);
end
%% Transmission matrix:
% In this section of code, I simulate measuring the transmission matrix of the 
% scattering region. Then, I apply this transmission matrix to create foci at 
% specified locations through the scattering region. 

do_transmission_matrix = false; 
if do_transmission_matrix
    fraction_of_max_alpha = 1;
    alpha = calculatePolarisability(k0,fraction_of_max_alpha);
    transmission_matrix_type = 'square';
    focus_location = [-0.3*scale 0 0.3*scale];
    run('doTransmissionMatrix.m')
end
%%
if do_transmission_matrix            
    cut_off = 40; % How many singular values to keep for inverse
    run('doTransmissionMatrixInverse.m')

    color_scale = 'linear';
    run('plotTransmissionMatrix.m')
    fig_name = ['TM_' num2str(cut_off) 'singValsInt'];
    saveFigure(fig,fig_name,save_path,{'png','fig'},0);
    
    fluct_plot_type = 'heatmap';
    run('testTransmissionMatrix.m')

    fig_name = ['TM_' num2str(cut_off) 'singValsFluctuations'];
    saveFigure(fig,fig_name,save_path,{'png','fig'},0);
end
%% GWS:
% In this section I calculate the GWS eigenfields for the fields that focus 
% on and avoid the scattering region. Here we approximate the scattering matrix 
% as only the transmission matrix.

do_GWS = false;
if do_GWS
    alpha_type = 'random';
    delta_alpha = 0.01;
    
    fraction_of_max_alpha = 0.1;
    alpha = calculatePolarisability(k0,fraction_of_max_alpha);

    run('doGWS.m')

    color_scale = 'log';
    run('plotGWS.m')
    fig_name = date + ', ' + num2str(n_dipoles) + ' dipoles, Q' + alpha_type + ' intensities';
    fig_name = ['lowAlphaQ' alpha_type 'Int_' color_scale];
    saveFigure(fig,fig_name,save_path,{'png','fig'},0);

    color_scale = 'linear';
    run('plotGWS.m')
    fig_name = date + ', ' + num2str(n_dipoles) + ' dipoles, Q' + alpha_type + ' intensities';
    fig_name = ['lowAlphaQ' alpha_type 'Int_' color_scale];
    saveFigure(fig,fig_name,save_path,{'png','fig'},0);
end
if do_GWS
    run('doGWSXi.m')
    fig_name = date + ', ' + num2str(n_dipoles) + ' dipoles, Q' + alpha_type + ', xi';
    fig_name = ['lowAlphaQ' alpha_type 'Xi'];
    saveFigure(fig,fig_name,save_path,{'png','fig'},0);
end
%% 
% Allow the moving dipoles to move and probe the intensity fluctuations at the 
% detector side of the scattering region.

if do_GWS
    [~, idx_min_xi] = min(xi_GWS,[],'all','linear');
    [~, idx_max_xi] = max(xi_GWS,[],'all','linear');
    [~, idx_med_xi] = min(abs(xi_GWS - median(xi_GWS)));
    idx_to_plot = [idx_max_xi idx_med_xi idx_min_xi]; 
    fluct_plot_type = 'heatmap';
    run('testGWS.m')  
    fig_name = date + ', ' + num2str(n_dipoles) + ' dipoles, Q' + alpha_type + ', int fluctuations';
    fig_name = ['lowAlphaQ' alpha_type 'IntFluctuations']
    saveFigure(fig,fig_name,save_path,{'png','fig'},0);
end
%% Slow optimization:

do_slow_optm = false;
if do_slow_optm
    n_iter = 150;                                        % no. of optimization loops to execute

    % Select the objective function to use.
    % Can be 'std/int' or 'std'
    objective_function = 'std/int';
    phase_step_size = (1*pi/10);                        % size of phase steps
    
    fraction_of_max_alpha = 1;
    alpha = calculatePolarisability(k0, fraction_of_max_alpha);
    run('setupSlowOptimisation.m')
%% 
% Perform optimisation:

    run('doSlowOptimisation.m')
    fig_name = 'slowOptObjFunc';
    saveFigure(fig,fig_name,save_path,{'png','fig'},0);    
end
%% 
% Test optimised solution with movement of dipoles and plot results:

if do_slow_optm
    color_scale = 'linear';
    fluct_plot_type = 'line';
    run('testSlowOptimisation.m')  

    color_scale = 'log';
    run('testSlowOptimisation.m') 
end
%% Plotting for paper supplementary

% fig = figure('Units','centimeters','Position',[10,10,8,5]);
% ha = tight_subplot(1,1,.1,.1); hold on; 
% plot((1:counter-1)./n_sources,plot_obj_func./plot_obj_func(1),'Color','b')
% axis([0 inf 0 inf])
% fig_name = 'FOM';
% saveFigure(fig,fig_name,save_path,{'png','fig'},0);
% 
% 
% plot_initial_field = initial_total_field;
% plot_initial_field(isnan(plot_initial_field)) = 0;
% 
% upscale = 5;
% fig = figure('Units','centimeters','Position',[10,10,11,11]);
% ha = tight_subplot(1,1,.1,.1); hold on; 
% sc_im = showComplexField(plot_initial_field);
% imshow(sc_im,'XData',[0 upscale*scale],'YData',[0 upscale*scale])
% hold on; box on;
% % axes(cha)
% plot(upscale*(real(z_dipole_positions)- min(x_points)), ...
%     upscale*(imag(z_dipole_positions)- min(x_points)),...
%     'LineStyle','none','Marker','.','Color','w')
% viscircles(upscale*[median(x_points- min(x_points)),...
%     median(x_points- min(x_points))],...
%     upscale*percent_area*(max(x_points)),...
%     'Color','w','LineWidth',0.5);
% set(ha,'YDir','normal');
% fig_name = 'Before';
% saveFigure(fig,fig_name,save_path,{'png','fig'},0);
% 
% 
% plot_opt_field = optimised_total_field;
% plot_opt_field(isnan(plot_opt_field)) = 0;
% 
% fig = figure('Units','centimeters','Position',[10,10,11,11]);
% ha = tight_subplot(1,1,.1,.1); hold on; 
% sc_im = showComplexField(plot_opt_field);
% imshow(sc_im,'XData',[0 upscale*scale],'YData',[0 upscale*scale])
% hold on; box on;
% % axes(cha)
% plot(upscale*(real(z_dipole_positions)- min(x_points)), ...
%     upscale*(imag(z_dipole_positions)- min(x_points)),...
%     'LineStyle','none','Marker','.','Color','w')
% viscircles(upscale*[median(x_points- min(x_points)),...
%     median(x_points- min(x_points))],...
%     upscale*percent_area*(max(x_points)),...
%     'Color','w','LineWidth',0.5);
% set(ha,'YDir','normal');
% fig_name = 'After';
% saveFigure(fig,fig_name,save_path,{'png','fig'},0);
%% Deposition matrix:

do_deposition_matrix = false;
if do_deposition_matrix
    fraction_of_max_alpha = 1;
    alpha_mod = (4/k02)*fraction_of_max_alpha;
    alpha_arg = asin(0.25*alpha_mod*k02);
    alpha = alpha_mod*exp(1i*alpha_arg);
    
    color_scale = 'linear';
    run('doDepositionMatrix.m')
    % fig_name = date + ', ' + num2str(n_dipoles) + ' dipoles, deposition matrix, intensities';
    fig_name = 'maxAlphaDepMatInt'
    saveFigure(fig,fig_name,save_path,{'png','fig'},0);

    color_scale = 'log';
    run('doDepositionMatrix.m')
    % fig_name = date + ', ' + num2str(n_dipoles) + ' dipoles, deposition matrix, intensities';
    fig_name = 'maxAlphaDepMatLogInt'
    saveFigure(fig,fig_name,save_path,{'png','fig'},0);    

    run('doDepositionMatrixXi.m')
    % fig_name = date + ', ' + num2str(n_dipoles) + ' dipoles, deposition matrix, xi';
    fig_name = 'maxAlphaDepMatXi'
    saveFigure(fig,fig_name,save_path,{'png','fig'},0);

    [~, idx_min_xi] = min(xi_dep,[],'all','linear');
    [~, idx_max_xi] = max(xi_dep,[],'all','linear');
    [~, idx_med_xi] = min(abs(xi_dep - median(xi_dep)));
    idx_to_plot = [idx_max_xi idx_med_xi idx_min_xi];  
    fluct_plot_type = 'heatmap';
    color_scale = 'log';
    run('testDepositionMatrix.m')
    % fig_name = date + ', ' + num2str(n_dipoles) + ' dipoles, deposition matrix, int fluctuations';
    fig_name = 'maxAlphaDepMatIntFluctuations'
    saveFigure(fig,fig_name,save_path,{'png','fig'},0);

end
%% Time-averaged transmission matrix:

do_time_avg_tm = false;
if do_time_avg_tm
    fraction_of_max_alpha = 1;
    alpha = calculatePolarisability(k0,fraction_of_max_alpha);
    run('doTimeAvgTM.m')
    run('doTimeAvgTMXi.m')
end
%%
if do_time_avg_tm    
    color_scale = 'log';
    idx_to_plot = round(linspace(1,length(abs_eigvals_tavg),8));
    run('doTimAvgTMPlot.m')
    fig_name = ['TavgEigenfieldsInt_' color_scale];
    saveFigure(fig,fig_name,save_path,{'png','fig'},0);

    color_scale = 'linear';
    idx_to_plot = round(linspace(1,length(abs_eigvals_tavg),8));
    run('doTimAvgTMPlot.m')
    fig_name = ['TavgEigenfieldsInt_' color_scale];
    saveFigure(fig,fig_name,save_path,{'png','fig'},0);

    [~, idx_min_xi] = min(xi_tavg,[],'all','linear');
    [~, idx_max_xi] = max(xi_tavg,[],'all','linear');
    [~, idx_med_xi] = min(abs(xi_tavg - median(xi_tavg)));
    idx_to_plot = [idx_max_xi idx_med_xi idx_min_xi];
    fluct_plot_type = 'heatmap';
    run('testTimeAvgTM.m')    
end
%% Fast optimisation, v1:
% Using Simon's fast gradient descent optimiser derivation

do_fast_opt_1 = false;
if do_fast_opt_1
    n_iter = 1;
    dj = 0.01;
    fraction_of_max_alpha = 1;
    alpha = calculatePolarisability(k0, fraction_of_max_alpha); 
    run('doFastOptimisation1.m')

    fig_name = 'fastOptv1_Xi'
    saveFigure(fig,fig_name,save_path,{'png','fig'},0);
end
%%
if do_fast_opt_1    
    color_scale = 'linear';
    fluct_plot_type = 'heatmap';
    run('testFastOptimisation1.m')

    color_scale = 'log';
    run('testFastOptimisation1.m')
end
%% Fast optimisation, v2:

do_fast_opt_2 = true;
if do_fast_opt_2
    n_iter = 90;
    dj = 0.01;
    fraction_of_max_alpha = 1;
    alpha = calculatePolarisability(k0, fraction_of_max_alpha); 
    run('doFastOptimisation2.m')   

    disp(['Fast optimiser v2 took ' num2str(toc) ' seconds.'])
end
%%
if do_fast_opt_2    
    color_scale = 'log';
    fluct_plot_type = 'heatmap';
    run('testFastOptimisation2.m')

    color_scale = 'linear';
    run('testFastOptimisation2.m')
end
%% Fast optimisation, v3:

% do_fast_opt_3 = false;
% n_iter = 250;
% dj = 0.01;
% 
% % movement_stdev = 0
% run('doFastOptimisation3.m')
% if do_fast_opt_3
%     % fig_name = date + ', ' + num2str(n_dipoles) + ' dipoles, fast opt 3, xi';
%     % saveFigure(fig,fig_name,save_path,{'png','fig'},0);
% 
%     color_scale = 'linear';
%     run('testFastOptimisation3.m')
%     % fig_name = date + ', ' + num2str(n_dipoles) + ' dipoles, fast optimiser 3 results';
%     % saveFigure(fig,fig_name,save_path,{'png','fig'},0);
% end
%%
% save(fullfile(save_path,[num2str(n_dipoles),' scatterers, ' num2str(n_move) ' moving, ', date]))
% % Save a .m version of this code for version control pu0rposes
% exported_to_m_file = export("dynamicScattererSimulations.mlx","dynamicScattererSimulations.m");