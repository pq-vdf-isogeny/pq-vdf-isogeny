import time
import sage.parallel.multiprocessing_sage
load('richelot_aux.sage')
load('montgomery.sage')
proof.arithmetic(False)# Speeds things up in Sage
import collections

PARALLEL_CPUS = 4

def Eval(p,b,l,j):

    @parallel(PARALLEL_CPUS)
    def compute_isogeny(x,Fp,K,A,cofactor,l,P0,Q0):
        # working with x-only coordinate
        M = [x,1]
        Q = montgomery_ladder(M,cofactor,A)   

        KerPolyP = KerpolyFromPoint(Q,l,A).change_ring(Fp).change_ring(K)
        E0_Fp2 = E0.change_ring(K)
        phiP = E0_Fp2.isogeny(KerPolyP)
        E1 = phiP.codomain()
        P1 = phiP(P0); 
        Q1 = phiP(Q0)
        return E1.j_invariant(),P1,Q1

    def KerpolyFromPoint(P,n,A):
        xs = []
        Q = P
        for i in range(n//2):
            xs.append(Q)
            Q  =  montgomery_ladder([P,1],i+2,A)  
        R.<X> = Fpk[]
        poly = prod(X-x for x in xs)
        return poly

    def montgomery_ladder(P,n,A):
        C = (A+2)/4
        Q = mmul(P,n,C)
        return Q[0]/Q[1]
        
    Fp = GF(p)
    Fpx.<x> = Fp[]
    k = int((l-1)/2)
    _.<I> = GF(p)[]
    K.<i> = GF(p^2, modulus=I^2+1)
    Fpk.<a> = GF(p^k, x^k+2)

    # internally working with montgomery curves
    A = montgomery_coefficient(EllipticCurve_from_j(Fp(j)),p)
    E0 = montgomery_curve(A,p)
    P0,Q0 =  gen2b(E0, b)
    cofactor = (p^k+1)//l

    t0 = time.time()

    inputs = []
    for _ in range(PARALLEL_CPUS):  
        x = Fpk.random_element()
        inputs.append((x,Fp,K,A,cofactor,l,P0,Q0))        

    results = list(compute_isogeny(inputs))
    result_dict = {}

    for result in results:
        (_, f_output) = result
        result_dict[f_output[0]] = f_output

    # asserting both directions has been computed
    assert len(result_dict) == 2

    # respect lexicography
    result_dict = collections.OrderedDict(sorted(result_dict.items()))

    for i,key in enumerate(result_dict):
        if i == 0:
            E1,P1,Q1 = result_dict[key]
        else:
            E1p,P1p,Q1p = result_dict[key]

    assert E1 != E1p

    t1 = time.time()
    print("Eval took %0.2fs" % (t1 - t0))
    return P1,Q1,P1p,Q1p,E1,E1p

