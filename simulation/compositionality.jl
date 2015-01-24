using StatsBase


# meanings, X, and utterances, Y; both vary along two dimensions, 0 and 1; a language is mapping 
X = (00,01,10,11) # four possible meanings, the input
Y = (00,01,10,11) # four possible outputs, the utterances


####################
##### holistic stuff

# Pssible sets
Y_1 = (00,01,10,11)

Y_2 = (00,01,10,1)
Y_3 = (00,01,10,0)
Y_4 = (00,01,1,0)

Y_5 = (00,01,0,11)
Y_6 = (00,01,1,11)
Y_7 = (00,0,1,11)

Y_8 = (00,0,10,11)
Y_9 = (00,1,10,11)
Y_10 = (0,1,10,11)

Y_11 = (0,01,10,1)

Y_1 = (00,0,10,1)

Y_1 = (0,01,1,11)
