import time
load('richelot_aux.sage')
proof.arithmetic(False)# Speeds things up in Sage

def Verify(E0,P1,Q1,P1p,Q1p,E1,E1p,p,b,c,d,l):
    t0 = time.time()

    assert E1.j_invariant() < E1p.j_invariant()
    Fp = GF(p)
    A = montgomery_coefficient(EllipticCurve_from_j(Fp(E0)),p)
    E0 = montgomery_curve(A,p)
    P0,Q0 =  gen2b(E0, b)
    _.<I> = GF(p)[]
    K.<i> = GF(p^2, modulus=I^2+1)
    E0_ext = E0.change_ring(K)
    assert Does22ChainSplit(E1,E0_ext, d*P1, d*Q1, (c*l)*P0, (c*l)*Q0, b,c,d)
    assert Does22ChainSplit(E1p,E0_ext, d*P1p, d*Q1p, (c*l)*P0, (c*l)*Q0, b,c,d)
    t1 = time.time()
    print_info("total verify took %0.2fs" % (t1 - t0))
