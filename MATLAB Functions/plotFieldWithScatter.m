function c = plotFieldWithScatter(field_data,x_data,y_data,axes_labels,markers,...
    marker_size,line_colors,display_name,do_colorbar)

imagesc(field_data{1},field_data{2},(field_data{3})./max(max(field_data{3})))
for d = 1:size(x_data,2)
    plot(x_data{d},y_data{d},markers{d},'LineStyle','none',...
        'MarkerSize',marker_size(d),'Color',line_colors(d,:),...
        'DisplayName',display_name{d})
end
axis image
legend('Location','bestoutside','FontName','cmss10',...
    'FontSize',0.9*get(groot,'defaultaxesfontsize'))
xlabel(axes_labels{1}); 
ylabel(axes_labels{2});

set(gca, 'YDir','reverse','XTick',get(gca,'YTick'));

if do_colorbar
    c = colorbar;   c.Label.String = 'Normalised intensity';
    c.Label.FontSize = get(groot,'defaultaxesfontsize');
else
    c = [];
end

end