library(dplyr)
window=30000
setwd("~/MurrayXsan/Bioinformatics/working_dir/extract/TajD/")

TD=data.frame()
for( POP in c("AXIOM","OMNI","CEU","CHB","CHS","GBR","YRI")){
  TD=data.frame()
  for( i in 1:22){
    TD=rbind(TD,read.table(file = paste0(POP,i,".taj_d"), header=TRUE))
  }
  TD = TD %>% mutate(BIN_END = BIN_START + window-1)
  TD$POP = POP
  colnames(TD)=c("chrom", "chrom_start", "num_snps", "TajimasD", "chrom_end", "Population")
  write.table(TD[,c("chrom", "chrom_start", "chrom_end", "num_snps", "TajimasD","Population" )], file=paste0("~/",POP,"_TD.txt"), row.names=FALSE, col.names=TRUE, sep="\t", quote=FALSE)

}


library(RMySQL)
drv = dbDriver("MySQL")
db = dbConnect(drv, user="murray", host="127.0.0.1", dbname="selection")

dbGetQuery(db, "CREATE TABLE `tajimasd`(`chrom` int(31),`chrom_start` int(10),`chrom_end` int(10), `num_snps` int(10), `TajimasD` float, `Population` varchar(20) );")
for(POP in c("AXIOM","OMNI","CEU","CHB","CHS","GBR","YRI")){
  dbGetQuery(db,paste0("load data infile '/home/murraycadzow/",POP,"_TD.txt' into table tajimasd fields terminated by '\t' lines terminated by '\n' ignore 1 rows;"))
}







##mysql
#CREATE TABLE `omni_ihs`(`chrom` int(31),`chrom_start` int(10),`chrom_end` int(10),`marker` varchar(40), `iHS` float, `iHS_rank` int(10),`neglogPvalue` float,`Population` varchar(20) );

#load data infile '/home/murraycadzow/axiom_ihs.txt' into table axiom_ihs fields terminated by '\t' lines terminated by "\n" ignore 1 rows;
