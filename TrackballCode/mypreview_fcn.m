function mypreview_fcn(obj,event,himage)
% Example update preview window function.

% % Get timestamp for frame.
% tstampstr = event.Timestamp;
% 
% % Get handle to text label uicontrol.
% ht = getappdata(himage,'HandleToTimestampLabel');
% 
% % Set the value of the text label.
% set(ht,'String',tstampstr);
% 
% % Display image data.
% set(himage, 'CData', event.Data)

% Get timestamp for frame.
tstampstr = event.Timestamp;

% Get handle to text label uicontrol.
ht = getappdata(himage,'HandleToTimestampLabel');

% Set the value of the text label.
set(ht,'String',tstampstr);

image=event.Data;


% Display image data.
set(himage, 'CData', event.Data)