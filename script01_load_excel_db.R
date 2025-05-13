# script01_load_excel_db.R

library(readxl)
library(tidyverse)

# Examine Excel data set
read_excel("ytube_characteristics_2021_12_30.xlsx")
# # A tibble: 616 × 3
#   RefID Field          Content                                       
#   <dbl> <chr>          <chr>                                         
# 1     1 paper_doi      10.1007/s10886-021-01291-w                    
# 2     1 journal        Journal of Chemical Ecology                   
# 3     1 paper_citation Debnath et al. 2021, J. Chem. Ecol. 47,664-679
# 4     1 moth_spp       Diaphania indica                              
# 5     1 moth_sex       female                                        
# 6     1 volatile1      pentadecane                                   

# Load to Global Enviornment
df_ytube_lit <- read_excel("ytube_characteristics_2021_12_30.xlsx")

# Examine number of RefID and obs per RefID
df_ytube_lit %>% 
  group_by(RefID) %>% 
  summarise(nObs = n())
# # A tibble: 28 × 2
#   RefID  nObs
#   <dbl> <int>
# 1     1    22
# 2     2    22
# 3     3    22
# 4     4    22

# Examine values of Field
unique(df_ytube_lit$Field)
# [1] "paper_doi"           "journal"             "paper_citation"      "moth_spp"            "moth_sex"           
# [6] "volatile1"           "volatile2"           "volatile3"           "volatile4"           "ytube_angle"        
# [11] "ytube_armlngth"      "ytube_bodylngth"     "ytube_diam"          "ytube_arm_mtrl"      "ytube_body_mtrl"    
# [16] "ytube_gas_source"    "ytube_hum_control"   "ytube_filtering"     "ytube_working_solv"  "ytube_cleaning_solv"
# [21] "ytube_manufctr"      "note"   

# Pivot wide--1 record per RefID
df_ytube_wide <- df_ytube_lit %>% 
  pivot_wider(names_from = Field, values_from = Content)

# Correct data type for numerical fields
df_ytube_wide$ytube_angle <- as.numeric(df_ytube_wide$ytube_angle)
df_ytube_wide$ytube_armlngth <- as.numeric(df_ytube_wide$ytube_armlngth)
df_ytube_wide$ytube_bodylngth <- as.numeric(df_ytube_wide$ytube_bodylngth)
df_ytube_wide$ytube_diam <- as.numeric(df_ytube_wide$ytube_diam)

# Use db to examine the data
journals <- data.frame(title = df_ytube_wide$journal)

journals %>% 
  filter(!is.na(title)) %>% 
  group_by(title) %>% 
  summarise(nObs = n()) %>% 
  arrange(desc(nObs))
# # A tibble: 19 × 2
#   title                                     nObs
#   <chr>                                    <int>
# 1 Entomologia Experimentalis et Applicata      4
# 2 Journal of Chemical Ecology                  3
# 3 Chemoecology                                 2
# 4 Environmental Entomology                     2
# 5 Plos ONE                                     2
# 6 ACTA Ecologica Sinica                        1
# 7 Brazilian Journal of Medicinal Plants        1
# 8 Bulletin of Entomological Research           1
# 9 Insect Science                               1
# 10 Insects                                      1
# 11 Journal of Applied Entomology                1
# 12 Journal of Asia-Pacific Entomology           1
# 13 Journal of Economic Entomology               1
# 14 Journal of Insect Behavior                   1
# 15 Journal of Plant Diseases and Protection     1
# 16 Journal of Stored Products Research          1
# 17 Physiological Entomology                     1
# 18 Phytoparasitica                              1
# 19 Turkish Journal of Entomology                1

# Save the wide from as an R dataset and as csv
saveRDS(df_ytube_wide,"ytube_lit_1rec_per_paper.Rds")
write.csv(df_ytube_wide,"ytube_lit_1rec_per_paper.csv",row.names = F)
