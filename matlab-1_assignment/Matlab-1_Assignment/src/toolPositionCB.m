function toolPositionCB(h, varargin)

set(h, 'Enable', 'off');

subplot(131);
set(h, 'Enable', 'on', 'UserData', [h.UserData, imline]);
