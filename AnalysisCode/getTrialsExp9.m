function [trials leg] = getTrialsExp9(data,trialsToInclude)

% if data.flyNum ~=3
%     leg = cell(3,1);
% 
%     intensity = data.stim.intensity;
%     bgIntensity = data.stim.bgIntensity;
% 
%     for i = 1:length(intensity)
%         trialsByType = intersect(find(data.processedData.intensity==intensity(i)),find(data.processedData.bgIntensity==bgIntensity(i)));
%         trials{i} = intersect(trialsToInclude,trialsByType);
%         leg{i} = ['Speaker location = M, Stimulus Intensity = ',num2str(intensity(i)),' Background Intensity = ',num2str(bgIntensity(i))];
%     end
%     
% else

    intensityR = data.stim.intensityR;
    bgIntensityR = data.stim.bgIntensityR;
    intensityL = data.stim.intensityL;
    bgIntensityL = data.stim.bgIntensityL;
    
    for i = 1:length(intensityR)
        trials{i} = find(data.processedData.intensityR == intensityR(i) & data.processedData.intensityL == intensityL(i) ...
            & data.processedData.bgIntensityR == bgIntensityR(i) & data.processedData.bgIntensityL == bgIntensityL(i));
        leg{i} = ['R = ,' num2str(intensityR(i)), 'L = ,' num2str(intensityL(i)), ...
            'R = ,' num2str(bgIntensityR(i)), 'R = ,' num2str(bgIntensityL(i))];
    end
    
% end