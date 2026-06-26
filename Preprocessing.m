% Matlab code For Thesis:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
clc; 
clear; 
close all;

%%%%%%%%%%%%%%%%% Load ECG and BCG signal %%%%%%%%%%%%%%%%
%%
%load ecg signal_____________________________________load ecg signal
load ('just.mat');
Fs = 500;
ecg = just(:,2);
%Load scg signal_____________________________________Load scg signal
scg_z = -(just(:,1));
fs = 500;

%%%%%%%%%%%%%%%%%%%%%% ECG %%%%%%%%%%%%%%%%%%%%%%
%%
%Normalized the ecg signal___________________________Normalized the ecg signal
ecg = (ecg - mean(ecg))/std(ecg);
t=1:1/(length(ecg)/120):120;

%FFT of ecg__________________________________________FFT of ecg
F = fft(ecg);
F = abs(F);
F = F(1:ceil(end/2));
F = F/max(F);
L = length(F);
f = (1:1:L)*((Fs/2)/L);
figure(1);
plot(f,F)
xlabel('Frequency (Hz)');
ylabel('Normalised Magnitude ');
title('Frequency of ECG');

%Creat filter for ecg signal_________________________Creat filter for ecg signal
cutoff = 20;
[b, a] = butter(4, cutoff/(Fs/2), 'low');
ecg_x = filter(b, a, ecg);
ecg_x = smooth (ecg_x)

%Remove lower frequencies of ecg signal___________Remove lower frequencies of ecg signal
fresult=fft(ecg_x);
fresult(1 : round(length(fresult)*5/Fs))=0;
fresult(end - round(length(fresult)*5/Fs) : end)=0;
corrected=real(ifft(fresult));

%Filter - first pass for ecg_________________________Filter - first pass for ecg
WinSize = floor(Fs * 571 / 1000);
if rem(WinSize,2)==0
    WinSize = WinSize+1;
end
filtered1_ecg = ecgdemowinmax(corrected, WinSize)
    
%Scale ecg signal____________________________________Scale ecg signal
peaks1_ecg = filtered1_ecg/(max(filtered1_ecg)/7);
%Filter by threshold filter
    for data = 1:1:length(peaks1_ecg)
        if peaks1_ecg(data) < 4
            peaks1_ecg(data) = 0;
        else
            peaks1_ecg(data)=1;
        end
    end
    positions_ecg=find(peaks1_ecg);
    distance_ecg=positions_ecg(2)-positions_ecg(1);
    %   Returns minimum distance between two peaks
    for data=1:1:length(positions_ecg)-1
        if positions_ecg(data+1)-positions_ecg(data)<distance_ecg 
            distance_ecg=positions_ecg(data+1)-positions_ecg(data);
        end
    end   
    
%Peak Detetion of ecg signal_________________________Peak Detetion of ecg signal
positions2_ecg=find(peaks1_ecg);
distanceBetweenFirstAndLastPeaks_ecg = positions2_ecg(length(positions2_ecg))-positions2_ecg(1);
averageDistanceBetweenPeaks_ecg = distanceBetweenFirstAndLastPeaks_ecg/length(positions2_ecg);

%Create figure-stages of processing of ecg_________Create figure-stages of processing of ecg
figure(2); 

%Original input ECG data
subplot(2, 2, 1); 
plot(t,ecg_x(1:length(t)))
title('\bf1. Original ECG');
xlabel('time/s');
ylabel('amplitude');

%ECG with removed low-frequency component____________ECG with removed low-frequency component
subplot(2, 2, 2); 
correted_plot = (corrected-min(corrected))/(max(corrected)-min(corrected))
plot(t,correted_plot(1:length(t)));
title('\bf2. FFT Filtered ECG'); 
xlabel('time/s');
ylabel('amplitude');
  
%Filtered ECG signal(1-st pass)______________________Filtered ECG signal(1-st pass)
subplot(2, 2, 3); 
filtered1_ecg_plot = (filtered1_ecg-min(filtered1_ecg))/(max(filtered1_ecg)-min(filtered1_ecg))
stem(t,filtered1_ecg_plot(1:length(t)));
title('\bf3. Filtered ECG'); 
xlabel('time/s');
ylabel('amplitude');
    
%Detected peaks in filtered ECG______________________Detected peaks in filtered ECG
subplot(2, 2, 4); 
stem(t,peaks1_ecg(1:length(t)));
title('\bf4. Detected Peaks'); 
xlabel('time/s');
ylabel('amplitude');

%%%%%%%%%%%%%%%%%%%%%% SCG %%%%%%%%%%%%%%%%%%%%%%

%FFT of scg__________________________________________FFT of scg
F = fft(scg_z);
F = abs(F);
F = F(1:ceil(end/2));
F = F/max(F);
L = length(F);
f = (1:1:L)*((Fs/2)/L);
figure(3);
plot(f,F)
xlabel('Frequency (Hz)');
ylabel('Normalised Magnitude ');
title('Frequency of SCG');

%Normalized scg signal_______________________________Normalized scg signal
a = max(scg_z);
b = min(scg_z);
d=b-a;

%Moving Average of ecg sihgnal_______________________Moving Average of ecg sihgnal
for i = 1:length(scg_z)   
    normaldata_scg(i) = (b-scg_z(i))/d;
end
num = (1/3)*[1 1 1];
den=[1];
rolling_avg_normaldata_scg = filter(num,den,normaldata_scg);

%Remove lower frequencies____________________________Remove lower frequencies
fresult=fft(rolling_avg_normaldata_scg);
fresult(1 : round(length(fresult)*4/fs))=0;
fresult(end - round(length(fresult)*5/fs) : end)=0;
corrected_scg=real(ifft(fresult));

%Creat filter for scg signal_________________________Creat filter for scg signal
[b,a] = butter(5,[70]/fs);
filtered_signal = filter(b,a,corrected_scg);
filtered_signal_scg =filtered_signal;
%filtered_signal_1 = sgolayfilt(filtered_signal_1,7,91);

WinSize_scg = floor(fs * 500 / 1000);
if rem(WinSize_scg,2)==0
    WinSize_scg = WinSize_scg+1;
end
filtered1_scg = ecgdemowinmax(filtered_signal_scg, WinSize_scg);

%Scale scg signal____________________________________Scale ecg signal
peaks1_scg = filtered1_scg/(max(filtered1_scg)/11);
%Filter by threshold filter
    for data = 1:1:length(peaks1_scg)
        if peaks1_scg(data) < 3
            peaks1_scg(data) = 0;
        else
            peaks1_scg(data)=1;
        end
    end
    positions_scg=find(peaks1_scg);
    distance_scg=positions_scg(2)-positions_scg(1);

    %   Returns minimum distance between two peaks
    for data=1:1:length(positions_scg)-1
        if positions_scg(data+1)-positions_scg(data)<distance_scg 
            distance_scg=positions_scg(data+1)-positions_scg(data);
        end
    end   
    
%Peak Detetion of ecg signal_________________________Peak Detetion of ecg signal
positions2_scg=find(peaks1_scg);
distanceBetweenFirstAndLastPeaks_scg = positions2_scg(length(positions2_scg))-positions2_scg(1);
averageDistanceBetweenPeaks_scg = distanceBetweenFirstAndLastPeaks_scg/length(positions2_scg);

%Create figure-stages of processing of scg___________Create figure-stages of processing of scg
figure(4)
subplot(311)
plot(t,scg_z(1:length(t)))
xlabel('time/s');
ylabel('amplitude');
title('Raw Data');

subplot(312)
plot(t,corrected_scg(1:length(t)))
xlabel('time/s');
ylabel('amplitude');
title('Time-domain diagram after removing lower frequenies');

subplot(313)
plot(t,filtered_signal_scg(1:length(t)))
xlabel('time/s');
ylabel('amplitude');
title('Time-domain diagram after butterworth lowpass filtering');

%%%%%%%%%%%%%%%% PLOT combination of ecg & bcg %%%%%%%%%%%%%%%
%%

for i = 1:length(filtered_signal_scg)   
    filtered_signal_scg(i) = filtered_signal_scg(i)+2;
    
end

for i = 1:length(ecg_x)   
    ecg_x(i) = ecg_x(i)-2;
    
end
%Create figure - result
figure(5); 

I = max(ecg_x)
O = min(ecg_x)
J = ((ecg_x-O)/(I-O))
K = peaks1_ecg.*((ecg_x-O)/(I-O))'

I1 = max(filtered_signal_scg)
O1 = min(filtered_signal_scg)
J1 = ((filtered_signal_scg-O1)/(I1-O1))
K1 = peaks1_scg'.*((filtered_signal_scg-O1)/(I1-O1))'

%Plotting ECG in green_______________________________Plotting ECG in red
plot(t,J(1: length(t)), '-r');   
hold on
%Plotting ECG in green_______________________________Plotting ECG in green
plot(t,J1(1:length(t)), '-g');
hold on
%Stemming peaks in dashed black______________________Stemming peaks in dashed black
stem(t,K(1: length(t)), ':k');
hold on
title('\bf Comparative SCG and ECG J-peak,R-Peak Detection Plot');  
%Stemming peaks in dashed black______________________Stemming peaks in dashed black
stem(t,K1(1: length(t)), ':k');

legend('ECG','SCG')
xlabel('Time/s');
ylabel('Amplitude');

hold off

%%%%%%%%%%%%%%%%%%distance btw SCG and ECG %%%%%%%%%%%%%%%
%%
acc_data = [];
result_dis = 0;

    %   Returns minimum distance between two peaks
    for i=1:length(positions_ecg)
        res = 100000;
        for j=1:length(positions_scg)
            res_1 = (positions_scg(j)- positions_ecg(i));
            if res_1 >=0
                res = min(res,res_1);
            end
            
        end
        acc_data = [acc_data; [res]];  
        result_dis = result_dis + res;
    end
    result_ds_mean = (result_dis/length(acc_data));
    
%%%%%%%%%%%%%%%%%%% %Display Output %%%%%%%%%%%%%%%%%%%
%%
%Measuring Heart Rate________________________________Measuring Heart Rate
averageHeartRate = 60 * Fs/averageDistanceBetweenPeaks_ecg;
Average_HeartBeat = sprintf('Average Heart Beat = %f beat/min.',averageHeartRate);
disp(Average_HeartBeat);

%Measuring distance between ecg & scg_____Measuring distance between ecg & scg
average_scg_ecg = result_ds_mean/fs;
RJ_peak_distane = sprintf('Average Distane Between R-peak(ECG) and J-peak(SCG) = %f s.',average_scg_ecg);
disp(RJ_peak_distane);

%%%%%%%%%%%%%%%%% ECG and SCG window function %%%%%%%%%%%%%%
%%
function Filtered=ecgdemowinmax(Original, WinSize)

    %initialising variables
    WinHalfSize = floor(WinSize/2);
    WinHalfSizePlus = WinHalfSize+1;
    WinSizeSpec = WinSize-1;
    FrontIterator = 1;
    WinPos = WinHalfSize;
    WinMaxPos = WinHalfSize;
    WinMax = Original(1);
    OutputIterator = 0;
    
    % Finding the postion of the largest value in window
    for LengthCounter = 0:1:WinHalfSize-1 
        if Original(FrontIterator+1) > WinMax
            WinMax = Original(FrontIterator+1);
            WinMaxPos = WinHalfSizePlus + LengthCounter;
        end
        FrontIterator=FrontIterator+1;
    end
    % if the first point is the highest, set ouput 1
    if WinMaxPos == WinHalfSize 
        Filtered(OutputIterator+1)=WinMax;
    else
        Filtered(OutputIterator+1)=0;
    end
    OutputIterator = OutputIterator+1;
    
    % search next half of signal
    for LengthCounter = 0:1:WinHalfSize-1 
        if Original(FrontIterator+1)>WinMax
            WinMax=Original(FrontIterator+1);
            WinMaxPos=WinSizeSpec;
        else
            WinMaxPos=WinMaxPos-1;
        end
        if WinMaxPos == WinHalfSize
            Filtered(OutputIterator+1)=WinMax;
        else
            Filtered(OutputIterator+1)=0;
        end
        FrontIterator = FrontIterator+1;
        OutputIterator = OutputIterator+1;
    end
    for FrontIterator=FrontIterator:1:length(Original)-1
        if Original(FrontIterator+1)>WinMax
            WinMax=Original(FrontIterator+1);
            WinMaxPos=WinSizeSpec;
        else
            WinMaxPos=WinMaxPos-1;
            if WinMaxPos < 0
                WinIterator = FrontIterator-WinSizeSpec;
                WinMax = Original(WinIterator+1);
                WinMaxPos = 0;
                WinPos=0;
                for WinIterator = WinIterator:1:FrontIterator
                    if Original(WinIterator+1)>WinMax
                        WinMax = Original(WinIterator+1);
                        WinMaxPos = WinPos;
                    end
                    WinPos=WinPos+1;
                end
            end
        end
        if WinMaxPos==WinHalfSize
            Filtered(OutputIterator+1)=WinMax;
        else
            Filtered(OutputIterator+1)=0;
        end
        OutputIterator=OutputIterator+1;
    end
    WinIterator = WinIterator-1;
    WinMaxPos = WinMaxPos-1;
    for LengthCounter=1:1:WinHalfSizePlus-1
        if WinMaxPos<0
            WinIterator=length(Original)-WinSize+LengthCounter;
            WinMax=Original(WinIterator+1);
            WinMaxPos=0;
            WinPos=1;
            for WinIterator=WinIterator+1:1:length(Original)-1
                if Original(WinIterator+1)>WinMax
                    WinMax=Original(WinIterator+1);
                    WinMaxPos=WinPos;
                end
                WinPos=WinPos+1;
            end
        end
        if WinMaxPos==WinHalfSize
            Filtered(OutputIterator+1)=WinMax;
        else
            Filtered(OutputIterator+1)=0;
        end
        FrontIterator=FrontIterator-1;
        WinMaxPos=WinMaxPos-1;
        OutputIterator=OutputIterator+1;
    end
end
