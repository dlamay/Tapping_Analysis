%% 
clear all
close all
addpath(genpath('/Users/danielle/Desktop/Coding Samples/'));

%% change subject information here!!! Also need to change the generated filename !!!

cd('/Users/danielle/Desktop/Coding Samples/');

subjectdata = 'P1_Data.mat';
load(['/Users/danielle/Desktop/Coding Samples/',subjectdata]);

combinedtaptimes =[log.taptimes1; log.taptimes2; log.taptimes3];
tappingfile = combinedtaptimes;


% generate an xlsx file with only one column with frequency information. 
readFrequency = xlsread('Frequency.xlsx');

%% 
%read in beatimes
beattime= nan(36,27);
for i = 1:size(beattime,1)
    beattime(i,1:size(readFrequency,2))=readFrequency(i,:);
end


%%
%record participant taps
taptime = nan(36,27);
taptime(:,1) = readFrequency(:,1);
for i = 1:length(tappingfile)
    taptime(i,2:(length(tappingfile{i,3})+1)) = tappingfile{i,3};
end

%%

% 11ms delay from computer generates sound till subject hears the sound
% 2ms midi delay
for i = 1:size(taptime,1)
    for j = 2: size(taptime,2)
        taptime(i,j) = taptime(i,j) - 0.013;
    end
end


%% remove double taps recorded by drumpad
cleantaptime = nan(36, 27);
cleantaptime(:,1) = taptime(:,1);
trials = size(taptime,1);

tap_index = 1;
for trial = 1:trials
    tap_count = 2; 
    tap_stop = 2;
    total_timepoints = sum(~isnan(taptime(trial,:)));
    for point = (tap_index+1):total_timepoints
        last_tap = taptime(trial,tap_count - 1);
        curr_tap = taptime(trial,point);
        tap_diff = curr_tap - last_tap;
        if tap_diff >= 0.1 
            cleantaptime(trial,tap_stop) = curr_tap;
            last_tap = curr_tap;
            tap_count = tap_count + 1;
            tap_stop = tap_stop + 1;
        else
            tap_count = tap_count + 1;
        end
    end
end


%% use beat time as an index for taptime 


beattime = beattime(:,1:22);
 
trials = size(cleantaptime,1);
taps = size(cleantaptime,2);
beats = size(beattime,2);
 
newtaptime = nan(trials,beats);
cycletime  = nan(trials,beats);
relphase   = nan(trials,beats);
newtaptime(:,1:2) = beattime(:,1:2);
cycletime(:,1:2)  = beattime(:,1:2);
relphase(:,1:2)   = beattime(:,1:2);






for i = 1:trials
    
    cycletime(i,3:beats-1) = diff(beattime(i,3:beats));  % Define window lengths by the difference between successive metronome beat times
    cycletime(i,beats) = cycletime(i,beats-1);  % Define last window length as the same as second to last
    
    for j = 3:beats
        
        differenceAllTaps = abs(beattime(i,j)-cleantaptime(i,3:beats));
        minIndex = find(differenceAllTaps == min(differenceAllTaps));  % Identify the tap closest to the metronome beat
        if abs(beattime(i,j)-cleantaptime(i,minIndex+2)) <= cycletime(i,j)/2  % If the difference between the closest tap and the current metronome beat is less than half the current window length, assign it
            newtaptime(i,j) = cleantaptime(i,minIndex+2);
        end
        
    end
    
end



 relphase(:,3:beats) = 2*pi*(newtaptime(:,3:beats) - beattime(:,3:beats))./ cycletime(:,3:beats);


return






%% sort conditions by frequency

%Tempo 1
a=1;
for i= 1:length(relphase)
    if relphase(i,1)== 4
        relphase_1 (a,:) = relphase(i,:);
        a = a+1;
    end
end
clear a;

%Tempo 2
a=1;
for i= 1:length(relphase)
    if relphase(i,1)== 3+1/3
        relphase_2 (a,:) = relphase(i,:);
        a = a+1;
    end
end
clear a;

%Tempo 3
a=1;
for i= 1:length(relphase)
    if relphase(i,1)== 2
        relphase_3 (a,:) = relphase(i,:);
        a = a+1;
    end
end
clear a;

%Tempo 4
a=1;
for i= 1:length(relphase)
    if relphase(i,1)== 1+ 3/7
        relphase_4 (a,:) = relphase(i,:);
        a = a+1;
    end
end
clear a;

%Tempo 5
a=1;
for i= 1:length(relphase)
    if relphase(i,1)== 1
        relphase_5 (a,:) = relphase(i,:);
        a = a+1;
    end
end
clear a;

%Tempo 6
a=1;
for i= 1:length(relphase)
    if relphase(i,1)== 10/13
        relphase_6 (a,:) = relphase(i,:);
        a = a+1;
    end
end
clear a;

%Tempo 7
a=1;
for i= 1:length(relphase)
    if relphase(i,1)== 10/19
        relphase_7 (a,:) = relphase(i,:);
        a = a+1;
    end
end
clear a;

%Tempo 8
a=1;
for i= 1:length(relphase)
    
    if relphase(i,1)== 5/13
        relphase_8 (a,:) = relphase(i,:);
        a = a+1;
    end
end
clear a;

%Tempo 9
a=1;
for i= 1:length(relphase)
    if relphase(i,1)== 10/37
        relphase_9 (a,:) = relphase(i,:);
        a = a+1;
    end
end
clear a;

%Tempo 10
a=1;
for i= 1:length(relphase)
    if relphase(i,1)== 10/51
        relphase_10 (a,:) = relphase(i,:);
        a = a+1;
    end
end
clear a;

%Tempo 11
a=1;
for i= 1:length(relphase)
    if relphase(i,1)== 5/36
        relphase_11 (a,:) = relphase(i,:);
        a = a+1;
    end
end
clear a;

%Tempo 12
a=1;
for i= 1:length(relphase)
    if relphase(i,1)== 0.10
        relphase_12 (a,:) = relphase(i,:);
        a = a+1;
    end
end
clear a;



%% Timeseries Plots

figure(1)

%tempo 1
subplot(4,3,1);
plot(nanmean(relphase_1(:,2:end)),'-o', 'LineWidth', 2);
set(gca, 'YTick', [-pi/2 -pi/4, 0, pi/4, pi/2], 'YTickLabel', {'-\pi/2' '-\pi/4', '0', '\pi/4', '\pi/2'})
ylim([-pi/2,pi/2]);
xlim([0,22])
refline(0)
title('4hz (240bpm)');
ylabel('relative phase')
set(gca, 'FontSize', 18)

%tempo 2
subplot(4,3,2);
plot(nanmean(relphase_2(:,2:end)),'-o', 'LineWidth', 2);
set(gca, 'YTick', [-pi/2 -pi/4, 0, pi/4, pi/2], 'YTickLabel', {'-\pi/2' '-\pi/4', '0', '\pi/4', '\pi/2'})
ylim([-pi/2,pi/2]);
xlim([0,22])
refline(0)
title('3.3333hz (200bpm)', 'LineWidth', 2);
ylabel('relative phase')
set(gca, 'FontSize', 18)

%tempo 3
subplot(4,3,3);
plot(nanmean(relphase_3(:,2:end)),'-o', 'LineWidth', 2);
set(gca, 'YTick', [-pi/2 -pi/4, 0, pi/4, pi/2], 'YTickLabel', {'-\pi/2' '-\pi/4', '0', '\pi/4', '\pi/2'})
ylim([-pi/2,pi/2]);
xlim([0,22])
refline(0)
title('2hz (120bpm)');
ylabel('relative phase')
set(gca, 'FontSize', 18)

%tempo 4
subplot(4,3,4);
plot(nanmean(relphase_4(:,2:end)),'-o', 'LineWidth', 2);
set(gca, 'YTick', [-pi/2 -pi/4, 0, pi/4, pi/2], 'YTickLabel', {'-\pi/2' '-\pi/4', '0', '\pi/4', '\pi/2'})
ylim([-pi/2,pi/2]);
xlim([0,22])
refline(0)
title('~1.43hz (~86bpm)');
ylabel('relative phase')
set(gca, 'FontSize', 18)

%tempo 5
subplot(4,3,5);
plot(nanmean(relphase_5(:,5:end)),'-o', 'LineWidth', 2);
set(gca, 'YTick', [-pi/2 -pi/4, 0, pi/4, pi/2], 'YTickLabel', {'-\pi/2' '-\pi/4', '0', '\pi/4', '\pi/2'})
ylim([-pi/2,pi/2]);
xlim([0,22])
refline(0)
title('1hz (60bmpm)');
ylabel('relative phase')
set(gca, 'FontSize', 18)

%tempo 6
subplot(4,3,6);
plot(nanmean(relphase_6(:,2:end)),'-o', 'LineWidth', 2);
set(gca, 'YTick', [-pi/2 -pi/4, 0, pi/4, pi/2], 'YTickLabel', {'-\pi/2' '-\pi/4', '0', '\pi/4', '\pi/2'})
ylim([-pi/2,pi/2]);
xlim([0,22])
refline(0)
title('~0.77hz (~46bpm)');
ylabel('relative phase')
set(gca, 'FontSize', 18)

%tempo 7
subplot(4,3,7);
plot(nanmean(relphase_7(:,2:end)),'-o','LineWidth', 2);
set(gca, 'YTick', [-pi/2 -pi/4, 0, pi/4, pi/2], 'YTickLabel', {'-\pi/2' '-\pi/4', '0', '\pi/4', '\pi/2'})
ylim([-pi/2,pi/2]);
xlim([0,22])
refline(0)
title('~0.53hz (~32bpm)');
ylabel('relative phase')
set(gca, 'FontSize', 18)

%tempo 8
subplot(4,3,8);
plot(nanmean(relphase_8(:,2:end)),'-o', 'LineWidth', 2);
set(gca, 'YTick', [-pi/2 -pi/4, 0, pi/4, pi/2], 'YTickLabel', {'-\pi/2' '-\pi/4', '0', '\pi/4', '\pi/2'})
ylim([-pi/2,pi/2]);
xlim([0,22])
refline(0)
title('~0.38hz (~23bpm)');
ylabel('relative phase')
set(gca, 'FontSize', 18)

%tempo 9
subplot(4,3,9);
plot(nanmean(relphase_9(:,2:end)),'-o', 'LineWidth', 2);
set(gca, 'YTick', [-pi/2 -pi/4, 0, pi/4, pi/2], 'YTickLabel', {'-\pi/2' '-\pi/4', '0', '\pi/4', '\pi/2'})
ylim([-pi/2,pi/2]);
xlim([0,22])
refline(0)
title('~0.27hz (~16bpm)');
ylabel('relative phase')
set(gca, 'FontSize', 18)

%tempo 10
subplot(4,3,10);
plot(nanmean(relphase_10(:,2:end)),'-o', 'LineWidth', 2);
set(gca, 'YTick', [-pi/2 -pi/4, 0, pi/4, pi/2], 'YTickLabel', {'-\pi/2' '-\pi/4', '0', '\pi/4', '\pi/2'})
ylim([-pi/2,pi/2]);
xlim([0,22])
refline(0)
title('~0.20hz (~12bpm)');
ylabel('relative phase')
set(gca, 'FontSize', 18)

%tempo 11
subplot(4,3,11);
plot(nanmean(relphase_11(:,2:end)),'-o', 'LineWidth', 2);
set(gca, 'YTick', [-pi/2 -pi/4, 0, pi/4, pi/2], 'YTickLabel', {'-\pi/2' '-\pi/4', '0', '\pi/4', '\pi/2'})
ylim([-pi/2,pi/2]);
xlim([0,22])
refline(0)
title('~0.14hz (~8bpm)');
ylabel('relative phase')
set(gca, 'FontSize', 18)

%tempo 12
subplot(4,3,12);
plot(nanmean(relphase_12(:,2:end)),'-o', 'LineWidth', 2);
set(gca, 'YTick', [-pi/2 -pi/4, 0, pi/4, pi/2], 'YTickLabel', {'-\pi/2' '-\pi/4', '0', '\pi/4', '\pi/2'})
ylim([-pi/2,pi/2]);
xlim([0,22])
refline(0)
title('0.10hz (6bpm)');
ylabel('relative phase')
set(gca, 'FontSize', 18)


%% Histagrams average

figure(2);

%tempo 1
subplot(4,3,1);
h=histogram(nanmean(relphase_1(:,2:end)),-pi/2:pi/20:pi/2);
line([0, 0], ylim, 'LineWidth', 2, 'Color', 'r');
h.Normalization ='probability';
xlim([-pi/2,pi/2]);
ylim([0,0.6]);
set(gca, 'XTick', [-pi/2 -pi/4, 0, pi/4, pi/2], 'XTickLabel', {'-\pi/2' '-\pi/4', '0', '\pi/4', '\pi/2'})
title('4hz (240bpm)');
xlabel('relative phase')
ylabel('frequency')
set(gca, 'FontSize', 18)


%tempo 2
subplot(4,3,2);
h=histogram(nanmean(relphase_2(:,2:end)),-pi/2:pi/20:pi/2);
line([0, 0], ylim, 'LineWidth', 2, 'Color', 'r');
h.Normalization ='probability';
xlim([-pi/2,pi/2]);
ylim([0,0.6]);
set(gca, 'XTick', [-pi/2 -pi/4, 0, pi/4, pi/2], 'XTickLabel', {'-\pi/2' '-\pi/4', '0', '\pi/4', '\pi/2'})
title('3.3333hz (200bpm)');
xlabel('relative phase')
ylabel('frequency')
set(gca, 'FontSize', 18)

%tempo 3
subplot(4,3,3);
h=histogram(nanmean(relphase_3(:,2:end)),-pi/2:pi/20:pi/2);
line([0, 0], ylim, 'LineWidth', 2, 'Color', 'r');
h.Normalization ='probability';
xlim([-pi/2,pi/2]);
ylim([0,0.6]);
set(gca, 'XTick', [-pi/2 -pi/4, 0, pi/4, pi/2], 'XTickLabel', {'-\pi/2' '-\pi/4', '0', '\pi/4', '\pi/2'})
title('2hz (120bpm)');
xlabel('relative phase')
ylabel('frequency')
set(gca, 'FontSize', 18)

%tempo 4
subplot(4,3,4);
h=histogram(nanmean(relphase_4(:,2:end)),-pi/2:pi/20:pi/2);
line([0, 0], ylim, 'LineWidth', 2, 'Color', 'r');
h.Normalization ='probability';
xlim([-pi/2,pi/2]);
ylim([0,0.6]);
set(gca, 'XTick', [-pi/2 -pi/4, 0, pi/4, pi/2], 'XTickLabel', {'-\pi/2' '-\pi/4', '0', '\pi/4', '\pi/2'})
title('~1.43hz (~86pm)');
xlabel('relative phase')
ylabel('frequency')
set(gca, 'FontSize', 18)

%tempo 5
subplot(4,3,5);
h=histogram(nanmean(relphase_5(:,2:end)),-pi/2:pi/20:pi/2);
line([0, 0], ylim, 'LineWidth', 2, 'Color', 'r');
h.Normalization ='probability';
xlim([-pi/2,pi/2]);
ylim([0,0.6]);
set(gca, 'XTick', [-pi/2 -pi/4, 0, pi/4, pi/2], 'XTickLabel', {'-\pi/2' '-\pi/4', '0', '\pi/4', '\pi/2'})
title('1hz (60bpm)');
xlabel('relative phase')
ylabel('frequency')
set(gca, 'FontSize', 18)

%tempo 6
subplot(4,3,6);
h=histogram(nanmean(relphase_6(:,2:end)),-pi/2:pi/20:pi/2);
line([0, 0], ylim, 'LineWidth', 2, 'Color', 'r');
h.Normalization ='probability';
xlim([-pi/2,pi/2]);
ylim([0,0.6]);
set(gca, 'XTick', [-pi/2 -pi/4, 0, pi/4, pi/2], 'XTickLabel', {'-\pi/2' '-\pi/4', '0', '\pi/4', '\pi/2'})
title('~0.77hz (~46bpm)');
xlabel('relative phase')
ylabel('frequency')
set(gca, 'FontSize', 18)

%tempo 7
subplot(4,3,7);
h=histogram(nanmean(relphase_7(:,2:end)),-pi/2:pi/20:pi/2);
line([0, 0], ylim, 'LineWidth', 2, 'Color', 'r');
h.Normalization ='probability';
xlim([-pi/2,pi/2]);
ylim([0,0.6]);
set(gca, 'XTick', [-pi/2 -pi/4, 0, pi/4, pi/2], 'XTickLabel', {'-\pi/2' '-\pi/4', '0', '\pi/4', '\pi/2'})
title('~0.53hz (~32bpm)');
xlabel('relative phase')
ylabel('frequency')
set(gca, 'FontSize', 18)

%tempo 8
subplot(4,3,8);
h=histogram(nanmean(relphase_8(:,2:end)),-pi/2:pi/20:pi/2);
line([0, 0], ylim, 'LineWidth', 2, 'Color', 'r');
h.Normalization ='probability';
xlim([-pi/2,pi/2]);
ylim([0,0.6]);
set(gca, 'XTick', [-pi/2 -pi/4, 0, pi/4, pi/2], 'XTickLabel', {'-\pi/2' '-\pi/4', '0', '\pi/4', '\pi/2'})
title('~0.38hz (~23bpm)');
xlabel('relative phase')
ylabel('frequency')
set(gca, 'FontSize', 18)

%tempo 9
subplot(4,3,9);
h=histogram(nanmean(relphase_9(:,2:end)),-pi/2:pi/20:pi/2);
line([0, 0], ylim, 'LineWidth', 2, 'Color', 'r');
h.Normalization ='probability';
xlim([-pi/2,pi/2]);
ylim([0,0.6]);
set(gca, 'XTick', [-pi/2 -pi/4, 0, pi/4, pi/2], 'XTickLabel', {'-\pi/2' '-\pi/4', '0', '\pi/4', '\pi/2'})
title('~0.27hz (~16bpm)');
xlabel('relative phase')
ylabel('frequency')
set(gca, 'FontSize', 18)

%tempo 10
subplot(4,3,10);
h=histogram(nanmean(relphase_10(:,2:end)),-pi/2:pi/20:pi/2);
line([0, 0], ylim, 'LineWidth', 2, 'Color', 'r');
h.Normalization ='probability';
xlim([-pi/2,pi/2]);
ylim([0,0.6]);
set(gca, 'XTick', [-pi/2 -pi/4, 0, pi/4, pi/2], 'XTickLabel', {'-\pi/2' '-\pi/4', '0', '\pi/4', '\pi/2'})
title('~0.20hz (~12bpm)');
xlabel('relative phase')
ylabel('frequency')
set(gca, 'FontSize', 18)

%tempo 11
subplot(4,3,11);
h=histogram(nanmean(relphase_11(:,2:end)),-pi/2:pi/20:pi/2);
line([0, 0], ylim, 'LineWidth', 2, 'Color', 'r');
h.Normalization ='probability';
xlim([-pi/2,pi/2]);
ylim([0,0.6]);
set(gca, 'XTick', [-pi/2 -pi/4, 0, pi/4, pi/2], 'XTickLabel', {'-\pi/2' '-\pi/4', '0', '\pi/4', '\pi/2'})
title('~0.14hz (~8bpm)');
xlabel('relative phase')
ylabel('frequency')
set(gca, 'FontSize', 18)

%tempo 12
subplot(4,3,12);
h=histogram(nanmean(relphase_12(:,2:end)),-pi/2:pi/20:pi/2);
line([0, 0], ylim, 'LineWidth', 2, 'Color', 'r');
h.Normalization ='probability';
xlim([-pi/2,pi/2]);
ylim([0,0.6]);
set(gca, 'XTick', [-pi/2 -pi/4, 0, pi/4, pi/2], 'XTickLabel', {'-\pi/2' '-\pi/4', '0', '\pi/4', '\pi/2'})
title('0.10hz (6bpm)');
xlabel('relative phase')
ylabel('frequency')
set(gca, 'FontSize', 18)


