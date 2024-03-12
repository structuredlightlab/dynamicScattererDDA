function gauss = Gaussian1D(x,mu,sig,amp,vo)
    gauss = amp*exp(-(((x-mu).^2)/(2*sig.^2)))+vo;
end