function all_notes = all_notes_method_one(type, L, f0, fs, alpha)
  
  all_notes = [];
  b = 1;
  
  for i=1:12
    f = f0*2^((i-1)/12);
    M = round(fs/f);
   if type == 'violin'
      x = [(0:M-1)*2/(M-1) zeros(1, L-M)];
   else
      x = [randn(1, M) zeros(1, L-M)];
   end
    a = [1 zeros(1, M-1) -alpha];
    all_notes = cat(2, all_notes, filter(b, a, x));
  end
  
  all_notes = all_notes - mean(all_notes);
end
  

