%%  Program Description

% Program delivers 300 Hz tone to one of two speakers
% (using the sound card).
% use DIO 0-2 to set channel and AO0 to set waveform
% enter channel number as binary 3-vector (i.e. [1 0 0])
% flyNumber = fly number
% expNumber = experiment number
% intensities = voltages being put out to NIDAQ board (vector; 1 is most intense)
% speakerLorR = which speaker emits sound (string, 'L' for left, 'R' for right)
% flycond = fly condition (aristae clipped? head glued?) (string)
% stim_freq = stimulus frequency (in Hz)
% stim_samprate = output sample rate of stimulus (in Hz; should be 40 kHz)
% stim_dur = duration of tone (in seconds)
% numtrials = number of times this program will run (i.e., number of
% trials in experiment)

close all
clear all

pause;




%% mouse data conversion factors
convert_x = 1.99/7750;
convert_y = 1.99/8242;


%% prepare to initiate trial

% start dde for mouse data
mouse_status = dos('C:\Alex\Dropbox\GitHub\AlexRepository\TrackballCode\MouseDataDirect3.exe &');



goodRunning = 0;
blockNumber = 0;

%% run trial
while goodRunning == 0; 
    blockStart=tic;
    blockNumber = blockNumber+1;
    disp(['block number: ',num2str(blockNumber)]);
    
    % reset aquisition engines
    daqreset;
    
    %% Trial information
    
    % Preallocate space
    x = zeros(60*40000,1);    % Matlab samples at approx 3kHz. This allocates more than
    y = zeros(60*40000,1);    % enough space for each trial.
    t = zeros(60*40000,1);
    
    % initiate dde (to acquire trackball data from mouse)
    channel = ddeinit('MouseDataDirect','DataForm');   

    %change to format long
    format long;
    
    % collect mouse data
    mouseDataPoint=1;
    elapsedTime = toc(blockStart);
    while elapsedTime <= 60;
        t(mouseDataPoint) = toc(blockStart);
        x(mouseDataPoint) = ddereq(channel, 'txtDx');
        y(mouseDataPoint) = ddereq(channel, 'txtDy');
        elapsedTime = t(mouseDataPoint);
        mouseDataPoint = mouseDataPoint+1;
    end
    
    
    %% reformat mouse data
    t(mouseDataPoint:end) = [];
    x(mouseDataPoint:end) = [];
    y(mouseDataPoint:end) = [];
    
    x = x*convert_x;
    y = y*convert_y;
    
    %% Analyse data from the last minute
    forwardVelocity = diff(y)./diff(t);
    lateralVelocity = diff(x)./diff(t);
    
    averageLateralVelocity = mean(lateralVelocity);
    disp(['Average lateral velocity = ', num2str(averageLateralVelocity)])
    
    averageForwardVelocity = mean(forwardVelocity);
    disp(['Average forward velocity = ', num2str(averageForwardVelocity)])
    
%     figure(1)
%     bins = -30:0.1:30;
%     hist(forwardVelocity,bins)
    
    x = x - repmat(x(1),[length(x),1]);
    y = y - repmat(y(1),[length(y),1]);
    
    figure()
    plot(x,y)
    
    if -0.2<averageLateralVelocity<0.2 && averageForwardVelocity > 0.5 
        goodRunning = 1;
    end
    clear x y t forwarVelocity lateralVelocity
    ddeterm(channel)
end

send_text_message('857-265-8622','AT&T','Fly is running well','Fly is running well')

daqreset;

close all
clear all

