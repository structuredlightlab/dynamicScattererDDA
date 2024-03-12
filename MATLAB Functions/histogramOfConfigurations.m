function hist_of_positions = histogramOfConfigurations(z_shifted_positions,...
    z_full_2d)

    shifted_x = real(z_shifted_positions);
    shifted_y = imag(z_shifted_positions);
    
    x_full_2d = real(z_full_2d);
    y_full_2d = imag(z_full_2d);
    
    
    n_iter = size(shifted_x,2);
    n_sources = size(shifted_x,3);
    n_phasesteps = size(shifted_x,4);
    n_movements = size(shifted_x,5);
    n_moving_dipoles = size(shifted_x,1);
    
    idx_shifted_x = zeros(n_moving_dipoles,n_iter,n_sources,...      
        n_phasesteps,n_movements);
    idx_shifted_y = zeros(n_moving_dipoles,n_iter,n_sources,...       
        n_phasesteps,n_movements);
    for o = 1:n_iter
        for s = 1:n_sources
            for n = 1:n_phasesteps
                for pp = 1:n_movements
                    for nn = 1:n_moving_dipoles
                        [~, idx_shifted_x(nn,o,s,n,pp)] = ...
                            min(abs(x_full_2d(1,:)-shifted_x(nn,o,s,n,pp))); 
                        [~, idx_shifted_y(nn,o,s,n,pp)] = ...
                            min(abs(y_full_2d(:,1)-shifted_y(nn,o,s,n,pp))); 
                    end
                end
            end
        end
    end
    
    A = reshape(idx_shifted_x,[numel(idx_shifted_x),1]);
    B = reshape(idx_shifted_y,[numel(idx_shifted_y),1]);
    
    n_points_1D = size(z_full_2d,1);
    hist_of_positions = zeros(n_points_1D);                
    for iii = 1:length(A)                                     
        hist_of_positions(B(iii),A(iii)) = ...
            hist_of_positions(B(iii),A(iii)) + 1;
    end
    hist_of_positions = hist_of_positions./norm(hist_of_positions);
end