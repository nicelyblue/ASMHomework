clear all;
close all;
clc;

%ime_fajla = 'Ton_C.wav';
ime_fajla = 'Akord_Cdur.wav';
%ime_fajla = 'akord_3_sinewave.wav';


[signal,fs] = audioread(ime_fajla);
signal = 0.8*signal/max(abs(signal));
Nfft = fs; % najfinija rezolucija df = 1Hz
%number of sub-ranges
subranges = 12; % 12 notes
N_window = 1024; % in samples
overlap = 0.5; %in percentage


shift = round((1-overlap)*N_window); %window shift

%Izracunavamo spektrogram
%figure, spectrogram(signal,hamming(N_window),round(overlap*N_window),Nfft,fs,'power');
%figure, spectrogram(signal,hamming(N_window),round(overlap*N_window),Nfft,fs);
S = spectrogram(signal,hamming(N_window),round(overlap*N_window),Nfft,fs,'power');
S = abs(S);

df = fs/Nfft;
f = (0 : df : fs/2);
t = (0 : size(S,2)-1).*shift/fs; %in seconds

%Crtamo spektrogram
figure,
surf(t,f,S,'EdgeColor', 'none');
title(['Spektrogram signala - ' ime_fajla]);
ylim([0 4000]); % do 4kHz crtamo
ylabel('Frekvencije (Hz)');
xlim([0 t(size(S,2))]);
xlabel('Vreme [s]');
view(2);
clrbr = colorbar;
clrbr.Label.String = 'Magnitude spectrum of signal (in dB)';
colormap('jet');


%Odabrani samo maksimumi spektrograma
S_max_reducted = zeros(size(S));
for i = 1 : size(S,2)
    [~,locs] = findpeaks(S(:,i),'NPeaks',200); %od 24000 tacaka power spectruma nadjemo 200 maksimalnih
    S_max_reducted(locs,i) = S(locs,i);
end

%Crtamo spektrogram - redukovani
figure,
surf(t,f,S_max_reducted,'EdgeColor', 'none');
title(['Redukovani spektrogram signala - ' ime_fajla]);
ylim([0 1200]); % do 1200kHz crtamo
ylabel('Frekvencije (Hz)');
xlim([0 t(size(S_max_reducted,2))]);
xlabel('Vreme [s]');
view(2);
clrbr = colorbar;
clrbr.Label.String = 'Magnitude spectrum of signal (in dB)';
colormap('jet');

%Kreiramo Hroma matricu
C = ConstructChromaMatrix(fs,Nfft, subranges);
tonovi_imena = {'C';'C#';'D';'D#';'E';'F';'F#';'G';'G#';'A';'A#';'B';'C'};


%Crtamo Hroma matricu
figure,
surf(f,(1:subranges+1)',C,'EdgeColor', 'none');
title(['Hroma matrica C - ' ime_fajla]);
ylabel('Hromatska skala');
    set(gca,'YTickLabel',tonovi_imena)%set new tick labels
    set(gca,'Ydir','reverse')
ylim([1 subranges+1]);
%yticks((1:subranges+1)+0.5);
xlim([0 fs/2]);
xlabel('Frequencies [Hz]');
view(2);
colorbar;
colormap('jet');

%hromatorgram 1
Hromatogram = C*S;

%Crtamo Hromatogram
figure,
surf(t,(1:subranges+1)',Hromatogram,'EdgeColor', 'none');
title(['Hromatogram  - ' ime_fajla]);
ylabel('Hromatska skala');
    set(gca,'YTickLabel',tonovi_imena);%set new tick label
    set(gca,'Ydir','reverse');
ylim([1 subranges+1]);
%yticks((1:subranges+1)+0.5);
xlim([0 t(size(Hromatogram,2))]);
xlabel('Vreme [s]');
view(2);
colorbar; colormap('jet');

%Crtamo Hromatogram od redukovanog spektra
Hromatogram2 = C*S_max_reducted;

%Crtamo Hromatogram od redukovanog spektra
figure,
surf(t,(1:subranges+1)',Hromatogram2,'EdgeColor', 'none');
title(['Hromatogram redukovanog STFT  - ' ime_fajla]);
ylabel('Hromatska skala');
    set(gca,'YTickLabel',tonovi_imena);%set new tick label
    set(gca,'Ydir','reverse');
ylim([1 subranges+1]);
%yticks((1:subranges+1)+0.5);
xlim([0 t(size(Hromatogram2,2))]);
xlabel('Vreme [s]');
view(2);
colorbar; colormap('jet');

%Ra?unamo Hroma Profil
ChromaProfile = sum(Hromatogram2(1:subranges,:),2);
figure,
bar(ChromaProfile);
    set(gca,'XTickLabel',tonovi_imena(1:subranges));
title(['Hroma profil dobijen redukovanjem STFT - ' ime_fajla]);


