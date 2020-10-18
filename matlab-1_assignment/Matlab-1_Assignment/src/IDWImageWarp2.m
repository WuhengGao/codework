function  [x2,y2] = IDWImageWarp2(im, psrc, pdst)

% input: im, psrc, pdst
%psrc:start points
%pdst:end points


%% basic image manipulations
% get image (matrix) size
[h, w, ~] = size(im);
n=size(pdst,1);

pdst(:,2)=h-pdst(:,2);
psrc(:,2)=h-psrc(:,2);

%linear transformation calculation
dij=pdist2(psrc,psrc);
dij=dij.^2;
c1=repmat(psrc(:,1),1,n)-repmat(psrc(:,1)',n,1);
c2=repmat(psrc(:,2),1,n)-repmat(psrc(:,2)',n,1);
c3=repmat(pdst(:,1),1,n)-repmat(pdst(:,1)',n,1);
c4=repmat(pdst(:,2),1,n)-repmat(pdst(:,2)',n,1);
ww=ones(n,n)./dij;
ww(logical(eye(size(ww))))=0;
%ww:wij  (wii=0)
%c1:xj,1-xi,1
c11=sum(ww.*c1.*c1,2);
c12=sum(ww.*c2.*c1,2);
c22=sum(ww.*c2.*c2,2);
c13=sum(ww.*c1.*c3,2);
c23=sum(ww.*c2.*c3,2);
c14=sum(ww.*c1.*c4,2);
c24=sum(ww.*c2.*c4,2);
%sum(wij*c1(d11*c1+d12*c2+c3)=0
A=[diag(c11),diag(c12);diag(c12),diag(c22)];
b1=[c13;c23];
b2=[c14;c24];
d1=A\b1;
d2=A\b2;
d11=d1(1:n,:);
d12=d1(n+1:2*n,:);
d21=d2(1:n,:);
d22=d2(n+1:2*n,:);

y=1:h;
y=flipud(y);
x=1:w;
c1=repmat(y,n,1)-repmat(psrc(:,2),1,h);
c1=repmat(c1,1,w);
c2=repmat(x,n,1)-repmat(psrc(:,1),1,w);
c2=kron(c2,ones(1,h));
d=1./(c1.^2+c2.^2);
a=d./repmat(sum(d,1),n,1);
%a:wi
y2=repmat(pdst(:,2),1,h*w)+c1.*repmat(d11,1,h*w)+c2.*repmat(d12,1,h*w);
y2=sum(a.*y2,1);
x2=repmat(pdst(:,1),1,h*w)+c1.*repmat(d21,1,h*w)+c2.*repmat(d22,1,h*w);
x2=sum(a.*x2,1);
y2=round(y2);
x2=round(x2);
y2(y2>h)=h;
y2(y2<1)=1;
x2(x2>w)=w;
x2(x2<1)=1;
y2=reshape(y2,h,w);
x2=reshape(x2,h,w);

end

