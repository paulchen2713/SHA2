%
% bitshift circular right
%
function out = bitshift_circular_right(a, n)
% a is the input string to be shifted
% n is the number of shifts

% bit = bitget(a,1:n);
% a = bitshift(a,-n);
% for in = 1 : n
%     a = bitset(a, 32-in+1, bit(n-in+1));
% end
% out = a;

ar = bitshift(a, -n);
al = double(bitshift(uint32(a), 32-n));
out = bitor(ar, al);

return
