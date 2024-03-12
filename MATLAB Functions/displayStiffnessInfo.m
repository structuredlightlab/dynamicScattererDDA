function displayStiffnessInfo()
disp(['x st. dev. is ' num2str(stdev_Gauss_lab(1),3) ' nm'])
disp(['y st. dev. is ' num2str(stdev_Gauss_lab(2),3) ' nm'])
disp(['z st. dev. is ' num2str(stdev_Gauss_lab(3),3) ' nm'])
disp(['x stiffness is ' num2str(k_Gauss_lab(1),3) ' N/m'])
disp(['y stiffness is ' num2str(k_Gauss_lab(2),3) ' N/m'])
disp(['z stiffness is ' num2str(k_Gauss_lab(3),3) ' N/m'])
disp(['Volume of ellipsoid is ' num2str(vol_Gauss_lab,8) ' nm^3'])
end