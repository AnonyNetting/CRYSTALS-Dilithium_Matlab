function Z = SPONGE256(N,d)
r=1088;
P=[N,pad(r,length(N))];%padding message
n=length(P)/r;
S=zeros(1,1600);
Z=[];
for i=1:n
    S=KECCAK([bitxor(S(1:r),P((i-1)*r+1:i*r)),S(r+1:end)]);
end
d=8*d;
while d>length(Z)
    Z=[Z,S(1:r)];
    S=KECCAK(S);
end
Z=Z(1:d);
end
