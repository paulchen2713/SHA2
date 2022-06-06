%
% SHA256 function
%
function HASH = SHA256_func(input_str)

K256 = ['428a2f98'; '71374491'; 'b5c0fbcf'; 'e9b5dba5'; '3956c25b'; '59f111f1'; '923f82a4'; 'ab1c5ed5';
        'd807aa98'; '12835b01'; '243185be'; '550c7dc3'; '72be5d74'; '80deb1fe'; '9bdc06a7'; 'c19bf174';
        'e49b69c1'; 'efbe4786'; '0fc19dc6'; '240ca1cc'; '2de92c6f'; '4a7484aa'; '5cb0a9dc'; '76f988da';
        '983e5152'; 'a831c66d'; 'b00327c8'; 'bf597fc7'; 'c6e00bf3'; 'd5a79147'; '06ca6351'; '14292967';
        '27b70a85'; '2e1b2138'; '4d2c6dfc'; '53380d13'; '650a7354'; '766a0abb'; '81c2c92e'; '92722c85';
        'a2bfe8a1'; 'a81a664b'; 'c24b8b70'; 'c76c51a3'; 'd192e819'; 'd6990624'; 'f40e3585'; '106aa070';
        '19a4c116'; '1e376c08'; '2748774c'; '34b0bcb5'; '391c0cb3'; '4ed8aa4a'; '5b9cca4f'; '682e6ff3';
        '748f82ee'; '78a5636f'; '84c87814'; '8cc70208'; '90befffa'; 'a4506ceb'; 'bef9a3f7'; 'c67178f2'];
H256 = ['6a09e667'; 'bb67ae85'; '3c6ef372'; 'a54ff53a'; '510e527f'; '9b05688c'; '1f83d9ab'; '5be0cd19'];
%
K = hex2dec(K256);
H = hex2dec(H256);
%
% input the data to be hashed from the user input
%
% input_str = ''; % plaintext data type
% 
% 6.2.1 Preprocessing
%
% 2.1 padding
%
str_len = length(input_str);
Nr = mod(str_len, 64);
if Nr <= 55
    N = floor(str_len / 64) + 1;
else
    N = floor(str_len / 64) + 2;
end
%
% convert the input_string into hexdecimal char
w = char();
for i = 1 : str_len
    w = strcat(w, dec2hex(double(input_str(i)), 2));
end
w = strcat(w, dec2hex(128, 2));
w = strcat(w, dec2hex(8*str_len, 2*(64*N - str_len - 1))); % num of hexdec text
%
% 2.2 parsing
%
ww = char();
for i = 1 : N
    % divide w into sets, each set contain 128 bits, and stored in ww
    ww(i, :) = w((i-1)*128 + 1 : i*128);
end
%
% 6.2.2 Hash Computation, outer rounds for N blocks
%
for i = 1 : N
    % 1. Prepare the message schedule
    %
    % divide into 16 sections, store as a vector in W
    W = zeros(64, 1);
    for iw = 1 : 16
        % catch 8 bits each time
        W(iw) = hex2dec(ww(i, (iw-1)*8 + 1 : iw*8));
    end
    % 
    for iw = 17 : 64
        s11 = bitshift_circular_right(W(iw-2), 17);
        s12 = bitshift_circular_right(W(iw-2), 19);
        s13 = bitshift(W(iw-2), -10); % shift right is "-"
        sigma1 = bitxor(bitxor(s11, s12), s13);
        
        s01 = bitshift_circular_right(W(iw-15), 7);
        s02 = bitshift_circular_right(W(iw-15), 18);
        s03 = bitshift(W(iw-15), -3); % shift right is "-"
        sigma0 = bitxor(bitxor(s01, s02), s03);
        
        W(iw) = mod(sigma1 + W(iw-7) + sigma0 + W(iw-16), 2^32);
    end
    % 2. Initialize the 8 working variables
    a = H(1);
    b = H(2);
    c = H(3);
    d = H(4);
    e = H(5);
    f = H(6);
    g = H(7);
    h = H(8);
    % 3.
    for ir = 1 : 64
        % first, compute the complex variables required for the computation
        %
        % bitcmp: bit compliment operation
        chefg = bitxor(bitand(e, f), bitand(double(bitcmp(uint32(e))), g)); % Ch(e, f, g)
        
        se1 = bitshift_circular_right(e, 6);
        se2 = bitshift_circular_right(e, 11);
        se3 = bitshift_circular_right(e, 25);
        sigmae = bitxor(bitxor(se1, se2), se3); % sigma(e)
        
        sa1 = bitshift_circular_right(a, 2);
        sa2 = bitshift_circular_right(a, 13);
        sa3 = bitshift_circular_right(a, 22);
        sigmaa = bitxor(bitxor(sa1, sa2), sa3); % sigma(a)
        
        majabc = bitxor(bitxor(bitand(a, b), bitand(a, c)), bitand(b, c)); % Maj(a, b, c)
        %
        % then, perform the computation
        T1 = mod(h + sigmae + chefg + K(ir) + W(ir), 2^32);
        T2 = mod(sigmaa + majabc, 2^32);
        h = g;
        g = f;
        f = e;
        e = mod(d + T1, 2^32);
        d = c;
        c = b;
        b = a;
        a = mod(T1 + T2, 2^32);
    end
    % 4. Compute the i-th intermediate hash value H(i)
    H(1) = mod(a + H(1), 2^32);
    H(2) = mod(b + H(2), 2^32);
    H(3) = mod(c + H(3), 2^32);
    H(4) = mod(d + H(4), 2^32);
    H(5) = mod(e + H(5), 2^32);
    H(6) = mod(f + H(6), 2^32);
    H(7) = mod(g + H(7), 2^32);
    H(8) = mod(h + H(8), 2^32);
end
% 
% message digest
%
H = dec2hex(H, 8); % 8 hexdec
HASH = H(1, :);
for i = 2 : 8
    HASH = strcat(HASH, H(i, :));
end
HASH = lower(HASH); % capital hex convert to lower case

return
