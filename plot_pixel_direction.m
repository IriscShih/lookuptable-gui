% --- Getting the center point of every pixels at starting z-value
for a = 1:size(pp,4)
fit2 = pp(:,:,3,a);
fwhm1 = fix(0.4*max(max(fit2)));
fwhm2 = fix(0.6*max(max(fit2)));
[y,x]=find(fit2>fwhm1 & fit2<fwhm2);
m(a,1) = a;
Fitting2=fit_ellipse(x,y);
m(a,2) = Fitting2.X0_in;
m(a,3) = Fitting2.Y0_in;
end

% --- Getting the center point of every pixels at ending z-value
for a = 1:size(pp,4)
fit2 = pp(:,:,150,a);
fwhm1 = fix(0.4*max(max(fit2)));
fwhm2 = fix(0.6*max(max(fit2)));
[y,x]=find(fit2>fwhm1 & fit2<fwhm2);
m(a,1) = a;
Fitting2=fit_ellipse(x,y);
m(a,4) = Fitting2.X0_in;
m(a,5) = Fitting2.Y0_in;
end

% --- Plotting the lines(directions) of all the pixels 
% --- starting point wiht green, ending point with red
for r = 1:size(m,1)
plot3([m(r,2),m(r,2)+(m(r,4)-m(r,2))/2],[m(r,3),m(r,3)+(m(r,5)-m(r,3))/2],[3,76], 'color', 'green')
plot3([m(r,2)+(m(r,4)-m(r,2))/2,m(r,4)],[m(r,3)+(m(r,5)-m(r,3))/2,m(r,5)],[76,150], 'color', 'red')
hold on
end