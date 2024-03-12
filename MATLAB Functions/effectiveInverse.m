function inverse_A = effectiveInverse(A,num_to_delete)
    if issparse(A)
        A = full(A);
    end
    [U,s,V] = svd(A,'econ');
    s = diag(s);
    
    figure('Units','centimeters','Position',[10 10 10 5]);
    ha = tight_subplot(1,1,.1,.15,.15);
    subplot_x = 0.15;      subplot_y = 0.2;
    subplot_width = 0.75;   subplot_height = subplot_width;
    axes(ha);   hold on;    box on;
    plot(s./max(s),'DisplayName','all')
    xlabel('Singular value index');
    ylabel('Normalised singular value');
    set(ha,'Position',[subplot_x subplot_y subplot_width subplot_height])
    axis tight

    r1 = num_to_delete;
    V(:,end-r1:end) = [];
    U(:,end-r1:end) = [];
    s(end-r1:end) = [];
    s = 1./s(:);

    plot(s./max(s),'DisplayName','removed','LineWidth',2)
    legend('Location','northeastoutside')

    inverse_A = (V.*s.')*U';
end