function toolPasteCB(varargin)

hpolys = evalin('base', 'hpolys');
L = evalin('base', 'L');
m = evalin('base', 'm');

roi = hpolys(1).getPosition();
dP = ceil(hpolys(2).getPosition() - roi);
dp=dP(1,:);

im1 = evalin('base', 'im1');
im2 = evalin('base', 'im2');
himg = evalin('base', 'himg');


imdst = blendImagePoisson(im1, im2,m,L,dp);
set(himg, 'CData', imdst);
