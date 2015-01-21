function [trials leg] = getTrialsExp2(data,trialsToInclude)

leg = cell(6,1);

intensity = sort(unique(data.processedData.intensity));
intensity = [sort(intensity,'descend'),intensity];
speaker = {'L' 'L' 'L' 'L' 'L' 'R' 'R' 'R' 'R' 'R'};

for i = 1:length(speaker)
    trialsAllSides = intersect(trialsToInclude,find(data.processedData.intensity==intensity(i)));
    trials{i} = intersect(trialsAllSides,find(strcmp(data.processedData.speaker,speaker{i})));
    leg{i} = ['Speaker location = ',speaker{i},' Intensity = ',num2str(intensity(i))];
end