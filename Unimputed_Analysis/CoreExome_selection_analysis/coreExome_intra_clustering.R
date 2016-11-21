library(RPostgreSQL)
drv = dbDriver("PostgreSQL")
db = dbConnect(drv,dbname="selectiondw_test")

combine=function(pop1,pop2){
  tmp = merge(pop1, pop2, by = 'posid', all=TRUE)
  tmp =tmp[,!names(tmp) %in% c("pop.x","pop.y","pop","statname.x", 'statname.y','rank.x','rank.y','statname','rank')]
  return(tmp)
}


pops <- dbReadTable(db, "dimpopdata")


pop_1kg <- pops[1:26,]

pops_id = pops$id[34:39]

dimStat <- dbReadTable(db, 'dimstat')
topN<-1000
stats <- c("TajimaD","FayWu_H","norm_ihs","norm_nsl")

for (stat in stats){

    statid <- dimStat[dimStat$statname == stat,'statid']

    statvalue <- 'statvalue'
    if(stat %in% c('norm_ihs','norm_nsl')){
        statvalue <- 'abs(statvalue)'
    }


query <-dbGetQuery(db, 
                   paste0('select posid,statvalue,statname,pop,rank from
                          (select statvalue,statid,popid,posid,rank() over (partition by popid order by ',statvalue,') rank from intrasel where statid = ', statid ,' and popid < 34) ranked 
                          inner join dimstat as ds on ds.statid = ranked.statid 
                          inner join dimpopdata as dp on dp.popid = ranked.popid 
                          where rank <= ',topN,';
                ')
                )


    query_list = list()
    for(POP in unique(query$pop)){
        query_list[[POP]] <- query[query$pop == POP,]
        names(query_list[[POP]])[2] <- POP
    }

    m = combine(query_list[[names(query_list)[1]] ],query_list[[names(query_list)[2] ]])
    for(POP in names(query_list)[3:length(names(query_list))]){
        m = combine(m, query_list[[POP]])
        #print(POP)
    }

    for(POP in names(query_list)){
        m[,POP] <- ifelse(is.na(m[,POP]),0,1)
    }
    n<- names(m)[-1]

    paste(n, pops[which(pops$pop == n),'superpop'])
    names(m)[-1] <-paste(names(m)[-1],'-',sapply(names(m)[-1], function(x){return(pops[pops$pop == x, 'superpop'])}))

    pdf(paste0('~/Git_repos/selectionAnalysis/Unimputed_Analysis/CoreExome_selection_analysis/coreExome_',stat,'_clustering.pdf'))
        plot(hclust(dist(t(m[,2:length(m)]), method="euclidean"), method = "single"), main = paste(stat, "Clustering"))
    heatmap(as.matrix(m[,2:length(m)]), distfun = function(y) dist(y, method="euclidean"),scale='none',col=c('white','black'))
    dev.off()
}
