# R script of ERGM
# chengjun wang @cmc, 2013 Dec 17th

#########################
# load data
#########################
setwd("E:/Github/ergm")
att = read.table("./party_info.txt", sep = ",", header = T, stringsAsFactors = F)
mat = as.matrix(read.table("./retweet_network.txt", header=TRUE, sep = ",",
                              row.names = 1,stringsAsFactors = F,
                              as.is=TRUE))
table(att$party) # democracy, independent, and republic.

##########################
# build the network object
##########################
#　since there is a conflict between igraph and statnet
#  we need to detach igraph first before we call statnet

detach("package:igraph", unload=TRUE)

library(statnet)

# Create a network object out of the edgelist
n = network(mat, vertex.attr=NULL, vertex.attrnames=NULL, 
            matrix.type="adjacency", directed=TRUE)
summary(n) # see the basic info of the network.
# network.vertex.names(n) 

# Add the node attribues
# Note that: if the sequence of vertex names are different from 
# its sequence in the attributes, we need to match the postion
# att$party[match(n%v%'vertex.names',att$id)]
set.vertex.attribute(n, "party", att$party) 
# n%v%'party'= att$party # another way to set node attributes

# model plot
plot(n, displayisolates = T, vertex.col =  "party", vertex.cex = 0.7)

# set the colors
n%v%'color'=n%v%'party'
n%v%'color'=gsub("D","red",n%v%'color')
n%v%'color'=gsub("R","blue",n%v%'color')
n%v%'color'=gsub("I","yellow",n%v%'color')
n%v%'size' = (degree(n) + 1)/5

set.seed(2014)
plot(n, displayisolates = F,  
     vertex.col = "color", vertex.cex = 'size')
# learn more about gplot by searching: ?gplot

###############
#   ergm
###############

m1 = ergm(n ~ edges + nodematch("party") + nodefactor("party")
         + mutual + gwesp(fixed=T, cutoff=30), parallel=10)

# this take a long time!

summary(m1)
mcmc.diagnostics(m1)
# 
# Iteration 1 of at most 20: 
#   Convergence test P-value: 0e+00 
# The log-likelihood improved by 15.56 
# Iteration 2 of at most 20: 
#   Convergence test P-value: 6.6e-14 
# The log-likelihood improved by 0.3207 
# Iteration 3 of at most 20: 
#   Convergence test P-value: 8e-225 
# The log-likelihood improved by 1.656 
# Iteration 4 of at most 20: 
#   Convergence test P-value: 6.3e-71 
# The log-likelihood improved by 4.498 
# Iteration 5 of at most 20: 
#   Convergence test P-value: 7.5e-51 
# The log-likelihood improved by 3.861 
# Iteration 6 of at most 20: 
#   Convergence test P-value: 0e+00 
# The log-likelihood improved by 10.69 
# Iteration 7 of at most 20: 
#   Convergence test P-value: 0e+00 
# The log-likelihood improved by 8.971 
# Iteration 8 of at most 20: 
#   Convergence test P-value: 0e+00 
# The log-likelihood improved by 9.294 
# Iteration 9 of at most 20: 
#   Convergence test P-value: 0e+00 
# The log-likelihood improved by 9.655 
# Iteration 10 of at most 20: 
#   Convergence test P-value: 0e+00 
# The log-likelihood improved by 9.934 
# Iteration 11 of at most 20: 
#   Convergence test P-value: 0e+00 
# The log-likelihood improved by 9.791 
# Iteration 12 of at most 20: 
#   Convergence test P-value: 0e+00 
# The log-likelihood improved by 10.54 
# Iteration 13 of at most 20: 
#   Convergence test P-value: 0e+00 
# The log-likelihood improved by 11.36 
# Iteration 14 of at most 20: 
#   Convergence test P-value: 0e+00 
# The log-likelihood improved by 11.49 
# Iteration 15 of at most 20: 
#   Convergence test P-value: 0e+00 
# The log-likelihood improved by 12.22 
# Iteration 16 of at most 20: 
#   Convergence test P-value: 0e+00 
# The log-likelihood improved by 12.02 
# Iteration 17 of at most 20: 
#   Convergence test P-value: 0e+00 
# The log-likelihood improved by 12.47 
# Iteration 18 of at most 20: 
#   Convergence test P-value: 0e+00 
# The log-likelihood improved by 12.79 
# Iteration 19 of at most 20: 
#   Convergence test P-value: 0e+00 
# The log-likelihood improved by 13.09 
# Iteration 20 of at most 20: 
#   Convergence test P-value: 0e+00 
# The log-likelihood improved by 13.28 
# 
# This model was fit using MCMC.  To examine model diagnostics and check for degeneracy, use the mcmc.diagnostics() function.
# > summary(m1)
# 
# ==========================
#   Summary of model fit
# ==========================
#   
#   Formula:   n ~ edges + nodematch("party") + nodefactor("party") + mutual + 
#   gwesp(fixed = T, cutoff = 30)
# 
# Iterations:  20 
# 
# Monte Carlo MLE Results:
#   Estimate Std. Error MCMC % p-value    
# edges              -7.90785    0.08056      0 < 1e-04 ***
#   nodematch.party     1.28507    0.10262      0 < 1e-04 ***
#   nodefactor.party.I -0.13371    0.68436      0 0.84510    
# nodefactor.party.R  0.16411    0.06165      0 0.00776 ** 
#   mutual              3.55762    0.07382      0 < 1e-04 ***
#   gwesp.fixed.0       2.56079    0.09791      0 < 1e-04 ***
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Null Deviance: 384284  on 277202  degrees of freedom
# Residual Deviance:   5877  on 277196  degrees of freedom
# 
# AIC: 5889    BIC: 5953 