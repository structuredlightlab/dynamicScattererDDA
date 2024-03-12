%% This function calculates a Laguerre-Gaussian beam for the given inputs. 
%% It will also plot the field if any string (i.e. "plot me please") is included as the last argument.

function U = generateLG(rho,l,w0,lambda,z,plotRange,resolution,varargin)
p = inputParser;
addRequired(p,'rho');
addRequired(p,'l');
addRequired(p,'w0');
addRequired(p,'lambda');
addRequired(p,'z');
addRequired(p,'size');
addRequired(p,'resolution');
addOptional(p,'plotthis',[],@isstring);
parse(p,rho,l,w0,lambda,z,plotRange,resolution,varargin{:});
plotthis = p.Results.plotthis;


k = 2*pi/lambda;        % Wavenumber of light
zR = k*w0^2/2;          % Calculate the Rayleigh range

startPoint = plotRange/2;
x = linspace(-startPoint,startPoint,resolution);
y = linspace(-startPoint,startPoint,resolution);
[xx, yy] = meshgrid(x,y);

% Calculate the cylindrical coordinates
[phi, r] = cart2pol(xx, yy);
U00 = 1/(1 + 1i*z/zR) .* exp(-r.^2/w0^2./(1 + 1i*z/zR));
w = w0 * sqrt(1 + z.^2/zR^2);
R = sqrt(2)*r./w;

% Lpl from OT toolbox
Lpl = nchoosek(rho+l,rho) * ones(size(R));   % x = R(r, z).^2
for m = 1:rho
    Lpl = Lpl + (-1)^m/factorial(m) * nchoosek(rho+l,rho-m) * R.^(2*m);
end
U = U00.*R.^l.*Lpl.*exp(1i*l*phi).*exp(-1i*(2*rho + l + 1)*atan(z/zR));

if ~isempty(varargin)
    figure;
    sgtitle(['LG' num2str(rho) num2str(l)])
    subplot(1, 2, 1);
    imagesc(x,y,abs(U).^2);
    axis square
    xlabel('x (m)');
    ylabel('y (m)');
    title('Intensity');
    colorbar
    subplot(1, 2, 2);
    imagesc(x,y,angle(U));
    title('Phase');
    axis square
    xlabel('x (m)');
    ylabel('y (m)');
    colorbar
end
end