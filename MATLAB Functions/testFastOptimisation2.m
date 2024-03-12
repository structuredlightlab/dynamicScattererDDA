tic

subplot_x = 0.1;      subplot_y = 0.2;
subplot_width = 0.5;   subplot_height = 0.75;
fig = figure('Units','centimeters','Position',[10,10,11,5]);
ha = tight_subplot(1,1,.1,.15,.15);
axes(ha);   hold on;    box on;
yyaxis left
plot(1:n_iter,xi_fast_1./max(xi_fast_1),'DisplayName','\xi')
plot(1:n_iter,intensity./max(intensity),'DisplayName','Mean int.')
plot(1:n_iter,standard_dev./max(standard_dev),'DisplayName','Mean st. dev.')
ylabel('Normalised value')
axis([1 n_iter 0 1])
yyaxis right
plot(1:n_iter,normalised_fom./normalised_fom(1),'DisplayName','F. O. M.')
xlabel('Iteration')
ylabel('Normalised value')
legend('Location','bestoutside')
% axis([1 n_iter -inf inf])
set(ha,'Position',[subplot_x subplot_y subplot_width subplot_height]);
fig_name = 'fastOptv2_Xi';
saveFigure(fig,fig_name,save_path,{'png','fig'},0);

% Generate some colors to use in fluctuation plots:
random_colors = rand(n_movements,1);    [~,~,random_color_idx] = unique(random_colors, 'stable');
colors = default_cmap(round(linspace(1,175,n_movements)),:);

[optimised_total_field,~] = DDA_true2D(k0,alpha,z_full_2d,exclusion_radius,...
    z_sources,optimised_field,z_dipole_positions,show_pol_plots);

%Calculate fluctuations of the initial and optimised fields:
fig = figure('Units','centimeters','Position',[10 10 15 15]);
ha = tight_subplot(1,2,.1,.15,.15);

subplot_x = 0.05;      subplot_y = 0.15;
subplot_width = 0.3;   subplot_height = subplot_width;
subplot_buffer = 0.02;

axes(ha(1));    hold on;    box on;
imagesc(x_points./wavelength,x_points./wavelength,...
    (abs(initial_total_field).^2)...
    ./max(max(abs(initial_total_field(:,:)).^2)));
plot(real(z_dipole_positions)/(wavelength),...
    imag(z_dipole_positions)/(wavelength),'LineStyle','none',...
    'Marker','.','MarkerSize',10,'Color',col6)
plot(real(moving_dipole_positions)/(wavelength),...
    imag(moving_dipole_positions)/(wavelength),'LineStyle','none',...
    'Marker','o','MarkerSize',10,'Color',col6)
set(ha(1),'Position',[subplot_x subplot_y subplot_width subplot_height],...
    'Color', 'w','YDir','reverse','ColorScale',color_scale,...
    'YTick',get(ha(1),'XTick'));
axis image;     xlabel('x, \lambda');   ylabel('y, \lambda');
title('Plane wave','FontName','cmss10','FontSize',1.1*get(groot,'defaultAxesFontSize'),...
    'FontWeight','normal');
  
axes(ha(2));    hold on;    box on;
imagesc(x_points./wavelength,x_points./wavelength,...
    (abs(optimised_total_field).^2)...
    ./max(max(abs(optimised_total_field(:,:)).^2)));
p1 = plot(real(z_dipole_positions)/(wavelength),...
    imag(z_dipole_positions)/(wavelength),'LineStyle','none',...
    'Marker','.','MarkerSize',10,'Color',col6,...
    'DisplayName',['Dipoles (' num2str(n_dipoles) ')']);
plot(real(moving_dipole_positions)/(wavelength),...
    imag(moving_dipole_positions)/(wavelength),'LineStyle','none',...
    'Marker','o','MarkerSize',10,'Color',col6)
axis image;     xlabel('x, \lambda');   
set(ha(2),'Position',[subplot_x+subplot_width+subplot_buffer...
    subplot_y subplot_width subplot_height],...
    'Color', 'w','YDir','reverse','ColorScale',color_scale,...
    'YTick',[]);
title('Optimised wave','FontName','cmss10','FontSize',1.1*get(groot,'defaultAxesFontSize'),...
    'FontWeight','normal');
legend(p1,'Position',[subplot_x+1.5*subplot_width+subplot_buffer subplot_y+subplot_height+1.5*subplot_buffer ...
    0.5*subplot_width 0.1*subplot_height])
  
c = colorbar('northoutside');       c.Label.String = 'Normalised intensity';   
c.Label.FontSize = get(groot,'defaultaxesfontsize');
c.Label.FontName = 'cmss10';
set(c,'Position',[subplot_x subplot_y+subplot_height+1.5*subplot_buffer ...
    1.475*subplot_width 0.05*subplot_height])

fig_name = ['fastOptInt_v2_' color_scale];
saveFigure(fig,fig_name,save_path,{'png'},0);
saveFigure(fig,fig_name,save_path,{'fig'},0);

switch fluct_plot_type
        case 'line'    
            % Generate some colors to use in fluctuation plots:
            random_colors = rand(n_movements,1);    [~,~,random_color_idx] = unique(random_colors, 'stable');
            colors = default_cmap(round(linspace(1,175,n_movements)),:);
            
            fig = figure('Units','centimeters','Position',[10 10 15 4]);
            ha = tight_subplot(1,2,.1,.15,.15);     
            
            subplot_x = 0.05;      subplot_y = 0.2;
            subplot_width = 0.4;   subplot_height = 0.7;
            subplot_buffer = 0.015;
            
            axes(ha(1));  hold on;    box on;
            field_fluctuations = testDipoleMovement(source_field,n_movements,movement_stdev,...
                k0,alpha,z_full_2d,static_dipole_positions,moving_dipole_positions,z_sources,z_detectors);
            max_fluctuations = max(max(abs(field_fluctuations(:,:)).^2));
            for n = 1:size(field_fluctuations,2)
                plot(x_points./wavelength,(abs(field_fluctuations(:,n)).^2)./max_fluctuations,'Color',colors(random_color_idx(n),:))
            end
            xlabel('y, \lambda');   ylabel('Normalised intensity')
            text(0.45*scale,0.9,num2str(idx_to_plot(1)),'FontName','cmss10','FontSize',get(groot,'defaultAxesFontSize'),...
                'BackgroundColor',[1 1 1 0.5]);
            text(-0.55*scale,0.89,['\xi = ' num2str(xi_GWS(idx_to_plot(1)),'%.2f')],...
                'FontName','cmss10','FontSize',get(groot,'defaultAxesFontSize'),'BackgroundColor',[1 1 1 0.5],'EdgeColor','black');
            set(ha(1),'Position',[subplot_x subplot_y subplot_width subplot_height])
            
            axes(ha(2));  hold on;    box on;
            field_fluctuations = testDipoleMovement(optimised_field,n_movements,movement_stdev,...
                k0,alpha,z_full_2d,static_dipole_positions,moving_dipole_positions,z_sources,z_detectors);
            max_fluctuations = max(max(abs(field_fluctuations(:,:)).^2));
            for n = 1:size(field_fluctuations,2)
                plot(x_points./wavelength,(abs(field_fluctuations(:,n)).^2)./max_fluctuations,'Color',colors(random_color_idx(n),:))
            end
            xlabel('y, \lambda');
            text(0.45*scale,0.9,num2str(idx_to_plot(2)),'FontName','cmss10','FontSize',get(groot,'defaultAxesFontSize'),...
                'BackgroundColor',[1 1 1 0.5]);
            text(-0.55*scale,0.89,['\xi = ' num2str(xi_GWS(idx_to_plot(2)),'%.2f')],...
                'FontName','cmss10','FontSize',get(groot,'defaultAxesFontSize'),'BackgroundColor',[1 1 1 0.5],'EdgeColor','black');
            set(ha(2),'Position',[subplot_x+subplot_width+subplot_buffer subplot_y subplot_width subplot_height],...
                'YTick',[])
            
        case 'heatmap'
            fig = figure('Units','centimeters','Position',[10 10 15 15]);
            ha = tight_subplot(1,2,.1,.15,.15);     
            
            subplot_x = 0.06;      subplot_y = 0.175;
            subplot_width = 0.4;   subplot_height = 0.3;
            subplot_buffer = 0.015;
            
            axes(ha(1));  hold on;    box on;
            field_fluctuations = testDipoleMovement(source_field,n_movements,movement_stdev,...
                k0,alpha,z_full_2d,static_dipole_positions,moving_dipole_positions,z_sources,z_detectors);
            imagesc(1:n_movements,y_detectors,abs(field_fluctuations).^2)
            xlabel('Dipole configurations');   ylabel('y, \lambda')
            text(0.075*n_movements,-0.45*scale,['\xi = ' num2str(mean(std(abs(field_fluctuations),0,2))/mean(mean(abs(field_fluctuations).^2,1)),'%.2f')],...
                'FontName','cmss10','FontSize',get(groot,'defaultAxesFontSize'),'BackgroundColor',[1 1 1 0.5],'EdgeColor','black');
            text(0.075*n_movements,0.45*scale,'Plane wave',...
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
            field_fluctuations = testDipoleMovement(optimised_field,n_movements,movement_stdev,...
                k0,alpha,z_full_2d,static_dipole_positions,moving_dipole_positions,z_sources,z_detectors);
            imagesc(1:n_movements,y_detectors,(abs(field_fluctuations).^2)./max(max(abs(field_fluctuations).^2)))
            xlabel('Dipole configurations'); 
            text(0.075*n_movements,-0.45*scale,['\xi = ' num2str(mean(std(abs(field_fluctuations),0,2))/mean(mean(abs(field_fluctuations).^2,1)),'%.2f')],...
                'FontName','cmss10','FontSize',get(groot,'defaultAxesFontSize'),'BackgroundColor',[1 1 1 0.5],'EdgeColor','black');
            text(0.075*n_movements,0.45*scale,'Optimised field',...
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

            c = colorbar;
            c.Label.String = 'Normalised intensity';
            c.Label.FontName = 'cmss10';
            c.Label.FontSize = get(groot,'defaultaxesfontsize');
            set(c,'Location','north','Position',[subplot_x subplot_y+subplot_height+subplot_buffer ...
                2*subplot_width+subplot_buffer 0.1*subplot_height])
    end
    fig_name = ['fastOptIntFluctuations_v2_' color_scale];
    saveFigure(fig,fig_name,save_path,{'png','fig'},0);
disp(['Testing movement with fast optimiser v2 took ' num2str(toc) ' seconds.'])