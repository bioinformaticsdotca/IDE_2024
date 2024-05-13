# create summary table showing counts
# of metadata variables across clusters

count_variables_by_cluster <- function(
    distance_threshold = 50, # the dist threshold used for cluster definition?
    vars = c("Country", "Source") # metadata vars only
) {
  
  if ( is.null(distance_threshold) ) { 
    stop("Please specify a value for `distance_threshold`")
  }
  
  
  target_variable <- paste0("Threshold_", distance_threshold)
  
  cluster_1 <-  clusters %>% select(ID, !!sym(target_variable))
  # set random seed
  set.seed(123)
  
  local_meta <- metadata %>% 
    left_join(cluster_1, by = "ID") %>% 
     select(ID, !!sym(target_variable), everything()) %>% 
      pivot_longer(cols = 3:ncol(.),
                 names_to = "variable",
                 values_to = "value") %>% 
    filter(variable %in% vars) %>% 
    rename("cluster" = target_variable) 
  
  ## Count varibles at threshold 
  
  summary_table <- local_meta%>%
                    group_by(cluster,value)%>%
                     summarise(n=n())%>%
                      pivot_wider(names_from = value,
                                  values_from = n) %>%
                          mutate(cluster = as.character(cluster))%>%
                            ungroup()
   ## change na to 0                   
  summary_table[is.na(summary_table)] <- 0
  
  ## reorder summary table columns 
  
  get_unique_colname <- function(column) {
    data.frame(colName = unique(column) %>% as.character() %>% sort())
  }
  
  colname_names <-metadata %>% 
                 select( vars) %>%
                  map(get_unique_colname)%>%
                   bind_rows()
  
  summary_table<- summary_table%>%
                       select(1:2,colname_names$colName)
  
  ## compute percentage for each cluster  
  
  cluster_count <-  metadata %>% 
                  left_join(
                   clusters %>% select(ID, !!sym(target_variable)),by = "ID"
                    ) %>% 
                  group_by(!!sym(target_variable))%>%
                  summarise(Count= n())%>%
                       ungroup()
 ## rename column names
 colnames(cluster_count )  <- c("cluster", "Count")
 
 ## merge count table and pertage table
 
 summary_table <- cluster_count%>%
                    left_join(summary_table, by =  "cluster")
 
  return(summary_table)
}
