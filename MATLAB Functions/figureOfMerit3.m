function FOM = figureOfMerit3(field_at_detectors)
n_movements = size(field_at_detectors,2);
fom = zeros(n_movements);
for nn = 1:n_movements
    for mm = 1:n_movements
        fom(nn,mm) = sum(abs(field_at_detectors(:,nn)...
            - field_at_detectors(:,mm)).^2,'all');
    end
end
FOM = sum(fom,'all');
end