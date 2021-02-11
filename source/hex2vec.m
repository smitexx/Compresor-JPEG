function y = hex2vec(s)

% function y = hex2mat(s)
% Convert a matrix of hex digit groups into a matrix of integers.
% Each row of groups is a single text string and converts to a
% row of matrix digits.
% Group are separated by ASCII chars < '0'.
% Nick Kingsbury, Dec 94

[m,n] = size(s);

y = [];

for r=1:m,
  v = [];
  sr = [s(r,:) ' '];
  c1 = 1;
  while c1 <= n,
    while (sr(c1) < '0') & (c1 <= n), c1 = c1 + 1; end
    c2 = c1 ;
    while (sr(c2) >= '0') & (c2 <= n), c2 = c2 + 1; end
    if c2 > c1, v = [v  hex2dec(sr(c1:(c2-1)))]; end
    c1 = c2;
  end
  y(r,:) = v;
end
return
    