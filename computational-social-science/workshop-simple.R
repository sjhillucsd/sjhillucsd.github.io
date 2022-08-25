#
# workshop-simple.R
#
# Simple 2-parameter item-response models.
#
# Seth Hill, sjhill@ucsd.edu.
#

rm( list=ls() )
if (.Platform$OS == "windows") { 
  # Set working directory in location of script.
  frame_files <- lapply(sys.frames(), function(x) x$ofile)
  frame_files <- Filter(Negate(is.null), frame_files)
  PATH <- dirname(frame_files[[length(frame_files)]])
  setwd(PATH) ; rm(PATH,frame_files)
}

# Data frame of votes from lecture.
dat = data.frame(matrix(c(
'A', 1, 1, 0, 1, 
'B', 1, 1, 0, 0,
'C', 1, 0, 1, 0,
'D', 1, 0, 1, 1,
'E', 1, 0, 1, 1
),nrow=5,ncol=5,byrow=T))
names(dat) =c("Legislator","Pie", "Tax", "Medicaid", "Drones")
rownames(dat) = dat$Legislator
dat = dat[,-1]
# Coerce to numeric.
for (i in 1:ncol(dat)) { dat[,i] = as.numeric(dat[,i])}
# Make it a bit more interesting with a few more votes,
# sampled at random.
set.seed(20220826)
dat$Vote6 = rbinom(5,prob=rowMeans(dat,na.rm=T),size=1)
dat$Vote7 = rbinom(5,prob=.7*rowMeans(dat,na.rm=T),size=1)
dat$Vote8 = rbinom(5,prob=1-rowMeans(dat,na.rm=T)/2,size=1)
dat$Vote9 = rbinom(5,prob=1-rowMeans(dat,na.rm=T)/4,size=1)

print(dat)

### Pie vote has no variation (all 1).
### Not useful for estimation.
dat = dat[,-1]

###########
# Bayesian estimate of 2-parameter irt model
# on simple example.
###########
require(MCMCpack) # library for Bayesian irt models

res_irt = MCMCirt1d(dat)
print(summary(res_irt))

