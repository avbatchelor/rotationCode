function [trials leg] = getTrialsExp8(data,trialsToInclude)

leg = cell(5,1);

intensity = data.stim.intensity;

for i = 1:length(intensity)
    trials{i} = intersect(trialsToInclude,find(data.processedData.intensity==intensity(i)));
    leg{i} = ['Speaker location = M, Intensity = ',num2str(intensity(i))];
end