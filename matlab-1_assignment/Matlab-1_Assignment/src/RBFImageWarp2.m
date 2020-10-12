function im2 = RBFImageWarp2(im, psrc, pdst)

% input: im, psrc, pdst
%psrc:start points
%pdst:end points


%% basic image manipulations
% get image (matrix) size
[h, w, dim] = size(im);
n=size(pdst,1);
im2=255*ones(h,w,dim);


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
i=1:h;
j=1:w;
c1=repmat(i,n,1)-repmat(psrc(:,1),1,h);
c1=repmat(c1,1,w);
c2=repmat(j,n,1)-repmat(psrc(:,2),1,w);
c2=kron(c2,ones(1,h));
c=sqrt(c1.^2+c2.^2+repmat(r,1,w*h));
i2=repmat(i,1,w)+sum(repmat(a(:,1),1,w*h)./c,1);
j2=kron(j,ones(1,h))+sum(repmat(a(:,2),1,w*h)./c,1);
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
    



end
