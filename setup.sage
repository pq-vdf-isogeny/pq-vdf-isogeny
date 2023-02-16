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
            return p
    return None

def gen_B_smooth_odd_primes(B):
    """
    outputs the list of odd primes smaller than B
    """
    B_smooth_odd_primes = [3]
    p = 3
    while p < B:
        p = next_prime(p)
        B_smooth_odd_primes.append(p)
    return B_smooth_odd_primes

def max_power(n,m):
    """
    exctracts maximal power of m in n
    """
    if n%m != 0:
        return 0
    exp = 1
    n = n//m
    while n%m == 0:
        n = n//m
        exp += 1
    return exp
    
def fast_special_factorisation(B_smooth_odd_primes, N):
    """
    outputs the factorisation of N if N is B-smooth
    """
    factorisation = []
    for q in B_smooth_odd_primes:
        mpow = max_power(N,q)
        if mpow != 0:
            N = N//(q^mpow)
            aux = [q,mpow]
            factorisation.append(aux)
    if N == 1:
        return factorisation
    else:
        return False 
    
def finding_N_b(lam,t,attempts = None):
    """
    given a security parameter lam and a desired puzzle complexity t,
    outputs b, ell, and the factorisation of N s.t. 2^b = N + ell, ell is a safe
    prime having the same bit-size of t, N is lam^2 smooth, and b>lam/3.
    One could also declare how many attempts the algorithm should try to find a smoother
    solution
    """
    if attempts== None:
        attempts = 0
        
    def aux(lam,t, lam_smooth_odd_primes):
        ell = finding_safe_primes(t)
        lower_bound = ceil(lam/3)
        while 2^lower_bound < ell:
            lower_bound +=1

        for b in range(lower_bound, lam):
            factorisation  = fast_special_factorisation(lam_smooth_odd_primes, 2^b - ell)
            if factorisation != False:
                return b, ell, factorisation
        return False
    
    lam_smooth_odd_primes = gen_B_smooth_odd_primes(lam^2)
    output1 = aux(lam,t, lam_smooth_odd_primes)
    while output1 == False:
        output1 = aux(lam,t, lam_smooth_odd_primes)
        
    biggest_prime_factor = output1[2][-1][0]
    for _ in range(0,attempts):
        output2 = aux(lam,t, lam_smooth_odd_primes)
        if output2 != False:
            new_factor = output2[2][-1][0]
            if new_factor < biggest_prime_factor:
                biggest_prime_factor = new_factor
                output1 = output2
    return output1
    
def Setup(lam, t, attempts = None):
    """
    given a security parameter lam and a desired puzzle complexity t,
    outputs f,b,ell,N veryfing the conditions in the paper.
    One could also declare how many attempts the algorithm should try to find a smoother
    solution
    """
    
    def conditions(f,b,ell):
        """
        executes the checks in the paper.
        """
        k = (ell-1)//2
        p = 2^b*f*(2^b-ell) - 1

        if -p % ell == 0:
            return False

        # -p has order k in F^*_ell
        order = Mod(-p,ell).multiplicative_order()
        if order!= k:
            return False
        
        # other checks
        a = 2.powermod((p-1)//k,p)
        if is_prime(p) and kronecker(-p,ell) == 1 and a!=1 :
            return True
        else:
            return False

    t0  = time.time()     
    b,ell, N_list = finding_N_b(lam,t,attempts)

    N = 1
    for q in N_list:
        N *= q[0]^q[1]
    k = (ell-1)//2

    # p%k==1
    x0 = ZZ(inverse_mod(2^(b-1)*(2^b-1),k))
    s_exp = 2*lam - b - ceil(log(N,2)) - ceil(log(k,2))
    s_exp_0, s_exp_1 = 2^s_exp, 2^(s_exp+1)-1
    s = randint(s_exp_0, s_exp_1)
    f = x0+s*k

    while not conditions(f,b,ell):
        s = randint(s_exp_0, s_exp_1)
        f = x0+s*k 
    
    p = reconstructing_p(f,b,N_list)


    E0 = EllipticCurve(GF(p), [1, 0])
    # random walk to simulate a trusted setup
    E0 = E0.isogenies_prime_degree(3)[0].codomain()
    j = E0.j_invariant()
    t1  = time.time()
    
    print("setup took %0.2fs" % (t1 - t0))
    print("This is the prime p")
    print(p)
    print(f"The bit size of p is {ceil(log(p,2))}")
    print("This is the factorisation of N")
    print(N_list)
    print(f"This is b: {b}")
    print(f"This is ell: {ell}")
    print(f"The bit size of ell is {ceil(log(ell,2))}")

    return p, b, N_list, ell, j
    
def reconstructing_p(f,b,N_list):
    N = 1
    for q in N_list:
        N *= q[0]^q[1]
    p = 2^b * f * N -1
    assert is_prime(p)
    return p 
