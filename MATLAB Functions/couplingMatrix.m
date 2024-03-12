%% Coupling Matrix for scalar DDA with scatterers of same polarisability
function [coupling_matrix] = couplingMatrix(z_dipole_positions,alpha,k_0)
k_02 = k_0^2;
n = size(z_dipole_positions,1);
coupling_matrix_diag = ones(n,1)*(alpha^(-1));
coupling_matrix = complex(diag(coupling_matrix_diag));
for j = 1:1:n
    for k = 1:1:n
        if j<k
            diff_vec = z_dipole_positions(j) - z_dipole_positions(k);
            r_jk = norm(diff_vec);
            off_diag = -1*k_02*(1i/4)*besselh(0,1,k_0*r_jk); % solution for a circular wave in 2D
            coupling_matrix(j,k) = off_diag;
            coupling_matrix(k,j) = off_diag;
        end
    end
end
end