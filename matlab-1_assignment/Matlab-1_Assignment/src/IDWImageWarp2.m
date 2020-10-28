function  [x2,y2] = IDWImageWarp2(im, psrc, pdst)
% input: im, psrc, pdst
%psrc:start points
%pdst:end points

%% linear transformation calculation
% get image (matrix) size
[h, w, ~] = size(im);
n=size(pdst,1);

%(x1,y1)->(x1,h-y1)=(x,y),axis change
pdst(:,2)=h-pdst(:,2);
psrc(:,2)=h-psrc(:,2);

%ww:wij=||psrci-psrcj||^(-u),u=2  (wii=0)
dij=(pdist2(psrc,psrc)).^2;
ww=1./dij;
ww(logical(eye(size(ww))))=0;

c1=repmat(psrc(:,1),1,n)-repmat(psrc(:,1)',n,1);
c2=repmat(psrc(:,2),1,n)-repmat(psrc(:,2)',n,1);
c3=repmat(pdst(:,1),1,n)-repmat(pdst(:,1)',n,1);
c4=repmat(pdst(:,2),1,n)-repmat(pdst(:,2)',n,1);
c11=sum(ww.*c1.*c1,2);
c12=sum(ww.*c2.*c1,2);
c22=sum(ww.*c2.*c2,2);
c13=sum(ww.*c1.*c3,2);
c23=sum(ww.*c2.*c3,2);
c14=sum(ww.*c1.*c4,2);
c24=sum(ww.*c2.*c4,2);
%sum(wij*c1(d11*c1+d12*c2+c3)=0
%sum(wij*c2(d11*c1+d12*c2+c3)=0
A=[diag(c11),diag(c12);diag(c12),diag(c22)];
b=[c13,c14;c23,c24];
d=A\b;
%D=(dij)
d11=d(1:n,1);
d12=d(n+1:2*n,1);
d21=d(1:n,2);
d22=d(n+1:2*n,2);

%% change image
%(i,j)->(j,h-i)=(x,y),axis change
y=fliplr(1:h);
x=1:w;

c1=repmat(repmat(y,n,1)-repmat(psrc(:,2),1,h),1,w);
c2=kron(repmat(x,n,1)-repmat(psrc(:,1),1,w),ones(1,h));
%a:wi=d/sum(d),d=||x-psrc||^(-u),u=2
d=1./(c1.^2+c2.^2);
a=d./repmat(sum(d,1),n,1);

%f(x)=sum(wi*fi),fi=pdsti+Di(x-psrci)
y2=round(sum(a.*(repmat(pdst(:,2),1,h*w)+c1.*repmat(d22,1,h*w)+c2.*repmat(d21,1,h*w)),1));
x2=round(sum(a.*(repmat(pdst(:,1),1,h*w)+c1.*repmat(d12,1,h*w)+c2.*repmat(d11,1,h*w)),1));

y2(y2>h)=h;
y2(y2<1)=1;
x2(x2>w)=w;
x2(x2<1)=1;
y2=reshape(y2,h,w);
x2=reshape(x2,h,w);

end

