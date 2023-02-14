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


## Credits

The `richelot_aux.sage` has been copied from [Giacomo Pope](https://github.com/jack4818/Castryck-Decru-SageMath)'s sage implementation of the [Castryck-Decru's attack](https://eprint.iacr.org/2022/975.pdf).

The `montgomery.sage` has been copied from Daniil Kliuev and Andrew Sutherland's [lectures](https://sage.sagemath.org/share/public_paths/eb6864a672ce55b641f57b6ea6efdbe7596199a6)
