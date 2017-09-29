function figPlot(figData,data,figSaveLocation)


%% unpack 
v2struct(figData)

%% Colors for graphs
lineColors = mat2cell(distinguishable_colors(length(trials),'w'),ones(1,length(trials)));

%% Plot mean position aligned to the beginning of trial
if expNum==9 
fig = figure();
set(fig,'units','normalized','outerposition',[0 0 1 1]);
h = plot(meanXRelStart',meanYRelStart');
xlabel('x position (cm)')
ylabel('y position (cm)')
title({['Experiment Number ',num2str(expNum),', Fly ',num2str(flyNum),', Fly Experiment Number ',num2str(flyExpNum),', ',data.date];['Fly condition = ',data.flycond];'Median position relative to position at start of trial'});
legend(leg,'Location','SouthOutside')
filename{1} = [figSaveLocation,'1.pdf'];
print(fig,'-dpdf',filename{1},'-r300')
end

%% Plot mean position aligned to the beginning of trial
if expNum ==9
fig = figure();
set(fig,'units','normalized','outerposition',[0 0 1 1]);
h = plot(meanXRelBgStart',meanYRelBgStart');
xlabel('x position (cm)')
ylabel('y position (cm)')
title({['Experiment Number ',num2str(expNum),', Fly ',num2str(flyNum),', Fly Experiment Number ',num2str(flyExpNum),', ',data.date];['Fly condition = ',data.flycond];'Median position relative to position at start of background'});
legend(leg,'Location','SouthOutside')
filename{2} = [figSaveLocation,'2.pdf'];
print(fig,'-dpdf',filename{2},'-r300')
end

%% Plot mean position aligned to start of pips
fig = figure();
set(fig,'units','normalized','outerposition',[0 0 1 1]);
for i = 1:length(trials)
    h = plot(meanX(i,:)',meanY(i,:)','Color',lineColors{i},'Linewidth',2);
    %h = errorshade2(meanX(i,:)',meanY(i,:)',stdX(i,:)',zeros(size(stdY(i,:)))','',lineColors{i});
    hold on 
end
% lineColors = get(h,'Color');
% if ~iscell(lineColors)
%     lineColors = mat2cell(lineColors);
% end
hold on
plot(0,0,'k+','Linewidth',3);
xlabel('x position (cm)')
ylabel('y position (cm)')
set(gca,'Box','off')
%title({['Experiment Number ',num2str(expNum),', Fly ',num2str(flyNum),', Fly Experiment Number ',num2str(flyExpNum),', ',data.date];['Fly condition = ',data.flycond];'Median position relative to position at start of stimulus'});
legend(leg,'Location','SouthOutside')
filename{3} = [figSaveLocation,'3.emf'];
print(fig,'-dmeta',filename{3},'-r300')

%% Plot position at end of stimulus
fig = figure();
xlimits = [];
for i = 1:length(trials)
    posend(i) = subplot(2,ceil(length(trials)/2),i);
    set(fig,'units','normalized','outerposition',[0 0 1 1]);
    line([zeros(length(xBefore{i}),1),xBefore{i}]',[zeros(length(xBefore{i}),1),yBefore{i}]','Color','k');
    hold on 
    plot([zeros(length(xAfter{i}),1),xAfter{i}]',[zeros(length(xAfter{i}),1),yAfter{i}]','Color',lineColors{i});
    title(leg{i});
    xlimits = [xlimits xlim];
    axis square
end

linkaxes(posend)
xlim([-max(abs(xlimits)) max(abs(xlimits))])
ylim([-0.75 0.5])
xlim([-0.5 0.5])
suplabel('x position (cm)','x')
suplabel('y position (cm)','y')

filename{4} = [figSaveLocation,'4.emf'];
print(fig,'-dmeta',filename{4},'-r300')

%% Plot histograms for position at end of stimulus
fig = figure();
bins = -0.5:0.01:0.5;
xlimits = [];
for i = 1:length(trials)
    
    histo(i) = subplot(ceil(length(trials)/2),2,i);
    set(fig,'units','normalized','outerposition',[0 0 1 1]);
    hist(histo(i),xAfter{i},bins)
    h = findobj(gca,'Type','patch');
    set(h,'FaceColor',lineColors{i},'EdgeColor','w')
    %title(leg{i});
    xlimits = [-0.25 0.25];
end
linkaxes(histo)
xlim([-max(abs(xlimits)) max(abs(xlimits))])
    suplabel('x position (cm)','x')
    suplabel('frequency','y')

filename{5} = [figSaveLocation,'5.emf'];
print(fig,'-dmeta',filename{5},'-r300')

%% Plot histograms for position at end of stimulus
fig = figure();
bins = -0.5:0.01:0.5;
xlimits = [];
for i = 1:length(trials)
    set(fig,'units','normalized','outerposition',[0 0 1 1]);
    [counts values] = hist(xAfter{i},bins);
    if i ==1
        B = bar(values,counts,'b','EdgeColor',[1 1 1]);
    else
        B = bar(values,counts,'g','EdgeColor',[1 1 1]);
    end
    ch = get(B,'child');
    set(ch,'facea',.3)
    hold on 
%     h = findobj(gca,'Type','patch');
%     set(h,'FaceColor',lineColors{i},'EdgeColor','w','FaceAlpha',0.3)
    clear h 

    xlimits = [xlimits xlim];
end

xlim([-max(abs(xlimits)) max(abs(xlimits))])
    suplabel('x position (cm)','x')
    suplabel('frequency','y')
    
set(gca,'Box','off')

filename{5} = [figSaveLocation,'5.emf'];
print(fig,'-dmeta',filename{5},'-r300')


%% Plot velocity 
fig = figure();
set(fig,'units','normalized','outerposition',[0 0 1 1]);

% Lateral Velocity
ax1 =  subplot(3,1,1);
title('Lateral velocity')
%title({['Experiment Number ',num2str(expNum),', Fly ',num2str(flyNum),', Fly Experiment Number ',num2str(flyExpNum),', ',data.date];['Fly condition = ',data.flycond];'Lateral Velocity'});
for i = 1:length(trials)
   errorshade(velocityTime,-meanVx(i,:),stdVx(i,:),'LineColor',lineColors{i},'ShadeColor',lineColors{i})
   hold on
end 
largestValue = max(abs([max(meanVx(:)+stdVx(:)),min(meanVx(:)-stdVx(:))]));
ylim([-largestValue,largestValue])
ylim([-0.2 0.2])

% plot bars showing when pips occur
Y = ylim(ax1);
X = [stimTime(pipStarts)',stimTime(pipEnds)'];
for k = 1:data.stim.numPips
    ha = area([X(k,1) X(k,2)], [Y(2) Y(2)],'BaseValue',Y(1),'EdgeColor','none');
    hold on 
end
    colormap hsv
    alpha(.1)


% Forward Velocity
ax2 = subplot(3,1,2);
title('Forward velocity')
for i = 1:length(trials)
   errorshade(velocityTime,meanVy(i,:),stdVy(i,:),'LineColor',lineColors{i},'ShadeColor',lineColors{i})
   hold on
end 
%ylabel('velocity (cm/s)')
largestValue = max(meanVy(:)+stdVy(:));
smallestValue = min(meanVy(:)-stdVy(:));
ylim([smallestValue,largestValue])

linkaxes([ax1,ax2],'x')


% plot bars showing when pips occur
Y = ylim(ax2);
X = [stimTime(pipStarts)',stimTime(pipEnds)'];
for k = 1:data.stim.numPips
    ha = area([X(k,1) X(k,2)], [Y(2) Y(2)],'BaseValue',Y(1),'EdgeColor','none');
    hold on 
end
    colormap hsv
    alpha(.1)

% net velocity
ax3 = subplot(3,1,3);
title('Net velocity')
for i = 1:length(trials)
   errorshade(velocityTime,meanVxy(i,:),stdVxy(i,:),'LineColor',lineColors{i},'ShadeColor',lineColors{i})
   hold on
end 
hold on 
largestValue = max(abs([max(meanVxy(:)+stdVxy(:)),min(meanVxy(:)-stdVxy(:))]));
ylim([0,largestValue])

linkaxes([ax1,ax2,ax3],'x')


% plot bars showing when pips occur
Y = ylim(ax3);
X = [stimTime(pipStarts)',stimTime(pipEnds)'];
for k = 1:data.stim.numPips
    ha = area([X(k,1) X(k,2)], [Y(2) Y(2)],'BaseValue',Y(1),'EdgeColor','none');
    hold on 
end
    colormap hsv
    alpha(.1)
  
xlim([1.5 3])
suplabel('time (s)','x')


filename{6} = [figSaveLocation,'6.emf'];
print(fig,'-dmeta',filename{6},'-r300')

%% Plot lateral displacement


fig = figure();
set(fig,'units','normalized','outerposition',[0 0 1 1]);
title({['Experiment Number ',num2str(expNum),', Fly ',num2str(flyNum),', Fly Experiment Number ',num2str(flyExpNum),', ',data.date];['Fly condition = ',data.flycond];'Lateral displacement'});
for i = 1:length(trials)
   errorshade(data.processedData.interpTime,-meanX(i,:),stdX(i,:),'LineColor',lineColors{i},'ShadeColor',lineColors{i})
   hold on
end 
hold on 
xlabel('time (s)')
ylabel('lateral displacement (cm)')
title('Mean lateral displacement')

% plot bars showing when pips occur
Y = ylim;
X = [stimTime(pipStarts)',stimTime(pipEnds)'];
for k = 1:data.stim.numPips
    ha = area([X(k,1) X(k,2)], [Y(2) Y(2)],'BaseValue',Y(1),'EdgeColor','none');
    hold on 
end
    colormap hsv
    alpha(.1)

filename{7} = [figSaveLocation,'7.pdf'];
print(fig,'-dpdf',filename{7},'-r300')




%% Create running histogram for entire experiment (pdf)
fig = figure();
for i = 1:length(trials)
% Forward velocity

set(fig,'units','normalized','outerposition',[0 0 1 1]);
subplot(2,1,1);
bins = -1:0.05:4;
VyTemp = Vy{i};
hist(VyTemp(:),bins);
hold on 
h = findobj(gca,'Type','patch');
set(h,'FaceColor',lineColors{i},'EdgeColor','w','FaceAlpha',0.3)
xlim([-1 4])
xlabel('Forward velocity (cm/s)')
ylabel('Counts')
% title({['Experiment Number ',num2str(expNum),', Fly ',num2str(flyNum),', Fly Experiment Number ',num2str(flyExpNum),', ',data.date];['Fly condition = ',data.flycond];'Histogram of forward velocity'});
title('Forward Velocity')

% Lateral velocity
subplot(2,1,2)
bins = -2:0.05:2;
VxTemp = Vx{i};
hist(VxTemp(:),bins)
hold on 
h = findobj(gca,'Type','patch');
set(h,'FaceColor',lineColors{i},'EdgeColor','w','FaceAlpha',0.3)
clear VxTemp
xlim([-2 2])
xlabel('Lateral velocity (cm/s)')
ylabel('Counts')
title('Histogram of lateral velocity');
end

filename{8} = [figSaveLocation,'8.emf'];
print(fig,'-dmeta',filename{8},'-r300')

% %% Plot correlation between forward and lateral velocity 
% fig = figure();
% for i = 1:length(trials)
% % Forward velocity
% 
% set(fig,'units','normalized','outerposition',[0 0 1 1]);
% VxTemp = abs(Vx{i});
% VyTemp = abs(Vy{i});
% plot(VxTemp,VyTemp,'o','Color',lineColors{i})
% hold on 
% xlabel('Lateral velocity (cm/s)')
% ylabel('Forward velocity (cm/s)')
% title({['Experiment Number ',num2str(expNum),', Fly ',num2str(flyNum),', Fly Experiment Number ',num2str(flyExpNum),', ',data.date];['Fly condition = ',data.flycond];'Correlation of x and y velocity'});
% end
% 
% filename{9} = [figSaveLocation,'9.pdf'];
% print(fig,'-dpdf',filename{9},'-r300')

%% Plot comet
% end
% axis equal
% 
% fig = figure();
% for i = 1%:length(trials)
%    %sps{i} = subplot(ceil(length(trials)/2),2,i);
% %     comet(meanVx(i,stimStartIndex:stimEndIndex),meanVy(i,stimStartIndex:stimEndIndex))
%     multicomet(xPosition(trials{i},stimStartIndex:stimEndIndex)',yPosition(trials{i},stimStartIndex:stimEndIndex)')
%         multicomet(Vx{i}')
% %      quiver(meanVx(i,stimStartIndex:stimEndIndex-1),meanVy(i,stimStartIndex:stimEndIndex-1),...
% %         meanVx(i,stimStartIndex+1:stimEndIndex),meanVy(i,stimStartIndex+1:stimEndIndex),'Color',lineColors{i})
% 
%     hold on
% end 
% linkaxes(cell2mat(sps))
% 
% fig = figure();
% xlim([-0.05 0.15])
% ylim([-0.05 0.15])
% multicomet(xPosition(trials{i},stimStartIndex-10:stimStartIndex)',yPosition(trials{i},stimStartIndex-10:stimStartIndex)','k')
% hold on 
% multicomet(xPosition(trials{i},stimStartIndex:stimEndIndex)',yPosition(trials{i},stimStartIndex:stimEndIndex)','r')
% hold on 
% multicomet(xPosition(trials{i},stimEndIndex:stimEndIndex+100)',yPosition(trials{i},stimEndIndex:stimEndIndex+100)','g')
% 
% multicomet(xPosition(trials{i},stimStartIndex-100:stimStartIndex+100)',yPosition(trials{i},stimStartIndex-100:stimStartIndex+100)','r')

%% Plot prob turn left vs. time
fig = figure();
set(fig,'units','normalized','outerposition',[0 0 1 1]);
for i = 1:length(trials)
    plot(velocityTime,probLeft(i,:),'Color',lineColors{i},'Linewidth',2)
    hold on 
end
hold on 
xlabel('time (s)')
%ylabel('probability of leftward movement')
%title({['Experiment Number ',num2str(expNum),', Fly ',num2str(flyNum),', Fly Experiment Number ',num2str(flyExpNum),', ',data.date];['Fly condition = ',data.flycond];'Probability of leftward movement vs time'});
ylim([0 1]);
% plot bars showing when pips occur
Y = ylim;
X = [stimTime(pipStarts)',stimTime(pipEnds)'];
for k = 1:data.stim.numPips
    ha = area([X(k,1) X(k,2)], [Y(2) Y(2)],'BaseValue',Y(1),'EdgeColor','none');
    hold on 
end
    colormap hsv
    alpha(.1)
    xlim([1.5 3])
    set(gca,'Box','off')
    
filename{10} = [figSaveLocation,'10.emf'];
print(fig,'-dmeta',filename{10},'-r100')


    
%% Plot angle turned c.f. start
fig = figure();
ylimits = [];
for i = 1:length(trials)
set(fig,'units','normalized','outerposition',[0 0 1 1]);
% plot(data.processedData.interpTime,median(angleCFStart(trials{i},:)),'Color',lineColors{i})
plot(data.processedData.interpTime,meanAngle(i,:),'Color',lineColors{i},'Linewidth',2)
hold on 
ylimits = [ylimits ylim];
end
ylim([-max(abs(ylimits)) max(abs(ylimits))])
xlabel('time (s)')
ylabel('Angle turned relative to y axis')
title('Angle turned relative to y axis')

% plot bars showing when pips occur
Y = ylim;
X = [stimTime(pipStarts)',stimTime(pipEnds)'];
for k = 1:data.stim.numPips
    ha = area([X(k,1) X(k,2)], [Y(2) Y(2)],'BaseValue',Y(1),'EdgeColor','none');
    hold on 
end
    colormap hsv
    alpha(.1)
    
filename{11} = [figSaveLocation,'11.emf'];
print(fig,'-dmeta',filename{11},'-r300')

% %% Plot displacement at time before stimulus correlated displacement at end of stimulus for each trial type
% 
% fig = figure();
% for i = 1:length(trials)
%     posend{i} = subplot(ceil(length(trials)/2),2,i);
%     set(fig,'units','normalized','outerposition',[0 0 1 1]);
%     plot(xBefore{i},xAfter{i},'o','Color',lineColors{i});
%     hold on 
%     title(leg{i});
% end
% linkaxes(cell2mat(posend))
% suplabel('x Before (cm)','x')
% suplabel('x After (cm)','y')
% suptitle('Correlation of x position before and after stimulus')
% 
% filename{12} = [figSaveLocation,'12.pdf'];
% print(fig,'-dpdf',filename{12},'-r300')

% %% Plot speed just before stimulus correlated with displacement at end of stimulus for each trial type 
% fig = figure();
% for i = 1:length(trials)
%     posend{i} = subplot(ceil(length(trials)/2),2,i);
%     set(fig,'units','normalized','outerposition',[0 0 1 1]);
%     plot(Vy{i}(:,stimStartIndex-1),xAfter{i},'o','Color',lineColors{i});
%     hold on 
%     title(leg{i});
% end
% linkaxes(cell2mat(posend))
% suplabel('Forward Velocity Before (cm/s)','x')
% suplabel('x After (cm)','y')
% suptitle('Correlation of forward velocity before sitmulus and x position and after stimulus')
% 
% filename{13} = [figSaveLocation,'13.pdf'];
% print(fig,'-dpdf',filename{13},'-r300')


%% Plot psychometric curve

fig = figure();
set(fig,'units','normalized','outerposition',[0 0 1 1]);


% ratios = unique(data.processedData.intensityL)./unique(data.processedData.intensityR);
% michelson = (unique(data.processedData.intensityR)-unique(data.processedData.intensityL))./(unique(data.processedData.intensityR)+unique(data.processedData.intensityL));
% intensities = [-sort(unique(data.processedData.intensity),'descend') unique(data.processedData.intensity)];
% intensities = [log(unique(data.processedData.intensity)) sort(-log(unique(data.processedData.intensity)))];
% weber = unique(data.processedData.intensityL)./(unique(data.processedData.intensityL)+unique(data.processedData.intensityR));
% weber = sort(weber,'descend');

michelson = (intensityR - intensityL) ./ (intensityR + intensityL);

for i = 1:length(pipStarts)
    posend{i} = subplot(2,ceil(length(pipStarts)/2),i);
    
%     %ratio 
%     plot(ratio([1 3 5]),probLeft([1 3 5],-500+round(pipEnds(i)./40)),'m','Linewidth',2); % difference = 0.4
%     hold on 
%     plot(ratio([2 4 6]),probLeft([2 4 6],-500+round(pipEnds(i)./40)),'g','Linewidth',2); % difference = 0.2
%     hold on 
%     plot(ratio([1 2 3 4 5 6]),0.5*ones(1,length(trials)),'k')
%     set(gca,'XTick',[0.05 0.5 0.8]);
    
    % log ratio
%     plot(log(ratio([1 3 5])),probLeft([1 3 5],-500+round(pipEnds(i)./40)),'m','Linewidth',2); % difference = 0.4
%     hold on
%     plot(log(ratio([2 4 6])),probLeft([2 4 6],-500+round(pipEnds(i)./40)),'g','Linewidth',2); % difference = 0.2
%     hold on
%     plot(log(ratio([1 2 3 4 5 6])),0.5*ones(1,length(trials)),'k')

%     % michelson contrast 
%     plot(michelson([1 3 5]),probLeft([1 3 5],-500+round(pipEnds(i)./40)),'m','Linewidth',2); % difference = 0.4
%     hold on 
%     plot(michelson([2 4 6]),probLeft([2 4 6],-500+round(pipEnds(i)./40)),'g','Linewidth',2); % difference = 0.2
%     hold on 
%     plot(michelson([1 2 3 4 5 6]),0.5*ones(1,length(trials)),'k')
%     set(gca,'XTick',[0.1 0.3 0.9]); 

%     % michelson contrast 
%     plot(log(michelson([1 3 5])),probLeft([1 3 5],-500+round(pipEnds(i)./40)),'m','Linewidth',2); % difference = 0.4
%     hold on 
%     plot(log(michelson([2 4 6])),probLeft([2 4 6],-500+round(pipEnds(i)./40)),'g','Linewidth',2); % difference = 0.2
%     hold on 
%     plot(log(michelson([1 2 3 4 5 6])),0.5*ones(1,length(trials)),'k')
%     xlim([-2.5 0])

%     %ratio 
%     plot(ratio,probLeft(:,-500+round(pipEnds(i)./40)),'b','Linewidth',2); % difference = 0.4
%     hold on 
%     plot(ratio([1 2 3 4 5 6]),0.5*ones(1,length(trials)),'k')
%     set(gca,'XTick',[ 0.05 0.2 0.4 0.5]);
%     xlim([0 0.5])
    
    %     %ratio 
    plot(log(ratio),probLeft(:,-500+round(pipEnds(i)./40)),'b','Linewidth',2); % difference = 0.4
    hold on 
    plot(log(ratio),0.5*ones(1,length(trials)),'k')

    

      ylim([0 1])  
      title(num2str(i))
end
%suplabel('trial type','x')
suplabel('prob left','y')
suptitle('Prob left vs. trial type')

filename{14} = [figSaveLocation,'14.emf'];
print(fig,'-dmeta',filename{14},'-r300')




%% Plot how running speed changes over time 
% fig = figure();
% set(fig,'units','normalized','outerposition',[0 0 1 1]);
% for i = 1:length(trials)
% plot(trials{i},nanmean(Vy{i}(:,[1:stimStartIndex-1,stimEndIndex:end]),2),'Color',lineColors{i});
% hold on 
% pRunSpeed{i} = polyfit(trials{i}',nanmean(Vy{i}(:,[1:stimStartIndex-1,stimEndIndex:end]),2),1)
% end
% 
% filename{15} = [figSaveLocation,'15.pdf'];
% print(fig,'-dpdf',filename{15},'-r300')
% 
% 
% % %% Plot how time spent stopped changes throughout the experiment
% % fig = figure();
% % set(fig,'units','normalized','outerposition',[0 0 1 1]);
% % for i = 1:length(trials)
% % plot(trials{i},meanStopLength(trials{i}),'Color',lineColors{i});
% % hold on 
% % pStop{i} = polyfit(trials{i},meanStopLength(trials{i}),1)
% % end
% % title('Time spent stopped')
% % xlabel('Trial')
% % ylabel('Time spent stopped')
% % 
% % filename{16} = [figSaveLocation,'16.pdf'];
% % print(fig,'-dpdf',filename{16},'-r300')


%% Plot lateral position vs. trial type for each pip 
fig = figure();
ylimits = [];
set(fig,'units','normalized','outerposition',[0 0 1 1]);
for i = 1:length(pipStarts)
    posend(i) = subplot(2,ceil(length(pipStarts)/2),i);
    plot(1:length(trials),meanX(:,-500+round(pipEnds(i)./40)));
    hold on 
    plot(1:length(trials),zeros(1,length(trials)),'k')
    title(num2str(i))
    ylimits = [ylimits ylim];
end
linkaxes(posend,'y')
ylim([-max(abs(ylimits)) max(abs(ylimits))])
suplabel('trial type','x')
suplabel('Lateral position','y')
suptitle('Lateral position vs. trial type')


filename{17} = [figSaveLocation,'17.pdf'];
print(fig,'-dpdf',filename{17},'-r300')


%% Plot lateral velocity vs. trial type for each pip
fig = figure();
ylimits = [];
set(fig,'units','normalized','outerposition',[0 0 1 1]);
for i = 1:length(pipStarts)
    posend(i) = subplot(2,ceil(length(pipStarts)/2),i);
    plot(1:length(trials),meanVx(:,-500+round(pipEnds(i)./40)));
    hold on 
    plot(1:length(trials),zeros(1,length(trials)),'k')
    title(num2str(i))
    ylimits = [ylimits ylim];
end
linkaxes(posend,'y')
ylim([-max(abs(ylimits)) max(abs(ylimits))])
suplabel('trial type','x')
suplabel('Lateral velocity','y')
suptitle('Lateral velocity vs. trial type')


filename{18} = [figSaveLocation,'18.pdf'];
print(fig,'-dpdf',filename{18},'-r300')

%% Plot time to peak lateral velocity vs. trial type for each pip
% Will leave this out for now and look at how psychometric curves change
% over time
%% Plot forward velocity vs. trial type 
fig = figure();
ylimits = [];
set(fig,'units','normalized','outerposition',[0 0 1 1]);
for i = 1:length(pipStarts)
    posend(i) = subplot(2,ceil(length(pipStarts)/2),i);
    plot(1:length(trials),meanVy(:,-500+round(pipEnds(i)./40)));
    hold on 
    title(num2str(i))
    ylimits = [ylimits ylim];
end
linkaxes(posend,'y')
ylim([min(ylimits) max(ylimits)])
suplabel('trial type','x')
suplabel('Forward velocity','y')
suptitle('Forward velocity vs. trial type')


filename{19} = [figSaveLocation,'19.pdf'];
print(fig,'-dpdf',filename{19},'-r300')
%% Plot angle turned vs. trial type for each pip 
fig = figure();
ylimits = [];
set(fig,'units','normalized','outerposition',[0 0 1 1]);
% intensities = [-sort(unique(data.processedData.intensity),'descend') unique(data.processedData.intensity)];
% intensities = [log(unique(data.processedData.intensity)) sort(-log(unique(data.processedData.intensity)))];
for i = 1:length(pipStarts)
    posend(i) = subplot(2,ceil(length(pipStarts)/2),i);
    plot(intensities,meanAngle(:,-500+round(pipEnds(i)./40)));
    hold on 
    plot(intensities,zeros(1,length(trials)),'k')
    title(num2str(i))
    ylimits = [ylimits ylim];
end
linkaxes(posend,'y')
ylim([-max(abs(ylimits)) max(abs(ylimits))])
suplabel('trial type','x')
suplabel('Angle relative to y axis','y')
suptitle('Angle relative to y axis vs. trial type')


filename{20} = [figSaveLocation,'20.pdf'];
print(fig,'-dpdf',filename{20},'-r300')

%% Plot log psychometric curve
weber = unique(data.processedData.intensityL)./(unique(data.processedData.intensityL)+unique(data.processedData.intensityR));
weber = sort(weber,'descend');
fig = figure();
set(fig,'units','normalized','outerposition',[0 0 1 1]);
% intensities = [-sort(unique(data.processedData.intensity),'descend') unique(data.processedData.intensity)];
% intensities = [log(unique(data.processedData.intensity)) sort(-log(unique(data.processedData.intensity)))];
for i = 1:length(pipStarts)
    posend{i} = subplot(2,ceil(length(pipStarts)/2),i);
    plot(log(weber),probLeft(:,-500+round(pipEnds(i)./40)));
    hold on 
    plot(log(weber),0.5*ones(1,length(trials)),'k')
    ylim([0 1])
    title(num2str(i))
    
    
end
%suplabel('trial type','x')in
suplabel('prob left','y')
suptitle('Prob left vs. trial type')


filename{14} = [figSaveLocation,'14.emf'];
print(fig,'-dmeta',filename{14},'-r300')



%% Append pdfs

append_pdfs(filename{:})
    
