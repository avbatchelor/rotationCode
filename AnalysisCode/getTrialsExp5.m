function [trials leg] = getTrialsExp5(data,trialsToInclude)

leg = cell(10,1);

numPips = [sort(data.stim.numPips,'descend') data.stim.numPips];
speaker = {'L' 'L' 'L' 'L' 'L' 'R' 'R' 'R' 'R' 'R'};

for i = 1:length(numPips)
    trialsAllSides = intersect(trialsToInclude,find(data.processedData.pipNum==numPips(i)));
    trials{i} = intersect(trialsAllSides,find(strcmp(data.processedData.speaker,speaker{i})));
    leg{i} = [speaker{i},' Num Pips = ',num2str(numPips(i))];
end