function alpha = calculatePolarisability(k0,fraction_of_max_alpha)
    k02 = k0^2;
    alpha_mod = (4/k02)*fraction_of_max_alpha;
    alpha_arg = asin(0.25*alpha_mod*k02);
    alpha = alpha_mod*exp(1i*alpha_arg);
end