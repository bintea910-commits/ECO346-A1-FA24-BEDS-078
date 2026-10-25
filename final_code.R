# ECO346 - A1 - BED-078 - Variant 6 Balochistan
hh <- read.csv("data/pslm_hh_subset.csv")
pp <- read.csv("data/pslm_person_subset.csv")

# Household education total (person file se sum)
hh_ed <- aggregate(ed_total ~ hhid, data=pp, FUN=sum, na.rm=TRUE)
hh <- merge(hh, hh_ed, by="hhid", all.x=TRUE)
hh$ed_total[is.na(hh$ed_total)] <- 0

# Balochistan filter prov_code == 4
hh_b <- hh[hh$prov_code == 4, ]

wtd_q <- function(x, w, prob){
  o <- order(x); x <- x[o]; w <- w[o]
  cw <- cumsum(w)/sum(w)
  x[which(cw >= prob)[1]]
}

x <- hh_b$ed_total
w <- hh_b$hhweight

p10 <- wtd_q(x, w, 0.10)
med <- wtd_q(x, w, 0.50)
p90 <- wtd_q(x, w, 0.90)

p10; med; p90

# Plot
hist(x, breaks=100, main="Variant 6 - Balochistan - ed_total", xlab="ed_total (Rs)")