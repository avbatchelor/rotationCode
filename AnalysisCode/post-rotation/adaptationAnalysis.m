%% Divide trials on each side into time sections 
clear all
figData = analyseExp(1,10,1,'laptop');
edges = 1:51:1001;
for i = 1:2
    trialsTemp = figData.trials{i};
    [blah bin] = histc(trialsTemp,edges);
    uBins = unique(bin);
    for j = 1:length(uBins)
        binInd = find(bin == uBins(j)); 
        meanX(i,j,:) = nanmedian(figData.xPosition(trialsTemp(binInd),:));
        meanY(i,j,:) = nanmedian(figData.yPosition(trialsTemp(binInd),:));
    end        
end


%% Set plot colors
numLines = size(meanX,2);
highColor = 0.9;
colorInterval = highColor/numLines;
colors = (0:colorInterval:highColor)';
colors = repmat(colors,1,3);

%% Plot 
figure() 
for i=1:2
    for j = 1:size(meanX,2)
        plot(squeeze(meanX(i,j,:)),squeeze(meanY(i,j,:)),'Color',colors(j,:))
        hold on 
    end  
end

figure() 
for i=1:2
    for j = 1:size(meanX,2)
        plot(smooth(squeeze(meanX(i,j,:)),101),smooth(squeeze(meanY(i,j,:)),101),'Color',colors(j,:))
        hold on 
    end  
end
