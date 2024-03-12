function distances = distanceAToB(A,B)
if size(B,2) == 1
    distances = zeros(size(B,1),size(A,1));
else
    distances = zeros(size(B,1),size(B,2),size(A,1));
end
for n = 1:size(A,1)
    distance_x = real(B) - real(A(n));
    distance_y = imag(B) - imag(A(n));
    r2 = distance_x.^2 + distance_y.^2;
    if size(B,2) == 1
        distances(:,n) = r2.^0.5;
    else 
        distances(:,:,n) = r2.^0.5;
    end
end
end
