function major_chord = major_chord(x, L)
  major_chord = x(1:L) + x(5*L+1:6*L) + x(8*L+1:9*L);
end
