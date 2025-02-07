function [RMS_noise, RMS_spikes] = computeSNR(data, threshold)

%%%%% All lines where you have to fill in information is tagged with a comment including "FILLIN". Use this flag to find everything you need to modify.
% The function description below described the high-level goals of the function and formats of the inputs and outputs. Read this carefully.


%[RMS_noise, RMS_spikes] = computeSNR(data, threshold)
%Uses the provided threshold to divide the data into 'signal' (spikes) and 'noise'
%Returns the root mean square (RMS) value of the noise and spike portions of the data.
%These, together, define the SNR (RMS_spikes/RMS_noise)
%
%inputs: data - vector time-series of voltage input ([1 x time] or [time x 1])
%        threshold - scalar threshold value for spike detection (units same as data)
%outputs: RMS_noise - scalar, root-mean-square of 'noise' portions of the data
%         RMS_spikes - scalar, root-mean-square of the 'signal' portions of the data


%define constants for the function
num_waveform_points_total = 30; %# of samples to load to capture the waveforms
num_waveform_points_before = 10; %# of samples before detection point to load



% we want to detect the time when the signal amplitude goes from below to above our threshold.
%1. create a logical vector that is zero when data is smaller than the threshold and 1 when it is bigger than the threshold
%we will want to account for the fact that we may want to use a negative threshold,
%in which case we want to find when the signal goes BELOW the threshold.
if threshold > 0
    amp_above_threshold = data > threshold; %FILLIN
else
    amp_above_threshold = data < threshold; %FILLIN
end

%2. create a vector that = 1 when amp_above_threshold goes from 0 -> 1 (hint: can be done in one line)
Low_hi = diff(amp_above_threshold); %FILLIN

%3. get the time index when low_hi = 1 (i.e. when our signal goes from below to above the threshold)
% this corresponds to the index of detected spikes
spike_idx = find(Low_hi); %FILLIN, index in data


%now that we have detected spikes, we want to sort the data as belonging to a spike (signal) or not (noise)
num_spikes = length(spike_idx); %# of spikes detected

isSpikeIdx = false(size(data)); %logical vector same size as the data
for iSpike=1:num_spikes

    idx = spike_idx(iSpike) + [0:num_waveform_points_total-1] - num_waveform_points_before ;

    %round idx to be within bounds of data
    idx = idx(idx>0);
    idx = idx(idx <= length(data));

    %flag these time-points as belonging to a spike
    isSpikeIdx(idx) = true;
end

%use the isSpkIdx logical to calculate RMS separately for 'noise' and 'spks'
RMS_noise  = rms(data(~isSpikeIdx));
RMS_spikes = rms(data(isSpikeIdx));

end
