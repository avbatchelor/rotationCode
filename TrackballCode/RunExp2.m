%%  Program Description

function RunExp2(flyNum,flyExpNum,flyCond)
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


pause

%% Amplifier settings
% Count six notches

%% mouse data conversion factors
convert_x = 1.99/7750;
convert_y = 1.99/8242;

%% Experiment information
data.date = datestr(now,29);                               % experiment date
data.expNum = 2;                     % Alex's experiment number
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

% make a video directory if one does not exist
vidSaveLocation = [pathName,'\Video\fly',num2str(data.flyNum),'_flyExpNum',num2str(data.flyExpNum),'\'];
if ~isdir(vidSaveLocation)
    mkdir(vidSaveLocation);
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
data.stim.voltageConversion = 1.5;

% generate sound stimulus
[stimTrain data.stim.pipStarts data.stim.pipEnds] = generateStimTrain(data.stim.freq,data.stim.samprate,data.stim.dur,data.stim.durramp,data.stim.numPips,data.stim.interPipInterval,data.stim.restTime);
data.stim.stimTrain = data.stim.voltageConversion.*stimTrain;
if isempty(data.stim.stimTrain) % if tone is not generated, display error
    fprintf('bad stimulus value\n');
    return;
end

data.stim.trialTime = length(data.stim.stimTrain)/40000;

%% Randomly order sound source for each trial
% Assumes there are always 20 trials per block.  10 are to the right.  For each side there are two trials of each intensity.  
% 1 to 5 = left trials, 6 to 10 = right trials 
% 1 is lowest intensity 5 is highest, 6 lowest, 10 highest.

for j=1:data.numBlocks;
    soundSourceNonRandom = [1:10 1:10];
    soundSourceIndex = randperm(data.numTrialsPerBlock);
    if j==1
        soundSource = soundSourceNonRandom(soundSourceIndex);
    else
        soundSource(end+1:end+data.numTrialsPerBlock) = soundSourceNonRandom(soundSourceIndex);
    end
end

speakerDirection = {'L' 'R'};           % 1 is left, 2 is right
intensity = [0.05 0.1 0.2 0.4 0.8];



%% prepare to initiate trials

% start dde for mouse data
mouse_status = dos('C:\Alex\Dropbox\GitHub\AlexRepository\TrackballCode\MouseDataDirect3.exe &');
globalTimer = tic;


%% run trial
for n = 1:data.numTrials
    pause(5)
    data.trialData.trialStart = toc(globalTimer);
    disp(['trial number: ',num2str(n)]);
    
    % initiate dde (to acquire trackball data from mouse)
    channel = ddeinit('MouseDataDirect','DataForm');
    
    % reset aquisition engines
    daqreset;
    
    %% Trial information
    if soundSource(n) < 6 
        data.trialData.speaker = 'L';   % which speaker emits sound for a given trial
        data.trialData.intensity = intensity(soundSource(n));
    else 
        data.trialData.speaker = 'R'; 
        data.trialData.intensity = intensity(soundSource(n) - 5);
    end
        data.trialData.trialNumber = n;                              % trial number
    
    % Preallocate space
    x = zeros(length(data.stim.stimTrain),1);    % Matlab samples at approx 3kHz. This allocates more than
    y = zeros(length(data.stim.stimTrain),1);    % enough space for each trial.
    t = zeros(length(data.stim.stimTrain),1);
    
    % reset image acquisition engine
    imaqreset;
    
    
    
    % configure analog output
    AO = analogoutput ('nidaq', 'Dev1');
    addchannel (AO, 0:1);
    set(AO, 'SampleRate', data.stim.samprate);
    set(AO, 'TriggerType', 'Manual');
    
    % load stimulus
    if strcmp(data.trialData.speaker,'L')
        ch0out = data.trialData.intensity.*data.stim.stimTrain;           %Left speaker
        ch1out = zeros(length(data.stim.stimTrain),1);    %Right speaker (B&W wire)
    elseif strcmp(data.trialData.speaker,'R')
        ch0out = zeros(length(data.stim.stimTrain),1);    %Left speaker
        ch1out = data.trialData.intensity.*data.stim.stimTrain;           %Right speaker (B&W wire)
    end
    putdata(AO,[ch0out, ch1out]);
    

    
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
    
    data.trialData.beforeVideoCollection = toc(globalTimer);
  

    
    data.trialData.afterVideoCollection = toc(globalTimer);
    

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



daqreset;

close all
clear all

