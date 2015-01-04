# Sampling from the posterior with two languages from Griffiths and Kalishs, 2005

using Gaston;

alpha = 0.6;		# Prior Probability
epsilon = 0.001;	# noise	
s = 0.5;			# probability of generating an (x, y) (input, output) pair such that x is in S (that is both languages produce the same utterance for x)

q_12 = alpha*s + ((1-epsilon)*alpha)/((1-alpha)*alpha+epsilon*(1-alpha)) * (1-s)*epsilon + (epsilon*alpha)/(epsilon*alpha+(1-epsilon)*(1-alpha)) * (1-s)*(1-epsilon);
q_21 = (1-alpha)*s + ((1-epsilon)*(1-alpha))/((1-alpha)*(1-alpha)+epsilon*alpha) * (1-s)*epsilon + (epsilon*(1-alpha))/(epsilon*(1-alpha)+(1-epsilon)*alpha) * (1-s)*(1-epsilon);

Q = [(1-q_21) q_12; q_21 (1-q_12)];	# transition matrix


n = 10;					# Iterationen
S = [1 0]				# start Bedingung
S = [S; zeros(n, 2)];	# Matrix mit Zustandswerten - Spalten enhalten jeweils Zustandsvektor
for i = 2:n+1
  S[i, :] = Q * S[i-1, :]';
end

plot(S[:,1])

