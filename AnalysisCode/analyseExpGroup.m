function analyseExpGroup(expNum,computer)

%% Specfy which flies and which fly experiments to use for each experiment
switch expNum
    case 1
         flyExperiments = [7 1;8 5;9 1;10 1;11 1];
%         flyExperiments = [12 1;13 2];
    case 2
        flyExperiments = [1 2; 2 1;5 1; 6 1];
    case 3
        flyExperiments = [1 1; 2 1];
    case 4
        flyExperiments = [1 3;2 1;4 1;5 1];
    case 5
        flyExperiments = [2 2; 3 2];
    case 6
        flyExperiments = [4 1; 5 1];
    case 7
        flyExperiments = [1 1; 2 1;3 2];
    case 8
        flyExperiments = [];
    case 9
        flyExperiments = [4 2; 5 2;6 1];
    case 10
        flyExperiments = [];
    case 11
        flyExperiments = [];
    case 12
        flyExperiments = [20 3];
end

close all
set(0,'DefaultAxesFontSize', 16)
set(0,'DefaultFigureColor','w')
if strcmpi(computer,'laptop')
    figSaveLocation = ['C:\Users\Alex\Desktop\Harvard\Dropbox\TrackballData','\ExpNum',num2str(expNum),'\Figures\','Group\'];
elseif strcmpi(computer,'desktop')
    figSaveLocation = ['C:\Alex\Dropbox\TrackballData','\ExpNum',num2str(expNum),'\Figures\','Group\'];
end
if ~isdir(figSaveLocation)
    mkdir(figSaveLocation)
end

for n = 1:size(flyExperiments,1)
    
    %% load processed data
    if strcmpi(computer,'laptop')
        pathName = ['C:\Users\Alex\Desktop\Harvard\Dropbox\TrackballData\ExpNum',num2str(expNum)];
        processedDataSaveLocation = [pathName,'\ProcessedData\fly',num2str(flyExperiments(n,1)),'_flyExpNum',num2str(flyExperiments(n,2)),'\'];
        processedDataFileName = [processedDataSaveLocation,'ProcessedData','_ExpNum',num2str(expNum),'_fly',num2str(flyExperiments(n,1)),'_flyExpNum',num2str(flyExperiments(n,2)),'.mat'];
    elseif strcmpi(computer,'desktop')
        pathName = ['C:\Alex\Dropbox\TrackballData\ExpNum',num2str(expNum)];
        processedDataSaveLocation = [pathName,'\ProcessedData\fly',num2str(flyExperiments(n,1)),'_flyExpNum',num2str(flyExperiments(n,2)),'\'];
        processedDataFileName = [processedDataSaveLocation,'ProcessedData','_ExpNum',num2str(expNum),'_fly',num2str(flyExperiments(n,1)),'_flyExpNum',num2str(flyExperiments(n,2)),'.mat'];
    end
    
    load(processedDataFileName)
    
    % Get trials
    netV = sqrt((data.processedData.Vy.^2)+(data.processedData.Vx.^2));
    [trials leg stimStartIndex stimEndIndex] = getTrials(expNum,data,netV);
    
    
    numDataPoints = size(data.processedData.xInterpFilt,2);
    startIndex=((data.stim.restTime)*1000)+1;
    
    xPosition = data.processedData.xPosition;
    yPosition = data.processedData.yPosition;
    angleCFStart = data.processedData.angleCFStart;
    
    
    if expNum ==9
        for k=1:data.actualNumTrials
            startIndex2(k)=find(~isnan(data.processedData.xInterpFilt(k,:)),1,'first');
            xRelStart(k,:) = data.processedData.xInterpFilt(k,:) - repmat(data.processedData.xInterpFilt(k,startIndex2(k)),[1,numDataPoints]);
            yRelStart(k,:) = data.processedData.yInterpFilt(k,:) - repmat(data.processedData.yInterpFilt(k,startIndex2(k)),[1,numDataPoints]);
        end
        
        startIndex3 = -500+ round(unique(data.stim.bgStart)/40);
        for k=1:data.actualNumTrials
            xRelBgStart(k,:) = data.processedData.xInterpFilt(k,:) - repmat(data.processedData.xInterpFilt(k,startIndex3),[1,numDataPoints]);
            yRelBgStart(k,:) = data.processedData.yInterpFilt(k,:) - repmat(data.processedData.yInterpFilt(k,startIndex3),[1,numDataPoints]);
        end
    end
    
   
    
    if n == 1
        figData.stimTime = (1:length(data.stim.stimTrain))./data.stim.samprate;
        figData.velocityTime = data.processedData.interpTime(1:end-1) + diff(data.processedData.interpTime)./2;
        stim = data.stim;
        
         
         
        for m=1:length(trials)
            x{m} = xPosition(trials{m},:);
            y{m} = yPosition(trials{m},:);
            angleS{m} = angleCFStart(trials{m},:);
            Vx{m} = data.processedData.Vx(trials{m},:);
            Vy{m} = data.processedData.Vy(trials{m},:);
            Vxy{m} = netV(trials{m},:);
            diffX{m} = diff(xPosition(trials{m},:),1,2)<0;
            if expNum ==9
            xRS{m} = xRelStart(trials{m},:);
            yRS{m} = yRelStart(trials{m},:);
            xRBS{m} = xRelBgStart(trials{m},:);
            yRBS{m} = yRelBgStart(trials{m},:);
            end
        end
        
    else
        

        
        for m=1:length(trials)
            x{m} = [x{m} ; xPosition(trials{m},:)];
            y{m} = [y{m} ; yPosition(trials{m},:)];
            angleS{m} = [angleS{m} ; angleCFStart(trials{m},:)];
            Vx{m} = [Vx{m} ; data.processedData.Vx(trials{m},:)];
            Vy{m} = [Vy{m} ; data.processedData.Vy(trials{m},:)];
            Vxy{m} = [Vxy{m} ; netV(trials{m},:)];
            diffX{m} = [diffX{m} ; diff(xPosition(trials{m},:),1,2)<0];
            if expNum ==9
            xRS{m} = [xRS{m} ; xRelStart(trials{m},:)];
            yRS{m} = [yRS{m} ; yRelStart(trials{m},:)];
            xRBS{m} = [xRBS{m} ; xRelBgStart(trials{m},:)];
            yRBS{m} = [yRBS{m} ; yRelBgStart(trials{m},:)];
            end
        end
    end
    clear xPosition yPosition xRelStart yRelStart xRelBgStart yRelBgStart angleCFStart
    
end

%% Stimulus information


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


beforeStimStart = stimStartIndex - (stimEndIndex - stimStartIndex);

beforeStimStart = 1179;
stimEndIndex = 1821;

% 
% beforeStimStart = 179;
% stimEndIndex = 821;

%% Parse data for experiment
for i = 1:length(trials)
    figData.meanX(i,:) = nanmedian(x{i});
    figData.stdX(i,:) = nanstd(x{i})./sqrt(length(trials{i}));
    figData.meanY(i,:) = nanmedian(y{i});
    figData.stdY(i,:) = nanstd(y{i})./sqrt(length(trials{i}));
    figData.meanVx(i,:) = nanmedian(Vx{i});
    figData.stdVx(i,:) = nanstd(Vx{i})./sqrt(length(trials{i}));
    figData.meanVy(i,:) = nanmedian(Vy{i});
    figData.stdVy(i,:) = nanstd(Vy{i}./sqrt(length(trials{i})));
    figData.meanVxy(i,:) = nanmedian(Vxy{i});
    figData.stdVxy(i,:) = nanstd(Vxy{i})./sqrt(length(trials{i}));
    figData.probLeft(i,:) = sum(diffX{i})./size(diffX{i},1);
    figData.meanAngle(i,:) = nanmedian(angleS{i});
    if expNum ==9
        figData.meanXRelStart(i,:) = nanmedian(xRS{i});
        figData.meanYRelStart(i,:) = nanmedian(yRS{i});
        figData.meanXRelBgStart(i,:) = nanmedian(xRBS{i});
        figData.meanYRelBgStart(i,:) = nanmedian(yRBS{i});
    end
    figData.xBefore{i} = x{i}(:,beforeStimStart);
    figData.xAfter{i} = x{i}(:,stimEndIndex);
    figData.yBefore{i} =  y{i}(:,beforeStimStart);
    figData.yAfter{i} = y{i}(:,stimEndIndex);
end



figData.Vx = Vx;
figData.Vy = Vy;


%% Plot figures
figData.trials = trials;
figData.leg = leg;
figData.expNum = expNum;
figData.pipStarts = pipStarts;
figData.pipEnds = pipEnds;
figData.flyNum = 'Group';
figData.flyExpNum = 'Group';
figData.stimStartIndex = stimStartIndex;
figData.stimEndIndex = stimEndIndex;

figPlot(figData,data,figSaveLocation)

