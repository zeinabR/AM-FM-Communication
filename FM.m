clc;
clear all;
% 1) modulate the signal
[sig,Fs] = audioread('audio/speech_dft_8kHz.wav');
%sound(sig)
fc = 100*10^3;
beta = 5;
%t = (0:1/Fs:((size(y,1)-1)/Fs))';
%figure;
%plot(t,y);
sampl_sig = resample(sig,Fs,fc);
%sound(sampl_sig)
am = max(sampl_sig);
x = fft (sampl_sig);
% % I only need to search 1/2 of xdft for the max because x is real-valued
% xdft = x(1:round(length(sampl_sig)/2)+1);
% [Y,I] = max(abs(xdft));
% freq = 0:fc/length(sampl_sig):fc/2;
% Fs = freq(I)
kf = beta*2*pi*Fs/am;
delta_w = kf * am;
t = (0:1/Fs:((size(sampl_sig,1)-1)/Fs))';
figure;
plot(t,sampl_sig);
%  8,000 Hz, BitsPerSample: 16
%fileReader = dsp.AudioFileReader('speech_dft_8kHz.wav');
%%% sampling
%samp_fs = 2*fc;
%[p,q] = rat(samp_fs / fs);
%%%end sampling
phase_dev = cumsum(sampl_sig)/Fs;
%y = cos(2*pi*fc*t + 2*pi*freqdev*int_x + ini_phase);
%s_fm = fmmod(sampl_sig, fc, 2*fc, kf*am)
s_fm = cos(2*pi*fc*t+kf*phase_dev);
t = (0:1/Fs:((size(s_fm,1)-1)/Fs))';
figure;
plot(t,s_fm);
% 2) add noise
%snr = 20;
%s_noisy = awgn(s_fm,snr);
% plot(t,s_noisy);
% 3) demodulate
demod_sig = fmdemod(sampl_sig,fc,2*fc,delta_w);
sampl_dem = resample(sig,fc,Fs);
t = (0:1/Fs:((size(sampl_dem,1)-1)/Fs))';
figure
   plot(t,sampl_dem);
% 4) listen
sound(sampl_dem);