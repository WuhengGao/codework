function im2= fixhole(im,hole)
[h, w, dim] = size(im);
det1=[1,-1,0,0,1,1,-1,-1];
det2=[0,0,1,-1,1,-1,1,-1];
det=[1,-1,h,-h,h+1,-h+1,h-1,-h-1];
im2=im;

[i,j]=ind2sub([h,w],hole);
flag=8*ones(length(hole),1);
sum=zeros(length(hole),dim);
for k=1:8
    i2=i+det1(k);
    j2=j+det2(k);
    hole2=hole+det(k);
    f1=union(find(i2>h),find(i2<1));
    f2=union(find(j2>w),find(j2<1));
    [~,f3,~]=intersect(hole2,hole);
    f=union(f1,f2);
    f=union(f,f3);
    sf=setdiff(1:length(hole),f);
    flag(f)=flag(f)-1;
    for d=1:dim
        imd=im(:,:,d);
        sum(sf,d)=sum(sf,d)+imd(hole2(sf))';
    end
end
rest=find(flag~=0);
sum=sum./repmat(flag,1,dim);
sum=round(sum);
sum(sum>255)=255;
sum(sum<0)=0;
for d=1:dim
    imd=im2(:,:,d);
    imd(hole(rest))=sum(rest,d);
    im2(:,:,d)=imd;
end
    

    
end

