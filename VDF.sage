from time import process_time_ns
import argparse

load("setup.sage")
load("eval.sage")
load("verify.sage")
load('util.sage')
proof.arithmetic(False)# Speeds things up in Sage


parser = argparse.ArgumentParser()
parser.add_argument("-lambda", "--lam", help="Security level", type=int, default=32)
parser.add_argument("-t", "--time", help="Desired puzzle complexities",type=str, default='2^6')
parser.add_argument("-a", "--attempts", help="How many attempts the algorithm should try to find a smoother solution",type=int, default=1)
args = parser.parse_args()

lam = args.lam
t = int(sage_eval(args.time))
attempts = args.attempts
 
# SETUP
p,b,N_list,l,j = Setup(lam,t,attempts)

# EVALUATE
P1,Q1,P1p,Q1p,E1,E1p = Eval(p,b,l,j)

# VERIFICATION
Verify(j,P1,Q1,P1p,Q1p,E1,E1p,p,b,N_list,l)

