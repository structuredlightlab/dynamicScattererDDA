 % inverse_transmission_matrix = pinv(transmission_matrix,s_tolerance);
    [U,s,V] = svd(transmission_matrix,'econ');
    s = diag(s);
    
    fig = figure('Units','centimeters','Position',[10 10 8 4]);
    ha = tight_subplot(1,1,.1,.15,.15);
    
    subplot_x = 0.15;      subplot_y = 0.2;
    subplot_width = 0.75;   subplot_height = subplot_width;
    
    axes(ha);   hold on;    box on;
    plot(s./max(s))
    xlabel('Singular value index');
    ylabel('Normalised singular value');
    set(ha,'Position',[subplot_x subplot_y subplot_width subplot_height])
    axis tight
    fig_name = 'TMSingVals';
    saveFigure(fig,fig_name,save_path,{'png','fig'},0);

    r1 = cut_off;
    V(:,r1:end) = [];
    U(:,r1:end) = [];
    s(r1:end) = [];
    s = 1./s(:);
    inverse_transmission_matrix = (V.*s.')*U';