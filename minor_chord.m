function minor_chord = minor_chord(x, L)
  minor_chord = x(1:L) + x(4*L+1:5*L) + x(8*L+1:9*L);
end