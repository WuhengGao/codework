function toolWarpCB(varargin)

hlines = evalin('base', 'hToolPoint.UserData');
im = evalin('base', 'im');
himg = evalin('base', 'himg');
himg2 = evalin('base', 'himg2');

p2p = zeros(numel(hlines)*2,2); 
for i=1:numel(hlines)
    p2p(i*2+(-1:0),:) = hlines(i).getPosition();
end

%Fix four corners
[h, w, ~] = size(im);
fixpoint=[0.1,0.1;h-0.1,0.1;0.1,w-0.1;h-0.1,w-0.1];



[i2,j2]= RBFImageWarp2(im, [fixpoint;p2p(1:2:end,:)], [fixpoint;p2p(2:2:end,:)]);
[i3,j3] = IDWImageWarp2(im, [fixpoint;p2p(1:2:end,:)], [fixpoint;p2p(2:2:end,:)]);


set(himg, 'XData', i2,'YData', j2);
set(himg2, 'XData', i3,'YData', j3);