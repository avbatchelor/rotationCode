function [stimTrain pipStarts pipEnds]= generateStimTrain2(freq,samprate,dur,durramp,numPips,interPipInterval,restTime,trialDur)


daqreset;
pip = generateTone(freq, samprate, dur, durramp)';
pipStarts = round(repmat((restTime*samprate)+1,[1,numPips])+(0:9).*(interPipInterval*samprate));
pipEnds = round(repmat(-1+(dur.*samprate),[1,numPips])+pipStarts);
stimTrain = zeros(samprate*trialDur,1);
for n=1:numPips
    stimTrain(pipStarts(n):pipEnds(n)) = pip;
end
