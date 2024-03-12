function source = sourceAtDetectors(k0,input_field,z_sources,z_detectors)
k02 = k0^2;
n_sources = size(z_sources,1);
n_detectors = size(z_detectors,1);
source = complex(zeros(n_detectors,1));
for nn = 1:1:n_sources
    distance_source_to_detectors = abs(z_sources(nn) - z_detectors);
    source = source + input_field(nn)...
        .*(k02*(1i/4).*besselh(0,1,k0*distance_source_to_detectors));
end
end