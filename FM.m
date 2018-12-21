clc;
clear all;
% 1) modulate the signal
[sig,fs] = audioread('audio/speech_dft_8kHz.wav');
 soundsc(sig)
fc = 100*10^3;
beta = 5;
am = max(sig);
kf = beta*2*pi*fs/am;
delta_w = beta / (2*pi*fs);
%  8,000 Hz, BitsPerSample: 16
%fileReader = dsp.AudioFileReader('speech_dft_8kHz.wav');
%%% sampling
%samp_fs = 2*fc;
%[p,q] = rat(samp_fs / fs);
sampl_sig = resample(sig,fs,fc);
fs = 2*fc;
t = (0:1/fs:((size(sampl_sig,1)-1)/fs))';
figure;
plot(t,sampl_sig);
t = t(:,ones(1,size(sampl_sig,2)));
%%%end sampling
phase_dev = cumsum(sampl_sig)/fs;
%y = cos(2*pi*fc*t + 2*pi*freqdev*int_x + ini_phase);
s_fm = cos(2*pi*fc*t+kf*phase_dev);
figure;
plot(t,s_fm);
% 2) add noise
snr = 20;
s_noisy = awgn(s_fm,snr);
% plot(t,s_noisy);
% 3) demodulate
demod_sig = fmdemod(s_noisy,fc,fs,50);
figure
   plot(t,demod_sig);
% 4) listen
%sound(demod_sig);