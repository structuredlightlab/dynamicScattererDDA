function [fig, ha] = plotNearFieldXYandXZ_2(beam,range,res,radius,figTtitle,wavelength0,n_medium,n_particle,bessel_modes,BesselType,polrz,circle_color)


wavelength_medium = wavelength0/n_medium;
nmax = (2*pi*(range)/wavelength_medium)+4.05*(2*pi*(range)/wavelength_medium)^(1/3)+2; nmax = round(nmax);
if isa(beam,'double')
    b2v = Bessel2VSWF(bessel_modes,wavelength_medium,nmax,BesselType,polrz);
    beam_VSWF = b2v*beam;
    beam = ott.Bsc(beam_VSWF(1:end/2),beam_VSWF(end/2+1:end),'regular','incident');
    beam.wavelength = wavelength_medium;

    %model field scattering (outside of the particle)
    T_sc = ott.Tmatrix.simple('sphere', radius, 'wavelength0', wavelength0,'index_medium', n_medium, 'index_particle', n_particle,'Nmax',nmax);
    beam_sc =  T_sc * beam;
    beam_out = beam_sc.totalField(beam);
    beam_out.basis = 'regular';
else
    beam_out = beam;
end

%model field scattering (inside of the particle)
T_in = ott.Tmatrix.simple('sphere', radius,'internal',true, 'wavelength0', wavelength0,'index_medium', n_medium, 'index_particle', n_particle,'Nmax',nmax);
beam_in =  T_in * beam;

% Create the grid of points we want to view
nx = res;
ny = res;
nz = res;
xrange = linspace(-range, range, nx);
yrange = linspace(-range, range, ny);
zrange = linspace(-range, range, nz);
[xx1, yy1] = meshgrid(xrange, yrange);
z1 = 0;
xyz1 = [xx1(:) yy1(:) ones(size(xx1(:)))*z1].';
%indices where the particle is
idx_particle = ((xx1 ).^2 + yy1.^2) <  radius^2;
% Calculate the E near-field outside the particle
[E_xy_out, ~] = beam_out.emFieldXyz(xyz1);
Ei_xy = reshape(sum(abs(E_xy_out).^2,1),[ny,nx]);
% Calculate the E near-field inside the particle
[E_xy_in, ~] = beam_in.emFieldXyz(xyz1);
Ei_xy_in = reshape(sum(abs(E_xy_in).^2,1),[ny,nx]);
%total field
Ei_xy(idx_particle) = Ei_xy_in(idx_particle);

%define the xz plane at a given y-coordinate
[xx2, zz2] = meshgrid(xrange, zrange);
y2 = 0;
xyz2 = [xx2(:) ones(size(xx2(:)))*y2 zz2(:)].';
% Calculate the E near-field outside the particle
[E_xz_out, ~] = beam_out.emFieldXyz(xyz2);
Ei_xz=reshape(sum(abs(E_xz_out).^2,1),[nz,nx]);
% Calculate the E near-field inside the particle
[E_xz_in, ~] = beam_in.emFieldXyz(xyz2);
Ei_xz_in=reshape(sum(abs(E_xz_in).^2,1),[nz,nx]);
%total field
Ei_xz(idx_particle) = Ei_xz_in(idx_particle);


%plot the intensitiy of the solution field in the two planes
fig = figure('Units','centimeters','Position',[10,10,10,10]);
ha = tight_subplot(1,2,.15,.15); hold on; box on;


axes(ha(1));    hold on;
imagesc(xrange, yrange, Ei_xy)
viscircles([0 0],radius,'LineStyle','-','linewidth',.1,'Color',circle_color);
axis image
text(0.9*min(xrange),0.9*max(yrange),'Intensity, xy plane','Color','w',...
    'FontName','cmss10','FontSize',get(groot,'defaultAxesFontSize')); 
xlabel('x, m'); ylabel('y, m')

axes(ha(2));    hold on;
hold on
imagesc(xrange, zrange, Ei_xz)
viscircles([0 0],radius,'LineStyle','-','linewidth',.1,'Color',circle_color);
axis image
text(0.9*min(xrange),0.9*max(zrange),'Intensity, xz plane','Color','w',...
    'FontName','cmss10','FontSize',get(groot,'defaultAxesFontSize'));  
xlabel('x, m'); ylabel('z, m')
%     c = colorbar; ylabel(c,'Intensity')


end

