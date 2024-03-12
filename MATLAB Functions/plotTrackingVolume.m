function [scatter_cols, aa] = plotTrackingVolume(xyz,ttl,scatter_cols,aa,...
    cut_off,voxel_size,face_color,eigVect_plot)
if isempty(scatter_cols)
    scatter_cols(:,1) = heatscatter_CS(xyz(:,1),xyz(:,2),cut_off);
    scatter_cols(:,2) = heatscatter_CS(xyz(:,1),xyz(:,3),cut_off);
    scatter_cols(:,3) = heatscatter_CS(xyz(:,2),xyz(:,3),cut_off);    
    %     disp('Generating new colors')
end

title(ttl,'FontWeight','normal');
% ha = tight_subplot(1,1,.1,.1,.1);
aa = shrinkwrapVolume(xyz,aa,cut_off,voxel_size,face_color);
% h = light;
% lighting gouraud
% lightangle(h,-15,0)

xlabel('x, nm'); ylabel('y, nm'); zlabel('z, nm');
box on; axis equal; hold on

lim = max(abs(aa));
axis(aa)
eigVect = [1 0 0; 0 1 0; 0 0 1];
eigVectPlot1 = [-eigVect(:,1), eigVect(:,1)]*lim;
eigVectPlot2 = [-eigVect(:,2), eigVect(:,2)]*lim;
plot3(eigVectPlot1(1,:),eigVectPlot1(2,:),ones(size(eigVectPlot1(3,:)))*aa(5),...
    'color',[0.85 0.85 0.85],'DisplayName','x')
plot3(eigVectPlot1(2,:),eigVectPlot1(1,:),ones(size(eigVectPlot1(3,:)))*aa(5),...
    'color',[0.85 0.85 0.85],'DisplayName','x')
plot3(eigVectPlot1(1,:),ones(size(eigVectPlot1(2,:)))*aa(4),eigVectPlot1(3,:),...
    'color',[0.85 0.85 0.85],'DisplayName','x')
plot3(eigVectPlot1(3,:),ones(size(eigVectPlot1(2,:)))*aa(4),eigVectPlot1(1,:),...
    'color',[0.85 0.85 0.85],'DisplayName','x')
plot3(-ones(size(eigVectPlot1(1,:)))*aa(3),eigVectPlot2(2,:),eigVectPlot2(3,:),...
    'color',[0.85 0.85 0.85],'DisplayName','y')
plot3(-ones(size(eigVectPlot1(1,:)))*aa(3),eigVectPlot2(3,:),eigVectPlot2(2,:),...
    'color',[0.85 0.85 0.85],'DisplayName','y')

if isempty(eigVect_plot)
else
    eigVect_plot1 = [-eigVect_plot(:,1), eigVect_plot(:,1)]*lim;
    eigVect_plot2 = [-eigVect_plot(:,2), eigVect_plot(:,2)]*lim;
    eigVect_plot3 = [-eigVect_plot(:,3), eigVect_plot(:,3)]*lim;
    plot3(eigVect_plot1(1,:),eigVect_plot1(2,:),zeros(size(eigVect_plot1(3,:)))*aa(5),...
    'color','r','DisplayName','x_t','LineWidth',1)
    plot3(eigVect_plot2(1,:),eigVect_plot2(2,:),zeros(size(eigVect_plot2(3,:)))*aa(5),...
    'color','r','DisplayName','y_t','LineWidth',1)
    plot3(zeros(size(eigVect_plot3(1,:))),eigVect_plot3(2,:),eigVect_plot3(3,:),...
    'color','r','DisplayName','y_t','LineWidth',1)
end
% axis(aa)
scatter3(xyz(:,1),xyz(:,2),ones(size(xyz(:,3)))*aa(5),[],scatter_cols(:,1),'.'); %'color',cols(3,:))
scatter3(xyz(:,1),ones(size(xyz(:,2)))*aa(4),xyz(:,3),[],scatter_cols(:,2),'.'); %'color',cols(3,:))
scatter3(ones(size(xyz(:,1)))*aa(2),xyz(:,2),xyz(:,3),[],scatter_cols(:,3),'.'); %'color',cols(3,:))
hold off

% c = colorbar;
% c.Label.String = 'Probability';
% clim([0 max(max(scatter_cols))])