library(RMySQL)
pw <- read.table("~/pw.txt", header=FALSE, stringsAsFactors = FALSE, comment.char = "")
drv = dbDriver("MySQL")
db = dbConnect(drv, user="murraycadzow", host="biocvisg0.otago.ac.nz", dbname="selection_phase3", password = as.character(pw))

pops <- dbGetQuery(db, "select * from population")
pop_1kg <- pops[1:26,]



# daf
# DAF
# <pos> <Ref> <Alt> <Anc> <MAF> <DAF>
#   dbGetQuery(db, "CREATE TABLE `allele_freq`(`chrom` smallint(3) unsigned,
#            `chrom_start` int(10) unsigned,
#            `chrom_end` int(10) unsigned,
#             `ref` varchar (3),
#            `alt` varchar (3),
#             `anc` varchar (3),
#             `maf` float,
#             `daf` float,
#            `pop` smallint(3) unsigned, 
# 
#             FOREIGN KEY (pop)
#               references population (id)
#             )ENGINE = INNODB;")


daf_path <- "/run/user/1000/gvfs/smb-share:server=biocldap,share=scratch/merrimanlab/murray/working_dir/Phase3_selection_results/DAF/"
for (pop in pop_1kg[,2]){
  for(chr in 1:22){
  tmp <- read.table(paste0(daf_path,pop,chr,"_aachanged2.af"), header=TRUE, stringsAsFactors = FALSE, sep="\t")
  tmp$pop <- which(pops$code==pop)
  tmp$chrom <- chr
  tmp$chrom_start <- tmp$Pos
  tmp$chrom_end <- tmp$Pos +1
  
  dbWriteTable(db, name = "allele_freq", tmp[,c("chrom","chrom_start","chrom_end", "Ref", "Alt", "Anc", "MAF","DAF","pop")], overwrite = FALSE, append=TRUE, row.names=FALSE)
  }
}
for (pop in c("AXIOM","OMNI")){
  for(info in c(0.3,0.8)){
    for(chr in 1:22){
      tmp <- read.table(paste0(daf_path,"Info",info,"/",pop,chr,"_aachanged2.af"), header=TRUE, stringsAsFactors = FALSE, sep="\t")
      tmp$pop <- which(pops$code==paste0(pop,info))
      tmp$chrom <- chr
      tmp$chrom_start <- tmp$Pos
      tmp$chrom_end <- tmp$Pos +1
      
      dbWriteTable(db, name = "allele_freq", tmp[,c("chrom","chrom_start","chrom_end", "Ref", "Alt", "Anc", "MAF","DAF","pop")], overwrite = FALSE, append=TRUE, row.names=FALSE)
    }
  }
}


##
# KaKs
##

# dbGetQuery(db, "CREATE TABLE `kaks`(`chrom` smallint(3) unsigned,
#            `gene_id` varchar (20),
#            `gene_name` varchar(20),
#             `ka` int(10),
#             `ks` int(10),
#            `pop` smallint(3) unsigned, 
# 
#             FOREIGN KEY (pop)
#               references population (id)
#             )ENGINE = INNODB;")


kaks_path <- "/run/user/1000/gvfs/smb-share:server=biocldap,share=scratch/merrimanlab/murray/working_dir/Phase3_selection_results/KaKs/" 
for (pop in pop_1kg[,2]){
  for(chr in 1:22){
    tmp <- read.table(paste0(kaks_path,pop,chr,".kaks"), header=TRUE, stringsAsFactors = FALSE, sep="\t")
    names(tmp) <- c("gene_id", "gene_name", "ka", "ks", "ka_div_ks_1")
    tmp$pop <- which(pops$code==pop)
    tmp$chrom <- chr
    
    dbWriteTable(db, name = "kaks", tmp[,c("chrom","gene_id","gene_name","ka","ks" ,"pop")], overwrite = FALSE, append=TRUE, row.names=FALSE)
  }
}
for (pop in c("AXIOM","OMNI")){
  for(info in c(0.3,0.8)){
    for(chr in 1:22){
      tmp <- read.table(paste0(kaks_path,"Info",info,"/",pop,chr,".kaks"), header=TRUE, stringsAsFactors = FALSE, sep="\t")
      names(tmp) <- c("gene_id", "gene_name", "ka", "ks", "ka_div_ks_1")
      tmp$pop <- which(pops$code==paste0(pop,info))
      tmp$chrom <- chr
      
      
      dbWriteTable(db, name = "kaks", tmp[,c("chrom","gene_id","gene_name","ka","ks" ,"pop")], overwrite = FALSE, append=TRUE, row.names=FALSE)
    }
  }
}

##
# tajimas d
##
tajd_path <- "/run/user/1000/gvfs/smb-share:server=biocldap,share=scratch/merrimanlab/murray/working_dir/Phase3_selection_results/TajimaD/"
window_info <- dbGetQuery(db, 'select * from window_info')
for (pop in pop_1kg[,2]){
  for(chr in 1:22){
    tmp <- read.table(paste0(tajd_path,pop,chr,".taj_d"), header=TRUE, stringsAsFactors = FALSE, sep="\t")
    tmp$pop <- which(pops$code==pop)
    tmp$chrom <- chr
    tmp$chrom_start <- tmp$BIN_START
    w <- tmp$BIN_START[3] - tmp$BIN_START[2]
    tmp$chrom_end <- tmp$BIN_START +w -1
    tmp$num_snps <- tmp$N_SNPS
    tmp$tajimasd <- tmp$TajimaD
    tmp$window_id <- window_info[which(window_info$width == w & window_info$slide == w),'id']
    
    dbWriteTable(db, name = "tajd", tmp[,c("chrom","chrom_start","chrom_end", "num_snps", "tajimasd" ,"pop", "window_id")], overwrite = FALSE, append=TRUE, row.names=FALSE)
  }
}
for (pop in c("AXIOM","OMNI")){
  for(info in c(0.3,0.8)){
    for(chr in 1:22){
      tmp <- read.table(paste0(tajd_path,"Info",info,"/",pop,chr,".taj_d"), header=TRUE, stringsAsFactors = FALSE, sep="\t")
      tmp$pop <- which(pops$code==paste0(pop,info))
      tmp$chrom <- chr
      tmp$chrom_start <- tmp$BIN_START
      w <- tmp$BIN_START[3] - tmp$BIN_START[2]
      tmp$chrom_end <- tmp$BIN_START +w -1
      tmp$num_snps <- tmp$N_SNPS
      tmp$tajimasd <- tmp$TajimaD
      tmp$window_id <- window_info[which(window_info$width == w & window_info$slide == w),'id']
      
      dbWriteTable(db, name = "tajd", tmp[,c("chrom","chrom_start","chrom_end", "num_snps", "tajimasd" ,"pop", "window_id")], overwrite = FALSE, append=TRUE, row.names=FALSE)
    }
  }
}

dbGetQuery(db, "CREATE TABLE `faw`(`chrom` smallint(3) unsigned,
           `chrom_start` int(10) unsigned,
           `chrom_end` int(10) unsigned,
            `num_sites` int (10),
            `missing` int(10),
           `s` int(10),
           `eta` int(10),
           `eta_e` int(10), 
           `pi` float,
           `fuli_d` float,
           `fuli_f` float,
           `faywu_h` float,
           `pop` smallint(3) unsigned,
           `window_id` smallint(3) unsigned,
            FOREIGN KEY (pop)
           references population (id),
          
            FOREIGN KEY (window_id)
              references window_info (id)
           ) ENGINE = INNODB;")
faw_path <- "/run/user/1000/gvfs/smb-share:server=biocldap,share=scratch/merrimanlab/murray/working_dir/Phase3_selection_results/FayWuH/"
for (pop in pop_1kg[,2]){
  for(chr in 1:22){
    tmp <- read.table(paste0(faw_path,pop,chr,".faw"), header=FALSE, stringsAsFactors = FALSE, skip =5)
    names(tmp)=c("RefStart","Refend","RefMid","chrom_start","chrom_end","Midpoint","num_sites","missing","s","eta","eta_e","pi","fuli_d","fuli_f","faywu_h")
    tmp$pop <- which(pops$code==pop)
    tmp$chrom <- chr
    
    w <- tmp$chrom_end[3] - tmp$chrom_start[3] +1
    tmp$window_id <- window_info[which(window_info$width == w & window_info$slide == w),'id']
    tmp <- replace(tmp, is.na(tmp), NA)
    dbWriteTable(db, name = "faw", tmp[,c("chrom","chrom_start","chrom_end", "num_sites","missing", "s", "eta", "eta_e","pi","fuli_d","fuli_f","faywu_h" ,"pop", "window_id")], overwrite = FALSE, append=TRUE, row.names=FALSE)
  }
}
for (pop in c("AXIOM","OMNI")){
  for(info in c(0.3,0.8)){
    for(chr in 1:22){
      tmp <- read.table(paste0(faw_path,pop,chr,".faw"), header=FALSE, stringsAsFactors = FALSE, skip =5)
      names(tmp)=c("RefStart","Refend","RefMid","chrom_start","chrom_end","Midpoint","num_sites","missing","s","eta","eta_e","pi","fuli_d","fuli_f","faywu_h")
      tmp$pop <- which(pops$code==paste0(pop,info))
      tmp$chrom <- chr
      
      w <- tmp$chrom_end[3] - tmp$chrom_start[3] +1
      tmp$window_id <- window_info[which(window_info$width == w & window_info$slide == w),'id']
      tmp <- replace(tmp, is.na(tmp), NA)
      dbWriteTable(db, name = "faw", tmp[,c("chrom","chrom_start","chrom_end", "num_sites","missing", "s", "eta", "eta_e","pi","fuli_d","fuli_f","faywu_h" ,"pop", "window_id")], overwrite = FALSE, append=TRUE, row.names=FALSE)
    }
  }
}


#ihs
<locusID> <physicalPos> <'1' freq> <ihh1> <ihh0> <unstandardized iHS> <norm> <crit>
ihs_path <- "/run/user/1000/gvfs/smb-share:server=biocldap,share=scratch/merrimanlab/murray/working_dir/Phase3_selection_results/selscan_ihs/"
for (pop in pop_1kg[,2]){
  for(chr in 1:22){
    tmp <- read.table(paste0(ihs_path,pop,chr,".ihs.out.100bins.norm"), header=FALSE, stringsAsFactors = FALSE, sep="\t")
    names(tmp) <- c("locus_id", "chrom_start", "freq_1", "ihh1","ihh0", "unstd_ihs", "norm_ihs", "significant")
    tmp$pop <- which(pops$code==pop)
    tmp$chrom <- chr
    
    tmp$chrom_end <- tmp$chrom_start +1
    dbWriteTable(db, name = "ihs", tmp[,c("chrom","chrom_start","chrom_end", "locus_id", "freq_1", "ihh0", "ihh1", "unstd_ihs", "norm_ihs", "significant" ,"pop")], overwrite = FALSE, append=TRUE, row.names=FALSE)
  }
}
for (pop in c("AXIOM","OMNI")){
  for(info in c(0.3,0.8)){
    for(chr in 1:22){
      tmp <- read.table(paste0(ihs_path,"Info",info,"/",pop,chr,".ihs.out.100bins.norm"), header=FALSE, stringsAsFactors = FALSE, sep="\t")
      names(tmp) <- c("locus_id", "chrom_start", "freq_1", "ihh1","ihh0", "unstd_ihs", "norm_ihs", "significant")
      tmp$pop <- which(pops$code==paste0(pop,info))
      tmp$chrom <- chr
      
      tmp$chrom_end <- tmp$chrom_start +1
      dbWriteTable(db, name = "ihs", tmp[,c("chrom","chrom_start","chrom_end", "locus_id", "freq_1", "ihh0", "ihh1", "unstd_ihs", "norm_ihs", "significant" ,"pop")], overwrite = FALSE, append=TRUE, row.names=FALSE)
    }
  }
}


# nSL
dbGetQuery(db, "CREATE TABLE `nsl`(`chrom` smallint(3) unsigned,
           `chrom_start` int(10) unsigned,
           `chrom_end` int(10) unsigned,
            `locus_id` varchar (20),
           `freq_1` float,
            `sL1` float,
            `sL0` float,
            `unstd_nsl` float,
            `norm_nsl` float,
            `significant` boolean, 
           `pop` smallint(3) unsigned, 

            FOREIGN KEY (pop)
              references population (id)
            )ENGINE = INNODB;")
<locusID> <physicalPos> <'1' freq> <ihh1> <ihh0> <unstandardized iHS> <norm> <crit>
  nsl_path <- "/run/user/1000/gvfs/smb-share:server=biocldap,share=scratch/merrimanlab/murray/working_dir/Phase3_selection_results/selscan_nsl/"
for (pop in pop_1kg[,2]){
  for(chr in 1:22){
    tmp <- read.table(paste0(nsl_path,pop,chr,".nsl.out.100bins.norm"), header=FALSE, stringsAsFactors = FALSE, sep="\t")
    names(tmp) <- c("locus_id", "chrom_start", "freq_1", "sL1","sL0", "unstd_nsl", "norm_nsl", "significant")
    tmp$pop <- which(pops$code==pop)
    tmp$chrom <- chr
    
    tmp$chrom_end <- tmp$chrom_start +1
    dbWriteTable(db, name = "nsl", tmp[,c("chrom","chrom_start","chrom_end", "locus_id", "freq_1", "sL1", "sL0", "unstd_nsl", "norm_nsl", "significant" ,"pop")], overwrite = FALSE, append=TRUE, row.names=FALSE)
  }
}
for (pop in c("AXIOM","OMNI")){
  for(info in c(0.3,0.8)){
    for(chr in 1:22){
      tmp <- read.table(paste0(nsl_path,"Info",info,"/",pop,chr,".nsl.out.100bins.norm"), header=FALSE, stringsAsFactors = FALSE, sep="\t")
      names(tmp) <- c("locus_id", "chrom_start", "freq_1", "sL1","sL0", "unstd_nsl", "norm_nsl", "significant")
      tmp$pop <- which(pops$code==paste0(pop,info))
      tmp$chrom <- chr
      
      tmp$chrom_end <- tmp$chrom_start +1
      dbWriteTable(db, name = "nsl", tmp[,c("chrom","chrom_start","chrom_end", "locus_id", "freq_1", "sL1", "sL0", "unstd_nsl", "norm_nsl", "significant" ,"pop")], overwrite = FALSE, append=TRUE, row.names=FALSE)
    }
  }
}




dbGetQuery(db, "CREATE TABLE `xpehh_axiom`(`chrom` smallint(3) unsigned,
           `chrom_start` int(10) unsigned,
           `chrom_end` int(10) unsigned,
            `gpos` float,
           `popA_1_freq` float,
           `ihhA` float,
           `popB_1_freq` float,
           `ihhB` float,
           `unstd_xpehh` float,
           `norm_xpehh` float,
           `significant` boolean, 
           `popA` smallint(3) unsigned, 
           `popB` smallint(3) unsigned,
           
           FOREIGN KEY (popA)
           references population (id),
           FOREIGN KEY (popB)
           references population (id)
)ENGINE = INNODB;")
<locusID> <physicalPos> <geneticPos> <popA '1' freq> <ihhA> <popB '1' freq> <ihhB> <unstandardized XPEHH> <norm XPEHH> <significant (0/1)>
chr  pos     gpos    p1      ihh1    p2      ihh2    xpehh   normxpehh       crit
xpehh_path <- ""
for (pop2 in pop_1kg[,2]){
  pop = "AXIOM"
  for(info in c(0.3,0.8)){
    for(chr in 1:22){
      tmp <- read.table(paste0(xpehh_path,"Info",info,"/",pop,"_",pop2,'_',chr,".xpehh.out.norm"), header=FALSE, stringsAsFactors = FALSE, sep="\t", skip=1)
      names(tmp) <- c('chrom', "chrom_start",'gpos', "popA_1_freq", "ihhA",'popB_1_freq',"ihhB", "unstd_xpehh", "norm_xpehh", "significant")
      tmp$popA <- which(pops$code==paste0(pop,info))
      tmp$popB <- which(pops$code == pop2)
      
      tmp$chrom_end <- tmp$chrom_start +1
      dbWriteTable(db, name = "xpehh_axiom", tmp[,c("chrom","chrom_start","chrom_end",'gpos', "popA_1_freq", "popB_1_freq","ihhA", "ihhB", "unstd_xpehh", "norm_xpehh", "significant" ,"popA","popB")], overwrite = FALSE, append=TRUE, row.names=FALSE)
    }
  }
}

pop="AXIOM"
pop2="OMNI"
for(info in c(0.3,0.8)){
  for(chr in 1:22){
    tmp <- read.table(paste0(xpehh_path,"Info",info,"/",pop,"_",pop2,'_',chr,".xpehh.out.norm"), header=FALSE, stringsAsFactors = FALSE, sep="\t", skip=1)
    names(tmp) <- c('chrom', "chrom_start",'gpos', "popA_1_freq", "ihhA",'popB_1_freq',"ihhB", "unstd_xpehh", "norm_xpehh", "significant")
    tmp$popA <- which(pops$code==paste0(pop,info))
    tmp$popB <- which(pops$code == paste0(pop2,info))
    
    tmp$chrom_end <- tmp$chrom_start +1
    dbWriteTable(db, name = "xpehh_axiom", tmp[,c("chrom","chrom_start","chrom_end",'gpos', "popA_1_freq", "popB_1_freq","ihhA", "ihhB", "unstd_xpehh", "norm_xpehh", "significant" ,"popA","popB")], overwrite = FALSE, append=TRUE, row.names=FALSE)
  }
}



dbGetQuery(db, "CREATE TABLE `xpehh_omni`(`chrom` smallint(3) unsigned,
           `chrom_start` int(10) unsigned,
           `chrom_end` int(10) unsigned,
           `gpos` float,
           `popA_1_freq` float,
           `ihhA` float,
           `popB_1_freq` float,
           `ihhB` float,
           `unstd_xpehh` float,
           `norm_xpehh` float,
           `significant` boolean, 
           `popA` smallint(3) unsigned, 
           `popB` smallint(3) unsigned,
           
           FOREIGN KEY (popA)
           references population (id),
           FOREIGN KEY (popB)
           references population (id)
)ENGINE = INNODB;")
#<locusID> <physicalPos> <geneticPos> <popA '1' freq> <ihhA> <popB '1' freq> <ihhB> <unstandardized XPEHH> <norm XPEHH> <significant (0/1)>
chr  pos     gpos    p1      ihh1    p2      ihh2    xpehh   normxpehh       crit
xpehh_path <- ""
for (pop2 in pop_1kg[,2]){
  pop = "OMNI"
  for(info in c(0.3,0.8)){
    for(chr in 1:22){
      tmp <- read.table(paste0(xpehh_path,"Info",info,"/",pop,"_",pop2,'_',chr,".xpehh.out.norm"), header=TRUE, stringsAsFactors = FALSE, sep="\t")
      names(tmp) <- c('chrom', "chrom_start",'gpos', "popA_1_freq", "ihhA",'popB_1_freq',"ihhB", "unstd_xpehh", "norm_xpehh", "significant")
      tmp$popA <- which(pops$code==paste0(pop,info))
      tmp$popB <- which(pops$code == pop2)
      
      tmp$chrom_end <- tmp$chrom_start +1
      dbWriteTable(db, name = "xpehh_omni", tmp[,c("chrom","chrom_start","chrom_end",'gpos', "popA_1_freq", "popB_1_freq","ihhA", "ihhB", "unstd_xpehh", "norm_xpehh", "significant" ,"popA","popB")], overwrite = FALSE, append=TRUE, row.names=FALSE)
    }
  }
}




##
## Fst
##
CHROM   BIN_START       BIN_END N_VARIANTS      WEIGHTED_FST    MEAN_FST
dbGetQuery(db, "CREATE TABLE `fst_axiom`(`chrom` smallint(3) unsigned,
           `chrom_start` int(10) unsigned,
           `chrom_end` int(10) unsigned,
            `num_snps` int (10),
            `weighted_fst` float,
            `mean_fst` float,
            `window_id` smallint(3) unsigned,
           `popA` smallint(3) unsigned, 
          `popB` smallint(3) unsigned, 

            FOREIGN KEY (popA)
              references population (id),
            FOREIGN KEY (popB)
              references population (id),
            FOREIGN KEY (window_id)
              references window_info (id)
            )ENGINE = INNODB;")

fst_path <- "~/Murray/Bioinformatics/working_dir/Phase3_selection_results/FST/"
# CHROM   BIN_START       BIN_END N_VARIANTS      WEIGHTED_FST    MEAN_FST
window_info <- dbGetQuery(db, 'select * from window_info')
for (pop2 in pop_1kg[,2]){
  pop = "AXIOM"
  for(info in c(0.3,0.8)){
    print(pop2)
    for(chr in 1:22){
      print(chr)
      tmp <- read.table(paste0(fst_path,"Info",info,"/",pop,"_",pop2,chr,".windowed.weir.fst"), header=FALSE, stringsAsFactors = FALSE, sep="\t", skip=1)
      names(tmp) <- c("chrom", "chrom_start", "chrom_end", "num_snps", "weighted_fst", "mean_fst")
      w = tmp$chrom_end[3] - tmp$chrom_start[3] +1
      s = tmp$chrom_start[4] - tmp$chrom_start[3]
      tmp$window_id <- window_info[which(window_info$width == w & window_info$slide == s),'id']
      tmp$popA <- which(pops$code==paste0(pop,info))
      tmp$popB <- which(pops$code == pop2)
      
      dbWriteTable(db, name = "fst_axiom", tmp[,c("chrom","chrom_start","chrom_end","num_snps", "weighted_fst", "mean_fst", "window_id" ,"popA","popB")], overwrite = FALSE, append=TRUE, row.names=FALSE)
    }
  }
}

for (pop2 in pop_1kg[,2]){
  pop = "OMNI"
  for(info in c(0.3,0.8)){
    for(chr in 1:22){
      tmp <- read.table(paste0(fst_path,"Info",info,"/",pop,"_",pop2,chr,".windowed.weir.fst"), header=FALSE, stringsAsFactors = FALSE, sep="\t", skip=1)
      names(tmp) <- c("chrom", "chrom_start", "chrom_end", "num_snps", "weighted_fst", "mean_fst")
      w = tmp$chrom_end[3] - tmp$chrom_start[3] +1
      s = tmp$chrom_start[4] - tmp$chrom_start[3]
      tmp$window_id <- window_info[which(window_info$width == w & window_info$slide == s),'id']
      tmp$popA <- which(pops$code==paste0(pop,info))
      tmp$popB <- which(pops$code == pop2)
      
      dbWriteTable(db, name = "fst_omni", tmp[,c("chrom","chrom_start","chrom_end","num_snps", "weighted_fst", "mean_fst", "window_id" ,"popA","popB")], overwrite = FALSE, append=TRUE, row.names=FALSE)
    }
  }
}



for (pop2 in c("OMNI")){
  pop = "AXIOM"
  for(info in c(0.3,0.8)){
    for(chr in 1:22){
      tmp <- read.table(paste0(fst_path,"Info",info,"/",pop,"_",pop2,chr,".windowed.weir.fst"), header=FALSE, stringsAsFactors = FALSE, sep="\t", skip=1)
      names(tmp) <- c("chrom", "chrom_start", "chrom_end", "num_snps", "weighted_fst", "mean_fst")
      w = tmp$chrom_end[3] - tmp$chrom_start[3] +1
      s = tmp$chrom_start[4] - tmp$chrom_start[3]
      tmp$window_id <- window_info[which(window_info$width == w & window_info$slide == s),'id']
      tmp$popA <- which(pops$code==paste0(pop,info))
      tmp$popB <- which(pops$code == paste0(pop2,info))
      
      dbWriteTable(db, name = "fst_axiom", tmp[,c("chrom","chrom_start","chrom_end","num_snps", "weighted_fst", "mean_fst", "window_id" ,"popA","popB")], overwrite = FALSE, append=TRUE, row.names=FALSE)
    }
  }
}


for (pop2 in c("AXIOM")){
  pop = "OMNI"
  for(info in c(0.3,0.8)){
    for(chr in 1:22){
      tmp <- read.table(paste0(fst_path,"Info",info,"/",pop,"_",pop2,chr,".windowed.weir.fst"), header=FALSE, stringsAsFactors = FALSE, sep="\t", skip=1)
      names(tmp) <- c("chrom", "chrom_start", "chrom_end", "num_snps", "weighted_fst", "mean_fst")
      w = tmp$chrom_end[3] - tmp$chrom_start[3] +1
      s = tmp$chrom_start[4] - tmp$chrom_start[3]
      tmp$window_id <- window_info[which(window_info$width == w & window_info$slide == s),'id']
      tmp$popA <- which(pops$code==paste0(pop,info))
      tmp$popB <- which(pops$code == paste0(pop2,info))
      
      dbWriteTable(db, name = "fst_omni", tmp[,c("chrom","chrom_start","chrom_end","num_snps", "weighted_fst", "mean_fst", "window_id" ,"popA","popB")], overwrite = FALSE, append=TRUE, row.names=FALSE)
    }
  }
}