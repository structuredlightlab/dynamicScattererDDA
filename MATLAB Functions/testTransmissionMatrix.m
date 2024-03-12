if do_transmission_matrix
    tic 
    switch fluct_plot_type
        case 'line'
            % Generate some colors to use in fluctuation plots:
            random_colors = rand(n_movements,1);    [~,~,random_color_idx] = unique(random_colors, 'stable');
            colors = default_cmap(round(linspace(1,175,n_movements)),:);
            
            fig = figure('Units','centimeters','Position',[10 10 15 4]);
            ha = tight_subplot(1,3,.1,.15,.15);     
            
            subplot_x = 0.05;      subplot_y = 0.15;
            subplot_width = 0.3;   subplot_height = 0.7;
            subplot_buffer = 0.015;
            
            axes(ha(1));  hold on;    box on;
            field_fluctuations = testDipoleMovement(transmission_matrix_input_field(:,1),n_movements,movement_stdev,...
                k0,alpha,z_full_2d,static_dipole_positions,moving_dipole_positions,z_sources,z_detectors);
            max_fluctuations = max(max(abs(field_fluctuations(:,:)).^2));
            for n = 1:size(field_fluctuations,2)
                plot(x_points./wavelength,(abs(field_fluctuations(:,n)).^2)./max_fluctuations,'Color',colors(random_color_idx(n),:))
            end
            plot(desired_field_points./wavelength,(abs(desired_foci(:,1)).^2),...
                'Color',col2,'DisplayName','ideal','LineStyle',':','LineWidth',1.5);
            text(-0.55*scale,0.89,['\xi = ' num2str(mean(std(abs(field_fluctuations),0,2))/mean(mean(abs(field_fluctuations).^2,1)),'%.2f')],...
                'FontName','cmss10','FontSize',get(groot,'defaultAxesFontSize'),'BackgroundColor',[1 1 1 0.5],'EdgeColor','black');
            xlabel('y, \lambda');   ylabel('Normalised intensity')
            set(ha(1),'Position',[subplot_x subplot_y subplot_width subplot_height])
            
            axes(ha(2));  hold on;    box on;
            field_fluctuations = testDipoleMovement(transmission_matrix_input_field(:,2),n_movements,movement_stdev,...
                k0,alpha,z_full_2d,static_dipole_positions,moving_dipole_positions,z_sources,z_detectors);
            max_fluctuations = max(max(abs(field_fluctuations(:,:)).^2));
            for n = 1:size(field_fluctuations,2)
                plot(x_points./wavelength,(abs(field_fluctuations(:,n)).^2)./max_fluctuations,'Color',colors(random_color_idx(n),:))
            end
            plot(desired_field_points./wavelength,(abs(desired_foci(:,2)).^2)./1,...
                'Color',col2,'DisplayName','ideal','LineStyle',':','LineWidth',1.5);
            xlabel('y, \lambda');
            text(-0.55*scale,0.89,['\xi = ' num2str(mean(std(abs(field_fluctuations),0,2))/mean(mean(abs(field_fluctuations).^2,1)),'%.2f')],...
                'FontName','cmss10','FontSize',get(groot,'defaultAxesFontSize'),'BackgroundColor',[1 1 1 0.5],'EdgeColor','black');
            set(ha(2),'Position',[subplot_x+subplot_width+subplot_buffer subplot_y subplot_width subplot_height],...
                'YTick',[])
            
            axes(ha(3));  hold on;    box on;
            field_fluctuations = testDipoleMovement(transmission_matrix_input_field(:,3),n_movements,movement_stdev,...
                k0,alpha,z_full_2d,static_dipole_positions,moving_dipole_positions,z_sources,z_detectors);
            max_fluctuations = max(max(abs(field_fluctuations(:,:)).^2));
            for n = 1:size(field_fluctuations,2)
                plot(x_points./wavelength,(abs(field_fluctuations(:,n)).^2)./max_fluctuations,'Color',colors(random_color_idx(n),:))
            end
            p1 = plot(desired_field_points./wavelength,(abs(desired_foci(:,3)).^2),...
                'Color',col2,'DisplayName','Desired int.','LineStyle',':','LineWidth',1.5);
            xlabel('y, \lambda');
            text(-0.55*scale,0.89,['\xi = ' num2str(mean(std(abs(field_fluctuations),0,2))...
                /mean(mean(abs(field_fluctuations).^2,1)),'%.2f')],...
                'FontName','cmss10','FontSize',get(groot,'defaultAxesFontSize'),...
                'BackgroundColor',[1 1 1 0.5],'EdgeColor','black');
            set(ha(3),'Position',[subplot_x+2*subplot_width+2*subplot_buffer subplot_y subplot_width subplot_height],...
                'YTick',[])
            legend(p1,'Location','north',...
                'Position',[subplot_x+2.46*subplot_width+4*subplot_buffer ...
                subplot_y+subplot_height+subplot_buffer...
                0.35*subplot_width 0.15*subplot_height])
            
            % max_y_lim = max([ha(1).YLim ha(2).YLim ha(3).YLim]);
            axis([ha(1) ha(2) ha(3)], [-inf inf 0 1])
            % title('Intensity fluctuations at detectors','Position',[-12.5 max_y_lim*1.01],...
            %     'FontWeight','normal','FontSize',1.1*get(groot,'defaultaxesfontsize'))
        case 'heatmap'
            fig = figure('Units','centimeters','Position',[10 10 15 5]);
            ha = tight_subplot(1,3,.1,.15,.15);     
            
            subplot_x = 0.06;      subplot_y = 0.175;
            subplot_width = 0.29;   subplot_height = 0.6;
            subplot_buffer = 0.015;
            
            axes(ha(1));  hold on;    box on;
            field_fluctuations = testDipoleMovement(transmission_matrix_input_field(:,1),n_movements,movement_stdev,...
                k0,alpha,z_full_2d,static_dipole_positions,moving_dipole_positions,z_sources,z_detectors);
            imagesc(1:n_movements,y_detectors,abs(field_fluctuations).^2)
            xlabel('Dipole configurations');   ylabel('y, \lambda')
            text(0.075*n_movements,-0.45*scale,['\xi = ' num2str(mean(std(abs(field_fluctuations),0,2))/mean(mean(abs(field_fluctuations).^2,1)),'%.2f')],...
                'FontName','cmss10','FontSize',get(groot,'defaultAxesFontSize'),'BackgroundColor',[1 1 1 0.5],'EdgeColor','black');
            set(ha(1),'Position',[subplot_x subplot_y subplot_width subplot_height],'YDir','reverse','ColorScale',color_scale)
            axis tight           
            switch color_scale
                case 'log'
                    clim([10e-32 1]);
                case 'linear'
                    % clim([0 1]);
            end

            axes(ha(2));  hold on;    box on;
            field_fluctuations = testDipoleMovement(transmission_matrix_input_field(:,2),n_movements,movement_stdev,...
                k0,alpha,z_full_2d,static_dipole_positions,moving_dipole_positions,z_sources,z_detectors);
            imagesc(1:n_movements,y_detectors,abs(field_fluctuations).^2)
            xlabel('Dipole configurations'); 
            text(0.075*n_movements,-0.45*scale,['\xi = ' num2str(mean(std(abs(field_fluctuations),0,2))/mean(mean(abs(field_fluctuations).^2,1)),'%.2f')],...
                'FontName','cmss10','FontSize',get(groot,'defaultAxesFontSize'),'BackgroundColor',[1 1 1 0.5],'EdgeColor','black');
            set(ha(2),'Position',[subplot_x+subplot_width+subplot_buffer subplot_y ...
                subplot_width subplot_height],'YDir','reverse','YTick',[],'ColorScale',color_scale)
            axis tight
            switch color_scale
                case 'log'
                    clim([10e-32 1]);
                case 'linear'
                    % clim([0 1]);
            end

            axes(ha(3));  hold on;    box on;
            field_fluctuations = testDipoleMovement(transmission_matrix_input_field(:,3),n_movements,movement_stdev,...
                k0,alpha,z_full_2d,static_dipole_positions,moving_dipole_positions,z_sources,z_detectors);
            max_fluctuations = max(max(abs(field_fluctuations(:,:)).^2));
            imagesc(1:n_movements,y_detectors,(abs(field_fluctuations).^2)./max_fluctuations)
            xlabel('Dipole configurations');  
            text(0.075*n_movements,-0.45*scale,['\xi = ' num2str(mean(std(abs(field_fluctuations),0,2))/mean(mean(abs(field_fluctuations).^2,1)),'%.2f')],...
                'FontName','cmss10','FontSize',get(groot,'defaultAxesFontSize'),'BackgroundColor',[1 1 1 0.5],'EdgeColor','black');
            set(ha(3),'Position',[subplot_x+2*subplot_width+2*subplot_buffer subplot_y ...
                subplot_width subplot_height],'YDir','reverse','YTick',[],'ColorScale',color_scale)
            axis tight
            switch color_scale
                case 'log'
                    clim([10e-32 1]);
                case 'linear'
                    % clim([0 1]);
            end

            c = colorbar;
            c.Label.String = 'Normalised intensity';
            c.Label.FontName = 'cmss10';
            c.Label.FontSize = get(groot,'defaultaxesfontsize');
            set(c,'Location','north','Position',[subplot_x subplot_y+subplot_height+subplot_buffer ...
                3*subplot_width+2*subplot_buffer 0.1*subplot_height])
    end
    disp(['Testing movement with transmission matrix fields took ' num2str(toc) ' seconds.']);
end