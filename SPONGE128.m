function Z = SPONGE128(N,d)
%Sponge construction uses the KECCAK function as the underlying function
%that works on a fixed-length binary vector. A parameter called the rate
%(r) is fixed for Shake256. Sponge construction
%also uses a padding rule (pad function) to generate the proper
%fixed-length binary vector. Each set of r-bits of the padded message is
%XORed with the first r-bits of the returned fixed-length binary vector and
%the last c-bits (c=b-r) are passed through.
r=1344;%only for SHAKE256 r=1344 for SHAKE128
P=[N,pad(r,length(N))];%padding message
n=length(P)/r;
S=zeros(1,1600);
Z=[];
%absorbing ...
for i=1:n
    S=KECCAK([bitxor(S(1:r),P((i-1)*r+1:i*r)),S(r+1:end)]);
    %executes sponge function of XORed r-bit message input and nth r-bits 
    %of initial/returned vector array and last c-bits of initial/returned
    %vector array
end
%squeezing ...
d=8*d;
while d>length(Z)
    Z=[Z,S(1:r)];
    S=KECCAK(S);
end
Z=Z(1:d);%outputs digest of length d
end