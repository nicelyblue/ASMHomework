%fs: sampling rate
%Nfft: number of FFT points in signal
%Nsubranges: number of sub-ranges of chroma matrix (usually 12)
function [C] = ConstructChromaMatrix(fs, Nfft, Nsubranges)
    NSpec = Nfft/2 + 1; %The number of bins in the spectrogram
    C = zeros(Nsubranges+1, NSpec);%Allocate space for the C matrix
    C1 = 32.70; %The lowest octave range to search C1
    f_max = fs/2; %Maximum frequency supported by this sampling rate
    tones = C1 * 2.^((0:Nsubranges)./Nsubranges); %all of the tones constructing chroma profile
    %For each note
    for i = 1 : length(tones)
        row = zeros(1, NSpec); %This row of the C matrix (for single tone in spectrum e.g D#3, F#5 ...)
        %osnovni ton 
        f_tone_ground = tones(i);
        max_numb_of_octave = floor(log(f_max/f_tone_ground)/log(2)); % maximum number of octaves (highest octave in spectrum)
        %For each octave from 0 to the max octave
        for octave_ind = 0 : max_numb_of_octave
            f = f_tone_ground*(2^octave_ind);
            %for each frequency (each octave of base frequency) we create
            %bump.
             
            %Create an exponential gaussian bump around k in the frequency
            %domain. Its frequency divided by frequency resolution df
            k = round (f/(fs/Nfft));
            bump = 0:NSpec-1;
            bump = exp(-50.*abs(log(bump/k)/log(2)));
            bump = bump/norm(bump); %umesto norm
            row = row + bump;
        end
        C(i, :) = row;
    end
end
