function [A,m] = computeA( im2, m1)
%m(i)=0,m(i)=1,m(i)=2:outside,omega,boundary of omega
[h, ~, ~] = size(im2);
m=m1;

b=edge(m1);
bw=find(b);
%boundary of omega

in=find(m1);
inter=intersect(in,bw);
m(inter)=0;
in=find(m);
m=m+2*b;
ih=length(in);
%omega

imax=max(in,[],1);
cindex=zeros(imax,1);
cindex(in)=1:ih;
%cindex:index of m->index of A

u=1:ih;
v=1:ih;
s=4*ones(1,ih);
%A=sparse(u,v,s);

det=[1,-1,h,-h];

for t=1:4
        q=in+det(t)*ones(ih,1);
        mq=m(q);
        flag=(mq==1);
        %q in omega

        uq=1:ih;
        uq=uq(flag);
        vq=cindex(q(flag));
        sq=-ones(1,ih);
        sq=sq(flag);
        u=[u,uq];
        v=[v,vq'];
        s=[s,sq];
end
A=sparse(u,v,s,ih,ih);

