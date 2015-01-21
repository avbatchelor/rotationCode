function [trials leg] = getTrialsExp1(data,trialsToInclude)

speaker = {'L' 'R'};

for i = 1:length(data.processedData.speaker)
    a(i) = data.processedData.speaker{i};
end

for i = 1:length(speaker)
    trials{i} = intersect(trialsToInclude,find(strcmp(a,speaker{i})));
    leg{i} = [speaker{i}];
end