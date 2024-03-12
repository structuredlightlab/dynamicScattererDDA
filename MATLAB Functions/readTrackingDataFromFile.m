function [xyz, t] = readTrackingDataFromFile(file_name, data_range, do_plot_data)
    data = readmatrix(file_name);
    if ~isempty(data_range)
        data = data(data_range,:);
        disp(['Extracting data for indices from ' num2str(data_range(1)) ' to ' num2str(data_range(end))])
    end

    %time, s
    t = data(:,1)*1e-6;
    
    %if time wraps run this line
    [~,maxT_ind] = max(t); t(maxT_ind+1:end) = t(maxT_ind+1:end) + t(maxT_ind);
    t = t - t(1);
    %dt = t(2) - t(1);
    
    % particle position, m (mean subtracted)
    x_particle = data(:,5)*1e-6; x_mean = mean(x_particle); x_particle = x_particle - x_mean;
    y_particle = data(:,6)*1e-6; y_mean = mean(y_particle); y_particle = y_particle - y_mean;
    z_particle = data(:,7)*1e-6; z_mean = mean(z_particle); z_particle = z_particle - z_mean;
    
    %average position over time
    window = 1000;
    x_movmean = movmean(x_particle,window);
    y_movmean = movmean(y_particle,window);
    z_movmean = movmean(z_particle,window);
    
    x_particle = x_particle - x_movmean;
    y_particle = y_particle - y_movmean;
    z_particle = z_particle - z_movmean;
    
    %collect data into one array
    xyz = [x_particle y_particle z_particle]*1e9;
    
    if do_plot_data
        figure('Units','centimeters','Position',[2,2,10,10]);
        ha = tight_subplot(3,1,.1,.1); 
        axes(ha(1));    hold on;
        title(file_name)
        plot(xyz(:,1))
        axis tight
        ylabel('x, nm')
        axes(ha(2))
        plot(xyz(:,2))
        ylabel('y, nm')
        axis tight
        axes(ha(3))
        plot(xyz(:,3))
        ylabel('z, nm')
        xlabel('t, s')
        axis tight
    end
    % gaus = @(x,mu,sig,amp,vo)amp*exp(-(((x-mu).^2)/(2*sig.^2)))+vo;
    % n_bins = 100;
    % x = linspace(min(xyz(:,3)),max(xyz(:,3)),n_bins);
    % sig = std(z_particle*1e9);
    % mu = 0;     vo = 0;     
    % 
    % figure
    % hold on
    % h = histogram(xyz(:,3),n_bins)
    % amp = max(h.Values);
    % gaussian_test = gaus(x,mu,sig,amp,vo).';
    % plot(x,gaussian_test,'LineWidth',2)
    % sgtitle('z-displacement histogram')
    % xlabel('z displacement (nm)')
    % ylabel('# of occurrences')
end