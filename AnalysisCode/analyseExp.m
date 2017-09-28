function analyseExp(expNum,flyNum,flyExpNum,computer)

% Creates graphs

close all
set(0,'DefaultAxesFontSize', 30)
set(0,'DefaultFigureColor','w')
set(0,'DefaultAxesBox','off')
if strcmpi(computer,'laptop')
    figSaveLocation = ['C:\Users\Alex\Desktop\Harvard\Dropbox\TrackballData','\ExpNum',num2str(expNum),'\Figures\','fly',num2str(flyNum),'_flyExpNum',num2str(flyExpNum),'/'];
elseif strcmpi(computer,'desktop')
    figSaveLocation = ['C:\Users\Alex\Documents\TrackballData','\ExpNum',num2str(expNum),'\Figures\','fly',num2str(flyNum),'_flyExpNum',num2str(flyExpNum),'/'];    
elseif strcmpi(computer,'desktop2')
    figSaveLocation = ['C:\Users\Alex\Documents\Data\TrackballData','\ExpNum',num2str(expNum),'\Figures\','fly',num2str(flyNum),'_flyExpNum',num2str(flyExpNum),'/'];
    
end
if ~isdir(figSaveLocation)
    mkdir(figSaveLocation)
end


%% load processed data
if strcmpi(computer,'laptop')
    pathName = ['C:\Users\Alex\Desktop\Harvard\Dropbox\TrackballData\ExpNum',num2str(expNum)];
elseif strcmpi(computer,'desktop')
    pathName = ['C:\Users\Alex\Documents\TrackballData\ExpNum',num2str(expNum)];
elseif strcmpi(computer,'desktop2')
    pathName = ['C:\Users\Alex\Documents\Data\TrackballData\ExpNum',num2str(expNum)];
end
processedDataSaveLocation = [pathName,'\ProcessedData\fly',num2str(flyNum),'_flyExpNum',num2str(flyExpNum),'\'];
processedDataFileName = [processedDataSaveLocation,'ProcessedData','_ExpNum',num2str(expNum),'_fly',num2str(flyNum),'_flyExpNum',num2str(flyExpNum),'.mat'];

load(processedDataFileName)

%% Get trials
Vxy = sqrt((data.processedData.Vy.^2)+(data.processedData.Vx.^2));

[trials leg stimStartIndex stimEndIndex] = getTrials(expNum,data,Vxy);


%% Stimulus information
if expNum ==5
    figData.stimTime = (1:length(data.stim.stimTrain{end}))./data.stim.samprate;
else
    figData.stimTime = (1:length(data.stim.stimTrain))./data.stim.samprate;
end
figData.velocityTime = data.processedData.interpTime(1:end-1) + diff(data.processedData.interpTime)./2;
numDataPoints = size(data.processedData.xInterpFilt,2);
startIndex=((data.stim.restTime)*1000)+1;

figData.xPosition = data.processedData.xPosition;
figData.yPosition = data.processedData.yPosition;
figData.angleCFStart = data.processedData.angleCFStart;

% for k=1:data.actualNumTrials
%     stoppedTimePoints = intersect(find(-0.025<data.processedData.Vy(k,:)),find(data.processedData.Vy<0.025));
%     stopStarts = findstr(stoppedTimePoints,[0 1]);
%     stopEnds = findstr(stoppedTimePoints,[1 0]);
%     if length(stopStarts) > length(stopEnds) 
%         stopStarts(end) = [];
%     elseif length(stopStarts) < length(stopEnds) 
%         stopEnds(1) = [];
%     end
%     figData.stopLengths{k} = stopEnds-stopStarts; 
%     figData.meanStopLength(k) = mean(figData.stopLengths{k});
% end

% turnsL = angleRad>0;
% turnsR = angleRad<0;

diffX = diff(figData.xPosition,1,2)<0;

if expNum ==9
    for k=1:data.actualNumTrials
        startIndex2(k)=find(~isnan(data.processedData.xInterpFilt(k,:)),1,'first');
        xRelStart(k,:) = data.processedData.xInterpFilt(k,:) - repmat(data.processedData.xInterpFilt(k,startIndex2(k)),[1,numDataPoints]);
        yRelStart(k,:) = data.processedData.yInterpFilt(k,:) - repmat(data.processedData.yInterpFilt(k,startIndex2(k)),[1,numDataPoints]);
    end

    startIndex3 = round(unique(data.stim.bgStart)/40);
    for k=1:data.actualNumTrials
        xRelBgStart(k,:) = data.processedData.xInterpFilt(k,:) - repmat(data.processedData.xInterpFilt(k,startIndex3),[1,numDataPoints]);
        yRelBgStart(k,:) = data.processedData.yInterpFilt(k,:) - repmat(data.processedData.yInterpFilt(k,startIndex3),[1,numDataPoints]);
    end
end

%% Get data specific to the experiment 




if isfield(data.stim,'pipStarts')
    if iscell(data.stim.pipStarts)
        pipStarts = data.stim.pipStarts{end};
        pipEnds = data.stim.pipEnds{end};
    else 
        pipStarts = data.stim.pipStarts;
        pipEnds = data.stim.pipEnds;
    end
end    




%% Parse data for experiment 
for i = 1:length(trials)
    figData.meanX(i,:) = nanmedian(figData.xPosition(trials{i},:));
    figData.stdX(i,:) = nanstd(figData.xPosition(trials{i},:))./sqrt(length(trials{i}));
    figData.meanY(i,:) = nanmedian(figData.yPosition(trials{i},:));
    figData.stdY(i,:) = nanstd(figData.yPosition(trials{i},:))./sqrt(length(trials{i}));
    figData.meanVx(i,:) = nanmedian(data.processedData.Vx(trials{i},:));
    figData.stdVx(i,:) = nanstd(data.processedData.Vx(trials{i},:))./sqrt(length(trials{i}));
    figData.meanVy(i,:) = nanmedian(data.processedData.Vy(trials{i},:));
    figData.stdVy(i,:) = nanstd(data.processedData.Vy(trials{i},:))./sqrt(length(trials{i}));
    figData.meanVxy(i,:) = nanmedian(Vxy(trials{i},:));
    figData.stdVxy(i,:) = nanstd(Vxy(trials{i},:))./sqrt(length(trials{i}));
    figData.meanAngle(i,:) = nanmedian(figData.angleCFStart(trials{i},:));
    if expNum ==9
    figData.meanXRelStart(i,:) = nanmedian(xRelStart(trials{i},:));
    figData.meanYRelStart(i,:) = nanmedian(yRelStart(trials{i},:));
    figData.meanXRelBgStart(i,:) = nanmedian(xRelBgStart(trials{i},:));
    figData.meanYRelBgStart(i,:) = nanmedian(yRelBgStart(trials{i},:));
    end

    figData.probLeft(i,:) = smooth(sum(diffX(trials{i},:))./length(trials{i}),25);

beforeStimStart = stimStartIndex - (stimEndIndex - stimStartIndex);
figData.xBefore{i} = figData.xPosition(trials{i},beforeStimStart-500);
figData.xAfter{i} = figData.xPosition(trials{i},stimEndIndex-500);
figData.yBefore{i} =  figData.yPosition(trials{i},beforeStimStart-500);
figData.yAfter{i} = figData.yPosition(trials{i},stimEndIndex-500);
figData.Vx{i} = data.processedData.Vx(trials{i},:);
figData.Vy{i} = data.processedData.Vy(trials{i},:);

end

%% Plot figures
figData.trials = trials;
figData.leg = leg;
figData.expNum = expNum;
figData.pipStarts = pipStarts;
figData.pipEnds = pipEnds;
figData.flyNum = flyNum;
figData.flyExpNum = flyExpNum;
figData.stimStartIndex = stimStartIndex;
figData.stimEndIndex = stimEndIndex;

% figPlot(figData,data,figSaveLocation)
angleHist(figData,figSaveLocation)
% histPlotTemp(figData,data,figSaveLocation)

