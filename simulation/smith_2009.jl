using Iterators
import Distributions:wsample


function bayes_rule(hypotheses, prior, data)
    llh_0 = *(hypotheses[1, :][data]...)
    llh_1 = *(hypotheses[2, :][data]...)
    return prior * llh_0 / (prior * llh_0 + (1 - prior) * llh_1)
end


function simulate(hypotheses, prior; n = 10)
    # unfinished, raw and wrong draft!

    res = zeros(n)
    data = [1, 1, 2]
    llh(h, i, d) = *(h[i, :][d]...)

    for i in 1:n
        pt = prior
        pt_next = 0.0

        # this doesn't make anysense!
        for d in collect(product(repeated(1:2, 3)...))
            d = collect(d)
            post = bayes_rule(hypotheses, pt, d)
            parens = pt * llh(hypotheses, 1, d) + (1 - pt) * llh(hypotheses, 2, d)
            pt_next += post * parens
        end

        res[i] = pt_next

        pt = pt_next
        hypotheses = [pt_next 1 - pt_next
                      1 - pt_next pt_next]

        data = wsample(1:2, collect(hypotheses[1, :]), 3)
    end

    return res
end
