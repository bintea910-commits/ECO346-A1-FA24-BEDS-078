# Q2: Variant 6, Balochistan rural, student-level weighted spending
library(ggplot2)
dir.create('figures', showWarnings=FALSE)
hh <- read.csv('data/pslm_hh_subset.csv')
pp <- read.csv('data/pslm_person_subset.csv')
stopifnot(all(c('hhid','hhweight','prov_code','urban_rural') %in% names(hh)))
stopifnot(all(c('hhid','ed_total') %in% names(pp)))
# Avoid duplicated join fields if person data already contains them
pp <- pp[, setdiff(names(pp), c('hhweight','prov_code','urban_rural')), drop=FALSE]
d <- merge(pp, hh[, c('hhid','hhweight','prov_code','urban_rural')], by='hhid', all.x=TRUE)
d <- subset(d, prov_code==4 & urban_rural==1 & is.finite(ed_total) & ed_total>0 & is.finite(hhweight) & hhweight>0)
weighted_quantile <- function(x,w,p) { z<-order(x); x<-x[z]; w<-w[z]; x[which(cumsum(w)/sum(w)>=p)[1]] }
p10<-weighted_quantile(d$ed_total,d$hhweight,.1)
med<-weighted_quantile(d$ed_total,d$hhweight,.5)
p90<-weighted_quantile(d$ed_total,d$hhweight,.9)
unweighted_med<-median(d$ed_total)
inside<-d$ed_total>=100 & d$ed_total<=1e6
excluded<-sum(!inside)
cat(sprintf('Q2: students=%d, weighted P10=Rs %.0f, weighted median=Rs %.0f, unweighted median=Rs %.0f, weighted P90=Rs %.0f, P90/median=%.2f, excluded=%d\n',nrow(d),p10,med,unweighted_med,p90,p90/med,excluded))
write.csv(data.frame(students=nrow(d),weighted_p10=p10,weighted_median=med,unweighted_median=unweighted_med,weighted_p90=p90,p90_median_ratio=p90/med,excluded=excluded),'figures/q2_results.csv',row.names=FALSE)
plot_data<-d[inside,,drop=FALSE]; plot_data$logspend<-log10(plot_data$ed_total)
# Weighted density: sum weights in bin / (total weights * bin width)
breaks<-seq(2,6,by=.1)
bin<-cut(plot_data$logspend,breaks=breaks,include.lowest=TRUE,right=FALSE)
bin[plot_data$logspend==6]<-levels(bin)[length(levels(bin))]
ws<-as.numeric(tapply(plot_data$hhweight, factor(bin,levels=levels(bin)), sum)); ws[is.na(ws)]<-0
hist_data<-data.frame(x=seq(2.05,5.95,by=.1),density=ws/(sum(ws)*.1))
p<-ggplot(hist_data,aes(x=x,y=density))+geom_col(width=.1,fill='#247D8F',color='white',linewidth=.12)+
  geom_vline(xintercept=log10(c(med,p90)),linetype='dashed',color=c('#C0483D','#5C3B9A'))+
  annotate('label',x=log10(med),y=Inf,label=paste0('Median Rs ',format(med,big.mark=',')),vjust=1.1,hjust=0,size=3)+
  annotate('label',x=log10(p90),y=Inf,label=paste0('P90 Rs ',format(p90,big.mark=',')),vjust=2.7,hjust=0,size=3)+
  scale_x_continuous(breaks=2:6,labels=c('Rs 100','Rs 1,000','Rs 10,000','Rs 100,000','Rs 1,000,000'),limits=c(2,6))+
  labs(title='Education spending varies widely among rural Balochistan students',x='Annual education spending (rupees)',y='Weighted density per log10 unit',caption=paste0('Source: PSLM 2019–20; students with positive spending; household weights. Outside Rs 100–1,000,000: ',excluded,' students.'))+
  theme_minimal(base_size=11)+theme(axis.text.x=element_text(angle=25,hjust=1))
ggsave('figures/q2_distribution.svg',p,width=10,height=6)
