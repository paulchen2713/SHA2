%
% bitcmp for 64bit
%
function out = bitcmp_64(a_hex)
a = a_hex;
%
% split a into left, and right parts in char string type
a_left = a(1:8);
a_right = a(9:16);
%
% convert a into decimal type
a_left_dec = uint32(hex2dec(a_left));
a_right_dec = uint32(hex2dec(a_right));
%
% executes bit-wise complement opertion
a_left_dec = bitcmp(a_left_dec);
a_right_dec = bitcmp(a_right_dec);
%
% turn a back into decimal type
a_left_hex = dec2hex(a_left_dec, 8);
a_right_hex = dec2hex(a_right_dec, 8);
%
% concatenate left and right string
a_hex = strcat(a_left_hex, a_right_hex);
out = a_hex;
return

