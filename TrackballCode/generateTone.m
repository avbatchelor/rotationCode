%% function stimtrain = generateTone(freq,samprate,dur,dr) 
function stimtrain = generateTone(freq,samprate,dur,dr) 
%stimtrain = generateTone(freq,samprate,dur,dr)
%
%Function generates a single tone of user-determined frequency, output
%sample rate, ramp, duration.  %AVB
%
%Inputs:
%   freq = stimulus frequency (in Hz)
%   samprate = output sample rate of stimulus (in Hz)
%   dur = duration of tone (in seconds)
%   dr = duration of ramp (set to 0 for default, which is dur/10)
%
%Outputs:
%   stimtrain = stimulus vector

sf = samprate;   % sample frequency (Hz)
stim_vector = zeros(1,(dur*sf));

%Make cos theta ramped pure tone             
n = sf*dur;                 % number of samples
s100 = (0:n-1)/sf;             % sound data preparation
s100 = sin(2*pi*freq*s100);   % sinusoidal modulation

% prepare ramp
if dr==0 || nargin<4
    dr = dur/10;
end
nr = floor(sf*dr);
r = sin(linspace(0,pi/2,nr));
r = [r,ones(1,n-nr*2),fliplr(r)];

% make ramped sound
s100 = s100.*r;

%add tones to stimulus vector
stimtrain = s100;