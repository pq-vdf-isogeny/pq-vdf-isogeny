def madd(P,Q,R):
    """Montgomery addition: returns (x_{m+n},z_{m+n}) given P=(x_m,z_m), Q=(x_n,z_n), and R=(x_{m-n},z_{m-n})"""
    a = P[0]-P[1]; b=P[0]+P[1]; c=Q[0]-Q[1]; d=Q[0]+Q[1]
    e=a*d; f=b*c;
    return (R[1]*(e+f)^2,R[0]*(e-f)^2)

def mdbl(P,C):
    """Montgomery doubling: returns (x_{2n},z_{2n}) given P=(x_n,z_n) and C=(A+2)/4 where By^2=x^3+Ax^2+x is the Montgomery curve equation"""
    a=P[0]+P[1]; b=P[0]-P[1]
    c=a^2; d=b^2; e=c-d
    return (c*d,e*(d+C*e))
    
def mmul(P,n,C):
    """Montgomery multiplication: returns (x_n,z_n) given P=(x_1,z_1) and C=(A+2)/4 where By^2=x^3+Ax^2+x is the Montgomery curve equation"""
    Q = [P,mdbl(P,C)]
    b=n.digits(2)
    for i in range(len(b)-2,-1,-1):
        Q[1-b[i]] = madd(Q[1],Q[0],P)
        Q[b[i]] = mdbl(Q[b[i]],C)
    return Q[0]
