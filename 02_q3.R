# Q3: weighted literacy by five-year age bands
library(ggplot2)
dir.create('figures',showWarnings=FALSE)
hh<-read.csv('data/pslm_hh_subset.csv'); pp<-read.csv('data/pslm_person_subset.csv')
pp<-pp[,setdiff(names(pp),c('hhweight','prov_code','urban_rural')),drop=FALSE]
d<-merge(pp,hh[,c('hhid','hhweight','prov_code','urban_rural')],by='hhid',all.x=TRUE)
d<-subset(d,prov_code==4 & urban_rural==1 & age>=10 & age<=64 & !is.na(literate) & sex %in% c(1,2) & is.finite(hhweight) & hhweight>0)
d$mid<-10+5*floor((d$age-10)/5)+2
d$gender<-factor(d$sex,levels=c(1,2),labels=c('Men','Women'))
keys<-unique(d[,c('mid','gender')]); keys<-keys[order(keys$mid,keys$gender),]
rows<-lapply(seq_len(nrow(keys)),function(i){k<-keys[i,]; z<-d[d$mid==k$mid & d$gender==k$gender,]; data.frame(mid=k$mid,band=sprintf('%d-%d',k$mid-2,k$mid+2),gender=k$gender,n=nrow(z),rate=100*sum(z$literate*z$hhweight)/sum(z$hhweight))})
tab<-do.call(rbind,rows)
write.csv(tab,'figures/q3_band_table_R.csv',row.names=FALSE)
wide<-reshape(tab[,c('mid','gender','rate')],idvar='mid',timevar='gender',direction='wide')
wide$gap<-wide$rate.Men-wide$rate.Women
largest<-wide[which.max(wide$gap),]
cat('Q3 weighted literacy table:\n'); print(tab,row.names=FALSE)
cat(sprintf('Largest male-female gap: %d-%d = %.1f pp\n',largest$mid-2,largest$mid+2,largest$gap))
for (m in c(17,57)) print(tab[tab$mid==m,],row.names=FALSE)
end<-tab[tab$mid==max(tab$mid),]
p<-ggplot(tab,aes(mid,rate,color=gender,group=gender))+geom_line(linewidth=1)+
  geom_point(data=subset(tab,n>=30),size=2.6)+
  geom_point(data=subset(tab,n<30),shape=21,fill='white',size=3,stroke=1.1)+
  geom_text(data=end,aes(label=gender),hjust=-.15,show.legend=FALSE,size=3.7)+
  annotate('label',x=largest$mid,y=min(96,max(12,mean(c(largest$rate.Men,largest$rate.Women)))),label=sprintf('Largest gap: %d-%d (%.1f pp)',largest$mid-2,largest$mid+2,largest$gap),size=3)+
  scale_color_manual(values=c(Men='#2863B0',Women='#C94F6D'))+
  scale_x_continuous(breaks=seq(12,62,5),limits=c(10,70))+
  scale_y_continuous(limits=c(0,100),breaks=seq(0,100,20))+
  labs(title='Literacy differs by age and gender in rural Balochistan',x='Age-band midpoint (years)',y='Weighted literacy rate (%)',caption='PSLM 2019–20; rural Balochistan, ages 10–64; hhweight. Hollow markers: fewer than 30 persons.')+
  theme_minimal(base_size=12)+theme(legend.position='none')
ggsave('figures/q3_literacy.svg',p,width=10,height=6)
