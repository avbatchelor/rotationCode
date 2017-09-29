function interpolateDataAll(expNum,computer)

flyExperiments = getFlyExperiments(expNum);
for i = 1:size(flyExperiments,1)
    interpolateData(expNum,flyExperiments(i,1),flyExperiments(i,2),computer)
end