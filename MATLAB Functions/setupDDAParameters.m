k0 = 2*pi/wavelength;  k02 = k0^2;  % wavenumber & wavenumber^2

% % Polarizability (for 2D) for the dipoles
% alpha_mod = (4/k02)*fraction_of_max_alpha;
% alpha_arg = asin(0.25*alpha_mod*k02);
% alpha = alpha_mod*exp(1i*alpha_arg);

% Set up the simulation area:
dipole_area = [1/3 1/3]*scale;   %0.5*[1 1]*scale;                       % amount of space dipoles occupy in a box of size scale
extra_space = 0.1*scale;                                % extra space (in m) around edge of scatterer locations
exclusion_radius = 0.2*wavelength/points_per_wavelength;% how close to each dipole the electric field will be plotted
box_width = scale + 2*extra_space;                      % total area plotted
n_points_1D = ceil((box_width/wavelength)...
    *points_per_wavelength);                            % no. of pixels in 1D in final plots
x_start = -1*box_width/2;                               % position (in m) of 1st pixel
x_points = linspace(x_start,x_start+box_width,...       % pixel positions in 1D
    n_points_1D);
[x_full_2d, y_full_2d] = meshgrid(x_points,x_points);   % 2d meshgrids of all x- and y-positions
z_full_2d = x_full_2d + 1i*y_full_2d;