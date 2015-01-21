function [trials leg] = getTrialsExp4(data,trialsToInclude)

leg = cell(6,1);

intensityL = sort([0.01 0.02 0.2 0.4 0.8 1.6],'descend');
intensityR = sort([0.21 0.42 0.4 0.8 1 2],'descend');

ratio = intensityL./intensityR;
difference = intensityR - intensityL; 

for i = 1:length(ratio)
    trials{i} = intersect(trialsToInclude,find(data.processedData.intensityL==intensityL(i)));
    leg{i} = ['L = ', num2str(intensityL(i)),', R = ',num2str(intensityR(i)) ', Ratio = ',num2str(ratio(i)),', Diff ',num2str(difference(i))];
end