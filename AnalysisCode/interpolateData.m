function interpolateData(expNum,flyNum,flyExpNum,computer)

% function interpolateTrkbData_randomized(data,fly_num,exp_num,save_directory)
%
% Takes data structure of parameters for a given experiment, fly number,
% and experiment number, and returns a .mat file containing matrices for
% (1) y velocities, (2) x velocities, (3) filtered/interpolated
% x values, and (4) filtered/interpolated y values.  The returned .mat
% file also contains a vector of small time stamps for the trial duration.
% This version is the same as the original (interpolateTrkbData) except it
% is compatible with aeb_testthreshold_randomized.

%% load raw data and process (filter, interpolate, calculate velocity)
% pathName = ['C:\Alex\TrackballData\ExpNum',num2str(expNum)];
% dataSaveLocation = [pathName,'\RawData\fly',num2str(flyNum),'_flyExpNum',num2str(flyExpNum),'\'];

% for laptop


if strcmpi(computer,'laptop')
    pathName = ['C:\Users\Alex\Desktop\Harvard\Dropbox\TrackballData\ExpNum',num2str(expNum)];
    dataSaveLocation = [pathName,'\RawData\fly',num2str(flyNum),'_flyExpNum',num2str(flyExpNum),'\'];
elseif strcmpi(computer,'desktop')
    pathName = ['C:\Alex\Dropbox\TrackballData\ExpNum',num2str(expNum)];
    dataSaveLocation = [pathName,'\RawData\fly',num2str(flyNum),'_flyExpNum',num2str(flyExpNum),'\'];
end

cd(dataSaveLocation)
fileNames = dir('*.mat');
numTrials = length(fileNames);


% multiply trial duration by 600 because mouse samprate is 500 Hz, and want to give
% a little more than that to allow for fuzziness in acquisition

% load and process data
for n = 1:numTrials;
    clear data
    load([dataSaveLocation,fileNames(n).name]);
    
    trialNumber = data.trialData.trialNumber;
    
    dataLength = length(data.trialData.t);
    
    if data.expNum ==5
        data.stim.trialTime = unique(cell2mat(data.stim.trialTime));
    end
    interpTime=0:.001:data.stim.trialTime;  % vector marking small time stamps for duration of trial (downsamples to 1 kHz)
    
    % preallocate space for matrices
    if n==1
        xInterpFilt = NaN(numTrials,length(interpTime));
        yInterpFilt = NaN(numTrials,length(interpTime));
        Vx = NaN(numTrials,length(interpTime)-1);
        Vy = NaN(numTrials,length(interpTime)-1);
        acquisitionRate = dataLength/(data.trialData.t(end)-data.trialData.t(1)); %should be around 3KHz
    end
    
    % filter raw data
    [kb ka] = butter(2,100/(acquisitionRate/2));
    x_filt = filtfilt(kb, ka, data.trialData.x);
    y_filt = filtfilt(kb, ka, data.trialData.y);
    
    % calculate acquisiton rate 
    mouseAcquisitionRate = median(diff(data.trialData.t));
    
    % interpolate filtered data
    
    [tUnique,indUnique] = unique(data.trialData.t);
    xInterpFilt(trialNumber,:) = interp1(data.trialData.t(indUnique),x_filt(indUnique),interpTime);
    yInterpFilt(trialNumber,:) = interp1(data.trialData.t(indUnique),y_filt(indUnique),interpTime);
    
    % calculate x and y velocities
    Vx(trialNumber,:) = diff(xInterpFilt(trialNumber,:))./diff(interpTime);
    Vy(trialNumber,:) = diff(yInterpFilt(trialNumber,:))./diff(interpTime);
    
%% get data specific to the trial
    if isfield(data.trialData,'speaker')
        speaker{trialNumber}=data.trialData.speaker;
    end
    if isfield(data.trialData,'pipNum')
        pipNum{trialNumber}=data.trialData.pipNum;
    end
    if isfield(data.trialData,'intensity')
        intensity(trialNumber) = data.trialData.intensity;
    end
    if isfield(data.trialData,'bgIntensity')
        bgIntensity(trialNumber) = data.trialData.bgIntensity;
    end
    if isfield(data.trialData,'intensityL')
        intensityL(trialNumber) = data.trialData.intensityL;
    end
    if isfield(data.trialData,'intensityR')
        intensityR(trialNumber) = data.trialData.intensityR;
    end
    if isfield(data.trialData,'bgIntensityL')
        bgIntensityL(trialNumber) = data.trialData.bgIntensityL;
    end
    if isfield(data.trialData,'bgIntensityR')
        bgIntensityR(trialNumber) = data.trialData.bgIntensityR;
    end
    allTrialNumbers(trialNumber)=data.trialData.trialNumber;
    if exist('data.trialData.vidInitialTriggerTime','var')
        vidInitialTriggerTime(trialNumber,:)=data.trialData.vidInitialTriggerTime;
    end
    AOInitialTriggerTime(trialNumber,:)=data.trialData.AOInitialTriggerTime;

    
    numDataPoints = size(xInterpFilt,2);
    startIndex=((data.stim.restTime)*1000)+1;
    xPosition(trialNumber,:) = xInterpFilt(trialNumber,:) - repmat(xInterpFilt(trialNumber,startIndex),[1,numDataPoints]);
    yPosition(trialNumber,:) = yInterpFilt(trialNumber,:) - repmat(yInterpFilt(trialNumber,startIndex),[1,numDataPoints]);
    for m = 1:size(xPosition,2)
        if m < startIndex
            straightVector = [0 -1];
            comparisonVector = [xPosition(trialNumber,m) yPosition(trialNumber,m)];
            angleCFStart(trialNumber,m) = - (180/pi) * (atan2(det([straightVector',comparisonVector']),dot(straightVector,comparisonVector)));
        else
            straightVector = [0 1];
            comparisonVector = [xPosition(trialNumber,m) yPosition(trialNumber,m)];
            angleCFStart(trialNumber,m) =  (180/pi) * (atan2(det([straightVector',comparisonVector']),dot(straightVector,comparisonVector)));
        end
    end


    
end

data=rmfield(data,'trialData');
if exist('intensity','var')
    data.processedData.intensity = intensity;
end
if exist('bgIntensity','var')
    data.processedData.bgIntensity = bgIntensity;
end
if exist('speaker','var')
    data.processedData.speaker=speaker;
end
if exist('intensityL','var')
    data.processedData.intensityL=intensityL;
end
if exist('intensityR','var')
    data.processedData.intensityR=intensityR;
end
if exist('bgIntensityL','var')
    data.processedData.bgIntensityL=bgIntensityL;
end
if exist('bgIntensityR','var')
    data.processedData.bgIntensityR=bgIntensityR;
end
data.processedData.trialNumber=allTrialNumbers;
if exist('data.processedData.vidInitialTriggerTime','var')
    data.processedData.vidInitialTriggerTime=vidInitialTriggerTime;
end
data.processedData.AOInitialTriggerTime=AOInitialTriggerTime;
data.processedData.mouseAcquisitionRate = mouseAcquisitionRate;
if exist('pipNum','var')
    data.processedData.pipNum = cell2mat(pipNum);
end
    data.actualNumTrials=numTrials;


%% Get rid of half a second at beginning of trial
xInterpFilt(:,1:500)=[];
yInterpFilt(:,1:500)=[];
Vx(:,1:500)=[];
Vy(:,1:500)=[];
interpTime(:,1:500)=[];
xPosition(:,1:500)=[];
yPosition(:,1:500)=[];
angleCFStart(:,1:500)=[];

%% Get rid of half a second at the end of trial
xInterpFilt(:,end-499:end)=[];
yInterpFilt(:,end-499:end)=[];
Vx(:,end-499:end)=[];
Vy(:,end-499:end)=[];
interpTime(:,end-499:end)=[];
xPosition(:,end-499:end)=[];
yPosition(:,end-499:end)=[];
angleCFStart(:,end-499:end)=[];


%% Save in structure
data.processedData.xInterpFilt=xInterpFilt;
data.processedData.yInterpFilt=yInterpFilt;
data.processedData.Vx=Vx;
data.processedData.Vy=Vy;
data.processedData.interpTime=interpTime;
data.processedData.xPosition=xPosition;
data.processedData.yPosition=yPosition;
data.processedData.angleCFStart = angleCFStart;

%% save processed data
processedDataSaveLocation = [pathName,'\ProcessedData\fly',num2str(flyNum),'_flyExpNum',num2str(flyExpNum),'\'];
if ~isdir(processedDataSaveLocation)
    mkdir(processedDataSaveLocation)
end
processedDataFileName = [processedDataSaveLocation,'ProcessedData','_ExpNum',num2str(data.expNum),'_fly',num2str(data.flyNum),'_flyExpNum',num2str(data.flyExpNum),'.mat'];
save(processedDataFileName,'data');