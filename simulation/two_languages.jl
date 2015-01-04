#=
Sampling from the posterior with two languages from Griffiths and Kalishs (2005, pp.447)

Terminology:
------------

- Q = transition matrix whose elements give the probability that a learner chooses
hypothesis i after seeing data generated from hypothesis j.

- Learning Algorithm, P_la = P(h|d)
- Producation Algorithm, P_pa = P(d|h = i)
- Bayes' Rule, P(h|d) = P_pa(d|h) * P(h) / P_pa(d)
- languages d: mapping from meanings x to utterances y (x, y)
- d = (x, y)
- h = probability distributions over y for each x


Example:
-------

2 languages, y can only be 1 or 0 (~ Quine's "Gavagai!")
need to specify a production algorithm and priors:

-- P_pa(d = (x, y)|h = i) = P(x)(1 - ϵ) iff correct else P(x)ϵ
-- P(h = 1) = α, P(h = 2) = 1 - α
=#

using PyPlot # Gaston / gnuplot doesn't work ...

s = .5 # probability for a (x, y) pair such that x is in S ~ both languages produce the same x

function simulate(α, ϵ; n=10)
    # α ~ prior; ϵ ~ noise

    q_12 =
    begin
        α*s +
        ((1 - ϵ)*α / ((1 - ϵ)*α + ϵ*(1 - α))) * (1 - s)*ϵ +
        (ϵ*α / (ϵ*α + (1 - ϵ)*(1 - α))) * (1 - s)*(1 - ϵ)
    end

    q_21 = 
    begin
        (1 - α)*s +
        ((1 - ϵ)*(1 - α) / ((1 - α)*(1 - α) + ϵ*α)) * (1 - s)*ϵ +
        (ϵ*(1 - α) / (ϵ*(1 - α) + (1 - ϵ)*α)) * (1 - s)*(1 - ϵ)
    end

    Q = [1-q_21 q_12
         q_21 1-q_12]

    init = [1 0] # initial conditions
    S = [init; zeros(n, 2)]

    for i in 2:n+1
        S[i, :] = Q * S[i-1, :]'
    end

    return S
end

S1 = simulate(.6, .05) # more noise, converges slower
S2 = simulate(.6, .001)

plot(S1, marker="o")
plot(S2, marker="o", linestyle="dashed")
