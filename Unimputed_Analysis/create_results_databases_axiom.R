library(RMySQL)
drv = dbDriver("MySQL")
db = dbConnect(drv, default.file = '~/.my.cnf', dbname="unimputed_axiom_selection")

pops = c("ACB", "ASW", "BEB", "CDX","CEU","CHB","CHS", "CLM", "ESN", 
         "FIN","GBR", "GIH", "GWD", "IBS", "ITU", "JPT", "KHV", "LWK",
         "MSL", "MXL", "PEL", "PJL", "PUR", "STU", "TSI","YRI",
         "AXIOM")



dbGetQuery(db, "CREATE TABLE `population` (`id` smallint(3) unsigned NOT NULL auto_increment,
           `code` VARCHAR(10),
            `super` VARCHAR(10),
            `description` VARCHAR(60),
           PRIMARY KEY (id)) 
           ENGINE = INNODB;")
for(pop in pops){
  dbGetQuery(db, paste0("INSERT into population (code) values ('",pop,"');"))
  
}
dbGetQuery(db, "CREATE TABLE `window_info` (`id` smallint(3) unsigned NOT NULL auto_increment, 
           `width` int(10), 
           `slide` int(10), 
           PRIMARY KEY (id))
           ENGINE=INNODB;")
#dbGetQuery(db, "INSERT INTO window_info (width, slide) values ( 30000, 30000);")

dbGetQuery(db, "CREATE TABLE `tajd`(`chrom` smallint(3) unsigned,
           `chrom_start` int(10) unsigned,
           `chrom_end` int(10) unsigned, 
           `num_snps` int(10) unsigned, 
           `tajimasd` float, 
           `pop` smallint(3) unsigned,
            `window_id` smallint(3) unsigned,
            foreign key (pop)
           references population (id),
          
            foreign key (window_id)
              references window_info (id)
           ) ENGINE = INNODB;")


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

# xpehh
dbGetQuery(db, "CREATE TABLE `xpehh`(`chrom` smallint(3) unsigned,
           `chrom_start` int(10) unsigned,
           `chrom_end` int(10) unsigned,
            `locus_id` varchar (20),
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

# ihs
dbGetQuery(db, "CREATE TABLE `ihs`(`chrom` smallint(3) unsigned,
           `chrom_start` int(10) unsigned,
           `chrom_end` int(10) unsigned,
            `locus_id` varchar (20),
           `freq_1` float,
            `ihh1` float,
            `ihh0` float,
            `unstd_ihs` float,
            `norm_ihs` float,
            `significant` boolean, 
           `pop` smallint(3) unsigned, 

            FOREIGN KEY (pop)
              references population (id)
            )ENGINE = INNODB;")

# kaks
dbGetQuery(db, "CREATE TABLE `kaks`(`chrom` smallint(3) unsigned,
           `gene_id` varchar (20),
           `gene_name` varchar(20),
            `ka` int(10),
            `ks` int(10),
           `pop` smallint(3) unsigned, 

            FOREIGN KEY (pop)
              references population (id)
            )ENGINE = INNODB;")

# DAF
#<pos> <Ref> <Alt> <Anc> <MAF> <DAF>
dbGetQuery(db, "CREATE TABLE `allele_freq`(`chrom` smallint(3) unsigned,
           `chrom_start` int(10) unsigned,
           `chrom_end` int(10) unsigned,
            `ref` varchar (3),
           `alt` varchar (3),
            `anc` varchar (3),
            `maf` float,
            `daf` float,
           `pop` smallint(3) unsigned, 

            FOREIGN KEY (pop)
              references population (id)
            )ENGINE = INNODB;")

# fst
#CHROM   BIN_START       BIN_END N_VARIANTS      WEIGHTED_FST    MEAN_FST
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




dbGetQuery(db, "INSERT INTO window_info (width, slide) values (30000, 30000);")
dbGetQuery(db, "INSERT INTO window_info (width, slide) values ( 1000000, 1000);")


