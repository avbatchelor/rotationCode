function figPlot2(figData,data,figSaveLocation)


%% unpack
v2struct(figData)


lineColors{1} = 'b';

lineColors{2} = [0    0.5000        0];
lineColors{4} = [0     0     1];
lineColors{3} = [0.7500         0    0.7500];
lineColors{6} = [1     0     0];
lineColors{5} = 'y';
% lineColors{10} = [0    0.7500    0.7500];
% lineColors{9} = [0    0.5000        0];
% lineColors{8} = [0     0     1];
% lineColors{7} = [0.7500         0    0.7500];
% lineColors{6} = [1     0     0];


%% Plot position at end of stimulus without rotation
fig = figure(1);
setCurrentFigurePosition(2)
h(1) = subplot(1,2,1);
line([zeros(length(xBefore{1}),1),xBefore{1}]',[zeros(length(xBefore{1}),1),yBefore{1}]','Color','k');
hold on
plot([zeros(length(xAfter{1}),1),xAfter{1}]',[zeros(length(xAfter{1}),1),yAfter{1}]','Color',lineColors{1});

suplabel('x position (cm)','x')
suplabel('y position (cm)','y')


% filename{4} = [figSaveLocation,'4.emf'];
% print(fig,'-dmeta',filename{4},'-r300')

% %% Plot histograms for position at end of stimulus
% fig = figure(2);
% setCurrentFigurePosition(2)
% bins = -0.5:0.01:0.5;
% [counts values] = hist(xAfter{1},bins);
% B = bar(values,counts,'b','EdgeColor',[1 1 1]);
% ch = get(B,'child');
% set(ch,'facea',.3)
% hold on
% clear h
% suplabel('x position (cm)','x')
% suplabel('frequency','y')
%     
% set(gca,'Box','off')
% 
% filename{5} = [figSaveLocation,'5.emf'];
% print(fig,'-dmeta',filename{5},'-r300')
%% Plot position at end of stimulus with rotation
figure(1)
setCurrentFigurePosition(2)
h(2) = subplot(1,2,2);
xlimits = [];
xBefore = cell2mat(xBefore);
yBefore = cell2mat(yBefore);
xAfter = cell2mat(xAfter);
yAfter = cell2mat(yAfter);
for i = 1:length(xBefore)
    
    % work out angle to rotate
    a = [xBefore(i);yBefore(i)];
    b = [0; -1];
    theta = acos(dot(a,b)/(norm(a)*norm(b)));
    if a(1) < 0
        R = [cos(theta),-sin(theta);sin(theta),cos(theta)];
    else
        R = [cos(theta),sin(theta);-sin(theta),cos(theta)];
    end
    before(i,1:2) = R*a;
    c = [xAfter(i);yAfter(i)];
    after(i,1:2) = R*c;
end

set(fig,'units','normalized','outerposition',[0 0 1 1]);
% plot
line([zeros(length(before),1),before(:,1)]',[zeros(length(before),1),before(:,2)]','Color','k');
hold on
plot([zeros(length(after),1),after(:,1)]',[zeros(length(after),1),after(:,2)]','Color','b');
%     title(leg{i});
xlimits = [xlimits xlim];


linkaxes(h)
xlim([-max(abs(xlimits)) max(abs(xlimits))])
ylim([-0.75 0.5])
xlim([-0.5 0.5])
suplabel('x position (cm)','x')
suplabel('y position (cm)','y')


% filename{4} = [figSaveLocation,'4.emf'];
% print(fig,'-dmeta',filename{4},'-r300')

%% Plot histograms for position at end of stimulus


acos(dot(a,b)/(norm(a)*norm(b)))*360/(2*pi);
% Work out distribution of angles 
for i = 1:length(xBefore)
    
    % work out angle without rotation
    a = [xAfter(i);yAfter(i)];
    b = [0; -1];
    thetaNoR(i) = acos(dot(a,b)/(norm(a)*norm(b)))*360/(2*pi);
    if xAfter(i) < 0 
        thetaNoR(i) = -thetaNoR(i);
    end
        
    
    % work out angle with rotation 
    a = after(i,:);
    b = [0; -1];
    thetaR(i) = acos(dot(a,b)/(norm(a)*norm(b)))*360/(2*pi);   
    if after(i) < 0 
        thetaR(i) = -thetaR(i);
    end
end

% Plot 
figure(2)
setCurrentFigurePosition(2)
bins = -180:2:180;
[counts values] = hist(thetaNoR,bins);
fig2(1) = subplot(3,1,1);
B = bar(values,counts,'b','EdgeColor',[1 1 1]);
ch = get(B,'child');
set(ch,'facea',.3)
fig2(3) = subplot(3,1,3);
B = bar(values,counts,'b','EdgeColor',[1 1 1]);
ch = get(B,'child');
set(ch,'facea',.3)
clear h values counts
hold on

[counts values] = hist(thetaR,bins);
fig2(2) = subplot(3,1,2);
B = bar(values,counts,'g','EdgeColor',[1 1 1]);
ch = get(B,'child');
set(ch,'facea',.3)
fig2(3) = subplot(3,1,3);
B = bar(values,counts,'g','EdgeColor',[1 1 1]);
ch = get(B,'child');
set(ch,'facea',.3)

suplabel('x position (cm)','x')
suplabel('frequency','y')
    
set(gca,'Box','off')

linkaxes(fig2)

% filename{5} = [figSaveLocation,'5.emf'];
% print(fig,'-dmeta',filename{5},'-r300')

%% Append pdfs

% append_pdfs(filename{:})

