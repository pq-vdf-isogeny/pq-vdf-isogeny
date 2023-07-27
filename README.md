## Towards a Quantum-resistant weak Verifiable Delay Function

### Usage

```shell
cd code
sage VDF.sage -h
usage: VDF.sage.py [-h] [-lambda LAM] [-mu MU] [-t TIME]

options:
  -h, --help            show this help message and exit
  -lambda LAM, --lam LAM
                        Security level
  -mu MU, --mu MU       Desired prime size
  -t TIME, --time TIME  Desired puzzle complexities
```

**N.B. The p used in the default parameters (256 bits) should be considered as a proof-of-concept and does not meet the security requirements.**

### Example

```shell
cd code
sage VDF.sage
================================================================================
                                setup took 0.31s                                
================================================================================
This is the prime p
98916547462675857730728019590977746685253628202140706481738446990151883161599
The bit size of p is 256
This is b: 35
This is ell: 167
This is c 14273
This is d 18405
The bit size of ell is 8
================================================================================
                                Eval took 62.30s                                
================================================================================
================================================================================
                            total verify took 3.63s                             
================================================================================
```

**Note:** the above output was generated running on an Apple M1 CPU clocked at 3.20 GHz using SageMath version 9.8

## Credits

The `richelot_aux.sage` has been copied from [Giacomo Pope](https://github.com/jack4818/Castryck-Decru-SageMath)'s sage implementation of the [Castryck-Decru's attack](https://eprint.iacr.org/2022/975.pdf).

The `montgomery.sage` has been copied from Daniil Kliuev and Andrew Sutherland's [lectures](https://sage.sagemath.org/share/public_paths/eb6864a672ce55b641f57b6ea6efdbe7596199a6)
