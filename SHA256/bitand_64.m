%
% Function of bitand for 64 bit
%
function out=bitand_64(a_hex,b_hex)
a=a_hex;
b=b_hex;
a_left=a(1:8);
a_right=a(9:16);
b_left=b(1:8);
b_right=b(9:16);
a_left_dec=uint32(hex2dec(a_left));
a_right_dec=uint32(hex2dec(a_right));
b_left_dec=uint32(hex2dec(b_left));
b_right_dec=uint32(hex2dec(b_right));
a_b_left_dec=bitand(a_left_dec,b_left_dec);
a_b_right_dec=bitand(a_right_dec,b_right_dec);
a_b_left_hex=dec2hex(a_b_left_dec,8);
a_b_right_hex=dec2hex(a_b_right_dec,8);
a_b_hex=strcat(a_b_left_hex,a_b_right_hex);
out=a_b_hex;
return
