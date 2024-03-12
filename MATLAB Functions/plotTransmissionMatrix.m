if do_transmission_matrix
    tic
    % inverse_type = 'inv';
    %     switch inverse_type
    %         case 'pinv'
    %             inverse_transmission_matrix = pinv(transmission_matrix);
    %         case 'ctranspose'
    %             inverse_transmission_matrix = ctranspose(transmission_matrix);
    %             % This gives same results as phase conjugation
    %         case 'inv'
    %             % This ONLY works for square transmission matrices!!!
    %             if size(transmission_matrix,1) == size(transmission_matrix,2)
    %                 % inverse_transmission_matrix = inv(transmission_matrix);
    %                 inverse_transmission_matrix = ...
    %                     pinv(transmission_matrix,s_tolerance);
    % 
    %                 % inv() actually doesn't work for square matrices
    %                 % either, lol
    %             else
    %                 disp('NOT a square transmission matrix! Cannot calculate inverse. Calculating psuedoinverse instead.')
    %                 inverse_transmission_matrix = ...
    %                     pinv(transmission_matrix,s_tolerance);
    %             end
    %     end

    % What field do we want to create at the output using the transmission
    % matrix?
    n_foci = length(focus_location);

    transmission_matrix_fields = zeros(n_points_1D,n_points_1D,n_foci);
    desired_foci = zeros(length(desired_field_points),n_foci);
    transmission_matrix_input_field = zeros(n_sources,n_foci);
    k = 0;
    for f = focus_location
        k = k + 1;

        desired_field_amp = Gaussian1D(desired_field_points,f,0.05*abs(2*x_start),1,0);
        desired_field_phase = zeros(size(desired_field_points));
        desired_field = desired_field_amp.*exp(1i*desired_field_phase);
        desired_foci(:,k) = desired_field;

        needed_input = inverse_transmission_matrix*desired_field;
        needed_input = needed_input./norm(needed_input);
        transmission_matrix_input_field(:,k) = needed_input;
    
        [transmission_matrix_field,~] = DDA_true2D(k0,alpha,z_full_2d,exclusion_radius,...
            z_sources,needed_input,z_dipole_positions,show_pol_plots);
        transmission_matrix_fields(:,:,k) = transmission_matrix_field;
    end

    fig = figure('Units','centimeters','Position',[10 10 15 15]);
    ha = tight_subplot(1,6,.1,.15,.15);
    
    subplot_x = 0.046;      subplot_y = 0.15;
    subplot_width = 0.2;   subplot_height = subplot_width;
    subplot_buffer = 0.0375;

    axes(ha(1));    hold on;    box on;
    imagesc(x_points./wavelength,x_points./wavelength,...
        (abs(transmission_matrix_fields(:,:,1)).^2)...
        ./max(max(abs(transmission_matrix_fields(:,:,1)).^2)));
    plot(real(z_dipole_positions)/(wavelength),...
        imag(z_dipole_positions)/(wavelength),'LineStyle','none',...
        'Marker','.','MarkerSize',7,'Color',col6)
    plot(real(moving_dipole_positions)/(wavelength),...
        imag(moving_dipole_positions)/(wavelength),'LineStyle','none',...
        'Marker','o','MarkerSize',7,'Color',col6)
    switch color_scale
            case 'log'
                clim([10e-32 1]);
            case 'linear'
                clim([0 1]);
    end
    axis image;     xlabel('x, \lambda');   ylabel('y, \lambda');
    c = colorbar('northoutside');       c.Label.String = 'Normalised intensity';   
    c.Label.FontSize = get(groot,'defaultaxesfontsize');
    set(ha(1),'Position',[subplot_x subplot_y subplot_width subplot_height],...
        'Color', 'w','YDir','reverse','YTick',get(ha(1),'XTick'),'ColorScale',color_scale);
      
    axes(ha(2));    hold on;    box on;
    plot((abs(transmission_matrix_fields(:,end,1)).^2)...
        ./max(max(abs(transmission_matrix_fields(:,end,1)).^2)),...
        x_points,'Color',col1,'DisplayName','Int. at det.');
    focus_normalisation = 1; %max(max(abs(transmission_matrix_fields(:,end,1)).^2)./max(max(abs(transmission_matrix_fields(:,:,1)).^2)));
    ax_lim = 0; % min(min(abs(transmission_matrix_fields(:,end,1)).^2)./max(max(abs(transmission_matrix_fields(:,:,1)).^2)));
    plot(focus_normalisation.*(abs(desired_foci(:,1)).^2)./max(abs(desired_foci(:,1)).^2),...
        desired_field_points./wavelength,'Color',col7,'DisplayName','Desired int.','LineStyle',':','LineWidth',1.5);
    set(ha(2),'Position',[subplot_x+subplot_width+0.25*subplot_buffer subplot_y ...
        0.4*subplot_width subplot_height],...
        'YDir','reverse','XAxisLocation','top','YTick',[],'XScale',color_scale);
    axis([ax_lim inf x_start -x_start])

    axes(ha(3));    hold on;    box on;
    imagesc(x_points./wavelength,x_points./wavelength,...
        (abs(transmission_matrix_fields(:,:,2)).^2)...
        ./max(max(abs(transmission_matrix_fields(:,:,2)).^2)));
    plot(real(z_dipole_positions)/(wavelength),...
        imag(z_dipole_positions)/(wavelength),'LineStyle','none',...
        'Marker','.','MarkerSize',7,'Color',col6)
    plot(real(moving_dipole_positions)/(wavelength),...
        imag(moving_dipole_positions)/(wavelength),'LineStyle','none',...
        'Marker','o','MarkerSize',7,'Color',col6)
    switch color_scale
            case 'log'
                clim([10e-32 1]);
            case 'linear'
                clim([0 1]);
    end
    axis image;     xlabel('x, \lambda');   
    set(ha(3),'Position',[subplot_x+1.4*subplot_width+1.25*subplot_buffer...
        subplot_y subplot_width subplot_height],...
        'Color', 'w','YDir','reverse','YTick',get(ha(1),'XTick'),'ColorScale',color_scale);
    
    axes(ha(4));    hold on;    box on;
    plot((abs(transmission_matrix_fields(:,end,2)).^2)...
        ./max(max(abs(transmission_matrix_fields(:,end,2)).^2)),...
        x_points,'Color',col1,'DisplayName','Int. at det.');
    % focus_normalisation = max(max(abs(transmission_matrix_fields(:,end,2)).^2)./max(max(abs(transmission_matrix_fields(:,:,2)).^2)));
    % ax_lim = min(min(abs(transmission_matrix_fields(:,end,2)).^2)./max(max(abs(transmission_matrix_fields(:,end,2)).^2)));
    plot(focus_normalisation.*(abs(desired_foci(:,2)).^2)./max(abs(desired_foci(:,2)).^2),...
        desired_field_points./wavelength,'Color',col7,'DisplayName','Desired int.','LineStyle',':','LineWidth',1.5);
    set(ha(4),'Position',[subplot_x+2.4*subplot_width+1.5*subplot_buffer subplot_y ...
        0.4*subplot_width subplot_height],...
        'YDir','reverse','XAxisLocation','top','YTick',[],'XScale',color_scale);
    axis([ax_lim inf x_start -x_start])

    axes(ha(5));    hold on;    box on;
    imagesc(x_points./wavelength,x_points./wavelength,...
        (abs(transmission_matrix_fields(:,:,3)).^2)...
        ./max(max(abs(transmission_matrix_fields(:,:,3)).^2)));
    p0 = plot(real(z_dipole_positions)/(wavelength),...
        imag(z_dipole_positions)/(wavelength),'LineStyle','none',...
        'Marker','.','MarkerSize',7,'Color',col6,...
        'DisplayName',['Dipoles (' num2str(n_dipoles) ')']);
    plot(real(moving_dipole_positions)/(wavelength),...
        imag(moving_dipole_positions)/(wavelength),'LineStyle','none',...
        'Marker','o','MarkerSize',7,'Color',col6)
    switch color_scale
        case 'log'
            clim([10e-32 1]);
        case 'linear'
            clim([0 1]);
    end
    axis image;     xlabel('x, \lambda');   
    set(ha(5),'Position',[subplot_x+2.8*subplot_width+2.5*subplot_buffer subplot_y ...
        subplot_width subplot_height],...
        'Color', 'w','YDir','reverse','YTick',get(ha(1),'XTick'),'ColorScale',color_scale);
        
    axes(ha(6));    hold on;    box on;
    p1 = plot((abs(transmission_matrix_fields(:,end,3)).^2)...
        ./max(max(abs(transmission_matrix_fields(:,end,3)).^2)),...
        x_points,'Color',col1,'DisplayName','Int. at det.');
    % focus_normalisation = max(max(abs(transmission_matrix_fields(:,end,3)).^2)./max(max(abs(transmission_matrix_fields(:,:,3)).^2)));
    % ax_lim = min(min(abs(transmission_matrix_fields(:,end,3)).^2)./max(max(abs(transmission_matrix_fields(:,end,3)).^2)));
    p2 = plot(focus_normalisation.*(abs(desired_foci(:,3)).^2)./max(abs(desired_foci(:,3)).^2),...
        desired_field_points./wavelength,'Color',col7,'DisplayName','Desired int.','LineStyle',':','LineWidth',1.5);
    set(ha(6),'Position',[subplot_x+3.8*subplot_width+2.75*subplot_buffer subplot_y ...
        0.4*subplot_width subplot_height],...
        'YDir','reverse','XAxisLocation','top','YTick',[],'XScale',color_scale);
    axis([ax_lim inf x_start -x_start])

    legend([p0 p1 p2],'Location','southoutside','Position',[subplot_x+3.8*subplot_width+1.25*subplot_buffer ...
        subplot_y+subplot_height+1.0*subplot_buffer 0.5*subplot_width 0.3*subplot_height])
   
    set(c,'Position',[subplot_x subplot_y+subplot_height+1.0*subplot_buffer...
        0.74 0.1*subplot_height]);
   
    disp(['Applying transmission matrix took ' num2str(toc) ' seconds.']);
end