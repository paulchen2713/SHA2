%
% SHA512
%
% clear all;
clc;

KT=[
    '428a2f98d728ae22'; '7137449123ef65cd'; 'b5c0fbcfec4d3b2f'; 'e9b5dba58189dbbc';
    '3956c25bf348b538'; '59f111f1b605d019'; '923f82a4af194f9b'; 'ab1c5ed5da6d8118';
    'd807aa98a3030242'; '12835b0145706fbe'; '243185be4ee4b28c'; '550c7dc3d5ffb4e2';
    '72be5d74f27b896f'; '80deb1fe3b1696b1'; '9bdc06a725c71235'; 'c19bf174cf692694';
    'e49b69c19ef14ad2'; 'efbe4786384f25e3'; '0fc19dc68b8cd5b5'; '240ca1cc77ac9c65';
    '2de92c6f592b0275'; '4a7484aa6ea6e483'; '5cb0a9dcbd41fbd4'; '76f988da831153b5';
    '983e5152ee66dfab'; 'a831c66d2db43210'; 'b00327c898fb213f'; 'bf597fc7beef0ee4';
    'c6e00bf33da88fc2'; 'd5a79147930aa725'; '06ca6351e003826f'; '142929670a0e6e70';
    '27b70a8546d22ffc'; '2e1b21385c26c926'; '4d2c6dfc5ac42aed'; '53380d139d95b3df';
    '650a73548baf63de'; '766a0abb3c77b2a8'; '81c2c92e47edaee6'; '92722c851482353b';
    'a2bfe8a14cf10364'; 'a81a664bbc423001'; 'c24b8b70d0f89791'; 'c76c51a30654be30';
    'd192e819d6ef5218'; 'd69906245565a910'; 'f40e35855771202a'; '106aa07032bbd1b8';
    '19a4c116b8d2d0c8'; '1e376c085141ab53'; '2748774cdf8eeb99'; '34b0bcb5e19b48a8';
    '391c0cb3c5c95a63'; '4ed8aa4ae3418acb'; '5b9cca4f7763e373'; '682e6ff3d6b2b8a3';
    '748f82ee5defb2fc'; '78a5636f43172f60'; '84c87814a1f0ab72'; '8cc702081a6439ec';
    '90befffa23631e28'; 'a4506cebde82bde9'; 'bef9a3f7b2c67915'; 'c67178f2e372532b';
    'ca273eceea26619c'; 'd186b8c721c0c207'; 'eada7dd6cde0eb1e'; 'f57d4f7fee6ed178';
    '06f067aa72176fba'; '0a637dc5a2c898a6'; '113f9804bef90dae'; '1b710b35131c471b';
    '28db77f523047d84'; '32caab7b40c72493'; '3c9ebe0a15c9bebc'; '431d67c49c100d4c';
    '4cc5d4becb3e42b6'; '597f299cfc657e2a'; '5fcb6fab3ad6faec'; '6c44198c4a475817'];
H=[
    '6a09e667f3bcc908';
    'bb67ae8584caa73b';
    '3c6ef372fe94f82b';
    'a54ff53a5f1d36f1';
    '510e527fade682d1';
    '9b05688c2b3e6c1f';
    '1f83d9abfb41bd6b';
    '5be0cd19137e2179'];
%
% Input data to be hushed
%
input_str='abc';
%
%
str_leng = length(input_str);
Nr = mod(str_leng, 128);
if Nr <= 111
    N = floor(str_leng/128) + 1;
else
    N = floor(str_leng/128) + 2;
end
%
w = char();
for i = 1 : str_leng
    w = strcat(w, dec2hex(uint8(double(input_str(i))), 2));
end
w = strcat(w, dec2hex(uint8(128), 2));
w = strcat(w, dec2hex(8*str_leng, 2*(128*N - str_leng - 1)));
%
% parse the message
%
ww = char();
for in = 1 : N
    ww(in, :) = w((in-1)*256 + 1 : in*256);
end
%
% outer round for N block
%
W = char();
for in = 1 : N
    %
    % internal round for single 1024 bits block
    %
    for iw = 1 : 16
        W(iw, :) = ww(in, (iw-1)*16 + 1 : iw*16);
    end
    %
    %
    for iw = 17 : 80
        sigma1512=bitxor_64(bitxor_64(bitshift_circular_right_64(W(iw-2,:),19),bitshift_circular_right_64(W(iw-2,:),61)),bitshift_right_64(W(iw-2,:),6));
        sigma0512=bitxor_64(bitxor_64(bitshift_circular_right_64(W(iw-15,:),1),bitshift_circular_right_64(W(iw-15,:),8)),bitshift_right_64(W(iw-15,:),7));
        W(iw,:)=mod_add_64(mod_add_64(mod_add_64(sigma1512,W(iw-7,:)),sigma0512),W(iw-16,:));
    end
    %
    %
    a=H(1,:);
    b=H(2,:);
    c=H(3,:);
    d=H(4,:);
    e=H(5,:);
    f=H(6,:);
    g=H(7,:);
    h=H(8,:);
    %
    %
    for iround=1:80
        chefg=bitxor_64(bitand_64(e,f),bitand_64(bitcmp_64(e),g));
        sigmae=bitxor_64(bitxor_64(bitshift_circular_right_64(e,14),bitshift_circular_right_64(e,18)),bitshift_circular_right_64(e,41));
        sigmaa=bitxor_64(bitxor_64(bitshift_circular_right_64(a,28),bitshift_circular_right_64(a,34)),bitshift_circular_right_64(a,39));
        majabc=bitxor_64(bitxor_64(bitand_64(a,b),bitand_64(a,c)),bitand_64(b,c));
        T1=mod_add_64(mod_add_64(mod_add_64(mod_add_64(h,chefg),sigmae),W(iround,:)),KT(iround,:));
        T2=mod_add_64(sigmaa,majabc);
        h=g;
        g=f;
        f=e;
        e=mod_add_64(d,T1);
        d=c;
        c=b;
        b=a;
        a=mod_add_64(T1,T2);    
        %
        %
    end
    H(1, :) = mod_add_64(a, H(1, :));
    H(2, :) = mod_add_64(b, H(2, :));
    H(3, :) = mod_add_64(c, H(3, :));
    H(4, :) = mod_add_64(d, H(4, :));
    H(5, :) = mod_add_64(e, H(5, :));
    H(6, :) = mod_add_64(f, H(6, :));
    H(7, :) = mod_add_64(g, H(7, :));
    H(8, :) = mod_add_64(h, H(8, :));
end
%
%
HASH = H(1, :); 
for i = 2 : 8
    HASH = strcat(HASH, H(i, :));
end
fprintf('\n Input string is: %s\n', input_str);
fprintf('\n HASH value is:   %s\n', HASH);
