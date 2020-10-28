function toolMarkCB(h, varargin)

evalin('base', 'delete(hpolys);');
evalin('base', 'delete(L);');
evalin('base', 'delete(m);');

set(h, 'Enable', 'off');

hp1 = impoly(subplot(121));
hp1.setVerticesDraggable(false);

hp2 = impoly(subplot(122), hp1.getPosition);
hp2.setVerticesDraggable(false);
addNewPositionCallback(hp2,@toolPasteCB);

assignin('base', 'hpolys', [hp1; hp2]);
im2 = evalin('base', 'im2');
m1=createMask(hp1);

[A,mm]= computeA( im2, m1);

%A=L'*L£¬pre-decomposition
assignin('base', 'L', chol(A));

%m(i)=0,m(i)=1,m(i)=2:outside,omega,boundary of omega
assignin('base', 'm', mm);

set(h, 'Enable', 'on');