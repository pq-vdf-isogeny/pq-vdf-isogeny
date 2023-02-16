## QIWI (Quantum-resistant Isogeny-based Weak Iterative Verifiable Delay Function)

### Usage

```shell
cd code
sage VDF.sage -h
usage: VDF.sage.py [-h] [-lambda LAM] [-t TIME] [-a ATTEMPTS]

options:
  -h, --help            show this help message and exit
  -lambda LAM, --lam LAM
                        Security level
  -t TIME, --time TIME  Desired puzzle complexities
  -a ATTEMPTS, --attempts ATTEMPTS
                        How many attempts the algorithm should try to find a smoother solution
```

### Example

```shell
sage VDF.sage -lambda 64 -t 2^8
setup took 0.03s
This is the prime p
276597292449876995672594681154659942399
The bit size of p is 128
This is the factorisation of N
[[3, 3], [5, 2], [17, 2], [43, 1]]
This is b: 23
This is ell: 383
The bit size of ell is 9
Eval took 210.67s
verify offline took 0.06s
verify online took 0.35s
total verify took 0.42s
```

## Credits

The `richelot_aux.sage` has been copied from [Giacomo Pope](https://github.com/jack4818/Castryck-Decru-SageMath)'s sage implementation of the [Castryck-Decru's attack](https://eprint.iacr.org/2022/975.pdf).

The `montgomery.sage` has been copied from Daniil Kliuev and Andrew Sutherland's [lectures](https://sage.sagemath.org/share/public_paths/eb6864a672ce55b641f57b6ea6efdbe7596199a6)
