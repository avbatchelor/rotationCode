function [stimTrain pipStarts pipEnds]= generateFlashTrain(freq,samprate,dur,durramp,numPips,interPipInterval,restTime)


daqreset;
flash = 5*ones(1,samprate*dur);
pipStarts = repmat((restTime*samprate)+1,[1,numPips])+(0:(numPips-1)).*(interPipInterval*samprate);
pipEnds = repmat(-1+(dur.*samprate),[1,numPips])+pipStarts;
stimTrain = zeros(ceil(samprate*(2*restTime + numPips*interPipInterval)),1);
for n=1:numPips
    stimTrain(pipStarts(n):pipEnds(n)) = flash;
end
