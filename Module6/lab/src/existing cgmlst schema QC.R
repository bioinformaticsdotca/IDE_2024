## cgMLST QC utilizing existing schema

# define path for wgmlst data and metadata using here() from 'here' package

wgmlst_path <- here("data","wgMLST_calls","wgMLST.tsv")

meta_path <- here("data","metadata","meta_all.tsv")

## load wgMLST data

wgMLST <- fread(wgmlst_path,sep = "\t")

meta<- fread(meta_path,sep = "\t")

# load example schema data 
existing_schema_path <-  here("data","metadata","existing_sechma_example.tsv")

existing_schema <- fread(existing_schema_path,sep = "\t")

#  identify chewBBACA_cgmlst loci and cgmlst data

cgmlst <- wgMLST%>%
              select(1, existing_schema$locus)

# identify low qual genomes
cgmlst_completion  <- compute_gc(cgmlst)

# define QC threshold using missing cgmlst calls
QC_threshold <- as.integer(ncol(cgmlst)*0.01) + 1 ## 1% missing core loci per genome

## create cgMLST QC and output QA files
cgmlst_completion  <- cgmlst_completion %>%
                      mutate(QC_cgmlst = case_when(missing_alleles < QC_threshold ~ 1,
                                                    T ~ 0))

write.table(cgmlst_completion , here("output","quality_summary","existing_schema_cgmlst_genome_qual.stats.tsv"),
            quote = F, row.names = F, sep = "\t")
# 
# # print data summary of cgmlst completeness
# 
# summary(cgmlst_completion)

## Finalized dataset utilizing exsiting cgMLST Schema

## define final genomes
final_genomes <- cgmlst_completion%>%
                      filter(QC_cgmlst > 0)

## define final cgmlst dataset 
cgmlst_final <-  cgmlst%>%
                   filter(ID%in%final_genomes$ID)


## define final cgmlst meta data
metadata <- meta %>% filter(ID%in%cgmlst_final$ID)

# write to files
write.table(cgmlst_final,  here("data","wgMLST_calls","cgmlst_final_existing_schema.tsv"),
            quote = F, row.names = F, sep = "\t")

write.table(metadata, here("data","metadata","metadata_final_existing_schema.tsv"),
            quote = F, row.names = F, sep = "\t")


# print filtering results
message(paste("Number of original loci:", ncol(wgMLST)-1))
message(paste("Number of core loci included:", ncol(cgmlst_final)-1))
message(paste("Number of accessory loci excluded:",ncol(wgMLST)- ncol(cgmlst_final)-1))
message(paste("Number of genomes before filter:", nrow(cgmlst_completion)))
message(paste("Number of genomes after filter:", nrow(cgmlst_final)))
message(paste("Number of genomes removed:",nrow(cgmlst_completion)-nrow(cgmlst_final)))
