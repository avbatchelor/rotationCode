function analyseExp2(expNum,flyNum,flyExpNum,computer)

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
%% Get trials
Vxy = sqrt((data.processedData.Vy.^2)+(data.processedData.Vx.^2));

[trials leg stimStartIndex stimEndIndex] = getTrials(expNum,data,Vxy);

figData.xPosition = data.processedData.xPosition;
figData.yPosition = data.processedData.yPosition;



%% Parse data for experiment 
timeBefore = 250; 
timeAfter = 0; 

for i = 1:length(trials)

beforeStimStart = stimStartIndex - (stimEndIndex - stimStartIndex);
figData.xBefore{i} = figData.xPosition(trials{i},beforeStimStart-500-timeBefore);
figData.xAfter{i} = figData.xPosition(trials{i},stimEndIndex-500+timeAfter);
figData.yBefore{i} =  figData.yPosition(trials{i},beforeStimStart-500-timeBefore);
figData.yAfter{i} = figData.yPosition(trials{i},stimEndIndex-500+timeAfter);


end

%% Plot figures


figPlot2(figData,data,figSaveLocation)
% histPlotTemp(figData,data,figSaveLocation)

