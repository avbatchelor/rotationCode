function [trials leg stimStartIndex stimEndIndex] = getTrials(expNum,data,Vxy)

%% exclude trials that do not meet criteria

% only include trials where resultant velocity during stimulus is between 0.1-3 cm/s

if isfield(data.stim,'pipStarts')
    if iscell(data.stim.pipStarts)
    stimStartIndex =  round(data.stim.pipStarts{end}(1)/40);
    stimEndIndex = round(data.stim.pipEnds{end}(end)/40);
    else
    stimStartIndex =  round(data.stim.pipStarts(1)/40);
    stimEndIndex = round(data.stim.pipEnds(end)/40);
    end
else
    stimStartIndex = 1500;
    stimEndIndex = 1821;
end
avgResultantVelocity = nanmean(Vxy(:,stimStartIndex:stimEndIndex),2);
trialsToInclude=intersect(find(0.1<avgResultantVelocity),find(avgResultantVelocity<3))';
trialsToInclude = unique(trialsToInclude);

%% separate out trials by trials by type
if expNum == 1
    [trials leg] = getTrialsExp1(data,trialsToInclude);
elseif expNum == 2
    [trials leg] = getTrialsExp2(data,trialsToInclude);
elseif expNum == 3
    [trials leg] = getTrialsExp3(data,trialsToInclude);
elseif expNum == 4
    [trials leg] = getTrialsExp4(data,trialsToInclude);
elseif expNum == 5
    [trials leg] = getTrialsExp5(data,trialsToInclude);
elseif expNum ==6
    [trials leg] = getTrialsExp6(data,trialsToInclude);
elseif expNum ==7
    [trials leg] = getTrialsExp7(data,trialsToInclude);
elseif expNum == 8 
    [trials leg] = getTrialsExp8(data,trialsToInclude);
elseif expNum == 9 
    [trials leg] = getTrialsExp9(data,trialsToInclude);
end