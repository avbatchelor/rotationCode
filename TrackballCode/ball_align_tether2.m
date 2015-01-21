function ball_align_tether2(axis_align, vid_duration)

imaqreset;

global align_duration;

align_duration = vid_duration;

if axis_align == 1;
    side_align;
elseif axis_align == 2;
    top_align;
elseif axis_align == 3;
    back_align; % NOTE: AS OF 30 AUGUST 2013, THERE IS NO LONGER A BACK CAMERA
elseif axis_align == 4;
    show_previews;
end


function show_previews;

vid1 = videoinput('dcam',1,'Y8_640x480');
vid2 = videoinput('dcam',2,'Y8_640x480');
vid3 = videoinput('dcam',3,'Y8_640x480');

preview(vid3)
preview(vid2)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function side_align(align_duration)

vid_side = videoinput('dcam',1,'Y8_640x480');

global align_duration;
track_time = align_duration;
set(vid_side,'FramesPerTrigger',inf);
set(vid_side,'FrameGrabInterval', 1);
triggerconfig(vid_side, 'Manual');
start(vid_side);
trigger(vid_side);
pause(.15);
stop(vid_side);
frames2grab = get(vid_side,'FramesAvailable');
[dataVideo4 video_time4] = getdata(vid_side,frames2grab);
imagesc(dataVideo4(:,:,:,2)); colormap('bone');
set(gcf,'Units','pixels');
scnsize = get(0,'ScreenSize');
set(gcf,'Position',[1 1 scnsize(3) scnsize(4)]);

input_x_coord4(1) = 157.5507;
input_y_coord4(1) = 413.8333;
input_x_coord4(3) = 474.6014;
input_y_coord4(3) = 416.6404;
center4 = [315.6887  458.9903];
radius4 = 164.4590;

% tall ball 
% input_x_coord4(1) = 151.6521;
% input_y_coord4(1) =  408.2193;
% input_x_coord4(3) = 477.5507;
% input_y_coord4(3) = 412.4298;

%[input_x_coord3 input_y_coord3] = ginput(3);
%[center3 radius3] = calcCircle([input_x_coord3(1) input_y_coord3(1)],[input_x_coord3(2) input_y_coord3(2)],[input_x_coord3(3) input_y_coord3(3)]);

%[x_stick4 y_stick4] = ginput(2);
x_stick4 = [328.5645 324.0483870967742];
y_stick4 = [221.3494 1.426640];

%[x_olf4 y_olf4] = ginput(4);
x_olf4 = [336.4516-7.8 427.4194-7.8 328.0645-7.8 425.4839-7.8];
y_olf4 = [215.2279+6.1 222.9491+6.1 263.4853+6.1 263.4853+6.1];

olfactometer_distance = .1*2*radius4/.635;

hold on; circle(center4,radius4,1000,'r--');
hold on; plot(input_x_coord4(1), input_y_coord4(1), 'r*');
hold on; plot(input_x_coord4(3), input_y_coord4(3), 'r*');
hold on; line([x_stick4(1) x_stick4(2)], [y_stick4(1) y_stick4(2)],'Color','r');
hold on; line([x_olf4(1) x_olf4(2)], [y_olf4(1) y_olf4(2)],'Color','r');
hold on; line([x_olf4(3) x_olf4(4)], [y_olf4(3) y_olf4(4)],'Color','r');
hold on; line([x_olf4(2) x_olf4(4)], [y_olf4(2) y_olf4(4)],'Color','r');
hold on; line([center4(1) center4(1)], [center4(2) 0],'Color','r');

xlim([0 640]);
ylim([0 480]);
axis off;
pause;


start_clock = clock;
start_time_seconds = (start_clock(4)*3600)+(start_clock(5)*60)+(start_clock(6));
tmp_val = (start_clock(4)*3600)+(start_clock(5)*60)+(start_clock(6));

while (tmp_val) < (start_time_seconds + track_time)
    vid_side = videoinput('dcam',1,'Y8_640x480');

    set(vid_side,'FramesPerTrigger',inf);
    set(vid_side,'FrameGrabInterval', 1);
    set(vid_side.Source,'Gain',1,'AutoExposure',100);
    triggerconfig(vid_side, 'Manual');
    start(vid_side);
    trigger(vid_side);
    pause(.12);
    stop(vid_side);
    frames2grab = get(vid_side,'FramesAvailable');
    [dataVideo4 video_time4] = getdata(vid_side,frames2grab);
    imagesc(dataVideo4(:,:,:,2)); colormap('bone');
    hold on; circle(center4,radius4,1000,'r--');
    hold on; plot(input_x_coord4(1), input_y_coord4(1), 'r*');
    hold on; plot(input_x_coord4(3), input_y_coord4(3), 'r*');
    hold on; line([x_stick4(1) x_stick4(2)], [y_stick4(1) y_stick4(2)],'Color','r');
    hold on; line([x_olf4(1) x_olf4(2)], [y_olf4(1) y_olf4(2)],'Color','r');
    hold on; line([x_olf4(3) x_olf4(4)], [y_olf4(3) y_olf4(4)],'Color','r');
    hold on; line([x_olf4(2) x_olf4(4)], [y_olf4(2) y_olf4(4)],'Color','r');
    hold on; line([center4(1) center4(1)], [center4(2) 0],'Color','r');
    current_time = clock;
    tmp_val = (current_time(4)*3600)+(current_time(5)*60)+(current_time(6));
    delete(vid_side);
    clear vid_side;
end
%close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function back_align(align_duration)
vid_back = videoinput('dcam',3,'Y8_640x480'); % uses side camera to aid with floating ball at proper height

global align_duration;
track_time = align_duration;
set(vid_back,'FramesPerTrigger',inf);
set(vid_back,'FrameGrabInterval', 1);
triggerconfig(vid_back, 'Manual');
start(vid_back);
trigger(vid_back);
pause(.15);
stop(vid_back);
frames2grab = get(vid_back,'FramesAvailable');
[dataVideo1 video_time1] = getdata(vid_back,frames2grab);
imagesc(dataVideo1(:,:,:,2)); colormap('bone');
set(gcf,'Units','pixels');
scnsize = get(0,'ScreenSize');
set(gcf,'Position',[1 1 scnsize(3) scnsize(4)]);

% input_x_coord1(1) = 220.8226;
% input_y_coord1(1) = 315.4598;
% input_x_coord1(3) = 388.5645;
% input_y_coord1(3) = 315.4598;
% 
% %input_x_coord1(3) = 379.5323;
% %input_y_coord1(3) = 281.3579;
% center1 = [304.7911  340.5673];
% radius1 =  87.6419;


[input_x_coord1 input_y_coord1] = ginput(3);
[center1 radius1] = calcCircle([input_x_coord1(1) input_y_coord1(1)],[input_x_coord1(2) input_y_coord1(2)],[input_x_coord1(3) input_y_coord1(3)]);
olfactometer_distance = .1*2*radius1/.635;

hold on; circle(center1,radius1,1000,'r--');
hold on; line([0 640], [input_y_coord1(1) input_y_coord1(1)],'Color','r');
hold on; line([center1(1) center1(1)], [center1(2) 0],'Color','r');


xlim([0 640]);
ylim([0 480]);
axis off;
pause;


start_clock = clock;
start_time_seconds = (start_clock(4)*3600)+(start_clock(5)*60)+(start_clock(6));
tmp_val = (start_clock(4)*3600)+(start_clock(5)*60)+(start_clock(6));

while (tmp_val) < (start_time_seconds + track_time)
    vid_back = videoinput('dcam',3,'Y8_640x480');

    set(vid_back,'FramesPerTrigger',inf);
    set(vid_back,'FrameGrabInterval', 1);
    triggerconfig(vid_back, 'Manual');
    start(vid_back);
    trigger(vid_back);
    pause(.12);
    stop(vid_back);
    frames2grab = get(vid_back,'FramesAvailable');
    [dataVideo1 video_time1] = getdata(vid_back,frames2grab);
    imagesc(dataVideo1(:,:,:,2)); colormap('bone');
    hold on; circle(center1,radius1,1000,'r--');
    hold on; line([0 640], [input_y_coord1(1) input_y_coord1(1)],'Color','r');
    hold on; line([center1(1) center1(1)], [center1(2) 0],'Color','r');
    current_time = clock;
    tmp_val = (current_time(4)*3600)+(current_time(5)*60)+(current_time(6));
    delete(vid_back);
    clear vid_back;
end
close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function top_align(align_duration)

y_vert_offset = 80;
OD_olfactometer = .1;%cm

global align_duration;
track_time = align_duration;

vid_top = videoinput('dcam',2,'Y8_640x480');

set(vid_top,'FramesPerTrigger',inf);
set(vid_top,'FrameGrabInterval', 1);
triggerconfig(vid_top, 'Manual');
start(vid_top);
trigger(vid_top);
pause(.15);
stop(vid_top);
frames2grab = get(vid_top,'FramesAvailable');
[dataVideo video_time] = getdata(vid_top,frames2grab);
imagesc(dataVideo(:,:,:,2)); colormap('bone');
set(gcf,'Units','pixels');
scnsize = get(0,'ScreenSize');
set(gcf,'Position',[1 1 scnsize(3) scnsize(4)]);

[input_x_coord2 input_y_coord2] = ginput(3);

[center2 radius2] = calcCircle([input_x_coord2(1) input_y_coord2(1)],[input_x_coord2(2) input_y_coord2(2)],[input_x_coord2(3) input_y_coord2(3)]);


% input_x_coord2(1) =  195.6613;
% input_y_coord2(1) = 121.7869;
% input_x_coord2(3) =  496.9516;
% input_y_coord2(3) =  192.5643;
% center2 = [326.5904  241.1042];
% radius2 = 177.1414;

olfactometer_distance = .1*2*radius2/.635;
hold on; circle(center2,radius2,1000,'y--');
xlim([0 640]);
ylim([0 480]);
axis off;
line([center2(1) center2(1)],[0 480],'Color','y');
line([center2(1) center2(1)],[center2(2)-y_vert_offset (center2(2)-olfactometer_distance)-y_vert_offset],'Color','r');
line([0 640], [(center2(2)-olfactometer_distance)-y_vert_offset (center2(2)-olfactometer_distance)-y_vert_offset],'Color','y');
line([0 640], [center2(2)-y_vert_offset center2(2)-y_vert_offset],'Color','y');
line([center2(1)+OD_olfactometer*2*radius2/.635 center2(1)+OD_olfactometer*2*radius2/.635], [(center2(2)-olfactometer_distance)-y_vert_offset 0],'Color','y');
line([center2(1)-OD_olfactometer*2*radius2/.635 center2(1)-OD_olfactometer*2*radius2/.635], [(center2(2)-olfactometer_distance)-y_vert_offset 0],'Color','y');

pause;

start_clock = clock;
start_time_seconds = (start_clock(4)*3600)+(start_clock(5)*60)+(start_clock(6));
tmp_val = (start_clock(4)*3600)+(start_clock(5)*60)+(start_clock(6));

while (tmp_val) < (start_time_seconds + track_time)
    vid_top = videoinput('dcam',2,'Y8_640x480');

    set(vid_top,'FramesPerTrigger',inf);
    set(vid_top,'FrameGrabInterval', 1);
    triggerconfig(vid_top, 'Manual');
    start(vid_top);
    trigger(vid_top);
    pause(.12);
    stop(vid_top);
    frames2grab = get(vid_top,'FramesAvailable');
    [dataVideo video_time] = getdata(vid_top,frames2grab);
    imagesc(dataVideo(:,:,:,2)); colormap('bone');
    hold on; circle(center2,radius2,1000,'y--');
    xlim([0 640]);
    ylim([0 480]);
    axis off;
    line([center2(1) center2(1)],[0 480],'Color','y');
    line([center2(1) center2(1)],[center2(2)-y_vert_offset (center2(2)-olfactometer_distance)-y_vert_offset],'Color','r');
    line([0 640], [(center2(2)-olfactometer_distance)-y_vert_offset (center2(2)-olfactometer_distance)-y_vert_offset],'Color','y');
    line([0 640], [center2(2)-y_vert_offset center2(2)-y_vert_offset],'Color','y');
    line([center2(1)+OD_olfactometer*2*radius2/.635 center2(1)+OD_olfactometer*2*radius2/.635], [(center2(2)-olfactometer_distance)-y_vert_offset 0],'Color','y');
    line([center2(1)-OD_olfactometer*2*radius2/.635 center2(1)-OD_olfactometer*2*radius2/.635], [(center2(2)-olfactometer_distance)-y_vert_offset 0],'Color','y');
    current_time = clock;
    tmp_val = (current_time(4)*3600)+(current_time(5)*60)+(current_time(6));
    delete(vid_top);
    clear vid_top;
end
close all;