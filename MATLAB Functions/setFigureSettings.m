% I'm going to attempt to make a file to call to make all of my thesis
% figures in the same style.

clear all
close all
%%
% Load in the colormaps to use for plots
% default_colormap_name = 'oslo'; % for the crameri colormap of same name
% loaded_cmap = load("C:\Users\cs850\AppData\Roaming\MathWorks\MATLAB Add-Ons\Toolboxes\crameri perceptually uniform scientific colormaps\crameri\CrameriColourMaps7.0.mat",default_colormap_name);
% default_cmap = struct2array(loaded_cmap);

load("thesisColormap.mat")
default_cmap = ThesisColormap_Green;

% Create default color order for plots
% Designed using coolors.co
col1 = [51 77 51]/255;
col2 = [166 128 140]/255;
col3 = [138 191 109]/255;
col4 = [21 30 63]/255;
col5 = [23 163 152]/255;
col6 = [232 208 157]/255;
col7 = [191 89 35]/255;
cols = [col1; col2; col3; col4; col5; col6; col7];
set(0,'defaultaxescolororder',cols)

% Set default figure settings
set(groot, 'DefaultFigureColormap', default_cmap)
set(groot, 'defaultAxesFontName', 'cmss10')
set(groot, 'defaultAxesFontSize', 9)
%%
% % Dummy data + plots
% amps = linspace(1,5,size(cols,1));
% data = amps.'*sin(linspace(0,2*pi,50)) + amps.';
% fig = figure('Units','centimeters','Position',[10 10 10 5]);
% plot(data.','LineWidth',1)
% axis tight
% legend('Location','best')
% title('Dummy title')
% 
% dummy_image = randn(250,250);
% dummy_image = dummy_image - min(dummy_image);
% fig = figure('Units','centimeters','Position',[10 10 10 7]);
% imagesc(linspace(-50,50,100),linspace(-50,50,100),dummy_image)
% axis square
% ttl = title('Dummy title');
% x_lbl = xlabel('x dummy label');
% ylabel('y dummy label');
% for j = 1:length(cols)
%     viscircles([0 0],10+(5*j),'Color',cols(j,:),'EnhanceVisibility',false);
% end
% c = colorbar;
% c.Position = c.Position.*[1.075 1 0.5 1];
% c.Label.String = 'c dummy label';
% c.Label.FontSize = c.Label.FontSize*1.1;