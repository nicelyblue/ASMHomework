clear;
close all;

fs = 44100;
f0 = 440;
alpha = 0.995;
duration = 1;
L = duration * fs;

% Generate scales for each instrument using two variants of Karplus-Strong
% algorithm
all_notes_violin_method_one = all_notes_method_one('violin', L, f0, fs, alpha);
all_notes_violin_method_two = all_notes_method_two('violin', L, f0, fs);

all_notes_guitar_method_one = all_notes_method_one('guitar', L, f0, fs, alpha);
all_notes_guitar_method_two = all_notes_method_two('guitar', L, f0, fs);

% Generate major and minor chords for each of the scales
violin_major_chord_method_one = major_chord(all_notes_violin_method_one, L);
violin_major_chord_method_two = major_chord(all_notes_violin_method_two, L);
violin_minor_chord_method_one = minor_chord(all_notes_violin_method_one, L);
violin_minor_chord_method_two = minor_chord(all_notes_violin_method_two, L);

guitar_major_chord_method_one = major_chord(all_notes_guitar_method_one, L);
guitar_major_chord_method_two = major_chord(all_notes_guitar_method_two, L);
guitar_minor_chord_method_one = minor_chord(all_notes_guitar_method_one, L);
guitar_minor_chord_method_two = minor_chord(all_notes_guitar_method_two, L);

% Determine lengths of time axes
chord_length = L;
scale_length = 12*L;

% Determine lengths of frequency axes
t_chord = (0:1/fs:(chord_length - 1)/fs);
t_scale = (0:1/fs:(scale_length - 1)/fs);

chord_fft_length = pow2(nextpow2(chord_length));
scale_fft_length = pow2(nextpow2(scale_length));

freq_one = (0:scale_fft_length-1)*(fs/scale_fft_length);
freq_two = (0:chord_fft_length-1)*(fs/chord_fft_length);

% Get FFT of all scales and chords
violin_scale_one = fft(all_notes_violin_method_one, scale_fft_length);
violin_scale_two = fft(all_notes_violin_method_two, scale_fft_length);

guitar_scale_one = fft(all_notes_guitar_method_one, scale_fft_length);
guitar_scale_two = fft(all_notes_guitar_method_two, scale_fft_length); 

% Plotting time domain signals (scales)
% Violin
figure('Name','Violin scale, as function of time','NumberTitle','off')
subplot(2,1,1);
plot(t_scale, all_notes_violin_method_one)
title('Method one')
xlabel('Time (seconds)')
ylabel('Amplitude')

subplot(2,1,2);
plot(t_scale, all_notes_violin_method_two)
title('Method two')
xlabel('Time (seconds)')
ylabel('Amplitude')

% Guitar
figure('Name','Guitar scale, as function of time','NumberTitle','off')
subplot(2,1,1);
plot(t_scale, all_notes_guitar_method_one)
title('Method one')
xlabel('Time (seconds)')
ylabel('Amplitude')

subplot(2,1,2);
plot(t_scale, all_notes_guitar_method_two)
title('Method two')
xlabel('Time (seconds)')
ylabel('Amplitude')

% Plotting time domain signals (chords)
% Violin
figure('Name','Violin chords, as function of time','NumberTitle','off')
subplot(2,2,1);
plot(t_chord, violin_major_chord_method_one)
title('Method one, major chord')
xlabel('Time (seconds)')
ylabel('Amplitude')

subplot(2,2,2);
plot(t_chord, violin_minor_chord_method_one)
title('Method one, minor chord')
xlabel('Time (seconds)')
ylabel('Amplitude')

subplot(2,2,3);
plot(t_chord, violin_major_chord_method_two)
title('Method two, major chord')
xlabel('Time (seconds)')
ylabel('Amplitude')

subplot(2,2,4);
plot(t_chord, violin_minor_chord_method_two)
title('Method two, minor chord')
xlabel('Time (seconds)')
ylabel('Amplitude')

% Guitar
figure('Name','Guitar chords, as function of time','NumberTitle','off')
subplot(2,2,1);
plot(t_chord, guitar_major_chord_method_one)
title('Method one, major chord')
xlabel('Time (seconds)')
ylabel('Amplitude')

subplot(2,2,2);
plot(t_chord, guitar_minor_chord_method_one)
title('Method one, minor chord')
xlabel('Time (seconds)')
ylabel('Amplitude')

subplot(2,2,3);
plot(t_chord, guitar_major_chord_method_two)
title('Method two, major chord')
xlabel('Time (seconds)')
ylabel('Amplitude')

subplot(2,2,4);
plot(t_chord, guitar_minor_chord_method_two)
title('Method two, minor chord')
xlabel('Time (seconds)')
ylabel('Amplitude')

% Plotting spectrums of scales
% Violin
violin_scale_one_power = abs(violin_scale_one).^2/scale_fft_length;
figure('Name','Violin scale, spectrum','NumberTitle','off')
subplot(2,1,1);
plot(freq_one(1:floor(scale_fft_length/2)), violin_scale_one_power(1:floor(scale_fft_length/2)))
title('Method one')
xlabel('Frequency (Hz)')
ylabel('Power')

subplot(2,1,2);
violin_scale_two_power = abs(violin_scale_two).^2/scale_fft_length;
plot(freq_one(1:floor(scale_fft_length/2)), violin_scale_two_power(1:floor(scale_fft_length/2)))
title('Method two')
xlabel('Frequency (Hz)')
ylabel('Power')

% Guitar
guitar_scale_one_power = abs(guitar_scale_one).^2/scale_fft_length;
figure('Name','Guitar scale, spectrum','NumberTitle','off')
subplot(2,1,1);
plot(freq_one(1:floor(scale_fft_length/2)), guitar_scale_one_power(1:floor(scale_fft_length/2)))
title('Method one')
xlabel('Frequency (Hz)')
ylabel('Power')

subplot(2,1,2);
guitar_scale_two_power = abs(guitar_scale_two).^2/scale_fft_length;
plot(freq_one(1:floor(scale_fft_length/2)), guitar_scale_two_power(1:floor(scale_fft_length/2)))
title('Method two')
xlabel('Frequency (Hz)')
ylabel('Power')

% Plotting spectrums of chords

violin_chord_method_one_component_one = abs(fft(all_notes_violin_method_one(1:L), chord_fft_length)).^2/chord_fft_length;
violin_major_chord_method_one_component_two = abs(fft(all_notes_violin_method_one(5*L+1:6*L), chord_fft_length)).^2/chord_fft_length;
violin_minor_chord_method_one_component_two = abs(fft(all_notes_violin_method_one(4*L+1:5*L), chord_fft_length)).^2/chord_fft_length;
violin_chord_method_one_component_three = abs(fft(all_notes_violin_method_one(8*L+1:9*L), chord_fft_length)).^2/chord_fft_length;

violin_chord_method_two_component_one = abs(fft(all_notes_violin_method_two(1:L), chord_fft_length)).^2/chord_fft_length;
violin_major_chord_method_two_component_two = abs(fft(all_notes_violin_method_two(5*L+1:6*L), chord_fft_length)).^2/chord_fft_length;
violin_minor_chord_method_two_component_two = abs(fft(all_notes_violin_method_two(4*L+1:5*L), chord_fft_length)).^2/chord_fft_length;
violin_chord_method_two_component_three = abs(fft(all_notes_violin_method_two(8*L+1:9*L), chord_fft_length)).^2/chord_fft_length;

guitar_chord_method_one_component_one = abs(fft(all_notes_guitar_method_one(1:L), chord_fft_length)).^2/chord_fft_length;
guitar_major_chord_method_one_component_two = abs(fft(all_notes_guitar_method_one(5*L+1:6*L), chord_fft_length)).^2/chord_fft_length;
guitar_minor_chord_method_one_component_two = abs(fft(all_notes_guitar_method_one(4*L+1:5*L), chord_fft_length)).^2/chord_fft_length;
guitar_chord_method_one_component_three = abs(fft(all_notes_guitar_method_one(8*L+1:9*L), chord_fft_length)).^2/chord_fft_length;

guitar_chord_method_two_component_one = abs(fft(all_notes_guitar_method_two(1:L), chord_fft_length)).^2/chord_fft_length;
guitar_major_chord_method_two_component_two = abs(fft(all_notes_guitar_method_two(5*L+1:6*L), chord_fft_length)).^2/chord_fft_length;
guitar_minor_chord_method_two_component_two = abs(fft(all_notes_guitar_method_two(4*L+1:5*L), chord_fft_length)).^2/chord_fft_length;
guitar_chord_method_two_component_three = abs(fft(all_notes_guitar_method_two(8*L+1:9*L), chord_fft_length)).^2/chord_fft_length;

% Violin
figure('Name','Violin chords spectrum','NumberTitle','off')
subplot(2,2,1);
hold on
plot(freq_two(1:floor(chord_fft_length/2)), violin_chord_method_one_component_one(1:floor(chord_fft_length/2)))
plot(freq_two(1:floor(chord_fft_length/2)), violin_major_chord_method_one_component_two(1:floor(chord_fft_length/2)))
plot(freq_two(1:floor(chord_fft_length/2)), violin_chord_method_one_component_three(1:floor(chord_fft_length/2)))
hold off
title('Method one, major chord')
legend('f0 component','f0*2^4^/^1^2component','f0*2^7^/^1^2 component')
xlabel('Frequency (Hz)')
ylabel('Power')

subplot(2,2,2);
hold on
plot(freq_two(1:floor(chord_fft_length/2)), violin_chord_method_one_component_one(1:floor(chord_fft_length/2)))
plot(freq_two(1:floor(chord_fft_length/2)), violin_minor_chord_method_one_component_two(1:floor(chord_fft_length/2)))
plot(freq_two(1:floor(chord_fft_length/2)), violin_chord_method_one_component_three(1:floor(chord_fft_length/2)))
hold off
title('Method one, minor chord')
legend('f0 component','f0*2^3^/^1^2component','f0*2^7^/^1^2 component')
xlabel('Frequency (Hz)')
ylabel('Power')

subplot(2,2,3);
hold on
plot(freq_two(1:floor(chord_fft_length/2)), violin_chord_method_two_component_one(1:floor(chord_fft_length/2)))
plot(freq_two(1:floor(chord_fft_length/2)), violin_major_chord_method_two_component_two(1:floor(chord_fft_length/2)))
plot(freq_two(1:floor(chord_fft_length/2)), violin_chord_method_two_component_three(1:floor(chord_fft_length/2)))
hold off
title('Method two, major chord')
legend('f0 component','f0*2^4^/^1^2component','f0*2^7^/^1^2 component')
xlabel('Frequency (Hz)')
ylabel('Power')

subplot(2,2,4);
hold on
plot(freq_two(1:floor(chord_fft_length/2)), violin_chord_method_two_component_one(1:floor(chord_fft_length/2)))
plot(freq_two(1:floor(chord_fft_length/2)), violin_minor_chord_method_two_component_two(1:floor(chord_fft_length/2)))
plot(freq_two(1:floor(chord_fft_length/2)), violin_chord_method_two_component_three(1:floor(chord_fft_length/2)))
hold off
title('Method two, minor chord')
legend('f0 component','f0*2^3^/^1^2component','f0*2^7^/^1^2 component')
xlabel('Frequency (Hz)')
ylabel('Power')

% Guitar
figure('Name','Guitar chords spectrum','NumberTitle','off')
subplot(2,2,1);
hold on
plot(freq_two(1:floor(chord_fft_length/2)), guitar_chord_method_one_component_one(1:floor(chord_fft_length/2)))
plot(freq_two(1:floor(chord_fft_length/2)), guitar_major_chord_method_one_component_two(1:floor(chord_fft_length/2)))
plot(freq_two(1:floor(chord_fft_length/2)), guitar_chord_method_one_component_three(1:floor(chord_fft_length/2)))
hold off
title('Method one, major chord')
legend('f0 component','f0*2^4^/^1^2component','f0*2^7^/^1^2 component')
xlabel('Frequency (Hz)')
ylabel('Power')

subplot(2,2,2);
hold on
plot(freq_two(1:floor(chord_fft_length/2)), guitar_chord_method_one_component_one(1:floor(chord_fft_length/2)))
plot(freq_two(1:floor(chord_fft_length/2)), guitar_minor_chord_method_one_component_two(1:floor(chord_fft_length/2)))
plot(freq_two(1:floor(chord_fft_length/2)), guitar_chord_method_one_component_three(1:floor(chord_fft_length/2)))
hold off
title('Method one, minor chord')
legend('f0 component','f0*2^3^/^1^2component','f0*2^7^/^1^2 component')
xlabel('Frequency (Hz)')
ylabel('Power')

subplot(2,2,3);
hold on
plot(freq_two(1:floor(chord_fft_length/2)), guitar_chord_method_two_component_one(1:floor(chord_fft_length/2)))
plot(freq_two(1:floor(chord_fft_length/2)), guitar_major_chord_method_two_component_two(1:floor(chord_fft_length/2)))
plot(freq_two(1:floor(chord_fft_length/2)), guitar_chord_method_two_component_three(1:floor(chord_fft_length/2)))
hold off
title('Method two, major chord')
legend('f0 component','f0*2^4^/^1^2component','f0*2^7^/^1^2 component')
xlabel('Frequency (Hz)')
ylabel('Power')

subplot(2,2,4);
hold on
plot(freq_two(1:floor(chord_fft_length/2)), guitar_chord_method_two_component_one(1:floor(chord_fft_length/2)))
plot(freq_two(1:floor(chord_fft_length/2)), guitar_minor_chord_method_two_component_two(1:floor(chord_fft_length/2)))
plot(freq_two(1:floor(chord_fft_length/2)), guitar_chord_method_two_component_three(1:floor(chord_fft_length/2)))
hold off
title('Method two, minor chord')
legend('f0 component','f0*2^3^/^1^2component','f0*2^7^/^1^2 component')
xlabel('Frequency (Hz)')
ylabel('Power')


