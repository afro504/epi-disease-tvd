source('dataset.R')

#001.CREATE THE LIST FOR FILTER---------------------------------------------------

#001.1. LIST IN SIDEBAR FOR dim1_type,dim1, dim2_type, dim2, dim3_type, dim3-------------------------------
#fct_list_filter <- function(fctfilter,a="col_ref"){
  
#  list_1_df <- tvd_dts%>% # Gloabal dataset GHO + Repository
#    ungroup()%>%
#    select(dim1_type,dim1,dim2_type,dim2, dim3_type, dim3)%>%
#    group_by(dim1_type,dim1,dim2_type,dim2, dim3_type, dim3)%>%
#    distinct()%>%
# #   distinct(indicator_code,  .keep_all = TRUE)%>%  ## delete duplicate for item in column
#    slice(1)%>%
#    select(dim1_type,dim1,dim2_type,dim2, dim3_type, dim3)%>%
#    as.data.table()
  
#  list_1_df$index_list_1 <- 1:nrow(list_1_df) # to add index 

  # filter by label
#  myrownames_label<-unique(a) # selection only list to create row head
# rowNames_data_label<-c() #preparing vector
# for (k in myrownames_label) {
#    rowNames_data_label <- c(rowNames_data_label, unique(a))
#  }
  
#  return(rowNames_data_label)
  
#}

# rowNames_dim1_type<-fct_list_filter(a=list_1_df[,1])
# rowNames_dmi1<-fct_list_filter(a=list_1_df[,2])
# rowNames_dim2_type<-fct_list_filter(a=list_1_df[,3])
# rowNames_dmi2<-fct_list_filter(a=list_1_df[,4])
# rowNames_dim3_type<-fct_list_filter(a=list_1_df[,5])
# rowNames_dmi3<-fct_list_filter(a=list_1_df[,6])




#001.2  FILTER LIST COUNTRY------------------------------
#filter_country<-getAPI_Country()%>%
#filter_country<-tvd_dts%>%
#  filter(!is.na(iso))%>%
# select(country,iso#,flag
#         )%>%
  # distinct(country,  .keep_all = TRUE)%>%
  # filter(country!="",iso!="MYT")

  #Afroname <- data.frame(country = c("WHO African Region"),iso=c("AFRO")#,flag=c("wa")
#                        )
#filter_country<-rbind(filter_country, Afroname)%>%
# as.data.table()
#
# filter_country$index_country <- 1:nrow(filter_country) # to add index 

## FILTER FLAG--------------------------
#flag_country<-getAPI_Country()%>%
#  filter(!is.na(iso))%>%
# select(flag,iso ,subregion,population,ref_data,data_source,country_class
# )






#001.3  FILTER LIST component ------------------------------
#tvd_component<-tvd_dts%>% 
# # tvd_component<-getAPI_Component()%>%
#  select(component)%>%
#    distinct(component,  .keep_all = TRUE)

#  Afroname_tvd <- data.frame(component = c("All Group"))

#  tvd_component<-rbind(tvd_component, Afroname_tvd)%>%
#    as.data.table()

#  tvd_component$index_component <- 1:nrow(tvd_component) #




#001.4 FILTER LIST Sub component---------------------------

  #tvd_subcomponent <- tvd_dts%>%
  #    filter(!is.na(iso))%>%
    ##  tvd_subcomponent <- getAPI_SubComponent()%>%
  #  group_by(component,sub_component)%>%
  #  slice(1)%>%
  #  select(component, sub_component)%>%
  #  as.data.table()

  #tvd_subcomponent$index_subcomponent <- 1:nrow(tvd_subcomponent) # to add index 


#001.5 FILTER LIST INDICATOR---------------------------
#tvd_indicator <-tvd_dts%>%
#  filter(!is.na(iso))%>%
# select(indicator_code)%>%
#  unique%>%
#  left_join(getAPI_Indicator()%>%
#              filter(indicator!="")%>%
#              mutate(indicator=str_replace_all(str_squish(str_sub(indicator, 1, 80)),"[\r\n\t]+", " "))%>%
## # mutate(indicator=str_replace_all(str_squish(str_sub(indicator, 1, 80)),"[\r\n\t]+", " "))%>% #remplace tabulations et retours par un espace simple, supprime espaces multiples + début/fin et limiter à 80 caractères
#  group_by(component,sub_component,indicator,indicator_code,indicator_source,indicator_unit,category_indicator,indicator_metric,performance_indicator,indicator_target, type_indicator),by = c("indicator_code" = "indicator_code"))%>%
##  #slice(1)%>%
#  unique()%>%
#  select(component, sub_component,indicator,indicator_code,indicator_source,indicator_unit,category_indicator,indicator_metric,performance_indicator,indicator_target,type_indicator)#%>%#  as.data.table()

#tvd_indicator$index_indicator <- 1:nrow(tvd_indicator) # to add index 

#View(tvd_indicator)

  
#004 FILTER FOR INDICATOR DESAGREGATION---------------------------------------------------

#lbl_gpe_report<-tvd_dts%>%
#  select(dim1_type,indicator_code)%>%
#  rename("Component"="dim1_type")%>%
#  mutate(sub_grps="First dimension")%>%
#  distinct_all()%>%
#  bind_rows(tvd_dts%>%
#              select(dim1,indicator_code)%>%
#              rename("Component"="dim1")%>%
#              mutate(sub_grps="Sex")%>%
#              distinct_all())%>%
#  bind_rows(tvd_dts%>%
#              select(dim2_type,indicator_code)%>%
#              rename("Component"="dim2_type")%>%
#              mutate(sub_grps="Second dimension")%>%
#              distinct_all())%>%
#  bind_rows(tvd_dts%>%
#              select(dim2,indicator_code)%>%
#              rename("Component"="dim2")%>%
#              mutate(sub_grps="group")%>%
#              distinct_all())%>%
#  bind_rows(tvd_dts%>%
#              select(dim3_type,indicator_code)%>%
#              rename("Component"="dim3_type")%>%
#              mutate(sub_grps="Third dimension")%>%
#              distinct_all())%>%
#  bind_rows(tvd_dts%>%
#              select(dim3,indicator_code)%>%
#              rename("Component"="dim3")%>%
#              mutate(sub_grps="Other group")%>%
#              distinct_all())%>%
#  distinct_all()
  
  

#lbl_gpe_reports<-lbl_gpe_report%>%
#  left_join(
#    tvd_dts %>% 
#      select(indicator_code, sub_component) %>% 
#      distinct(indicator_code, .keep_all = TRUE),
#    by = "indicator_code"
#  )%>%

# # left_join(tvd_dts%>%select(indicator_code,sub_component), by=c("indicator_code"="indicator_code"))%>%
#  filter(Component!='NA')%>%  
#  select(sub_grps,sub_component)%>%
#  distinct_all()
 
  #distinct(sub_grps,  .keep_all = TRUE)

#lbl_gpe_reports$index_gpe <- 1:nrow(lbl_gpe_reports) #

#myrownames_gpe<-lbl_gpe_reports[,1]




#lbl_gpe_rep<-lbl_gpe_reports%>%
#  select(sub_grps)%>%
#  distinct(sub_grps,  .keep_all = TRUE)

#All_gpe <- data.frame(sub_grps = c("All"))
#lbl_gpe_rep<-rbind(lbl_gpe_rep, All_gpe)%>%
#  as.data.table()
#lbl_gpe_rep$index_gpe <- 1:nrow(lbl_gpe_rep)







categ_list<-tvd_indicator%>%
  select(category_indicator)%>%
  unique

categ_list$index_categ <- 1:nrow(categ_list) # to add index 

myrownames_categ<-categ_list[,1]# selection only list to create row head
rowNames_categ<-c() #preparing vector
for (k in myrownames_categ) {
  rowNames_categ <- c(rowNames_categ, categ_list[,1])
}
rowNames_categ<-c(rowNames_categ$category_indicator)




#001.8 FILTER LIST REF.SOURCE----------------------------
#group_ref_data<-tvd_dts%>%
#  filter(!is.na(iso))%>%
#  distinct(ref_data,  .keep_all = TRUE)%>%  ## delete duplicate for item in column
# select(ref_data)

#001.9 FILTER LIST COUNTRY FROM DOWLOAD SECTION-------------------------------------

#country_download_list<-getAPI_Country()%>%
#  filter(id<=47)%>%
#  select(country)

#Afroname <- data.frame(country = c("WHO African Region"))

#country_download_list<-rbind(country_download_list, Afroname)%>%
#  as.data.table()

#country_download_list$index_country_download_list <- 1:nrow(country_download_list) # to add index 


### FOR MAP------------------------------

#spdf_africa1 <- ne_countries(continent = 'africa')


#sf::sf_use_s2(TRUE)

#result <- c()
#for (x in spdf_africa1$adm0_a3){
#  if (x %in% c("EGY","DJI","SOM","ESH","LBY","MAR","SDN","SSD","TUN")){
#    result <- c(result, "#009E73")
#  } else {
#   result <- c(result, "#F0E442")
# }
#}
#spdf_africa1$afro <- result

#spdf_africa2a <- sf::st_as_sf(spdf_africa1) # To create an sf object from a SpatVector like this:


#plot(spdf_africa2a[,"afro"])
#str(spdf_africa1a)
#spdf_africa1 = st_make_valid(spdf_africa1)
#plot(spdf_africa2a[,5])

#spdf_africa1$afro
#ne_download(returnclass = 'sf')`

#as(st_geometry(spdf_africa1), "Spatial")
#View(spdf_africa2a)
#View(spdf_africa1a@data)
#str(spdf_africa2a)
#plot(spdf_africa1$isNLD)

#plot(sudan[,5])
#sudan <- ne_countries(country = "sudan")

#dput(names(spdf_africa_prod_sh_disease))

# Define the countries you want in green
#green_countries <- c("EGY","DJI","SOL","SOM","SAH","LBY","MAR","SDN","TUN")

# Assign colors directly with vectorization
#spdf_africa1$afro <- ifelse(spdf_africa1$adm0_a3 %in% green_countries,
#                            "#009E73",  # green
#                            "#F0E442")  # yellow

# Convert to sf object
#spdf_africa_prod_sh_disease <- sf::st_as_sf(spdf_africa_prod_sh_disease)

# Plot
#plot(spdf_africa_prod_sh_disease["group_index"])




# spdf_africa1 <- spdf_africa1 %>%
#   mutate(afro = case_when(
#     adm0_a3 %in% green_countries ~ "#009E73",
#     TRUE ~ "#F0E442"
#   ))

# spdf_africa2a <- sf::st_as_sf(spdf_africa1)
# plot(spdf_africa2a["afro"])

##unique(spdf_africa_prod_sh_disease$adm0_a3) #Confirm Sudan’s code exists in your attribute table

##-------------------TEST--------------------


# Fonction pour extraire les valeurs uniques d'une colonne
#fct_list_filter <- function(a) {
#  return(unique(a))
#}

## Création des listes de dimensions
#list_1_df <- tvd_dts %>%
#  ungroup() %>%
#  select(dim1_type, dim1, dim2_type, dim2, dim3_type, dim3) %>%
#  distinct() %>%
#  as.data.table()

#list_1_df$index_list_1 <- seq_len(nrow(list_1_df))

#rowNames_dim1_type <- fct_list_filter(list_1_df$dim1_type)
#rowNames_dmi1      <- fct_list_filter(list_1_df$dim1)
#rowNames_dim2_type <- fct_list_filter(list_1_df$dim2_type)
#rowNames_dmi2      <- fct_list_filter(list_1_df$dim2)
#rowNames_dim3_type <- fct_list_filter(list_1_df$dim3_type)
#rowNames_dmi3      <- fct_list_filter(list_1_df$dim3)

## Filtre pays
filter_country <- tvd_dts %>%
  filter(!is.na(iso), country != "", iso != "MYT") %>%
  select(country, iso) %>%
  distinct(country, .keep_all = TRUE) %>%
  as.data.table()

Afroname <- data.frame(country = "WHO African Region", iso = "AFRO")
filter_country <- rbind(filter_country, Afroname) %>%
  as.data.table()
filter_country$index_country <- seq_len(nrow(filter_country))

# Composants
tvd_component <- tvd_dts %>%
  select(component) %>%
  distinct(component, .keep_all = TRUE) %>%
  as.data.table()

Afroname_tvd <- data.frame(component = "All Group")
tvd_component <- rbind(tvd_component, Afroname_tvd) %>%
  as.data.table()
tvd_component$index_component <- seq_len(nrow(tvd_component))

# Sous-composants
tvd_subcomponent <- tvd_dts %>%
  filter(!is.na(iso)) %>%
  group_by(component, sub_component) %>%
  slice(1) %>%
  select(component, sub_component) %>%
  as.data.table()
tvd_subcomponent$index_subcomponent <- seq_len(nrow(tvd_subcomponent))

# Indicateurs
tvd_indicator <- tvd_dts %>%
  filter(!is.na(iso)) %>%
  select(indicator_code) %>%
  distinct() %>%
  left_join(
    getAPI_Indicator() %>%
      filter(indicator != "") %>%
      mutate(indicator = str_replace_all(
        str_squish(str_sub(indicator, 1, 80)),
        "[\r\n\t]+", " "
      )),
    by = "indicator_code"
  ) %>%
  distinct() %>%
  select(component, sub_component, indicator, indicator_code,
         indicator_source, indicator_unit, category_indicator,
         indicator_metric, performance_indicator, indicator_target,
         type_indicator) %>%
  as.data.table()

tvd_indicator$index_indicator <- seq_len(nrow(tvd_indicator))

# Catégories
categ_list <- tvd_indicator %>%
  select(category_indicator) %>%
  distinct() %>%
  as.data.table()
categ_list$index_categ <- seq_len(nrow(categ_list))
rowNames_categ <- categ_list$category_indicator

# Références
group_ref_data <- tvd_dts %>%
  filter(!is.na(iso)) %>%
  distinct(ref_data, .keep_all = TRUE) %>%
  select(ref_data)

# Carte Afrique
spdf_africa1 <- ne_countries(continent = "africa")

result <- ifelse(spdf_africa1$adm0_a3 %in% c("EGY","DJI","SOM","ESH","LBY","MAR","SDN","SSD","TUN"),
                 "#009E73", "#F0E442")
spdf_africa1$afro <- result

spdf_africa2a <- sf::st_as_sf(spdf_africa1)


# Flag and country subdivision: population, classe and subregion

flag_country <- getAPI_Country() %>%
  filter(!is.na(iso)) %>%
  select(flag, iso, subregion, population, ref_data, data_source, country_class)


dfm_stat <- tvd_dts %>%
  select(component,sub_component,indicator, indicator_code, iso, country, numeric_value, alpha_value,year_api) %>%
  left_join(flag_country, by = "iso") %>%
  select(iso, subregion, country_class, population,component,sub_component,
         indicator, indicator_code,year_api, numeric_value,alpha_value) %>%
  data.table()


data_st_disease_all <- dfm_stat %>%
  ungroup() %>%
  filter(!is.na(year_api),  numeric_value>0) %>%   # uso == en lugar de %in% para un solo valor
  group_by(sub_component, indicator_code, iso) %>%
  summarise(year_api = max(year_api, na.rm = TRUE), .groups = "drop") %>%
  ungroup() %>%
  mutate(kp = paste(indicator_code, iso, year_api, sep = "-")) %>%
  select(sub_component, indicator_code, iso, year_api, kp) %>%
  left_join(
    dfm_stat %>%
      filter(!is.na(year_api), numeric_value>0) %>%
      mutate(kp = paste(indicator_code, iso, year_api, sep = "-")) %>%
      select(kp, numeric_value),
    by = "kp"
  ) %>%
  select(iso, sub_component, indicator_code, year_api, numeric_value) %>%
  distinct()
  

#####TesT-------------------------------


