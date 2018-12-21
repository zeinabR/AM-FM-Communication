%% Initialization
clear ; close all; clc

%% Read audio file
%audio = audioread('SpeechDFT-16-8-mono-5secs.wav');
fname = 'speech_dft_8kHz.wav';
m = dsp.AudioFileReader(fname,'OutputDataType','single');
file_info = audioinfo(fname);
[y,fs] = audioread (fname);
%y = y(:,1);
%soundsc(y);
m_min = abs(min(y));%min value of modulating signal
Fs = file_info.SampleRate; %sampling rate of modulating signal

%plot signal in time and frequency domain
 dt = 1/fs;
 t = 0:dt:(length(y)*dt)-dt;
% plot(t,y); title('original');xlabel('Seconds'); ylabel('Amplitude');
% figure
% plot(psd(spectrum.periodogram,y,'Fs',fs,'NFFT',length(y)));
%% =========== Part 1:AM modulation  =============
%AM modulation parameters
Ac = m_min / 0.9; 
Fc = 100000; %100 k HZ %carrier frequency

% Carrier Wave
Carrier = (cos(2*pi*Fc*t)');
% Signal Modulation
ya = y;
y = (Ac + y);
modulated = y.*Carrier;

i=1;
for snr= 0:4:20
    y = awgn(modulated,snr); %add noise
    %demodulating
    demodulated = abs(hilbert(y));
    offset = mean(demodulated);
    demodulated2 = demodulated - offset;
     %soundsc(demodulated)
    disp(mean(demodulated2));
    %calculate MSE and add it to the array to plot
    mse = immse(y, demodulated); %mean squre error between 2 signals
    snr_array(i) = snr;
    mse_array(i) = mse;
    i = i +1;
    %pause(file_info.Duration+1)
end
figure
plot(snr_array,mse_array);
title('snr VS mse');xlabel('SNRs'); ylabel('MSEs');;

