library(RPostgreSQL)
drv = dbDriver("PostgreSQL")
db = dbConnect(drv,dbname="selectiondw_test")

pops <- dbGetQuery(db, "select * from dimpopdata")


pop_1kg <- pops[1:26,]

pops_id = pops$id[34:39]

TD <-dbGetQuery(db, 'select posid,statvalue,statname,pop,rank from 
(select statvalue,statid,popid,posid,rank() over (partition by popid order by statvalue) rank from intrasel where statid = 1 and popid < 34) ranked 
inner join dimstat as ds on ds.statid = ranked.statid 
inner join dimpopdata as dp on dp.popid = ranked.popid 
where rank <= 1000;
                ')

TD_list = list()
for(POP in unique(TD$pop)){
  TD_list[[POP]] <- TD[TD$pop == POP,]
  names(TD_list[[POP]])[2] <- POP
}

combine=function(pop1,pop2){
  tmp = merge(pop1, pop2, by = 'posid', all=TRUE)
  #names(tmp)[names(tmp) == "tajimasd.x"] = paste0(pops[which(na.omit(tmp$pop.x) == pops$id), "code"] ,"_td")
  #names(tmp)[names(tmp) == "tajimasd.y"] = paste0(pops[which(na.omit(tmp$pop.y) == pops$id), "code"] ,"_td")
  tmp =tmp[,!names(tmp) %in% c("pop.x","pop.y","pop","statname.x", 'statname.y','rank.x','rank.y','statname','rank')]
  return(tmp)
}

m = combine(TD_list[[names(TD_list)[1]] ],TD_list[[names(TD_list)[2] ]])
for(POP in names(TD_list)[3:length(names(TD_list))]){
  m = combine(m, TD_list[[POP]])
  #print(POP)
}

for(POP in names(TD_list)){
  m[,POP] <- ifelse(is.na(m[,POP]),0,1)
}
n<- names(m)[-1]

paste(n, pops[which(pops$pop == n),'superpop'])
names(m)[-1] <-paste(names(m)[-1],'-',sapply(names(m)[-1], function(x){return(pops[pops$pop == x, 'superpop'])}))


plot(hclust(dist(t(m[,2:length(m)]), method="euclidean"), method = "single"), main = "Tajima D Clustering")

