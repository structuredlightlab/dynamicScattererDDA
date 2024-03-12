function FOM = figureOfMerit(field_at_detectors,norm_factors)
n_movements = length(norm_factors);
fom = zeros(n_movements);
for nn = 1:n_movements
    for mm = 1:n_movements
        fom(nn,mm) = -1*(sum(abs(field_at_detectors(:,nn)...
            .*conj(field_at_detectors(:,mm))),'all')...
            /(norm_factors(nn)*norm_factors(mm)));
    end
end
FOM = sum(fom,'all');
end