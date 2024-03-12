function sc_img = showComplexField(field)    
    amplitude = abs(field);
    amplitude = amplitude./max(amplitude, [], "all");
    phase = angle(field);

    img = zeros([size(field), 3]);
    img(:, :, 1) = amplitude .* (cos(phase - (2 * pi / 3)) * 0.5 + 0.5);
    img(:, :, 2) = amplitude .* (cos(phase) * 0.5 + .5);
    img(:, :, 3) = amplitude .* (cos(phase + (2 * pi / 3)) * 0.5 + 0.5);

    sc_img = img;
end