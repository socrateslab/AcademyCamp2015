# Describe the congressmen's retweet network with R
# chengjun wang 
# @ Tencent 2014/04/16


library(igraph)
# detach("package:igraph", unload=TRUE)
# detach("package:statnet", unload=TRUE)

setwd("E:/Github/ergm") # change here to your work directory
att = read.table("./party_info.txt", sep = ",", header = T, stringsAsFactors = F)
mat = as.matrix(read.table("./retweet_network.txt", header=TRUE, sep = ",",
                           row.names = 1,stringsAsFactors = F,
                           as.is=TRUE))
table(att$party) # democracy, independent, and republic.

g = graph.adjacency(mat, mode=c("directed"), weighted=TRUE, diag=FALSE)    ; g         
V(g)$name = colnames(mat)
# edgelist = data.frame( get.edgelist(g, names = T) , stringsAsFactors = FALSE)

set.seed(2010); lay = layout.fruchterman.reingold(g)
V(g)$party = att$party[match(V(g)$name, att$id)]

V(g)$color[V(g)$party =="D"] = 'red'
V(g)$color[V(g)$party =="R"] = 'green'
V(g)$color[V(g)$party =="I"] = 'yellow'
V(g)$size = (degree(g)+1)
plot(g, layout=lay, vertex.size = V(g)$size,edge.arrow.size=0.2,
     vertex.label=NA, vertex.size=3)

#################
# Graph Statistics
#################
# No of nodes
length(V(g))
# No of edges
length(E(g))
# Density (No of edges / possible edges)
graph.density(g)
# Number of islands
clusters(g)$no
# Global cluster coefficient:
#(close triplets/all triplets)
transitivity(g, type="global")
# Reciprocity of the graph
reciprocity(g)


# Connected Component algorithms is to find the island 
# of nodes that are interconnected with each other, 
# in other words, one can traverse from one node to 
# another one via a path.  

# Notice that connectivity is symmetric in undirected graph.Therefore in
# directed graph, there is a concept of "strong" connectivity which means both
# nodes are considered connected only when it is reachable in both direction.

# A "weak" connectivity means nodes are connected

# Nodes reachable from node4
subcomponent(g, 4, mode="out")
# Nodes who can reach node4
subcomponent(g, 4, mode="in")


clusters(g, mode="weak")
clusters(g, mode="strong")

# 1. Connectivity between two nodes measure the distinct paths with no shared 
# edges between two nodes. (ie: how much edges need to be removed to disconnect them)
edge.connectivity(g)
# Compute the connectivity for two nodes
edge.connectivity(g, 7, 2)
# Same as edge.connectivity
graph.adhesion(g)
# The adhesion of a graph is the minimum number of edges needed to remove to
# obtain a graph which is not strongly connected. This is the same as the edge
# connectivity of the graph. Edge connectivity, 0 since graph is disconnected

# 2. Shortest path between two nodes
shortest.paths(g, 1, 2)
# Compute the shortest path matrix
matrix_of_shortest_path = shortest.paths(g)

# 3. the diameter of the graph
# Diameter of the graph the length of the longest geodesic. 
# the geodesic distance is the number of relations in the shortest possible walk 
# from one actor to another
diameter(g)
get.diameter(g)

# 4. degree distribution
d = degree(g)
dd = degree.distribution(g)

##########################################
# plot and fit the power law distribution
##########################################
# power law distribution
plot(degree.distribution(g), type = "b", xlab="node degree", ylab = "Probability")
plot(degree.distribution(g), log =  "xy", type = "b", xlab="node degree", ylab = "probability")

# rank-order distribution
d = degree(graph, mode="all")
d = d[d!=0]
p = d/sum(as.numeric(d))
Rank = rank(-d,  ties.method = c("first"))
plot(d~Rank, log = "xy", xlab  = "Rank (log)", ylab = "Degree (log)", 
     main = "Rank-Order Distribution")

fit_power_law = function(graph){
  # calculate degree
  d = degree(graph, mode="all")
  dd = degree.distribution(graph, mode="all", cumulative=FALSE)
  degree = 1:max(d)
  probability = dd[-1]
  # delete blank values
  nonzero.position = which(probability!=0)
  probability = probability[nonzero.position]
  degree = degree[nonzero.position]
  reg = lm(log(probability)~log(degree))
  cozf=coef(reg)
  power.law.fit = function(x) exp(cozf[[1]] + cozf[[2]]*log(x)) 
  alpha = -cozf[[2]]
  R.square = summary(reg)$r.squared 
  print(paste("Alpha =", round(alpha, 3)))
  print(paste("R square =", round(R.square, 3)  ))
  # plot
  plot(probability~degree, log="xy", xlab="Degree (log)", ylab="Probability (log)",
       col=1, main="Degree Distribution")
  curve(power.law.fit, col="red", add = T, n = length(d))
  
}


fit_power_law(g)

#################
# Centrality Measures
#################

# 1. Degree centrality gives a higher score to a node that has a high in/out-degree
# 2. Closeness centrality gives a higher score to a node that has short path distance to every other nodes
# 3. Betweenness centrality gives a higher score to a node that sits on many shortest path of other node pairs
# 4. Eigenvector centrality gives a higher score to a node if it connects to many high score nodes
# 5. Local cluster coefficient measures how my neighbors are inter-connected with each other, 
# which means the node becomes less important.

# g1 = barabasi.game(100, directed=F)
# g2 = barabasi.game(100, directed=F)
# g = g1 %u% g2

# Degree
deg = degree(g)
deg_in = degree(g, mode = "in")
deg_out = degree(g, mode = "out")

plot(data.frame(deg, deg_in, deg_out))
# Closeness (inverse of average dist)
clo = closeness(g)

# Betweenness
bet = betweenness(g)

# Local cluster coefficient
tra = transitivity(g, type="local")

# Eigenvector centrality
eig = evcent(g)$vector

net.cen = data.frame(degree = deg, closeness = clo, 
                     betweenness = bet, eigenvector = eig, transtivity = tra)
plot(net.cen)


# Plot the eigevector and betweenness centrality
# par(mfrow=c(1, 2))
plot(evcent(g)$vector, betweenness(g))
text(evcent(g)$vector, betweenness(g), cex=0.6, pos=4)

# plot the network
V(g)$labels = NA
# V(g)$labels[which(degree(g) > 15)] = which(degree(g) > 15)
V(g)[4]$labels = 4
V(g)[495]$labels = 495
V(g)$shape = 'circle'
E(g)$color = 'grey'
# V(g)[4]$shape = 'square'
# V(g)[495]$shape = 'rectangle'

plot(g, layout=lay, vertex.size = V(g)$size, edge.arrow.size=0.2,
     vertex.label=V(g)$labels, vertex.shape = V(g)$shape, vertex.size=3)

##################
# Shortest path
##################
# 'Shortest Path algorithm aims to find the shortest path from 
# node A to node B.  

# shortest path
pa = get.shortest.paths(g, 77, 495)[[1]]
pa = get.shortest.paths(g, 495, 77)[[1]]

pa = unlist(pa)
E(g)$color = 'grey'
E(g, path=pa)$color = 'red'
E(g, path=pa)$width = 3
plot(g, layout=lay, vertex.size = V(g)$size, edge.arrow.size=0.2,
     vertex.label=V(g)$labels, vertex.shape = V(g)$shape, vertex.size=3)

#######################
# network diameter
########################
d = get.diameter(g)
E(g)$color = 'grey'
E(g, path=d)$color = "blue"
E(g, path=d)$width = 3


plot(g, layout=lay, vertex.size = V(g)$size, edge.arrow.size=0.2,
     vertex.label=V(g)$labels, vertex.shape = V(g)$shape, vertex.size=3)


