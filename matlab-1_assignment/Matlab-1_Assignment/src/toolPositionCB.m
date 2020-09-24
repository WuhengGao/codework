function toolPositionCB(h, varargin)

set(h, 'Enable', 'off');
%real time off

subplot(131);
hh=imline;
addNewPositionCallback(hh,@toolWarpCB);
set(h, 'Enable', 'on', 'UserData', [h.UserData, hh]);


w=1;


