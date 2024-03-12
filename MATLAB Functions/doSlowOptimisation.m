if do_slow_optm
    %The optimisation:
    counter = 1;
    choices_made = zeros(n_iter*n_sources,1);
    for iter = 1:n_iter                     % for-loop over the number of optimization loops
        for s = 1:n_sources                 % for-loop over all sources
            iter_phases = optimized_phases;
            stepped_phases = optimized_phases;
            for n = 1:length(phase_steps)   % for-loop over all phase steps
                stepped_phases(s) = iter_phases(s) + phase_steps(n);
                stepped_field = source_amps.*exp(1i*stepped_phases);
                stepped_field = stepped_field./norm(stepped_field);
    
                source_at_detectors = sourceAtDetectors(k0,stepped_field,z_sources,z_detectors);
    
                field_fluctuations = zeros(n_detectors,n_movements);
                parfor p = 1:n_movements
                    z_shifted_dipole_positions = shifted_x(:,iter,s,n,p) + 1i*shifted_y(:,iter,s,n,p);
                    [total_field,~] = DDA_true2D_onlyOutputs(k0,alpha,z_detectors,z_sources,...
                        stepped_field,source_at_detectors,...
                        [static_dipole_positions; z_shifted_dipole_positions]);
                    field_fluctuations(:,p) = total_field;
                end
                intensity_fluctuations_at_detectors = abs(field_fluctuations).^2;
    
                stepped_st_dev(n) = mean(std(abs(field_fluctuations),0,2));% standard deviation of output field for each position of moving scatterers
                stepped_int(n) = mean(intensity_fluctuations_at_detectors,"all");            % intensity of output field for each position of moving scatterers
            end
    
            switch objective_function
                case 'std'
                    [opt_objective_func(s),opt_idx(s)] = min(stepped_st_dev);  % find minimum standard deviation change to source
                case 'std/int'
                    [opt_objective_func(s),opt_idx(s)] = min(stepped_st_dev./stepped_int);
            end
    
            opt_standard_deviation(s) = stepped_st_dev(opt_idx(s));
            opt_intensity(s) = stepped_int(opt_idx(s));                                 % intensity corresponding to minimum standard deviation
            optimized_phases(s) = iter_phases(s) + phase_steps(opt_idx(s));
            
            choices_made(counter) = opt_idx(s);
            
            plot_obj_func(counter) = opt_objective_func(s);
            plot_int(counter) = opt_intensity(s);
            plot_std(counter) = opt_standard_deviation(s);
    
            p_obj.XData = (0:counter-1)/n_sources;  p_obj.YData = plot_obj_func./plot_obj_func(1);
            p_int.XData = (0:counter-1)/n_sources;  p_int.YData = plot_int./plot_int(1);
            p_std.XData = p_int.XData;              p_std.YData = plot_std./plot_std(1);
            drawnow
    
            counter = counter + 1;
            if stop_button.Value; break; end
        end
        
        
        if rem(iter,10); progressbar(iter/n_iter); end
        if stop_button.Value; break; end
    end
    progressbar(1)
    close(fig_progress)
    
    disp(['Slow optimization took ' num2str(toc) ' seconds.']);
    
    %Plot of objective function:
    fig = figure('Units','centimeters','Position',[10 10 15 15]);
    ha = tight_subplot(1,1,.1,.15,.1); hold on; box on; grid on;

    subplot_x = 0.15;      subplot_y = 0.2;
    subplot_width = 0.4;   subplot_height = 0.25;

    plot((1:counter-1)./n_sources,plot_int./plot_int(1),'Color',col2)                                     
    plot((1:counter-1)./n_sources,plot_std./plot_std(1),'Color',col3)
    plot((1:counter-1)./n_sources,plot_obj_func./plot_obj_func(1),'Color',col1)
    % title(['Optimiser performance over ',num2str(floor(counter/n_sources)),' optimizations'],...
    %     'FontName','cmss10','FontSize',1.1*get(groot,'defaultAxesFontSize'),'FontWeight','normal')
    axis tight; ylim([0 inf]);
    xlabel('Iteration');   ylabel('Normalized quantity')
    legend('Mean int.','Mean st. dev.','\xi','Location','northeastoutside')
    set(ha,'Position',[subplot_x subplot_y subplot_width subplot_height])
end