function normalisation_factor = normalisationFOM(field_at_detectors)
normalisation_factor = sqrt(sum(abs(ctranspose(field_at_detectors)*field_at_detectors)));
end