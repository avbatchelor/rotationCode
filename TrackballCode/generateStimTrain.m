function [stimTrain pipStarts pipEnds]= generateStimTrain(freq,samprate,dur,durramp,numPips,interPipInterval,restTime)

% the length of the stimulus is always the length it would be for 10 pips 
daqreset;
pip = generateTone(freq, samprate, dur, durramp)';
pipStarts = repmat((restTime*samprate)+1,[1,numPips])+(0:(numPips-1)).*(interPipInterval*samprate);
pipEnds = repmat(-1+(dur.*samprate),[1,numPips])+pipStarts;
stimTrain = zeros(ceil(samprate*(2*restTime + 10*interPipInterval)),1);
for n=1:numPips
    stimTrain(pipStarts(n):pipEnds(n)) = pip;
end
