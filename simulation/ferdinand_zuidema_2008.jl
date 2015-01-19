import Distributions:wsample


function bayes_rule(prior, llh)
    posterior = exp(prior + llh)
    return posterior / sum(posterior)
end


function simulate(;MAP=true, N_sam=1, N_gen=10000,
                   priors=[.8 .1 .1; .1 .1 .8],
                   H=[.6 .2 .2; .2 .6 .2; .2 .2 .6])

    # Julia version of Ferdinand & Zuidema (2008) Appendix A
    # wrapped in a function, cleaned up code a little

    h_row, h_col = size(H)
    p_row, p_col = size(priors)
    @assert p_col == h_row

    N_pop = p_row # number of populations
    N_hyp = h_row # number of hypotheses
    N_dat = h_col # number of data points seen
    N_sampop = N_sam * N_pop # number of samples, agents per population

    # keep track of the history
    posterior_history = zeros(N_gen, N_pop, N_hyp)
    hypotheses_history = zeros(N_gen, N_pop)
    hyphist = zeros(N_pop, N_hyp)
    hyphistnorm = zeros(N_pop, N_hyp)

    posterior = zeros(N_pop, N_hyp)
    agents_posterior = zeros(N_pop, N_hyp)
    agents_hypothesis = zeros(N_pop, 1)
    posterior_mean = zeros(N_pop, N_hyp)

    # priors over hypotheses over populations
    priors = log(priors)

    # ~ likelihood of data points under each hypothesis
    hypotheses = log(H)

    # initial data, uniform[1, 3]
    data = rand(1:N_dat, (1, N_sampop))

    # for each generation
    for generation in 1:N_gen

        # for each population
        for i in 1:N_pop
            likelihood = zeros(1, N_hyp) # reset the likelihood

            # for each sample per population per generation
            for j in 1:N_sampop
                likelihood += hypotheses[:, data[j]]' # hypotheses are the likelihoods
            end

            agents_posterior[i, :] = bayes_rule(priors[i, :], likelihood)
            posterior_history[generation, :, :] = agents_posterior
            posterior_mean[i, :] = sum(posterior_history[:, i, :]) ./ N_gen

            if MAP
                ############################
                post = agents_posterior[i, :]
                value = maximum(post)
                pos = findin(post, value)
                s = size(pos)[1]

                # if there is more than one maximum, choose randomly between them
                if s > 1
                    pos = pos[rand(1:s, 1)]
                end

                agents_hypothesis[i, :] = pos[1]
                hypotheses_history[generation, i] = pos[1]
                ####################################
            else # Sampling
                ############################
                weights = agents_posterior[i, :]'
                agents_hypothesis[i] = wsample(1:N_hyp, collect(weights), N_sam)[1]
                hypotheses_history[generation, i] = agents_hypothesis[i]
                ####################################
            end
        end

        # generate data
        for i in 1:N_pop
            weights = exp(hypotheses[agents_hypothesis[i], :])
            data[i] = wsample(1:N_dat, collect(weights), N_sam)[1]
        end
    end

    # create hypotheses history
    for pop in 1:N_pop
        for h in 1:N_hyp
            for g in 1:N_gen
                if hypotheses_history[g, pop] == h
                    hyphist[pop, h] += 1
                end
            end
        end
    end

    for i in 1:N_pop
        hyphistnorm[i, :] = hyphist[i, :] ./ sum(hyphist[i, :])
    end

    return hyphistnorm
end


# simulate effect of bottleneck size (for canonical hypotheses only)
function simulate_bottlenecks(;MAP=true, bottlenecks=[1:10])

    result = zeros(length(bottlenecks), 3)
    prior = [1/3 1/3 1/3] # 1 prior => 1 agent per population
    hypotheses = [.6 .2 .2; .2 .6 .2; .2 .2 .6] # 3 elements each => 3 possible data points 

    for (i, b) in enumerate(bottlenecks)
        result[i, :] = simulate(priors = prior, H = hypotheses, N_sam = b)
    end

    return result
end


# simulate effect of multiple agents in a population
function simulate_population(;MAP=true)

    result = ones(5, 3)
    one_agent = [.7 .2 .1]
    two_agents = [.7 .2 .1; .7 .2 .1]
    hypotheses = [.8 .1 .1; .1 .8 .1; .1 .1 .8]
    # bottleneck = 3, number per generation = 10.000

    # MAP
    result[2, :] = simulate(priors = one_agent, H = hypotheses)
    result[3, :] = mean(simulate(priors = two_agents, H = hypotheses), 1)

    # Sampling
    result[4, :] = simulate(priors = one_agent, H = hypotheses, MAP=false)
    result[5, :] = mean(simulate(priors = two_agents, H = hypotheses, MAP=false), 1)

    # prior
    result[1, :] = one_agent

    return result
end
