function angleHist(figData,figSaveLocation)


%% unpack
v2struct(figData)

%% Colors for graphs
lineColors = mat2cell(distinguishable_colors(length(trials),'w'),ones(1,length(trials)));
figure

%% For tight subplots
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.05], [0.1 0.15], [0.1 0.01]);

%% Histogram settings
bins = -180:5:180;
xlimits = [];

%% subplot order 
subplotOrder = [9:-2:1,2:2:10];

%% Titles 
titleText = {'Left, intensity = 0.05','Left, intensity = 0.1','Left, intensity = 0.2','Left, intensity = 0.4','Left, intensity = 0.8',...
    'Right, intensity = 0.05','Right, intensity = 0.1','Right, intensity = 0.2','Right, intensity = 0.4','Right, intensity = 0.8'};

%% Plot position at end of stimulus
straightVector = [0 1];

for i = 1:length(trials)
    
    xMat = xAfter{i};
    yMat = yAfter{i};
    
    for j = 1:length(xMat)
        comparisonVector = [xMat(j) yMat(j)];
        angle(j) =  -(180/pi) * (atan2(det([straightVector',comparisonVector']),dot(straightVector,comparisonVector)));
    end
    
    histo(i) = subplot(ceil(length(trials)/2),2,subplotOrder(i));
    hist(histo(i),angle,bins)
    h = findobj(gca,'Type','patch');
    set(h,'FaceColor',lineColors{i},'EdgeColor','w')
    if i ~= 1 && i ~= 10 
        noXAxisSettings
    else 
        bottomAxisSettings
    end
    
end

linkaxes(histo)
