function im2 = IDWImageWarp2(im, psrc, pdst)

% input: im, psrc, pdst
%psrc:start points
%pdst:end points


%% basic image manipulations
% get image (matrix) size
[h, w, dim] = size(im);
n=size(pdst,1);
im2=255*ones(h,w,dim);

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
x1=A\b1;
x2=A\b2;
d11=x1(1:n,:);
d12=x1(n+1:2*n,:);
d21=x2(1:n,:);
d22=x2(n+1:2*n,:);

i=1:h;
j=1:w;
c1=repmat(i,n,1)-repmat(psrc(:,1),1,h);
c1=repmat(c1,1,w);
c2=repmat(j,n,1)-repmat(psrc(:,2),1,w);
c2=kron(c2,ones(1,h));
d=1./(c1.^2+c2.^2);
a=d./repmat(sum(d,1),n,1);
%a:wi
i2=repmat(pdst(:,1),1,h*w)+c1.*repmat(d11,1,h*w)+c2.*repmat(d12,1,h*w);
i2=sum(a.*i2,1);
j2=repmat(pdst(:,2),1,h*w)+c1.*repmat(d21,1,h*w)+c2.*repmat(d22,1,h*w);
j2=sum(a.*j2,1);
i2=round(i2);
j2=round(j2);
i2(i2>h)=h;
i2(i2<1)=1;
j2(j2>w)=w;
j2(j2<1)=1;
idx=sub2ind([h,w],j2,i2);
for k=1:dim
    imi=255*ones(h,w);
    imi(idx)=im(:,:,k);
    im2(:,:,k)=imi;
end

hole=setdiff(1:w*h,idx);
im2=fixhole(im2,hole); 

end

