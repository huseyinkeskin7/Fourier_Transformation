clc; clear all; close all; %#ok<*CLALL> 

%% Time domain:
Fs = 88200; % The sampling frequency is selected as 88.2 KHz
dt = 1/Fs; % Each time sample
StartTime = 0;
StopTime = 0.5; % Total duration of each note will be 0.5 second

t = (StartTime:dt:StopTime-dt)'; % Sampling

%Find the frequencies in Hz of each musical tone and add it to the code 
Do= 261; 
Re= 293; 
Mi= 329; 
Fa= 349; 
Sol= 391; 
La=440;  
Si= 493;

%% Creating music
Fc = [Sol Mi Mi Mi Sol Mi Mi Mi Sol La Sol Mi Fa Re Fa Re Re Re Fa Re Re Re Fa Sol Fa Re Mi Do]; %küçük kurbağa
Fc_String = ["Sol", "Mi", "Mi", "Mi","Sol","Mi","Mi","Mi","Sol","La","Sol","Mi","Fa" ,"Re", "Fa", "Re", "Re", "Re", "Fa", "Re", "Re", "Re", "Fa", "Sol", "Fa", "Re", "Mi", "Do"];
Fc_Notes = [Do Re Mi Fa Sol La Si]; % 7 musical notes
y = cos(2*pi*t*Fc); % Each musical tone is a pure sine wave 
N = size(y,2); % Checking the number of musical notes we use

%% Reshape signal to a single column vector:
y = y(:);
%sound(y,Fs); % Listen, also read the help file of sound function

%% Reformulate time domain:
StopTime = N*StopTime; % Since we have N tones, total time increases 
t = (StartTime:dt:StopTime-dt)'; % Creating new time vector
M = size(t,1); % Finding the length of the time vector

%% Frequency domain:
dF = Fs/M; % The fourier transform creates frequency bins in the length of the input vector. Since our total length is M, and our maximum frequency is Fs, each frequency bin is Fs/M
f = -Fs/2:dF:Fs/2-dF; % Frequencies range from -Fs/2 to Fs/2 (Remember Nyquist Rate)
Y = fftshift(fft(y)); % Why is fftshift used?



%% Plot 1000 sample points for each tone in the time domain
tt = 0:0.000005:0.005-0.000005; %1000 sample, sample interval = 0.000005 

% Time domain Waveforms for each 7 notes
figure;
for i = 1:1:length(Fc_Notes)
   plot(tt, cos(2*pi.*tt*Fc_Notes(i)));
   hold on;
end
legend (["Do", "Re", "Mi", "Fa", "Sol", "La", "Si"]);
xlabel("Time");
ylabel("Value");
title("Time Domain Waveforms of the 7 Notes");

% Time domain Waveforms for each music notes in subplot
figure;
for i = 1:1:length(Fc)
   subplot(length(Fc)/2,2,i);
   plot(tt, cos(2*pi.*tt*Fc(i)));
   title(Fc_String(i));
   xlabel("Time");
   ylabel("Value");
   hold on;
end

% Time domain Waveforms for each music notes in one figure
figure;
for i = 1:1:length(Fc)
   plot(tt, cos(2*pi.*tt*Fc(i)));
   hold on;
end
xlabel("Time");
ylabel("Value");
title("Time Domain Waveforms of the Music Notes");


%% Plot the absolute value of 'Y' from -1000 Hz to 1000Hz in the frequency domain, remember 0 Hz is in the middle.
figure;
plot(f, abs(Y));
title("Frequency Domain - Absolute Value of Y");
xlabel("Frequency(Hz)");
ylabel("Amplitude|Y(f)|");
xlim([-1000, 1000]);

%%%%Can you see all the musical tones?
%%%% Why do you think we have negative frequencies?


%% Find the frequency bins for the musical tone Do and make them equal to zero in Y.
%We choose Do note because Si note is not available in our music. 
% Do is the last note of our music

%First we tried to use find() function. But it didnt work.
% Do_indices = find(f >= Do - 10 & f <= Do + 10); % Defining a frequency range around Do
% Y(Do_indices) = 0; % Set the values in this frequency range to zero

%We directly remove Do bins in y ,then applied Fourier Transform again.It worked.
y(1190700:end, 1) = 0; %This is the Do frequency range.
Y = fftshift(fft (y));

% Plotting the modified frequency domain signal
figure;
plot(f, abs(Y));
title("Frequency Domain - Tone Do Frequency Bins Set to Zero");
xlabel("Frequency (Hz)");
ylabel("Amplitude|Y(f)|");
xlim([-1000, 1000]);

%% Inverse transform and listen to the modified signal
y1 = ifft(ifftshift(Y));
sound(y1, Fs); %Last note Do is removed