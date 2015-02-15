function historyDependenceTest 

for i = 1:length(data.processedData.speaker)
    a(i) = data.processedData.speaker{i};
end

leftTrials = find(strcmp(a,'L'));
