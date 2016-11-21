
setwd('~/Git_repos/SelectionDW_ETL/')
source('selection_etl_script_postgres.R')
init_()

# load core exome marker matched unimputed with 1kgp ####
data_dir <- '/media/xsan/scratch/merrimanlab/murray/working_dir/coreExome_selection/NZ/Unimputed_1kg_marker_matched/Results/'
for(chr in 1:22){
  print(chr)
  print('tajd')
  main(experiment_id = 5,results_directory = paste0(data_dir, 'tajd/chr',chr,'/'))
  print('fawh')
  main(experiment_id = 5,results_directory = paste0(data_dir, 'fawh/chr',chr,'/'))
  print('ihs')
  main(experiment_id = 5,results_directory = paste0(data_dir, 'ihs/norm/chr',chr,'/'))
  print('nsl')
  main(experiment_id = 5,results_directory = paste0(data_dir, 'nsl/norm/chr',chr,'/'))
  print('daf')
  main(experiment_id = 5,results_directory = paste0(data_dir, 'daf/chr',chr,'/'))
  
  print('_________________________________________')
  print("#########################################")
  print("#########################################")
  print('_________________________________________')
  
}
# print('fst')
# main(experiment_id = 5,results_directory = paste0(data_dir, 'fst/chr',chr,'/'))
# print('xpehh')
# main(experiment_id = 5,results_directory = paste0(data_dir, 'xpehh/norm/chr',chr,'/'))


# # for(chr in 1:22){
# #   main(experiment_id = 5,results_directory = paste0(data_dir, 'kaks/chr',chr,'/'))
# # }
#   
# #####
# 
# 
# # load axiom/omni phase 3 ####
# #axiom and omni info 0.3
# data_info03 <- '/media/xsan/scratch/merrimanlab/murray/working_dir/Phase3_selection_results/dbLoad/Info0.3/'
# main(experiment_id = 3,results_directory = paste0(data_info03, 'TajimaD/'))
# main(experiment_id = 3,results_directory = paste0(data_info03, 'FayWuH/'))
# 
# for(chr in 1:22){
#   message(chr)
#   main(experiment_id = 3,results_directory = paste0(data_info03, 'Selscan_ihs/chr',chr,'/'))
#   
# }
# 
# 
# 
# for(chr in 1:22){
#   message(chr)
#   main(experiment_id = 3,results_directory = paste0(data_info03, 'Selscan_nsl/chr',chr,'/'))
# }
# 
# 
# 
# data_info08 <- '/media/xsan/scratch/merrimanlab/murray/working_dir/Phase3_selection_results/dbLoad/Info0.8/'
# main(experiment_id = 4,results_directory = paste0(data_info08, 'TajimaD/'))
# main(experiment_id = 4,results_directory = paste0(data_info08, 'FayWuH/'))
# 
# for(chr in 1:22){
#   message(chr)
#   main(experiment_id = 4,results_directory = paste0(data_info08, 'Selscan_ihs/chr',chr,'/'))
#   
# }
# 
# 
# 
# for(chr in 1:22){
#   message(chr)
#   main(experiment_id = 4,results_directory = paste0(data_info08, 'Selscan_nsl/chr',chr,'/'))
# }
# ####