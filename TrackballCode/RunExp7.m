%%  Program Description

function RunExp7(flyNum,flyExpNum,flyCond)
% Program to deliver light stimulus on one side

% To callibrate the voltage and current
% putsample(AO,[5,0])
pause

%% Amplifier settings
% Count six notches

%% mouse data conversion factors
convert_x = 1.99/7750;
convert_y = 1.99/8242;

%% Experiment information
data.date = datestr(now,29);                               % experiment date
data.expNum = 7;                     % Alex's experiment number
data.flyNum = flyNum;                     % fly number of the day
data.flyExpNum = flyExpNum;                     % Alex's experiment number
data.numBlocks = 400;                            % length of a block which contains equal numbers of left and right trials
data.numTrialsPerBlock = 20;                     % must be a multiple of 2
data.numTrials = data.numBlocks * data.numTrialsPerBlock; % total number of trials
data.flycond = flyCond;                         % fly condition (antenna glued? head glued?)

%% Make directories

% make a path name for this experiment if one does not exist
pathName = ['C:\Alex\Dropbox\TrackballData\ExpNum',num2str(data.expNum)];
if ~isdir(pathName)
    mkdir(pathName);
end

% make a data directory if one does not exist
dataSaveLocation = [pathName,'\RawData\fly',num2str(data.flyNum),'_flyExpNum',num2str(data.flyExpNum),'\'];
if ~isdir(dataSaveLocation)
    mkdir(dataSaveLocation);
end

%% define stimulus parameters and generate stimulus

% stimulus parameters
data.stim.freq=300;  %stimulus frequency (in Hz)
data.stim.samprate=40000; %stimulus output sample rate (in Hz)
data.stim.dur=0.015; %stimulus duration (in seconds)
data.stim.durramp=0;
data.stim.numPips = 10;
data.stim.interPipInterval = 0.034; % From the start of one pip to the start of the next
data.stim.restTime = 2; % Time within a trial that occurs before and after presentation of the stimulus train
data.stim.voltageConversion = 1;
data.stim.type = 'light';

% generate sound stimulus
[stimTrain data.stim.pipStarts data.stim.pipEnds] = generateFlashTrain(data.stim.freq,data.stim.samprate,data.stim.dur,data.stim.durramp,data.stim.numPips,data.stim.interPipInterval,data.stim.restTime);
data.stim.stimTrain = data.stim.voltageConversion.*stimTrain;
if isempty(data.stim.stimTrain) % if tone is not generated, display error
    fprintf('bad stimulus value\n');
    return;
end

data.stim.trialTime = length(data.stim.stimTrain)/40000;



%% prepare to initiate trials

% start dde for mouse data
dos('C:\Alex\Dropbox\GitHub\AlexRepository\TrackballCode\MouseDataDirect3.exe &');
globalTimer = tic;

    % reset aquisition engines
    daqreset;
    
%% run trial
for n = 1:data.numTrials
    
    % reset aquisition engines
    daqreset;
    pause(5)
    if n==1
        pause(10)
    end
    data.trialData.trialStart = toc(globalTimer);
    disp(['trial number: ',num2str(n)]);
    
    % initiate dde (to acquire trackball data from mouse)
    channel = ddeinit('MouseDataDirect','DataForm');
    

    
    %% Trial information
    data.trialData.speaker = 'L';   % which speaker emits sound for a given trial
    data.trialData.trialNumber = n;                              % trial number
    

    % configure analog output
    AO = analogoutput ('nidaq', 'Dev1');
    addchannel (AO, 0:1);
    set(AO, 'SampleRate', data.stim.samprate);
    set(AO, 'TriggerType', 'Manual');

    % load stimulus
    ch0out = data.stim.stimTrain;           %Left speaker
    ch1out = zeros(length(data.stim.stimTrain),1);    %Right speaker (B&W wire)
    putdata(AO,[ch0out, ch1out]);
    

    % Preallocate space
    x = zeros(length(data.stim.stimTrain),1);    % Matlab samples at approx 3kHz. This allocates more than
    y = zeros(length(data.stim.stimTrain),1);    % enough space for each trial.
    t = zeros(length(data.stim.stimTrain),1);
    
    
    %change to format long
    format long;
    
    data.trialData.beforeStimulusStart = toc(globalTimer);
    
    %start playback
    start(AO);
    triggerStart=tic; trigger(AO);
    
    % collect mouse data
    mouseDataPoint=1;
    elapsedTime = toc(triggerStart);
    while elapsedTime < data.stim.trialTime + 0.06;
        t(mouseDataPoint) = toc(triggerStart);
        x(mouseDataPoint) = ddereq(channel, 'txtDx');
        y(mouseDataPoint) = ddereq(channel, 'txtDy');
        elapsedTime = t(mouseDataPoint);
        mouseDataPoint = mouseDataPoint+1;
    end
    
    data.trialData.beforeStopping = toc(globalTimer);
    
    % stop data collection
    stop(AO);
    
    ddeterm(channel);
   
    
    data.trialData.AOInitialTriggerTime = AO.InitialTriggerTime;
    
    
    delete(AO);
    clear AO;
    
    
    
    %% reformat mouse data
    t(mouseDataPoint:end) = [];
    x(mouseDataPoint:end) = [];
    y(mouseDataPoint:end) = [];
    
    data.trialData.t = t;
    data.trialData.x = x.*convert_x;
    data.trialData.y = y.*convert_y;
    
    xplot = convert_x.*(x - repmat(x(1),[length(x),1]));
    yplot = convert_y.*(y - repmat(y(1),[length(y),1]));
    
    figure(1)
    plot(xplot,yplot)
    title(data.trialData.speaker)
    
    data.trialData.trialEnd = toc(globalTimer);
    
    %% save data(n)
    dataFilename = [dataSaveLocation,'ExpNum',num2str(data.expNum),'_fly',num2str(data.flyNum),'_flyExpNum',num2str(data.flyExpNum),'_',datestr(now,29),'_trial',num2str(n),'.mat'];
    save(dataFilename, 'data');
    data=rmfield(data,'trialData');
    clear x y t ch0out ch1out
    
    
end


    % reset aquisition engines
    daqreset;


close all
clear all

