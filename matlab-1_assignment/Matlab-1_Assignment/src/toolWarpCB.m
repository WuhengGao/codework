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
fixpoint=[0.1,0.1;w-0.1,0.1;0.1,h-0.1;w-0.1,h-0.1];



[x2,y2]= RBFImageWarp2(im, [fixpoint;p2p(1:2:end,:)], [fixpoint;p2p(2:2:end,:)]);
[x3,y3] = IDWImageWarp2(im, [fixpoint;p2p(1:2:end,:)], [fixpoint;p2p(2:2:end,:)]);


set(himg, 'XData', x2,'YData', y2);
set(himg2, 'XData', x3,'YData', y3);