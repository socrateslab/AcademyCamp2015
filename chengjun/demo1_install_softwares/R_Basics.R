
# Demo 1 install R, R studio, and NodeXL

########################
# R basics
########################

# get work directory
getwd() 
setwd("E:/github/ergm/") # modify here to set your work directory


1 + 3 # evaluation
a = 3 # assignment
a # evaluation
a = 3 # spacing does not matter
sqrt(a) # use the square root function
b = sqrt(a) ; b # use function and save result


help(sqrt)# get specific help for a function
?sqrt # get specific help for a function

a == b # Using two equals sign to judge whether a is equivalent to b. 
a != b # is a not equal to b?

##############################
# Vectors and matrices in R
#############################

# create a vector by combining values
a = c(1,3,5) ; a 
a[2] # select the second element
b = c("one","three","five") ; b# also works with strings
b[2]
a = c(a,a) ; a # can apply recursively
a = c(a,b) ; a # mixing types---what happens?

## Sequences and replication
a = seq(from=1,to=5,by=1) # from 1 to 5 the slow way
b = 1:5 # a shortcut!
a==b # all TRUE
rep(1,times=5) # a lot of ones
rep(1:5,times=2) # repeat an entire sequence
rep(1:5,each=2) # same, but element-wise
rep(1:5,times=5:1) # can vary the count of each element

## matrices
a = matrix(data=1:25, nrow=5, ncol=5) ; a # create a matrix the "formal" way
a[1,2] # select a matrix element (two dimensions)
a[1,] # just the first row
a[,2] # can also perform for columns
a[2:3,3:5] # select submatrices
a[-1,] # get rid of row one

# create matrices by combining rows or columns
b = cbind(1:5,1:5) ;b
d = rbind(1:5,1:5) ;d # can perform with rows, too

dim(b) # dimensions = number of rows * number of columns
nrow(b) # the number of rows
ncol(b) # the number of columns

# Element-wise operations
a = 1:5
a + 1 # addition
a * 2 # multiplication
a / 3 # division
a - 4 # subtraction
a ^ 5 # the 5th power
a + a # also works on pairs of vectors
a * a
log(a)
exp(b)

#################
# Data frames
#################

d = data.frame(income=1:5,health=c(T,T,T,T,F),name=LETTERS[1:5])
d
d[1,2] # acts a lot like a matrix!
d[,1]*5
d[-1,]
d$health # can use dollar sign notation 
d$health[3]=FALSE # making changes
d
d[2,3] # shows factors for string values
d$name = LETTERS[1:5] # eliminate evil factors by overwriting
d[2,3]

# avoid to use factors (if you want)
d = data.frame(income=1:5,health=c(T,T,T,T,F),name=LETTERS[1:5],
               stringsAsFactors=FALSE)
d
d = as.data.frame(cbind(1:5,2:6)) # can create from matrices
d
is.data.frame(d) # how can we tell it's not a matrix?
is.matrix(d) # the truth comes out


# Finding built-in data sets
# Many packages have built-in data for testing and educational purposes

data() # lists them all
?USArrests # get help on a data set
data(USArrests) # load the data set
USArrests # view the object

#############################
# Elementary visualization
#############################

## R's workhorse is the ``plot" command

plot(USArrests$Murder,USArrests$UrbanPop) # using dollar sign notation
plot(USArrests$Murder,USArrests$UrbanPop,log="xy") # log-log scale

## Adding plot title and axis labels

plot(USArrests$Murder,USArrests$Assault,
     xlab="Murder",ylab="Assault",main="USArrests")

## Can also add text
plot(USArrests$Murder,USArrests$Assault,
     xlab="Murder",ylab="Assault", main="USArrests",type="n")
text(USArrests$Murder,USArrests$Assault,rownames(USArrests))

## Histograms and boxplots 
hist(USArrests$Murder)
boxplot(USArrests)

#######################
# install R packges
######################

install.packages(c("igraph", "statnet", "e1071", "RTextTools"))
