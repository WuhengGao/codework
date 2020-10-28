function [x2,y2] = RBFImageWarp2(im, psrc, pdst)
% input: im, psrc, pdst
%psrc:start points in im axis
%pdst:end points in im axis

%% caculate warp coefficients
% get image (matrix) size
[h, w,~] = size(im);
n=size(pdst,1);

%(x1,y1)->(x1,h-y1)=(x,y),axis change
pdst(:,2)=h-pdst(:,2);
psrc(:,2)=h-psrc(:,2);

%d^2=xij=||psrc(i,:)-psrc(j,:)||^2
xij=(pdist2(psrc,psrc)).^2;

%r^2=min(d^2),i!=j
xij2=xij+diag(h+w+zeros(1,length(xij)));
r=min(xij2,[],2);

%R=(d^2+r^2)^(u/2),u=-2
R=(1./sqrt(xij+repmat(r, 1, n)))';

%a:coefficients
b=pdst-psrc;
a=R\b;

%% change image
%(i,j)->(j,h-i)=(x,y),axis change
y=fliplr(1:h);
x=1:w;

%c=(d^2+r^2)^(u/2),u=-2
dy=repmat(repmat(y,n,1)-repmat(psrc(:,2),1,h),1,w);
dx=kron(repmat(x,n,1)-repmat(psrc(:,1),1,w),ones(1,h));
c=1./sqrt(dy.^2+dx.^2+repmat(r,1,w*h));

%T(x)=x+sum(a*c)
y2=round(repmat(y,1,w)+sum(repmat(a(:,2),1,w*h).*c,1));
x2=round(kron(x,ones(1,h))+sum(repmat(a(:,1),1,w*h).*c,1));

y2(y2>h)=h;
y2(y2<1)=1;
x2(x2>w)=w;
x2(x2<1)=1;
y2=reshape(y2,h,w);
x2=reshape(x2,h,w);

  




end
