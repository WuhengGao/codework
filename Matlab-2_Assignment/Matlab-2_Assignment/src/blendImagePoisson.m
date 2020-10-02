function imret = blendImagePoisson(im1, im2,m,L,dp)

% input: im1 (background), im2 (foreground), m1 (mask in im2), 
%L(A=L'*L),dp(f*p-fp)


%% TODO: compute blended image
imret=im1;
[h, ~, ~] = size(im2);
[h2, ~, ~] = size(im1);

in=find(m==1);
[inx,iny]=find(m==1);
ih=length(in);
%omega

tinx=inx+dp(2)*ones(ih,1);
tiny=iny+dp(1)*ones(ih,1);
tin=tinx+h2*(tiny-ones(ih,1));
%target omega

b=zeros(ih,3);

det=[1,-1,h,-h];
det2=[1,-1,h2,-h2];
for i=1:3
    imi2=im2(:,:,i);
    imi1=im1(:,:,i);
    fp1=double(imi2(in));
    fp2=double(imi1(tin));
    for t=1:4
        fq1=double(imi2(in+det(t)*ones(ih,1)));
        fq2=double(imi1(tin+det2(t)*ones(ih,1)));
        vpq1=fp1-fq1;
        vpq2=fp2-fq2;
        flag=(abs(vpq1)>abs(vpq2));
        vpq=vpq1;
        vpq(~flag)=vpq2(~flag);
        %mixing gradients
        b(:,i)=b(:,i)+vpq;
        
        mq=m(in+det(t)*ones(ih,1));
        flag2=find(mq==2);
        %q in boundary
        b(flag2,i)=b(flag2,i)+fq2(flag2);
    end
end

%x=linsolve(L',b,'opts.LT = true');
%x2=linsolve(L,x,'opts.UT = true');

x=L'\b;
x2=L\x;


%L'Lx2=b,L:Upper triangular



x2=uint8(x2);
for i=1:3
    for j=1:ih
        imret(tinx(j),tiny(j),i)=x2(j,i);
    end
end






