import time
load('richelot_aux.sage')
proof.arithmetic(False)# Speeds things up in Sage

def gen_point_order_q(E, n, order):
    """
    generates a point of prescribed order, if there exists any 
    """
    G = E.random_point()
    G =  (order//n) *G
    while G.is_zero() :
        G = (order//n) * E.random_point()
    return G

def PushingNIsogeny(E, order, n, P,Q):
    """
    Given an elliptic curve E over Fp, its order over Fp, 
    the degree n of the isogeny we would like to compute, and the points P and Q
    to map under the isogeny, it outputs an Fp-rational isogeny defined over Fp2
    """
    _.<I> = GF(p)[]
    K.<i> = GF(p^2, modulus=I^2+1)
    E_ext = E.change_ring(K)
    G = gen_point_order_q(E, n, order)
    H = E_ext(G)
    phi = E_ext.isogeny(H)
    return phi.codomain(),phi(P),phi(Q)

def Verify(E0,P1,Q1,P1p,Q1p,E1,E1p,p,b,N_list,l):
    t0 = time.time()

    assert E1 < E1p

    # internally working with montgomery curves
    Fp = GF(p)
    A = montgomery_coefficient(EllipticCurve_from_j(Fp(j)),p)
    E0 = montgomery_curve(A,p)
    P0,Q0 =  gen2b(E0, b)
    P2,Q2 = P0, Q0
    E2 = E0
    
    # pushing rational isogeny
    t0off = time.time()
    for factor in N_list:
        for _ in range (factor[1]):
            E2, P2,Q2 = PushingNIsogeny(E2, p+1, factor[0], P2,Q2)

    assert E2 != E0

    x = 1
    for q in N_list:
        x *= q[0]^q[1]
    t1off = time.time()
    print("verify offline took %0.2fs" % (t1off - t0off))

    t0on = time.time()
    assert Does22ChainSplit(E2, l*P2,  l*Q2, x*P1, x*Q1, b)
    assert Does22ChainSplit(E2, l*P2,  l*Q2, x*P1p, x*Q1p, b)
    t1on = time.time()
    print("verify online took %0.2fs" % (t1on - t0on))
    t1 = time.time()
    print("total verify took %0.2fs" % (t1 - t0))
