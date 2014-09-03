%tmp = csvread('try2.txt');
% stored in try3

%Centers fox x,y,z
cX = 56;
cY = 56;
cZ = 1;
%Max Z
mZ = 150;
%total Pixels
tP = 256;

pp = zeros(2*cX-1,2*cY-1,mZ+1,tP);
st =size(tmp);
for i=1:st(1)
        x = tmp(i,1)+cX;
        y = tmp(i,2)+cY;
        z = tmp(i,3)+1;
        pp(x,y,z,:)=tmp(i,7:tP+6);
end

clear tmp x y z i st;

%interpolate the data acquired with 2mm grid
% starting at milimiter 51
lZ = 51;
%The truncated pyramid scan has a slope of
% 25 + z/5
% so add that
sB = 25;
sF = 5;

for z=lZ+2:2:mZ+1
        sl = sB+fix((z-1)/sF);
        xr = cX-sl:2:cX+sl;
        yr = cY-sl+1:2:cY+sl-1;
        pp(xr,yr,z,:)=(pp(xr,yr+1,z,:)+pp(xr,yr-1,z,:))/2;
        xr = cX-sl+1:2:cX+sl-1;
        yr = cY-sl:2:cY+sl;
        pp(xr,yr,z,:)=(pp(xr+1,yr,z,:)+pp(xr-1,yr,z,:))/2;
        xr = cX-sl+1:2:cX+sl-1;
        yr = cY-sl+1:2:cY+sl-1;
        pp(xr,yr,z,:)=(pp(xr+1,yr-1,z,:)+pp(xr-1,yr+1,z,:)+pp(xr+1,yr-1,z,:)+pp(xr+1,yr+1,z,:))/4;
end

for z=lZ+1:2:mZ
        sl = sB+fix((z-1)/sF);
        xr = cX-sl:cX+sl;
        yr = cY-sl:cY+sl;
        pp(xr,yr,z,:)=(pp(xr,yr,z+1,:)+pp(xr,yr,z-1,:))/2;
end        

pp = int16(16*pp);
clear x y z lZ sB sF;
