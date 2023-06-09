def base_torsion(E,N):  
    """
    deterministic algorithm that, on input
    a supersingular elliptic curve and a positive integer N, 
    outputs two generators of
    the N-torsion
    """
    p =  E.base_field().base().characteristic()
    cofactor = (p+1)//N
    _.<I> = GF(p)[]
    K.<i> = GF(p^2, modulus=I^2+1)
    E1 = E.change_ring(K)
    P1,Q1 = E1.gens()
    P1 = cofactor *P1
    Q1 = cofactor *Q1
    return P1,Q1

def gen2b(E,b):  
    """
    deterministic algorithm that, on input
    a supersingular elliptic curve and a positive integer b, 
    outputs two generators of
    the 2b-torsion
    """
    return base_torsion(E,2^b)

def montgomery_coefficient(E,p):
    Ew = E.change_ring(GF(p)).short_weierstrass_model()
    _, _, _, a, b = Ew.a_invariants()
    R.<z> = GF(p)[]
    r = (z**3 + a*z + b).roots(multiplicities=False)[0]
    s = sqrt(3 * r**2 + a)
    if not is_square(s): s = -s
    A = 3 * r / s
    assert montgomery_curve(A,p).change_ring(GF(p)).is_isomorphic(Ew)
    return GF(p)(A)

def montgomery_curve(A,p):
    return EllipticCurve(GF(p), [0, A, 0, 1, 0])

def print_info(str, banner="="):
    """
    Print information with a banner to help
    with visibility during debug printing
    """
    print(banner * 80)
    print(f"{str}".center(80))
    print(banner * 80)