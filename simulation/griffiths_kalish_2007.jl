#=
Simple bayesian iterated learning with two languages from Griffiths and Kalish (2007, pp.447)

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

1) Sampling: posterior converges to the prior
2) MAP: more complex, but when .5 < α < 1-ϵ, directly depends on s and ϵ
=#
using PyPlot


function simulate(α, ϵ; n=10, s=.5, MAP=false)
    # α ~ prior; ϵ ~ noise
    # s ~ probability for both languages producing the same x

    if MAP
        R(x) = x == .5 ? .5 : x > .5 ? 1 : 0
        q_12 = s + (1 - s)*ϵ + R(ϵ*α / (ϵ*α + (1 - ϵ)*(1 - α))) * (1 - s)*(1 - ϵ)
        q_21 = R(ϵ*(1 - α) / (ϵ*(1 - α) + (1 - ϵ)*α)) * (1 - s)*(1 - ϵ)
    else
        q_12 = begin α*s +
            ((1 - ϵ)*α / ((1 - ϵ)*α + ϵ*(1 - α))) * (1 - s)*ϵ +
            (ϵ*α / (ϵ*α + (1 - ϵ)*(1 - α))) * (1 - s)*(1 - ϵ)
        end

        q_21 = begin (1 - α)*s +
            ((1 - ϵ)*(1 - α) / ((1 - α)*(1 - α) + ϵ*α)) * (1 - s)*ϵ +
            (ϵ*(1 - α) / (ϵ*(1 - α) + (1 - ϵ)*α)) * (1 - s)*(1 - ϵ)
        end
    end

    Q = [1-q_21 q_12
         q_21 1-q_12]

    inits = MAP ? [.5 .5] : [1 0]
    S = [inits; zeros(n, 2)]

    for i in 2:n+1
        S[i, :] = Q * S[i-1, :]'
    end

    return S
end

S1 = simulate(.6, .05) # more noise, doesn't converge as good (even when n is large)
S2 = simulate(.6, .001)
S3 = simulate(.6, .001; s=.2, MAP=true)
S4 = simulate(.6, .001; s=.8, MAP=true)

# plot both simulations
subplot(211)
plot(S1, marker="o")
plot(S2, marker="o", linestyle="dashed")
subplot(212)
plot(S3, marker="o")
plot(S4, marker="o", linestyle="dashed")
