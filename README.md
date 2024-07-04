# CRYSTALS-Dilithium_Matlab
Full security level implementation of CRYSTALS-Dilithium fit for FIPS204(https://doi.org/10.6028/NIST.FIPS.204.ipd) published on Aug2023.

## Reference Notice
The Keccak function in this project references open-source software developed by David Hill. The original copyright notice is as follows:

Copyright (c) 2020, David Hill
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution
* Neither the name of Brigham Young University nor the names of its
  contributors may be used to endorse or promote products derived from this
  software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


### Disclaimer

This project is provided "as is" without any express or implied warranties, including but not limited to, implied warranties of merchantability and fitness for a particular purpose.

## Necessary Toolbox
Signal Processing Toolbox

## How to use?
To edit the necessary inputs for the algorithm in the xxx_testcase.mlx file, execute it to obtain the corresponding outputs that meet the FIPS204 standard requirements.
For example, in KeyGen_testcase.mlx, make the following edits:

clear;  
seed = zeros(1,256); % seed  
security_level = 2; % 2 or 3 or 5  
[pk, sk] = KeyGen(seed, security_level);  
pk  
sk  
After execution, the public key (pk) and private key (sk) for CRYSTALS-Dilithium security-level 2 KeyGen with seed == 256'b0 will be obtained.

In this project, the bit order of all inputs and outputs corresponds to the FIPS204 standard requirements (lower bits on the left).

The result_transformer.mlx file provides the functionality to package all inputs and outputs into 4-bit groups and convert them into hexadecimal numbers, facilitating the observation of simulation results during hardware development (lower bits on the right).
