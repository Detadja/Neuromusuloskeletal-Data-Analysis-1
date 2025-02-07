function p2p = calcSpikePeak2Peak(spike_waveforms)

% p2p = calcSpikePeak2Peak(spike_waveforms)
% function to compute the peak-to-peak amplitude of spike waveforms
% Done by searching in a restricted window for the maximum and minimum waveform amplitude
% p2p = max - min
%
% inputs: spike_waveforms - matrix ([# spikes x time]) of spike waveform traces
% outputs: p2p - vector ([# spikes x 1]) of peak-to-peak for each waveform
%
%A.L. Orsborn, v191223

num_spikes = size(spike_waveforms,1);

searchIdx = [8:20];

mx = max(spike_waveforms(:,searchIdx),[],2);
mn = min(spike_waveforms(:,searchIdx),[],2);

p2p = mx - mn;
