% A function to calculate the stdev of 3D tracking data
function [k,stdev,eigVect] = calculateStiffnessFromTracking(xyz,axes)
kbT = 1.380649e-23*300;
switch axes
    case 'lab'
        stdev = std(xyz,0,1);
        eigVect = eye(3);
    case 'ellipsoid'
        nPoints = size(xyz,1);
        C = zeros(3);
        for i = 1:1:3
            for j = 1:1:3
                if i>=j
                    C(i,j) = (1/nPoints)*dot(xyz(:,i),xyz(:,j));
                    C(j,i) = C(i,j);
                end
            end
        end
        %each column of eigVect indicates one of the major axes of the thermal
        %ellipsoid, each diagonal element of eigVal gives the variance along the
        %major axes
        [eigVect,eigVal] = eig(C);
        %standard deviation
        stdev = sqrt(diag(eigVal)).';
end
k = kbT./(stdev*1e-9).^2;
end