function [figure1,axes1]=mimshowDPinterp(M,upscale,maxAFrac)

% M: complex (or real) 2D array to plot (if real will plot colour green as
% treats as phase = 0 everywhere)

% upscale: factor to upscale image by (make sure bigge than 1)

% maxAFrac: fraction of input array max to set maximum of plot colour-scale to
% (setting to 1 keeps at max, above 1 does nothing, below one clips
% everything above this fraction)

[nrows,ncols] = size(M);
extrarows = floor(nrows/2)*(upscale-1);
extracols = floor(ncols/2)*(upscale-1);

nrowsBig = nrows + 2*extrarows;
ncolsBig = ncols + 2*extracols;

Up = zeros(nrowsBig,ncolsBig);
Mft = fftshift(fft2((ifftshift(M))));
Up(extrarows+1:extrarows+nrows,extracols+1:extracols+ncols) = Mft;
Mift = fftshift(ifft2((ifftshift(Up))));

% normalise image amplitude
mAx = max(max(abs(Mift)));
Mift = Mift/mAx;

% clip amplitude to maxAFrac if it is below 1
A = abs(Mift);
P = angle(Mift);
if maxAFrac<1
    clipped = double(A>maxAFrac);
    keep = 1-clipped;
    A = keep.*A + clipped*maxAFrac;
    mAx = max(max(A));
    A = A/mAx;
end
% Mift = (keep.*A + clipped).*exp(1i*P);
% A=abs(Mift);
% P=angle(Mift);

cp(:,:,1)=min(A,1).*(cos(P-2*pi/3)/2+.5);
cp(:,:,2)=min(A,1).*(cos(P)/2+.5);
cp(:,:,3)=min(A,1).*(cos(P+2*pi/3)/2+.5);

% Create figure
% figure1 = figure('Color',[1 1 1]);
figure1 = figure('Units','centimeters','Position',[10 10 15 15]);
%colormap(hsv);

% Create axes
axes1 = axes('Visible','on','Parent',figure1,'YDir','normal',...
    'TickDir','out',...
    'DataAspectRatio',[1 1 1]);
box(axes1,'on');
hold(axes1,'all');
xlabel('k_0x')
ylabel('k_0y')
imshow(cp,'Parent',axes1);
end