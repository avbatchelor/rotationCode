function [trials leg] = getTrialsExp3(data,trialsToInclude)

if data.flyNum == 1
    trials{1} = trialsToInclude;
    leg{1} = 'Left antenna fixed';
else
    trials{2} = trialsToInclude;
    leg{2} = 'Left antenna fixed';
end