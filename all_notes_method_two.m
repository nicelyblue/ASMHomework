function all_notes = all_notes_method_two(type, L, f0, fs)
  
  all_notes = [];
  
  for i=1:12
    
    f = f0*2^((i-1)/12);
    M = round(fs/f);
    if type == 'violin'
      x = [(0:M-1)*2/(M-1) zeros(1, L-M)];
    else
      x = [randn(1, M) zeros(1, L-M)];
    end
    a = [1 zeros(1, M-1) -0.5 -0.5];
    b = firls(M+1, [0 1/M 2/M 1], [0 0 1 1]);
    all_notes = cat(2, all_notes, filter(b, a, x));
    
  end
  all_notes = all_notes - mean(all_notes);
  
end