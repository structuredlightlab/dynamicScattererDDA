function overlap = overlapIntegral(A,B)
overlap = sum(abs(B*ctranspose(A)),'all');
end