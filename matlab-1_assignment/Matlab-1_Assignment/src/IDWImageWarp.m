function im2 = IDWImageWarp(im, psrc, pdst)

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



%% change image
for i=1:h
    for j=1:w
        %d=pdist2([i,j],psrc);
        %d=d.^2;
        d=(psrc(:,1)-i*ones(n,1)).^2+(psrc(:,2)-j*ones(n,1)).^2;
        d=ones(n,1)./d;
        a=d./repmat(sum(d,1),n,1);
        %a:wi
        det=repmat([i,j],n,1)-psrc;
        %det:x-p
        i2=sum(a.*(pdst(:,1)+det(:,1).*d11+det(:,2).*d12),1);
        %i2=sum(wi*fi),fi=q(x)+d11*det(x)+d12*det(y)
        j2=sum(a.*(pdst(:,2)+det(:,1).*d21+det(:,2).*d22),1);
        i2=round(i2);
        j2=round(j2);
        if i2 > h || j2>w || i2 < 1 || j2 < 1
				continue;
        end
        im2(i2,j2,:)=im(i,j,:);
        
    end
end

