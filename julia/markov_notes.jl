"""
Short summary on (finite) Markov Chains as relevant for the simulation.
Drawn from:

- Griffiths & Kalish (2007, pp.447)¹ 
- http://quant-econ.net/jl/finite_markov.html
- http://www.math.wisc.edu/~valko/courses/331/MC1.pdf [exercises]
- http://www.math.wisc.edu/~valko/courses/331/MC2.pdf

¹ http://onlinelibrary.wiley.com/doi/10.1080/15326900701326576/full

===========================

MC ~ sequence of random variables t_0, ... t_n such that

P(t_n|t_0, ... t_i) = P(t_n|t_n-1)

thus the condition distribution of the future state t_n+1 depends only
on the present state t_n and is independent of the past states t_0, ... t_n-1

transition matrix T = (t_ij) such that

t_ij = P(t_n = i|t_n-1 = j)

example:
   state space S = {0, 1} with k = 2 members, where 0 equals rain, 1 equals no rain

   P(t_n = 0|t_n-1 = 0) = \alpha = .7
   P(t_n = 0|t_n-1 = 1) = \beta = .3

   p_0 is a vector encoding the initial state (rain / no rain)

   marginal distribution of state i given initial probabilities p_0
   P(t_1 = i|p_0) = ∑P(t_1 = i|t_0 = j)P(t_1 = j|p_0)  [for all j]

   which yields ∑t_ij * p_0j [for all j in S]

   writing P(t_1 = i|p_1), P(t_2 = i|p_2), ... p(t_n =|p_n) as p_n we get

   p_1 = Tp_0
   p_2 = Tp_1
   p_n = T^n p_0
"""

# 1) exercise, rain
α = .7
β = .3

p_0 = [.5, .5]
T = [α 1-α
     β 1-β]

p_1 = T*p_0
p_4 = T^4*p_0

# 2) exercise, urns
U = [ 0   1   0   0
     1/9 4/9 4/9  0
      0  4/9 4/9 1/9
      0   0   1   0]

"""
the stationary distribution describes the asymptotic behavior of a markov chain

    π = Tπ

once reached, the probability of being in a particular state will remain constant

lim T^n p_0 = π
(n -> inf)

regardless of the initial state, as n becomes large, the distribution over states
will approach the stationary distribution

However, there might be more stationary distributions. In fact, if T is the identity
matrix, then all distributions are stationary!

one sufficient condition for uniqueness is ergodicity (see below)
when a markov chain is ergodic, the first eigenvector of T yields the stationary distribution

#================
some properties:

-- homogenous ~ P(t_n|t_n-1) is constant for all values of n (T fully describes MC)
-- regular ~ some power of MC's transition matrix has only positive entries
-- irreducible ~ can get from every state to every state with positive probability
-- ergodic ~ irreducible + aperiodic [is ergodic iff it has just one eigenvalue of value 1]
   uniformly ergodic if there exists a positive integer m such that all elements of T^m are strictly
   positive
"""
