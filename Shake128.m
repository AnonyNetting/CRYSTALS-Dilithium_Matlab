% function stream = Shake256(m,d)
% %m= any length byte array or character array, d=2^n (n=positive integer) number of output bytes
% %David Hill
% %7 January 2020
% %Version 1.0.1
% if ischar(m)
%     m=unicode2native(m,'UTF-8');
% end
% N=flip(dec2bin(m,8)');%converts byte array (0-255) to binary array
% B=[N(:)'-'0',1,1,1,1];%appends 1,1,1,1 to message for shake
% Z=SPONGE(B,d);
% stream=dec2hex(bin2dec(flip(reshape(char(Z+'0'),8,''))'))';%converts binary digest to hex
% stream=lower(stream(:)');
% end

function Z = Shake128(m,d)
%m= any length byte array or character array, d=2^n (n=positive integer) number of output bytes
%David Hill
%7 January 2020
%Version 1.0.1
% if ischar(m)
%     m=unicode2native(m,'UTF-8');
% end
% N=flip(dec2bin(m,8)');%converts byte array (0-255) to binary array
B=[m,1,1,1,1];%appends 1,1,1,1 to message for shake
Z=SPONGE128(B,d);
%stream=dec2hex(bin2dec(flip(reshape(char(Z+'0'),8,''))'))';%converts binary digest to hex
%stream=lower(stream(:)');
end