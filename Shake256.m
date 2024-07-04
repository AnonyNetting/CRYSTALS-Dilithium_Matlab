function Z = Shake256(m,d)
B=[m,1,1,1,1];
Z=SPONGE256(B,d);
end
