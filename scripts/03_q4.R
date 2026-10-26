# Q4: EXACT default ggplot; Q3 figure is the redesign
library(ggplot2)
dir.create('figures',showWarnings=FALSE)
hh<-read.csv('data/pslm_hh_subset.csv'); pp<-read.csv('data/pslm_person_subset.csv')
pp<-pp[,setdiff(names(pp),c('hhweight','prov_code','urban_rural')),drop=FALSE]
d<-merge(pp,hh[,c('hhid','hhweight','prov_code','urban_rural')],by='hhid',all.x=TRUE)
d<-subset(d,prov_code==4 & urban_rural==1 & age>=10 & age<=64 & !is.na(literate) & sex %in% c(1,2))
data<-data.frame(x=d$age,y=d$literate)
p_default <- ggplot(data, aes(x, y)) + geom_point()
ggsave('figures/default.svg',p_default,width=9,height=5)
# IMPORTANT: Commit figures/default.svg BEFORE running/committing Q3 redesign.
# The Q4 redesigned graph is figures/q3_literacy.svg from 02_q3.R.
