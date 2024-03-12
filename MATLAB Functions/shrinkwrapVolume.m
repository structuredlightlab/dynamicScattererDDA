function aa = shrinkwrapVolume(xyz,aa,cut_off,voxel_size,face_color)
% cmap = crameri('acton');

size_bins = voxel_size; % in nm

n_bins = [10, 10, 25]; %number of bins in x, y, and z
x_bins = min(xyz(:,1)):size_bins:max(xyz(:,1));
y_bins = min(xyz(:,2)):size_bins:max(xyz(:,2));
z_bins = min(xyz(:,3)):size_bins:max(xyz(:,3));
[X,Y,Z] = meshgrid(y_bins,x_bins,z_bins);
n_bins = [length(x_bins), length(y_bins), length(z_bins)];

n_points = length(xyz);
x_idx = zeros(1,n_points);  y_idx = x_idx;  z_idx = x_idx;
for ii = 1:n_points
    [~,x_idx(ii)] = min(abs(X(1,:,1)-xyz(ii,1)));
    [~,y_idx(ii)] = min(abs(Y(:,1,1)-xyz(ii,2)));
    [~,z_idx(ii)] = min(abs(Z(1,1,:)-xyz(ii,3)));    
end

histogram_positions = zeros(n_bins);                  % empty array filled in for-loop
for iii = 1:n_points                                   % calculate 2D histogram of moving scatterer positions
    histogram_positions(y_idx(iii),x_idx(iii),z_idx(iii)) = histogram_positions(y_idx(iii),x_idx(iii),z_idx(iii)) + 1;
end
probabilities = histogram_positions./sum(histogram_positions,'all');
greater_than_threshold = find(probabilities > cut_off);
total_probability = sum(probabilities(greater_than_threshold),'all');

default_colors = get(groot,'defaultAxesColorOrder');
% face_color = default_colors(7,:);

s = isosurface(X,Y,Z,probabilities,cut_off);
s2 = isocaps(y_bins,x_bins,z_bins,probabilities,cut_off);
p = patch(s);
isonormals(y_bins,x_bins,z_bins,probabilities,p)
view(3);
set(p,'FaceColor', face_color);  
set(p,'EdgeColor','none');
camlight;
lighting gouraud;

if isempty(aa)
    aa = axis;
%     disp(['No axis limits set'])
    aa = 1.5*aa;
    aa(1:4) = 1.5*aa(1:4);
else
    axis(aa);
%     disp(['Axis limits set'])
end

% colormap(cmap);
axis(aa)
axis equal
