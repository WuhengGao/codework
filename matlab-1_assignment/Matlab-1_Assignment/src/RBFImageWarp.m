function im2 = RBFImageWarp(im, psrc, pdst)

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
for i=1:h
    for j=1:w
        i2=i+sum(a(:,1)./sqrt((psrc(:,1)-i*ones(n,1)).^2+(psrc(:,2)-j*ones(n,1)).^2+r),1);
        j2=j+sum(a(:,2)./sqrt((psrc(:,1)-i*ones(n,1)).^2+(psrc(:,2)-j*ones(n,1)).^2+r),1);
        i2=round(i2);
        j2=round(j2);
        if i2 > h || j2>w || i2 < 1 || j2 < 1
				continue;
        end
        im2(i2,j2,:)=im(i,j,:);
        
    end
end


%% TODO: compute warpped image