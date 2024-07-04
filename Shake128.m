function Z = Shake128(m,d)
B=[m,1,1,1,1];
Z=SPONGE128(B,d);
end
