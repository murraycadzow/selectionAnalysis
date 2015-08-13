drv=dbDriver(drvName = "MySQL")
db=dbConnect(drv, host="127.0.0.1", user="murray", db="selection")
axiomTD= dbGetQuery(db, "select * from tajimasd where Population = 'AXIOM' and TajimasD < 0 order by TajimasD limit 1000;")
omniTD=dbGetQuery(db, "select * from tajimasd where Population = 'OMNI' and TajimasD < 0 order by TajimasD limit 1000;")
ceuTD=dbGetQuery(db, "select * from tajimasd where Population = 'CEU' and TajimasD < 0 order by TajimasD limit 1000;")
chbTD=dbGetQuery(db, "select * from tajimasd where Population = 'CHB' and TajimasD < 0 order by TajimasD limit 1000;")
chsTD=dbGetQuery(db, "select * from tajimasd where Population = 'CHS' and TajimasD < 0 order by TajimasD limit 1000;")
gbrTD=dbGetQuery(db, "select * from tajimasd where Population = 'GBR' and TajimasD < 0 order by TajimasD limit 1000;")
yriTD=dbGetQuery(db, "select * from tajimasd where Population = 'YRI' and TajimasD < 0 order by TajimasD limit 1000;")

combine=function(pop1,pop2){
  return(merge(pop1, pop2, by = c("chrom", "chrom_start")))
}

overlap = function(pop1, pop2){
  return(length(combine(pop1,pop2)[,1]))
}

axiom_omniTD = overlap(axiomTD,omniTD)
axiom_ceuTD = overlap(axiomTD,ceuTD)
axiom_chbTD =overlap(axiomTD,chbTD)
axiom_chsTD = overlap(axiomTD,chsTD)
axiom_gbrTD = overlap(axiomTD,gbrTD)
axiom_yriTD = overlap(axiomTD,yriTD)

omni_ceuTD = overlap(omniTD,ceuTD)
omni_chbTD = overlap(omniTD,chbTD)
omni_chsTD = overlap(omniTD,chsTD)
omni_gbrTD = overlap(omniTD,gbrTD)
omni_yriTD = overlap(omniTD,yriTD)

ceu_chbTD = overlap(ceuTD,chbTD)
ceu_chsTD = overlap(ceuTD,chsTD)
ceu_gbrTD = overlap(ceuTD,gbrTD)
ceu_yriTD = overlap(ceuTD,yriTD)

chb_chsTD = overlap(chbTD, chsTD)
chb_gbrTD = overlap(chbTD, gbrTD)
chb_yriTD = overlap(chbTD, yriTD)

chs_gbrTD = overlap(chsTD, gbrTD)
chs_yriTD = overlap(chsTD, yriTD)

gbr_yriTD = overlap(gbrTD,yriTD)

# make distance matrix
distTD = matrix(nrow = 7, ncol=7)
colnames(distTD) = c('axiom','omni','ceu','chb','chs','gbr','yri')
rownames(distTD) = c('axiom','omni','ceu','chb','chs','gbr','yri')
distTD[,1]= c(0,axiom_omniTD,axiom_ceuTD,axiom_chbTD,axiom_chsTD,axiom_gbrTD,axiom_yriTD)
distTD[,2]= c(axiom_omniTD,0,omni_ceuTD,omni_chbTD,omni_chsTD,omni_gbrTD,omni_yriTD)
distTD[,3]= c(axiom_ceuTD,omni_ceuTD,0,ceu_chbTD,ceu_chsTD,ceu_gbrTD,ceu_yriTD)
distTD[,4]= c(axiom_chbTD,omni_chbTD,ceu_chbTD,0,chb_chsTD,chb_gbrTD,chb_yriTD)
distTD[,5]= c(axiom_chsTD,omni_chsTD,ceu_chsTD,chb_chsTD,0,chs_gbrTD,chs_yriTD)
distTD[,6]= c(axiom_gbrTD,omni_gbrTD,ceu_gbrTD,chb_gbrTD,chs_gbrTD,0,gbr_yriTD)
distTD[1,]=t(distTD[,1])
distTD[2,]=t(distTD[,2])
distTD[3,]=t(distTD[,3])
distTD[4,]=t(distTD[,4])
distTD[5,]=t(distTD[,5])
distTD[6,]=t(distTD[,6])
distTD[7,7] = 0
dist2TD = 1/distTD
distTD

dist2TD = 1/distTD
dist2TD[1,1]=0;dist2TD[2,2]=0;dist2TD[3,3]=0;dist2TD[4,4]=0;dist2TD[5,5]=0;dist2TD[6,6]=0;dist2TD[7,7]=0
plot(hclust(dist(dist2TD),method="single"), main= "Tajima's D Cluster Dendrogram")
distTD


# ceu_gbr first cluster
cg= combine(ceuTD, gbrTD)
cg_axiom = overlap(cg,axiomTD)
cg_omni = overlap(cg,omniTD)
cg_chb = overlap(cg,chbTD)
cg_chs = overlap(cg,chsTD)
cg_yri = overlap(cg,yriTD)

# make distance matrix
distTD = matrix(nrow = 6, ncol=6)
colnames(distTD) = c('axiom','omni','ceu_gbr','chb','chs','yri')
rownames(distTD) = c('axiom','omni','ceu_gbr','chb','chs','yri')
distTD[,1]= c(0,axiom_omniTD,cg_axiom,axiom_chbTD,axiom_chsTD,axiom_yriTD)
distTD[,2]= c(axiom_omniTD,0,cg_omni,omni_chbTD,omni_chsTD,omni_yriTD)
distTD[,3]= c(cg_axiom,cg_omni,0,cg_chb,cg_chs,cg_yri)
distTD[,4]= c(axiom_chbTD,omni_chbTD,cg_chb,0,chb_chsTD,chb_yriTD)
distTD[,5]= c(axiom_chsTD,omni_chsTD,cg_chs,chb_chsTD,0,chs_yriTD)
#distTD[,6]= c(axiom_ceuTD,omni_ceuTD,ceu_chbTD,chb_chsTD,chs_gbrTD,0)
distTD[1,]=t(distTD[,1])
distTD[2,]=t(distTD[,2])
distTD[3,]=t(distTD[,3])
distTD[4,]=t(distTD[,4])
distTD[5,]=t(distTD[,5])
#distTD[6,]=t(distTD[,6])
distTD[6,6] = 0
dist2TD = 1/distTD
distTD

#second cluster chb_chs
cc = combine(chbTD, chsTD)
cc_axiom = overlap(cc,axiomTD)
cc_omni =overlap(cc,omniTD)
cc_cg = overlap(cc,cg)
cc_yri = overlap(cc,yriTD)

distTD = matrix(nrow = 5, ncol=5)
colnames(distTD) = c('axiom','omni','ceu_gbr','chb_chs','yri')
rownames(distTD) = c('axiom','omni','ceu_gbr','chb_chs','yri')
distTD[,1]= c(0,axiom_omniTD,cg_axiom,cc_axiom,axiom_yriTD)
distTD[,2]= c(axiom_omniTD,0,cg_omni,cc_omni,omni_yriTD)
distTD[,3]= c(cg_axiom,cg_omni,0,cc_cg,cg_yri)
distTD[,4]= c(cc_axiom,cc_omni,cg_chb,0,cc_yri)
#distTD[,5]= c(axiom_chsTD,omni_chsTD,cg_chs,chb_chsTD,0,chs_yriTD)
#distTD[,6]= c(axiom_ceuTD,omni_ceuTD,ceu_chbTD,chb_chsTD,chs_gbrTD,0)
distTD[1,]=t(distTD[,1])
distTD[2,]=t(distTD[,2])
distTD[3,]=t(distTD[,3])
distTD[4,]=t(distTD[,4])
#distTD[5,]=t(distTD[,5])
#distTD[6,]=t(distTD[,6])
distTD[5,5] = 0
dist2TD = 1/distTD
distTD

# third cluster axiom omni
ao = combine(axiomTD, omniTD)
ao_cg = overlap(ao,cg)
ao_cc = overlap(ao, cc)
ao_yri = overlap(ao,yriTD)
distTD = matrix(nrow = 4, ncol=4)
colnames(distTD) = c('axiom_omni','ceu_gbr','chb_chs','yri')
rownames(distTD) = c('axiom_omni','ceu_gbr','chb_chs','yri')
distTD[,1]= c(0,ao_cg,ao_cc,ao_yri)
distTD[,2]= c(ao_cg,0,cc_cg,cg_yri)
distTD[,3]= c(ao_cc,cc_cg,0,cg_yri)
distTD[1,]=t(distTD[,1])
distTD[2,]=t(distTD[,2])
distTD[3,]=t(distTD[,3])
distTD[4,4] = 0
dist2TD = 1/distTD
distTD

#fourth cluster axiom_omni chb_chs
aocc = combine(ao, cc)
aocc_cg = overlap(ao, cg)
aocc_yri = overlap(ao, yriTD)
distTD = matrix(nrow = 3, ncol=3)
colnames(distTD) = c('axiom_omni_chb_chs','ceu_gbr','yri')
rownames(distTD) = c('axiom_omni_chb_chs','ceu_gbr','yri')
distTD[,1]= c(0,aocc_cg,ao_yri)
distTD[,2]= c(aocc_cg,0,cg_yri)
distTD[1,]=t(distTD[,1])
distTD[2,]=t(distTD[,2])
distTD[3,3] = 0
dist2TD = 1/distTD
distTD


#fourth cluster axiom_omni chb_chs
aocccg = combine(aocc, cg)
aocccg_yri = overlap(aocccg, yriTD)
distTD = matrix(nrow = 2, ncol=2)
colnames(distTD) = c('axiom_omni_chb_chs_ceu_gbr','yri')
rownames(distTD) = c('axiom_omni_chb_chs_ceu_gbr','yri')
distTD[,1]= c(0,aocccg_yri)

distTD[1,]=t(distTD[,1])

distTD[2,2] = 0
dist2TD = 1/distTD
distTD

tree = "(((ceu:0.577,gbr:0.577),((chb:0.518,chs:0.518),(axiom,omni:0.296):0.046):0.028),yri)"