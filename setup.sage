load('util.sage')

def is_safe_prime(p):
    """
    checks that a number p is a safe prime, i.e.
    p is prime and (p-1)/2 is prime as well
    """
    if is_prime(p) and p>3:
        return ((p-1)//2).is_prime()
    else:
        return False
    
def finding_safe_primes(t):
    """
    outputs a safe prime having the same bit-size of t
    """
    while True:
        p = randint(t,2*t)
        if is_safe_prime(p):
            return ZZ(p)
    return None

def finding_safe_prime(t, b = None):
    """
    outputs a safe prime ell such that there exist b, c
    and d veryfing c^2 * ell + d^2 == 2^b
    Optionally, you can put a lower bound on b
    """
    while True:
        ell = finding_safe_primes(t)
        QF = gp.Qfb(1, 0, ell)
        if b == None:
            b = ell.nbits() 
        for e in range(b,b+100):
            sol = QF.qfbsolve(2^e)
            if sol:
                d, c = list(map(ZZ, sol))
                c, d = abs(c), abs(d)
                assert 2**e == c^2*ell + d^2
                if d^2 > ell:
                    return ell, c, d, e
    
def Setup(lam, mu, t):
    """
    given a security parameters lam,mu and a desired puzzle complexity t,
    outputs f,b,ell,N veryfing the conditions in the paper.
    """

    def conditions(f,b,c,d,ell):
        """
        executes the checks in the paper.
        """
        p = 2^b*c*d*f - 1
        
        if not is_prime(p):
            return False
        if -p % ell == 0:
            return False

        # -p has order k in F^*_ell
        k = (ell-1)//2
        order = Mod(-p,ell).multiplicative_order()
        if order!= k:
            return False
        
        # other checks
        a = 2.powermod((p-1)//k,p)
        if kronecker(-p,ell) == 1 and a!=1 :
            return True
        else:
            return False

    t0  = time.time()  

    ell, c, d, b = finding_safe_prime(t, lam)

    # p%k==1

    f_size = mu - b - len(c.str(2)) - len(d.str(2))
    f = randint(2^f_size ,2^(f_size +1))
 

    while not conditions(f,b,c,d,ell):
        f = randint(2^f_size ,2^(f_size +1))
    
    p = 2^b*c*d*f - 1

    E0 = EllipticCurve(GF(p), [1, 0])
    # random walk to simulate a trusted setup
    E0 = E0.isogenies_prime_degree(3)[0].codomain()
    j = E0.j_invariant()
    t1  = time.time()
    
    print_info("setup took %0.2fs" % (t1 - t0))
    print("This is the prime p")
    print(p)
    print(f"The bit size of p is {ceil(log(p,2))}")
    print(f"This is b: {b}")
    print(f"This is ell: {ell}")
    print(f"This is c {c}")
    print(f"This is d {d}")
    print(f"The bit size of ell is {ceil(log(ell,2))}")

    return p, b, ell, c, d, j
