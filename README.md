# Strange-Patterns-
Cool patterns created through FFT.

I discovered them when I broke my code accidently while simulating OFDM :P


This is how it works:
1) QAM symbols are generated.

2) A seed is provided by user.

3) IFFT is taken over the seed.

4) Multiplying seed_ifft with QAM symbols generates cool and symmetric patterns.

5) What is happening? Well multiplication in freqency domian translates to convolution in time domain. So the seed is the actual pattern and is replicated over spacce
   when multiplication happens. Try experimenting with seeds and it generates new patterns.
   
Thanks :D
Ish Kool.
