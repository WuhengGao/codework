function [x2,y2] = RBFImageWarp2(im, psrc, pdst)

% input: im, psrc, pdst
%psrc:start points
%pdst:end points


%% basic image manipulations
% get image (matrix) size
[h, w,~] = size(im);
n=size(pdst,1);
%im2=255*ones(h,w,dim);

pdst(:,2)=h-pdst(:,2);
psrc(:,2)=h-psrc(:,2);

b=pdst-psrc;
%d^2=xij=||psrc(i,:)-psrc(j,:)||^2
xij=pdist2(psrc,psrc);
xij=xij.^2;
%r^2=min(d^2)
xij2=xij;
if n>1
 xij2=xij+diag(h+w+zeros(1,length(xij)));
end
r=min(xij2,[],2);
%R=(d^2+r^2)^(u/2),u=-2
R=xij+repmat(r, 1, n);
R=ones(n,n)./sqrt(R);
R=R';
%a:coefficients
a=R\b;

%% change image
y=1:h;
y=flipud(y);
x=1:w;
c1=repmat(y,n,1)-repmat(psrc(:,2),1,h);
c1=repmat(c1,1,w);
c2=repmat(x,n,1)-repmat(psrc(:,1),1,w);
c2=kron(c2,ones(1,h));
c=sqrt(c1.^2+c2.^2+repmat(r,1,w*h));
y2=repmat(y,1,w)+sum(repmat(a(:,2),1,w*h)./c,1);
x2=kron(x,ones(1,h))+sum(repmat(a(:,1),1,w*h)./c,1);
y2=round(y2);
x2=round(x2);
y2(y2>h)=h;
y2(y2<1)=1;
x2(x2>w)=w;
x2(x2<1)=1;
y2=reshape(y2,h,w);
x2=reshape(x2,h,w);

  




end
