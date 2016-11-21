setwd('~/Git_repos/SelectionDW_ETL/')
source('selection_etl_script_postgres.R')

data_dir <- '/media/xsan/scratch/merrimanlab/murray/working_dir/coreExome_selection/NZ/Unimputed_1kg_marker_matched/Results/'
for(chr in 1:22){
  print(chr)
    print('fst')
  main(experiment_id = 5,results_directory = paste0(data_dir, 'fst/chr',chr,'/'))
  print('xpehh')
  main(experiment_id = 5,results_directory = paste0(data_dir, 'xpehh/norm/chr',chr,'/'))
  
  print('_________________________________________')
  print("#########################################")
  print("#########################################")
  print('_________________________________________')
  
}

