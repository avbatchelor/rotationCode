function histPlotTemp(figData,data,figSaveLocation)

%% Plot settings
set(0,'DefaultAxesFontSize', 16)
set(0,'DefaultFigureColor','w')
set(0,'DefaultAxesBox','off')

%% unpack
v2struct(figData)

%% Plot histograms for position at end of stimulus
fig = figure();
suptitle([date,', Experiment Number = ',num2str(data.expNum),', Fly Number = ',num2str(data.flyNum),', Fly Experiment Number = ',num2str(data.flyExpNum)]);

bins = -0.15:0.01:0.15;
xlimits = [];
alpha = 1; 
for i = [5:-1:1,6:10]
    set(gca,'layer','top')
    histo{i} = subplot(length(trials),1,i);
    set(fig,'units','normalized','outerposition',[0 0 1 1]);
    hist(histo{i},xAfter{i},bins)
    h = findobj(gca,'Type','patch');
    set(h,'FaceColor',[0 0.5 0.5],'EdgeColor','w','FaceAlpha',alpha,'EdgeAlpha',alpha)
    hold on
     line([0 0],ylim,'Color','k')
    xlimits = [-0.15 0.15];
    if i ~= 10 
        set(gca,'Box','off','XTick',[],'YTick',[],'layer','top')
    else 
        set(gca,'Box','off','TickDir','out','layer','top')
        xlabel('Position (cm)')
    end
    axis tight
    
end
linkaxes(cell2mat(histo))
xlim([-max(abs(xlimits)) max(abs(xlimits))])
suplabel('Counts','y')

saveFilename = [figSaveLocation,'position_histogram'];
print(fig,'-dmeta',saveFilename)

%
% filename{5} = [figSaveLocation,'5.emf'];
% print(fig,'-dmeta',filename{5},'-r300')