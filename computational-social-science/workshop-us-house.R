#
# workshop-us-house.R
#
# 2-parameter item-response models
# of US House member ideology.
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

library(RColorBrewer)
palette(brewer.pal(n=9,name="Set1")[c(1:5,7:9)]) # reset default colors


# Data frame of 1993 US House votes.
# https://www.voteview.com/static/data/out/votes/H103_votes.csv
votes = subset(read.csv("H103_votes.csv"),cast_code %in% c(1,6),select=c(rollnumber,icpsr,cast_code))
# https://www.voteview.com/static/data/out/members/H103_members.csv
members = subset(read.csv("H103_members.csv"),chamber == "House",select=c(icpsr, district_code, state_abbrev, party_code, bioname,born))
print(head(members))


# Reshape votes to wide.
votes2 = reshape(votes, direction = "wide", idvar = "icpsr", timevar = "rollnumber")
# Change code of no votes from 6 to 0.
for (j in 2:ncol(votes2)) {
  votes2[,j] = ifelse(is.na(votes2[,j]),NA,ifelse(votes2[,j] == 6,0,1))
}
# Remove near-unanimous votes.
vote_rates = colMeans(votes2[,2:ncol(votes2)],na.rm=T)
drop = which(vote_rates > .9 | vote_rates < .1) + 1 # because first column icpsr id
votes2 = votes2[,-drop]
# Random sample of 100 votes.
votes3 = votes2[,c(1,sample(x=2:ncol(votes2),size=100,replace=F))]

###########
# Bayesian estimate of 2-parameter irt model
# on sampled House votes.
###########
require(MCMCpack) # library for Bayesian irt models

res_irt = MCMCirt1d(votes3[,-1])
post = summary(res_irt)
# Estimated ideal points (posterior median).
psi = data.frame(icpsr=votes3[,"icpsr"],psi=post$quantiles[,"50%"]) 


# Merge estimated ideal point back to members.
dat = merge(members,psi,by="icpsr",all.x=T)
range_ideals = range(dat$psi,na.rm=T)

###########
# Histogram by party.
###########
par.old = par(mfrow=c(1,2))
# Republicans.
hist(dat[dat$party_code == 200,"psi"],xlim=range_ideals,xlab="psi",col=1,main="Republican ideology")
# Democrats.
hist(dat[dat$party_code == 100,"psi"],xlim=range_ideals,xlab="psi",col=2,main="Democrat ideology")
par(par.old)
# Mean by party.
tapply(dat$psi,dat$party_code,mean,na.rm=T)
