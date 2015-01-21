function [trials leg] = getTrialsExp6(data,trialsToInclude)

leg = cell(6,1);

intensityL = sort(unique(data.processedData.intensityL),'descend');
intensityR = sort(unique(data.processedData.intensityR),'descend');

ratio = intensityL./intensityR;
difference = intensityR - intensityL; 

for i = 1:length(ratio)
    trials{i} = intersect(trialsToInclude,find(data.processedData.intensityL==intensityL(i)));
    leg{i} = ['L intensity = ', num2str(intensityL(i)),', R intensity = ',num2str(intensityR(i)), ', Ratio = ',num2str(ratio(i)),', Difference ',num2str(difference(i))];
end