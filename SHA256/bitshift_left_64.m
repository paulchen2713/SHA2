%
% bitshift_left_64 function
%
function out = bitshift_left_64(a, num)
    a_left = a(1:8);
    a_right = a(9:16);
    a_left_dec = uint32(hex2dec(a_left));
    a_right_dec = uint32(hex2dec(a_right));
    %
    if num < 32
        temp_right = bitget(a_right_dec, 33 - num:32);
        a_left_dec = bitshift(a_left_dec, num);
        a_right_dec = bitshift(a_right_dec, num);
        for i = 1 : num
            a_left_dec = bitset(a_left_dec, i, temp_right(i));
        end
    elseif num == 32
        a_left_dec = a_right_dec;
        a_right_dec = 0;
    else
        temp_right = bitget(a_right_dec, 1 : 64-num);
        a_left_dec = uint32(0);
        a_right_dec = uint32(0);
        for i = 1 : 64-num
            a_left_dec = bitset(a_left_dec, num - 32 + i, temp_right(i)) ;
        end
    end
    %
    a_left_hex = dec2hex(a_left_dec, 8);
    a_right_hex = dec2hex(a_right_dec, 8);
    a_hex = strcat(a_left_hex, a_right_hex);
    out = a_hex;
    % out = bitshift_right_64(a, 64 - num);
return

