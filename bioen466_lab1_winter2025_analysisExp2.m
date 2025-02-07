%%%%% This script provides a guided outline for analyzing your experimental data collected for Experiment 2 (studying the impact of electrode size on recorded ephys signals)
%%%%% Written by A.L. Orsborn, v201219
%%%%%
%%%%%
%%%%% All lines where you have to fill in information is tagged with a comment including "FILLIN". Use this flag to find everything you need to modify.


% we will first load a data file and test our pre-processing and calculations on one file. Once that is complete, we can extend our analysis to all data to examine trends.

%% testing pre-processing and calculations

% Define some basic things to make it easy to find your data files.
% We will want to take advantage of systematic naming structure in our data files.
% Your files should have names like [prefix][date][id #].
% Note that the SpikeRecorder program automatically saves files with date and time in the name.
% We recommend re-naming your files to convert time into a simpler id# e.g. 1, 2, 3...

dataDir = 'C:\Users\denis\OneDrive\Uni Stuff\UW\2 Winter 2024\BIOEN 566 - Neural Engineering Lab\Lab Manuals and Code Templates\Lab 1\Lab 1 - EE 466 (Data)\'; %FILLIN with the path to where your data is stored

file_prefix = '2.'; %FILLIN with the text string that is common among all your data files
file_type = '.wav';   %FILLIN with the file extension for your data type

% file_date   = ''; %FILLIN with the date string used in your file
file_idnum  = 1; %FILLIN with the numeric value of the file id

full_file_name = [dataDir file_prefix num2str(file_idnum) file_type];

% load your data file and the sampling rate into matlab into the variables 'data' and FS, respectively.
% hint: look at the Matlab function 'audioread'
[data, FS] = audioread(full_file_name);

% check the basic properties of your loaded variables
whos data FS


% plot 1 second of your data to assure the loaded file looks correct
figure
time = [0:1/FS:1];
plot( time, data(1:length(time)) ) %FILLIN the portion in the brackets to only plot 1 second
xlabel('Time, in Seconds') %FILLIN the units of the time axis on this plot
ylabel('Voltage (mV)')



% Detect spikes using the program we wrote for experiment 1.
threshold = -0.1; %FILLIN with a number based on your data.
[spike_times, spike_waveforms] = detectSpikes(data, threshold, FS);

%inspect our data

%plot the raw signal and times of detected spikes to see if our function is working correctly
time_data = [0:length(data)-1]./FS; %this creates a time vector of the data in seconds
plot(time_data, data) %plot the raw data
xlabel('Time (s)')
ylabel('Voltage (mV)')
hold on
plot([spike_times spike_times]', repmat([.1 .15], length(spike_times),1)', 'r') %plot a vertical line at each detected spike time on the same plot
set(gca, 'xlim', [0 0.5]); %zoom in a bit
%pan through the data to see if you are doing a good job of detecting spikes.


%In addition to things we calculated in experiment 1 (like spike rate), here we
%will want to compute the SNR (signal to noise ratio) for our data.
%We've provided an outline of the calculations to do in the function computeSNR.m. Open this function and fill it in.
[RMS_noise, RMS_spikes] = computeSNR(data, threshold);

SNR = RMS_spikes / RMS_noise; %FILLIN compute the SNR
sprintf('The estimated SNR is %.4f', SNR)




%%  Now we can proceed to look at trends in our data across our recordings
%This will be almost exactly the same pipeline as in experiment 1, but we will add in SNR calculations.
%feel free to copy/reuse your code.

%again, we want to point to where our data files are. Except now, we want to specify a list of all files we want to analyze.
dataDir = 'C:\Users\denis\OneDrive\Uni Stuff\UW\2 Winter 2024\BIOEN 566 - Neural Engineering Lab\Lab Manuals and Code Templates\Lab 1\Lab 1 - EE 466 (Data)\'; %FILLIN with the path to where your data is stored

file_prefix = '2.'; %FILLIN with the text string that is common among all your data files
file_type = '.wav';   %FILLIN with the file extension for your data type

% file_date   = ''; %FILLIN with the date string used in your file
file_idnums  = [1 2 3] ; %FILLIN with the LIST of numeric values of the file ids.


%we also want to define the meta-data associated with each file we listed so we can analyze trends.
%the variable we changed across recordings is the electrode size. Define a variable for electrode_size
%that goes small -> large as the size of your measurement electrodes increases.
%note that the ordering of this variable should match the ordering of file_idnums defined above so that each file is matched with the appropriate metadata.
%Also note that it's easiest if you order the files so that electrode_spacing goes from smallest -> largest.

electrode_size = [3 2 1]; %FILLIN with the LIST of values for your spacings


num_files = length(file_idnums);
indv_thresh = [-0.1 -0.5 -0.1];

all_spike_times = cell(num_files, 1);
all_spike_waveforms = cell(num_files, 1);
all_spike_rates = zeros(num_files, 1);
all_mean_waveforms = cell(num_files, 1);
all_p2p = cell(num_files, 1);
all_mean_p2p = zeros(num_files, 1);
all_snr = zeros(num_files, 1);

% loop through your files to get spike rates and waveforms for all files
for iF=1:num_files

    %load the data and sampling rate, as done above
    full_file_name = [dataDir file_prefix num2str(file_idnums(iF)) file_type];
    [data, FS] = audioread(full_file_name);
    % figure
    % plot(data)
    % grid on

    %calculate an appropriate threshold for detecting spikes based on the data (see above)
    threshold = indv_thresh(iF); %FILLIN

    %detect spikes and waveforms. Save them into a variable for later analysis.
    %note: since there will be different numbers of spikes across files, these variables will need to be cells.
    %FILLIN with relevant code
    [spike_times, spike_waveforms] = detectSpikes(data, threshold, FS);
    all_spike_times{iF} = spike_times;
    all_spike_waveforms{iF} = spike_waveforms;

    %calculate the spike rate for each file. Again, save in a variable for later analysis.
    %FILLIN with relevant code
    time = [0:length(data) - 1]./ FS; 
    all_spike_rates(iF) = length(spike_times) / time(end);

    %calculate the peak-to-peak amplitude for your spikes and the mean peak-to-peak across all your waveforms.
    %use the provided function calcSpikePeak2Peak.m
    %FILLIN with relevant code
    p2p = calcSpikePeak2Peak(spike_waveforms);
    all_p2p{iF} = p2p;
    all_mean_p2p(iF) = mean(p2p);

    %calculate the mean waveform across all detected spikes. Save in a variable for plotting.
    %FILLIN with relevant code
    all_mean_waveforms{iF} = mean(spike_waveforms);

    %calculate the SNR for each recording.
    %FILLIN with relevant code
    [RMS_noise, RMS_spikes] = computeSNR(data, threshold);
    all_snr(iF) = RMS_spikes / RMS_noise;

end %end loop through files.


% We will now generate figures to explore our data:

%figure 1: mean firing rate as a function of electrode size. (attach in your comprehension questions)
figure
plot(electrode_size, all_spike_rates) %FILLIN with relevant variable name
xlabel('Electrode Size (Magnitude)') %FILL IN label
ylabel('Spike/Firing Rate (Spikes/Second)') %FILL IN label, be sure to include units
title('Mean Firing Rate vs Electrode Size')
grid on


%figure 2: plot example waveforms (attach in your comprehension questions)
%as before, it may be most informative to plot a smaller subset of all waveforms.
time_waveforms = [-10:19]./FS; %time vector of the waveforms in seconds
y_axis_range = {[-0.7 0.35] [-0.75 0.6] [-0.25 0.15]};

%loop through each file
for iF=1:num_files
    % subplot(1, num_files, iF)
    
    figure(iF)
    plot(time_waveforms, all_spike_waveforms{iF}) %FILLIN with relevant variable name
    xlabel('Time (s)') %FILL IN label
    ylabel('Waveforms (mV)') %FILL IN label, be sure to include units
    set(gca, 'ylim', y_axis_range{iF}) %keep axis the same across plots for easier comparison
    title(['E-size: ', num2str(electrode_size(iF))])
    grid on
end %end loop through files


%figure 3: mean waveform versus electrode size (attach in your comprehension questions)
for iF=1:num_files
    % figure(iF)
    plot(time_waveforms, all_mean_waveforms{iF}) %FILLIN with relevant variable name
    xlabel('Time (s)') %FILL IN label
    ylabel('Mean Waveform (mV)') %FILL IN label, be sure to include units
    legendEntries = {'Large Electrode', 'Medium Electrode', 'Small Electrode'};
    legend(legendEntries)
    title('Mean Waveform vs Electrode Size')
    grid on
    hold on
end



%figure 4: mean peak-to-peak amplitude versus electrode electrode size (attach in your comprehension questions)
figure
plot(electrode_size, all_mean_p2p) %FILLIN with relevant variable name
xlabel('Electrode Size (Magnitude)') %FILL IN label
ylabel('Mean Peak to Peak Amplitude (mV)') %FILL IN label, be sure to include units
title('Mean Peak-to-Peak vs Electrode Size')
grid on


%figure 5: histogram of peak-to-peak amplitude for each recording (attach in your comprehension questions)
% histBins = [0:.01:.5]; %bins to use--note, may want to adjust depending on your data range
%loop through each file
for iF=1:num_files
    % subplot(num_files, 1, iF)
    
    figure(iF)
    hist(all_p2p{iF}, 20) %FILLIN with your data to make a histogram of peak-to-peak amplitudes observed across all spikes, using histBins
    xlabel('Peak to Peak Amplitude (mV)') %FILL IN label be sure to include units
    ylabel('# of Waveforms with same Amplitude') %FILL IN label, be sure to include units
    title(['E-size: ', num2str(electrode_size(iF))])
end %end loop through files


%figure 6: SNR versus electrode electrode size (attach in your comprehension questions)
figure
plot(electrode_size, all_snr) %FILLIN with relevant variable name
xlabel('Electrode Size (Magnitude)') %FILL IN label
ylabel('Signal to Noise Ratio (Spikes/Noise)') %FILL IN label, be sure to include units
title('SNR vs Electrode Size')
grid on