# Packages nécessaires
# Packages nécessaires
source('dependencies.R')

##001 GET REQUEST FROM AN API===============================================================

#001.1 List of indicators get from my Python app --------------------------------------
# api_indicator <- fromJSON(readLines('http://127.0.0.1:8000/json_indicator')[1])%>% 
# rename("component"="subcomponent__component__component_name",
#       "sub_component"="subcomponent__subcomponent_name",
#       "indicator"="indicator_name",
#       "indicator_code"="indicator_code")%>% # rename the column name after downloaded
# as.data.table() #Transform to data table



#001.2 List of country get from my Python app --------------------------------------
#api_country <- fromJSON(readLines('http://127.0.0.1:8000/json_country')[1])%>% 
#rename("country"="name",
#      "iso"="cca3")%>%# rename the column name after downloaded
#  as.data.table() #Transform to data table


#001.3 Geolocalisation of country get from my Python app --------------------------------------
# api_location <- fromJSON(readLines('http://127.0.0.1:8000/json_location')[1])%>% 
#rename("country"="name",
#       "iso"="iso3")%>%
#  as.data.table() #Transform to data table


#001.4 dataset get from my Python app that connected with API for Global Health observatory-----------------
#api_storeapi <- fromJSON(readLines('http://127.0.0.1:8000/json_storeAPI')[1])%>% 
#rename("iso"="country_code",
#       "year_api"="time_dim")%>%
#  as.data.table() #Transform to data table



#001.5 Dataset get from my Python app that upload data from Excel file --------------------------------------
#api_repository <- fromJSON(readLines('http://127.0.0.1:8000/json_repository')[1])%>% 
#rename("component"="indicator__subcomponent__component__component_name",
#       "sub_component"="indicator__subcomponent__subcomponent_name",
#       "country"="country__name",
#       "iso"="spatial_dim",
#      "indicator"="indicator__indicator_name",
#      "indicator_code"="indicator__indicator_code")%>%
#  as.data.table() #Transform to data table


#001.6 List of component get from my Python app --------------------------------------
# api_component <- fromJSON(readLines('http://127.0.0.1:8000/json_component')[1])%>% 
#  rename("component"="component_name")%>%
#  as.data.table() #Transform to data table



#001.7 List of sub component get from my Python app --------------------------------------
#api_subcomponent <- fromJSON(readLines('http://127.0.0.1:8000/json_subcomponent')[1])%>% 
# rename("component"="component__component_name",
#       "sub_component"="subcomponent_name")%>%
#  as.data.table() #Transform to data table




#001.8 List of survey project get from my Python app --------------------------------------
#api_surveyproject <- fromJSON(readLines('http://127.0.0.1:8000/json_surveyproject')[1])%>% 
#rename("population"="target_population")%>%
#  as.data.table() #Transform to data table


#001.9 Dataset get from my Python app that upload data survey in Excel format --------------------------------------
#api_surveydataset <- fromJSON(readLines('http://127.0.0.1:8000/json_surveydataset')[1])%>% 
#rename("responsible"="surveyProject__responsible",
#       "title_surv"="surveyProject__title_surv",
#       "start_date"="surveyProject__start_date",
#       "end_date"="surveyProject__end_date",
#       "location_survey"="surveyProject__location_survey",
#       "code"="quest_code",
#       "level_first"="level_1",
#       "level_second"="level_2")%>%
#  as.data.table() #Transform to data table



#001.10 List of USER get from my Python app --------------------------------------
#api_user <- fromJSON(readLines('http://127.0.0.1:8000/json_user')[1])%>%
#  as.data.table() #Transform to data table


#result
#spdf_africa1$afro<-result

#spdf_africa1a <- sf::st_as_sf(spdf_africa1) # To create an sf object from a SpatVector like this:


  





#002. CONNECT TO RSQLITE ---------
#conn <- dbConnect(RSQLite::SQLite(), "books.sqlite")

#Load books data.frame as a SQLite database

#003. READ TABLE FROM RSQLITE --------
#dbGetQuery(conn, "SELECT *FROM authentication_basic")


#004. TO DELETE TABLE IN DATABASE SQLite------------------------------------------
# dbExecute(conn,"DROP TABLE API_Component")
# dbExecute(conn,"DROP TABLE API_SubComponent")
# dbExecute(conn,"DROP TABLE Summ_workplan")
# dbExecute(conn,"DROP TABLE Award_Type_Class")



#005. CREATE TABLE IN DATABASE SQLite ---------------------------------

# TABLE 1: API_Indicator---------

#API_Indicator<-dbExecute(conn, "
#                        CREATE TABLE API_Indicator (
#                          id INTEGER PRIMARY KEY AUTOINCREMENT, 
#                          indicator_code TEXT NOT NULL,
#                          indicator TEXT NOT NULL,
#                          indicator_target TEXT,
#                          indicator_metric TEXT,
#                          indicator_unit TEXT,
#                          indicator_source TEXT,
#                          category_indicator TEXT,
#                          forecasting_indicator TEXT,
#                          performance_indicator TEXT,
#                          sub_component TEXT,
#                          component TEXT
#                        );",
#                    errors=FALSE
#)
#if(API_Indicator== -1){

#  cat ("An error has occured.\n")
#  msg<- odbcGetErrMsg(conn)
#  print(msg)

#  }else{
#  cat ("API_Indicator Table was created successfuly.\n")
#}


# TABLE 2: API_Country--------

#API_Country<-dbExecute(conn, "
#                        CREATE TABLE API_Country (
#                          id INTEGER PRIMARY KEY AUTOINCREMENT, 
#                          flag TEXT,
#                          iso TEXT NOT NULL,
#                          country TEXT NOT NULL,
#                          official TEXT,
#                          capital TEXT,
#                          subregion TEXT,
#                          area TEXT,
#                          population NUMERIC,
#                          languages TEXT
#                        );",
#                              errors=FALSE
#)
#if(API_Country== -1){

#  cat ("An error has occured.\n")
#  msg<- odbcGetErrMsg(conn)
#  print(msg)

#}else{
#  cat ("API_Country Table was created successfuly.\n")
#}


# TABLE 3: API_Location--------

# API_Location<-dbExecute(conn, "
#                        CREATE TABLE API_Location (
#                          id INTEGER PRIMARY KEY AUTOINCREMENT, 
#                          iso TEXT NOT NULL,
#                          country TEXT NOT NULL,
#                          latitude TEXT,
#                          longitude TEXT
#                        );",
#                           errors=FALSE
#)
#if(API_Location== -1){

#  cat ("An error has occured.\n")
#  msg<- odbcGetErrMsg(conn)
#  print(msg)

#}else{
#  cat ("API_Location Table was created successfuly.\n")
#}





# TABLE 4: API_GHO----------------

#API_GHO<-dbExecute(conn, "
#                        CREATE TABLE API_GHO (
#                          id INTEGER PRIMARY KEY AUTOINCREMENT, 
#                          indicator_code TEXT NOT NULL,
#                          iso TEXT NOT NULL,
#                          year_api NUMERIC,
#                          dim1_type TEXT,
#                          dim1 TEXT,
#                          dim2_type TEXT,
#                          dim2 TEXT,
#                          dim3_type TEXT,
#                          dim3  TEXT,
#                          alpha_value TEXT,
#                          numeric_value NUMERIC
#                        );",
#                        errors=FALSE
#)
#if(API_GHO== -1){
  
#  cat ("An error has occured.\n")
#  msg<- odbcGetErrMsg(conn)
#  print(msg)
  
#}else{
#  cat ("API_GHO Table was created successfuly.\n")
#}




# TABLE 5: api_repository-------------------

#API_Repository<-dbExecute(conn, "
#                        CREATE TABLE API_Repository (
#                          id INTEGER PRIMARY KEY AUTOINCREMENT, 
#                          component TEXT NOT NULL,
#                          sub_component TEXT NOT NULL,
#                          country TEXT,
#                          iso TEXT,
#                          indicator TEXT,
#                          indicator_code TEXT,
#                          dim1_type TEXT,
#                          dim1 TEXT,
#                          dim2_type TEXT,
#                          dim2 TEXT,
#                          dim3_type TEXT,
#                          dim3  TEXT,
#                          time_dim NUMERIC,
#                          alpha_value TEXT,
#                          numeric_value NUMERIC,
#                          publish_date REAL
#                        );",
#                   errors=FALSE
#)
#if(API_Repository== -1){
  
#  cat ("An error has occured.\n")
#  msg<- odbcGetErrMsg(conn)
#  print(msg)
  
#}else{
#  cat ("API_Repository Table was created successfuly.\n")
#}



# TABLE 6: API_Component--------------------

#API_Component<-dbExecute(conn, "
#                        CREATE TABLE API_Component (
#                          id INTEGER, 
#                          component TEXT NOT NULL
#                        );",
#                        errors=FALSE
#)
#if(API_Component== -1){
  
#  cat ("An error has occured.\n")
#  msg<- odbcGetErrMsg(conn)
#  print(msg)
  
#}else{
#  cat ("API_Component Table was created successfuly.\n")
#}




# TABLE 7: API_SubComponent-------------------

#API_SubComponent<-dbExecute(conn, "
#                        CREATE TABLE API_SubComponent (
#                          id INTEGER, 
#                          sub_component TEXT NOT NULL,
#                          component TEXT NOT NULL
                          
#                        );",
#                         errors=FALSE
#)
#if(API_SubComponent== -1){
  
#  cat ("An error has occured.\n")
#  msg<- odbcGetErrMsg(conn)
#  print(msg)
  
#}else{
#  cat ("API_SubComponent Table was created successfuly.\n")
#}



# TABLE 8: api_surveyproject---------------------------

#API_Surveyproject<-dbExecute(conn, "
#                        CREATE TABLE API_Surveyproject (
#                          id INTEGER, 
#                          responsible  TEXT,
#                          title_surv TEXT,
#                          population  TEXT,
#                          start_date REAL,
#                          end_date REAL,
#                          location_survey TEXT,
#                          date_creation REAL
#                        );",
#                          errors=FALSE
#)
#if(API_Surveyproject== -1){
  
#  cat ("An error has occured.\n")
#  msg<- odbcGetErrMsg(conn)
#  print(msg)
  
#}else{
#  cat ("API_Surveyproject Table was created successfuly.\n")
#}



# TABLE 9: api_surveydataset---------------------------

#API_Surveydataset<-dbExecute(conn, "
#                        CREATE TABLE API_Surveydataset (
#                          id INTEGER, 
#                          responsible  TEXT,
#                          title_surv TEXT,
#                          population  TEXT,
#                          start_date REAL,
#                          end_date REAL,
#                          location_survey TEXT,
#                          code TEXT,
#                          question TEXT,
#                          response_text TEXT,
#                          response_num NUMERIC,
#                          level_first TEXT,
#                          level_second TEXT
#                          
#                        );",
#                             errors=FALSE
#)
#if(API_Surveydataset== -1){
  
#  cat ("An error has occured.\n")
#  msg<- odbcGetErrMsg(conn)
#  print(msg)
  
#}else{
#  cat ("API_Surveydataset Table was created successfuly.\n")
#}


# TABLE 10: Monitoring_tracker---------------------------

#Monitoring_tracker_df<-dbExecute(conn, "
#                        CREATE TABLE Monitoring_tracker (
#                          id INTEGER PRIMARY KEY AUTOINCREMENT, 
#                          Area TEXT,
#                          Action_point TEXT NOT NULL,
#                          Trigger_date TEXT,
#                          Focal_point  TEXT,
#                          Latest_update TEXT,
#                          Date_of_update TEXT,
#                          Status TEXT,
#                          Complete_percent TEXT
#                          
#                        );",
#                    errors=FALSE
#)
#if(Monitoring_tracker_df== -1){

#  cat ("An error has occured.\n")
#  msg<- odbcGetErrMsg(conn)
#  print(msg)

#}else{
#  cat ("Monitoring tracker Table was created successfuly.\n")
#}


#006. LOAD DATA FROM IN SQLITE FROM JSON API------------------------------------

#006.1 LOAD TABLE: API_Indicator -----------------------------
#if(!'API_Indicator' %in% dbListTables(conn)) {
  
  
#  #001.1 READ List of indicators get from my Python app ---
#      API_Indicator <- fromJSON(readLines('http://127.0.0.1:8000/json_indicator')[1])%>% 
#      rename("component"="subcomponent__component__component_name",
#            "sub_component"="subcomponent__subcomponent_name",
#            "indicator"="indicator_name",
#            "indicator_code"="indicator_code")%>% # rename the column name after downloaded
#      as.data.table() #Transform to data table
    
  
  #008.1.2 PROPIRTY DATASET FROM JSON FILE--
  
#  API_Indicator$sub_component <- strsplit(API_Indicator$sub_component, ';')
#    API_Indicator$sub_component <- lapply(API_Indicator$sub_component, trimws) # Strip white space
#    API_Indicator$sub_component <- unlist(lapply(API_Indicator$sub_component, paste0, collapse = ';'))
  
#    API_Indicator$component  <- strsplit(API_Indicator$component, ';')
#    API_Indicator$component  <- lapply(API_Indicator$component , trimws) # Strip white space
#    API_Indicator$component  <- unlist(lapply(API_Indicator$component , paste0, collapse = ';'))
  
#    API_Indicator$indicator <- strsplit(API_Indicator$indicator, ';')
#    API_Indicator$indicator <- lapply(API_Indicator$indicator, trimws) # Strip white space
#    API_Indicator$indicator <- unlist(lapply(API_Indicator$indicator, paste0, collapse = ';'))
  
# # Award_Distribution$Award_End_Date <- as.Date(Award_Distribution$Award_End_Date) ## Very important to convert in Date format
  
  #008.1.3 PUT ID IN TABLE --
#    API_Indicator$id <- 1:nrow(API_Indicator)
  
  #008.1.4 LOAD DATA FORM ECXEL TO SQLITE -
#     dbWriteTable(conn, "API_Indicator", API_Indicator, overwrite = TRUE, header=TRUE) #Ecrasement de tables existante "books "en remplaçant par la nouvelle table nommée aussi "books"
  #}





#006.2 LOAD TABLE: API_Country -----------------------------
#if(!'API_Country' %in% dbListTables(conn)) {
  
  
#  #001.1 READ List of indicators get from my Python app ---
#  API_Country <- fromJSON(readLines('http://127.0.0.1:8000/json_country')[1])%>% 
 #     rename("country"="name",
#           "iso"="cca3")%>%# rename the column name after downloaded
#      as.data.table() #Transform to data table
  
  
  #008.1.2 PROPIRTY DATASET FROM JSON FILE--
  
#  API_Country$country  <- strsplit(API_Country$country , ';')
#  API_Country$country  <- lapply(API_Country$country , trimws) # Strip white space
#  API_Country$country  <- unlist(lapply(API_Country$country , paste0, collapse = ';'))
  
#  API_Country$capital  <- strsplit(API_Country$capital, ';')
#  API_Country$capital  <- lapply(API_Country$capital , trimws) # Strip white space
#  API_Country$capital  <- unlist(lapply(API_Country$capital , paste0, collapse = ';'))
  
#  API_Country$subregion <- strsplit(API_Country$subregion, ';')
#  API_Country$subregion <- lapply(API_Country$subregion, trimws) # Strip white space
#  API_Country$subregion <- unlist(lapply(API_Country$subregion, paste0, collapse = ';'))
  
  
# API_Country$languages <- strsplit(API_Country$languages, ';')
#  API_Country$languages <- lapply(API_Country$languages, trimws) # Strip white space
#  API_Country$languages <- unlist(lapply(API_Country$languages, paste0, collapse = ';'))
  
#  # Award_Distribution$Award_End_Date <- as.Date(Award_Distribution$Award_End_Date) ## Very important to convert in Date format
  
#  #008.1.3 PUT ID IN TABLE --
#  API_Country$id <- 1:nrow(API_Country)
  
#  #008.1.4 LOAD DATA FORM ECXEL TO SQLITE -
#   dbWriteTable(conn, "API_Country", API_Country, overwrite = TRUE, header=TRUE) #Ecrasement de tables existante "books "en remplaçant par la nouvelle table nommée aussi "books"
#}






#006.3 LOAD TABLE: API_Location -----------------------------
#if(!'API_Location' %in% dbListTables(conn)) {
  
  
#  #001.1 READ List of indicators get from my Python app ---
#  API_Location <- fromJSON(readLines('http://127.0.0.1:8000/json_location')[1])%>% 
#      rename("country"="name",
#            "iso"="iso3")%>%
#      as.data.table() #Transform to data table
  
  
#  #008.1.2 PROPIRTY DATASET FROM JSON FILE--
  
#  API_Location$iso  <- strsplit(API_Location$iso , ';')
#  API_Location$iso  <- lapply(API_Location$iso , trimws) # Strip white space
#  API_Location$iso  <- unlist(lapply(API_Location$iso , paste0, collapse = ';'))
  
#  API_Location$country  <- strsplit(API_Location$country, ';')
#  API_Location$country  <- lapply(API_Location$country , trimws) # Strip white space
#  API_Location$country  <- unlist(lapply(API_Location$country , paste0, collapse = ';'))
  
  
#  # Award_Distribution$Award_End_Date <- as.Date(Award_Distribution$Award_End_Date) ## Very important to convert in Date format
  
#  #008.1.3 PUT ID IN TABLE --
#  API_Location$id <- 1:nrow(API_Location)
  
#  #008.1.4 LOAD DATA FORM ECXEL TO SQLITE -
#  #dbWriteTable(conn, "API_Location", API_Location, overwrite = TRUE, header=TRUE) #Ecrasement de tables existante "books "en remplaçant par la nouvelle table nommée aussi "books"
#}



#006.4 LOAD TABLE: API_GHO -----------------------------
#if(!'API_GHO' %in% dbListTables(conn)) {
  
  
  #001.1 READ List of indicators get from my Python app ---
#  API_GHO <- fromJSON(readLines('http://127.0.0.1:8000/json_storeAPI')[1])%>% 
#    rename("iso"="country_code",
#           "year_api"="time_dim")%>%
#      as.data.table() #Transform to data table
  
  
  #008.1.2 PROPIRTY DATASET FROM JSON FILE--
  
#    API_GHO$iso  <- strsplit(API_GHO$iso , ';')
#    API_GHO$iso  <- lapply(API_GHO$iso , trimws) # Strip white space
#    API_GHO$iso  <- unlist(lapply(API_GHO$iso , paste0, collapse = ';'))
  
#    API_GHO$indicator_code  <- strsplit(API_GHO$indicator_code, ';')
#    API_GHO$indicator_code  <- lapply(API_GHO$indicator_code , trimws) # Strip white space
#    API_GHO$indicator_code  <- unlist(lapply(API_GHO$indicator_code , paste0, collapse = ';'))
  
  
  #  # Award_Distribution$Award_End_Date <- as.Date(Award_Distribution$Award_End_Date) ## Very important to convert in Date format
  
  #  #008.1.3 PUT ID IN TABLE --
#    API_GHO$id <- 1:nrow(API_GHO)
  
  #  #008.1.4 LOAD DATA FORM ECXEL TO SQLITE -
#     dbWriteTable(conn, "API_GHO", API_GHO, overwrite = TRUE, header=TRUE) #Ecrasement de tables existante "books "en remplaçant par la nouvelle table nommée aussi "books"
#}





#006.5 LOAD TABLE: API_Repository -----------------------------
#if(!'API_Repository' %in% dbListTables(conn)) {
  
  
#  #001.1 READ List of indicators get from my Python app ---
#  API_Repository <-  fromJSON(readLines('http://127.0.0.1:8000/json_repository')[1])%>% 
#    rename("component"="indicator__subcomponent__component__component_name",
#           "sub_component"="indicator__subcomponent__subcomponent_name",
#           "country"="country__name",
#           "iso"="spatial_dim",
#           "indicator"="indicator__indicator_name",
#           "indicator_code"="indicator__indicator_code")%>%
#      as.data.table() #Transform to data table
  
  
#  #008.1.2 PROPIRTY DATASET FROM JSON FILE--
  
#  API_Repository$component  <- strsplit(API_Repository$component , ';')
#  API_Repository$component  <- lapply(API_Repository$component , trimws) # Strip white space
#  API_Repository$component  <- unlist(lapply(API_Repository$component , paste0, collapse = ';'))
  
#  API_Repository$sub_component   <- strsplit(API_Repository$sub_component , ';')
#  API_Repository$sub_component   <- lapply(API_Repository$sub_component  , trimws) # Strip white space
#  API_Repository$sub_component   <- unlist(lapply(API_Repository$sub_component  , paste0, collapse = ';'))
  
#  API_Repository$country   <- strsplit(API_Repository$country , ';')
#  API_Repository$country   <- lapply(API_Repository$country  , trimws) # Strip white space
#  API_Repository$country   <- unlist(lapply(API_Repository$country  , paste0, collapse = ';'))
  
#  API_Repository$iso   <- strsplit(API_Repository$iso , ';')
#  API_Repository$iso   <- lapply(API_Repository$iso  , trimws) # Strip white space
#  API_Repository$iso   <- unlist(lapply(API_Repository$iso  , paste0, collapse = ';'))
  
  
#  API_Repository$indicator   <- strsplit(API_Repository$indicator , ';')
#  API_Repository$indicator   <- lapply(API_Repository$indicator  , trimws) # Strip white space
#  API_Repository$indicator   <- unlist(lapply(API_Repository$indicator  , paste0, collapse = ';'))
  
  
#  API_Repository$indicator_code   <- strsplit(API_Repository$indicator_code , ';')
#  API_Repository$indicator_code   <- lapply(API_Repository$indicator_code  , trimws) # Strip white space
#  API_Repository$indicator_code   <- unlist(lapply(API_Repository$indicator_code  , paste0, collapse = ';'))
  
#  # Award_Distribution$Award_End_Date <- as.Date(Award_Distribution$Award_End_Date) ## Very important to convert in Date format
  
#  #008.1.3 PUT ID IN TABLE --
#  API_Repository$id <- 1:nrow(API_Repository)
  
#  #008.1.4 LOAD DATA FORM ECXEL TO SQLITE -
#  # dbWriteTable(conn, "API_Repository", API_Repository, overwrite = TRUE, header=TRUE) #Ecrasement de tables existante "books "en remplaçant par la nouvelle table nommée aussi "books"
#}




#006.6 LOAD TABLE: API_Component -----------------------------
#if(!'API_Component' %in% dbListTables(conn)) {
  
#  #001.1 READ List of indicators get from my Python app ---
#  API_Component <-  fromJSON(readLines('http://127.0.0.1:8000/json_component')[1])%>% 
#     rename("component"="component_name")%>%
#      as.data.table() #Transform to data table
    
#    #008.1.2 PROPIRTY DATASET FROM JSON FILE--
  
#  API_Component$component  <- strsplit(API_Component$component , ';')
#  API_Component$component  <- lapply(API_Component$component , trimws) # Strip white space
#  API_Component$component  <- unlist(lapply(API_Component$component , paste0, collapse = ';'))
  
#  #008.1.4 LOAD DATA FORM ECXEL TO SQLITE -
#  # dbWriteTable(conn, "API_Component", API_Component, overwrite = TRUE, header=TRUE) #Ecrasement de tables existante "books "en remplaçant par la nouvelle table nommée aussi "books"
#}



#006.7 LOAD TABLE: API_SubComponent -----------------------------
#if(!'API_SubComponent' %in% dbListTables(conn)) {
  
#  #001.1 READ List of indicators get from my Python app ---
#  API_SubComponent <-  fromJSON(readLines('http://127.0.0.1:8000/json_subcomponent')[1])%>% 
#    rename("component"="component__component_name",
#           "sub_component"="subcomponent_name")%>%
#      as.data.table() #Transform to data table
    
  
#  #008.1.2 PROPIRTY DATASET FROM JSON FILE--
  
#  API_SubComponent$component  <- strsplit(API_SubComponent$component , ';')
#  API_SubComponent$component  <- lapply(API_SubComponent$component , trimws) # Strip white space
#  API_SubComponent$component  <- unlist(lapply(API_SubComponent$component , paste0, collapse = ';'))
  
  
#  API_SubComponent$sub_component  <- strsplit(API_SubComponent$sub_component , ';')
#  API_SubComponent$sub_component  <- lapply(API_SubComponent$sub_component , trimws) # Strip white space
#  API_SubComponent$sub_component  <- unlist(lapply(API_SubComponent$sub_component , paste0, collapse = ';'))
  
#  #008.1.4 LOAD DATA FORM ECXEL TO SQLITE -
#  # dbWriteTable(conn, "API_SubComponent", API_SubComponent, overwrite = TRUE, header=TRUE) #Ecrasement de tables existante "books "en remplaçant par la nouvelle table nommée aussi "books"
#}


#006.8 LOAD TABLE: API_Surveyproject -----------------------------
#if(!'API_Surveyproject' %in% dbListTables(conn)) {
  
#  #001.1 READ List of indicators get from my Python app ---
#  API_Surveyproject <-  fromJSON(readLines('http://127.0.0.1:8000/json_surveyproject')[1])%>% 
#    rename("population"="target_population")%>%
#      as.data.table() #Transform to data table
  
  
#  #008.1.2 PROPIRTY DATASET FROM JSON FILE--
  
#  API_Surveyproject$responsible  <- strsplit(API_Surveyproject$responsible , ';')
#  API_Surveyproject$responsible  <- lapply(API_Surveyproject$responsible , trimws) # Strip white space
#  API_Surveyproject$responsible  <- unlist(lapply(API_Surveyproject$responsible , paste0, collapse = ';'))
  
#  API_Surveyproject$title_surv  <- strsplit(API_Surveyproject$title_surv , ';')
#  API_Surveyproject$title_surv  <- lapply(API_Surveyproject$title_surv , trimws) # Strip white space
#  API_Surveyproject$title_surv  <- unlist(lapply(API_Surveyproject$title_surv , paste0, collapse = ';'))
  
#  #008.1.4 LOAD DATA FORM ECXEL TO SQLITE -
#  #  dbWriteTable(conn, "API_Surveyproject", API_Surveyproject, overwrite = TRUE, header=TRUE) #Ecrasement de tables existante "books "en remplaçant par la nouvelle table nommée aussi "books"
#}


#006.9 LOAD TABLE: API_Surveydataset -----------------------------
#if(!'API_Surveydataset' %in% dbListTables(conn)) {
  
#  #006.9.1 READ List of indicators get from my Python app ---
#  API_Surveydataset <-  fromJSON(readLines('http://127.0.0.1:8000/json_surveydataset')[1])%>% 
#    rename("responsible"="surveyProject__responsible",
#           "title_surv"="surveyProject__title_surv",
#           "start_date"="surveyProject__start_date",
#           "end_date"="surveyProject__end_date",
#           "location_survey"="surveyProject__location_survey",
#           "code"="quest_code",
#           "level_first"="level_1",
#           "level_second"="level_2")%>%
#      as.data.table() #Transform to data table
  
  
#  #006.9.2 PROPIRTY DATASET FROM JSON FILE--
  
#  API_Surveydataset$responsible  <- strsplit(API_Surveydataset$responsible , ';')
#  API_Surveydataset$responsible  <- lapply(API_Surveydataset$responsible , trimws) # Strip white space
#  API_Surveydataset$responsible  <- unlist(lapply(API_Surveydataset$responsible , paste0, collapse = ';'))
  
#  API_Surveydataset$title_surv  <- strsplit(API_Surveydataset$title_surv , ';')
#  API_Surveydataset$title_surv  <- lapply(API_Surveydataset$title_surv , trimws) # Strip white space
#  API_Surveydataset$title_surv  <- unlist(lapply(API_Surveydataset$title_surv , paste0, collapse = ';'))
  
#  API_Surveydataset$question  <- strsplit(API_Surveydataset$question , ';')
#  API_Surveydataset$question  <- lapply(API_Surveydataset$question , trimws) # Strip white space
#  API_Surveydataset$question  <- unlist(lapply(API_Surveydataset$question , paste0, collapse = ';'))
  
#  API_Surveydataset$response_text  <- strsplit(API_Surveydataset$response_text , ';')
#  API_Surveydataset$response_text  <- lapply(API_Surveydataset$response_text , trimws) # Strip white space
#  API_Surveydataset$response_text  <- unlist(lapply(API_Surveydataset$response_text , paste0, collapse = ';'))
  
#  API_Surveydataset$code  <- strsplit(API_Surveydataset$code , ';')
#  API_Surveydataset$code  <- lapply(API_Surveydataset$code , trimws) # Strip white space
#  API_Surveydataset$code  <- unlist(lapply(API_Surveydataset$code , paste0, collapse = ';'))
  
#  #006.9.3 LOAD DATA FORM ECXEL TO SQLITE -
# # dbWriteTable(conn, "API_Surveydataset", API_Surveydataset, overwrite = TRUE, header=TRUE) #Ecrasement de tables existante "books "en remplaçant par la nouvelle table nommée aussi "books"
#}


#006.10 LOAD TABLE: authentication_basic -----------------------------
#  if(!'authentication_basic' %in% dbListTables(conn)) {
    
#    #006.10.1 READ DATASET FROM XLSL FILE---------------
#    authentication_basic <- import('data/authenticate/authentication_basic.csv')
    
#    #006.10.2 PROPIRTY DATASET FROM XLSL FILE---------------
    
#   authentication_basic$user_name <- strsplit(authentication_basic$user_name, ';')
#    authentication_basic$user_name <- lapply(authentication_basic$user_name, trimws) # Strip white space
#    authentication_basic$user_name <- unlist(lapply(authentication_basic$user_name, paste0, collapse = ';'))
    
#    authentication_basic$password  <- strsplit(authentication_basic$password, ';')
#    authentication_basic$password  <- lapply(authentication_basic$password , trimws) # Strip white space
#    authentication_basic$password  <- unlist(lapply(authentication_basic$password , paste0, collapse = ';'))
    
#    authentication_basic$permissions <- strsplit(authentication_basic$permissions, ';')
#    authentication_basic$permissions <- lapply(authentication_basic$permissions, trimws) # Strip white space
#    authentication_basic$permissions <- unlist(lapply(authentication_basic$permissions, paste0, collapse = ';'))
    
    
#    authentication_basic$name <- strsplit(authentication_basic$name, ';')
#    authentication_basic$name <- lapply(authentication_basic$name, trimws) # Strip white space
#    authentication_basic$name <- unlist(lapply(authentication_basic$name, paste0, collapse = ';'))
   
    
#    #006.10.3 PUT ID IN TABLE ---------------
#   authentication_basic$id <- 1:nrow(authentication_basic)
    
#   #006.10.4 LOAD DATA FORM ECXEL TO SQLITE ---------------
#  # dbWriteTable(conn, "authentication_basic", authentication_basic, overwrite = TRUE, header=TRUE) #Ecrasement de tables existante "books "en remplaçant par la nouvelle table nommée aussi "books"
#  }


#006.11 LOAD TABLE: Monitoring_tracker -----------------------------

#if(!'Monitoring_tracker' %in% dbListTables(conn)) {
#  Monitoring_tracker <- read.csv('data/brut/dataSet/Monitoring_tracker.csv', stringsAsFactors = FALSE)
  
#   Monitoring_tracker$Area <- strsplit(Monitoring_tracker$Area, ';')
#    Monitoring_tracker$Area <- lapply(Monitoring_tracker$Area, trimws) # Strip white space
#   Monitoring_tracker$Area <- unlist(lapply(Monitoring_tracker$Area, paste0, collapse = ';'))
  
#   Monitoring_tracker$Action_point <- strsplit(Monitoring_tracker$Action_point, ';')
#    Monitoring_tracker$Action_point <- lapply(Monitoring_tracker$Action_point, trimws) # Strip white space
#    Monitoring_tracker$Action_point <- unlist(lapply(Monitoring_tracker$Action_point, paste0, collapse = ';'))
  
#    Monitoring_tracker$Focal_point <- strsplit(Monitoring_tracker$Focal_point, ';')
#    Monitoring_tracker$Focal_point <- lapply(Monitoring_tracker$Focal_point, trimws) # Strip white space
#    Monitoring_tracker$Focal_point <- unlist(lapply(Monitoring_tracker$Focal_point, paste0, collapse = ';'))
  
#  Monitoring_tracker$id <- 1:nrow(Monitoring_tracker)
#  # dbWriteTable(conn, "Monitoring_tracker", Monitoring_tracker, overwrite = TRUE, header=TRUE)
  
  
#   #dbWriteTable(conn, "Monitoring_tracker", Monitoring_tracker,overwrite = TRUE,  header=TRUE) #Ecrasement de tables existante "books "en remplaçant par la nouvelle table nommée aussi "books"
#}



#library(DBI)
#library(RSQLite)

# Connexion à la base originale
#con <- dbConnect(SQLite(), "books.sqlite")

# Vérifier les tables disponibles
#dbListTables(con)

# Exemple : extraction des colonnes utiles de chaque table
#api_country <- dbGetQuery(con, "
#  SELECT id, flag,iso, country,subregion,country_class ,area,
#  population,languages,ref_data,data_source,official
#  FROM API_Country
#")

#api_location <- dbGetQuery(con, "
#  SELECT id, country, latitude,longitude
#  FROM API_Location
#")

#api_component <- dbGetQuery(con, "
#  SELECT id, component
#  FROM API_Component
#")

#api_subcomponent <- dbGetQuery(con, "
#  SELECT id, sub_component, component 
#  FROM API_SubComponent
#")

#api_indicator <- dbGetQuery(con, "
#  SELECT id, indicator,indicator_code, type_indicator,indicator_target,
#  indicator_metric ,indicator_unit,ref_data,
#  indicator_source , category_indicator ,forecasting_indicator ,
#  performance_indicator ,sub_component , component 
#  FROM API_Indicator
#")

#api_repository <- dbGetQuery(con, "
#  SELECT id, component, sub_component,country, iso ,indicator,
#   indicator_code, time_dim,  alpha_value,
#   numeric_value ,  publish_date 
#   FROM API_Repository
#")


#api_gho <- dbGetQuery(con, "
#  SELECT indicator_code, iso, year_api, alpha_value, numeric_value
#  FROM API_GHO
#")


#authentication_basic <- dbGetQuery(con, "
#  SELECT user_name, password, permissions, name
#  FROM authentication_basic
#")


#monitoring_tracker <- dbGetQuery(con, "
#  SELECT id, Area,  Action_point ,Trigger_date, Focal_point, Latest_update,
#Date_of_update, Status ,Complete_percent 
#  FROM Monitoring_tracker
#")

#dbDisconnect(con)
# Créer une nouvelle base plus légère
#con_new <- dbConnect(SQLite(), "books_clean.sqlite")

# Sauvegarder les tables nettoyées
#dbWriteTable(con_new, "API_Indicator", api_indicator, overwrite = TRUE)
#dbWriteTable(con_new, "API_SubComponent", api_subcomponent, overwrite = TRUE)
#dbWriteTable(con_new, "API_Component", api_component, overwrite = TRUE)
#dbWriteTable(con_new, "API_Country", api_country, overwrite = TRUE)
#dbWriteTable(con_new, "API_Location", api_location, overwrite = TRUE)
#dbWriteTable(con_new, "API_Repository", API_Repository, overwrite = TRUE)
#dbWriteTable(con_new, "API_GHO", api_gho, overwrite = TRUE)
#dbWriteTable(con_new, "Monitoring_tracker", monitoring_tracker, overwrite = TRUE)
#dbWriteTable(con_new, "authentication_basic", authentication_basic, overwrite = TRUE)

#dbDisconnect(con_new)

# Vérifier la taille du nouveau fichier
#size_mb <- file.info("books_clean.sqlite")$size / (1024*1024)
#cat("Nouvelle base créée : books_clean.sqlite (", round(size_mb, 2), "MB )\n")



#007. EXTRACT DATA FROM SQLITE TABLES----------------

#007.1.1 EXTRACT TABLE: API_Indicator -------------------------------
getAPI_Indicator <- function() {
  con_new <- dbConnect(SQLite(), "books_clean.sqlite")
    res <- dbSendQuery(con_new, "SELECT * FROM API_Indicator")
  
    API_Indicator <- dbFetch(res)
    dbClearResult(res)
  
    API_Indicator$indicator_metric <- as.factor(API_Indicator$indicator_metric)
    API_Indicator$category_indicator <- as.factor(API_Indicator$category_indicator)
    API_Indicator$forecasting_indicator <- as.factor(API_Indicator$forecasting_indicator)
    API_Indicator$performance_indicator <- as.factor(API_Indicator$performance_indicator)
    API_Indicator$sub_component <- as.factor(API_Indicator$sub_component)
    API_Indicator$component <- as.factor(API_Indicator$component)
    

    return(API_Indicator)
    
    dbDisconnect(con_new)
   
  }
 #getAPI_Indicator()


#007.1.2 EXTRACT TABLE: API_Country -------------------------------

getAPI_Country <- function() {
    con_new <- dbConnect(SQLite(), "books_clean.sqlite")
    res <- dbSendQuery(con_new, "SELECT * FROM API_Country")
    
    API_Country <- dbFetch(res)
    dbClearResult(res)
    
    API_Country$country <- as.factor(API_Country$country)
    API_Country$official  <- as.factor(API_Country$official )
    API_Country$iso <- as.factor(API_Country$iso)
    API_Country$subregion <- as.factor(API_Country$subregion)
    API_Country$languages <- as.factor(API_Country$languages)
    API_Country$country_class <- as.factor(API_Country$country_class)
  
     return(API_Country)
    dbDisconnect(con_new)
}

# getAPI_Country()



#007.1.3 EXTRACT TABLE: API_Location -------------------------------

getAPI_Location <- function() {
  con_new <- dbConnect(SQLite(), "books_clean.sqlite")
  res <- dbSendQuery(con_new, "SELECT * FROM API_Location")
  
  API_Location <- dbFetch(res)
  dbClearResult(res)
  
  API_Location$iso  <- as.factor(API_Location$country)
  API_Location$country  <- as.factor(API_Location$country)
 
  return(API_Location)
  
  dbDisconnect(con_new)
}

# getAPI_Location()




#007.1.4 EXTRACT TABLE: API_GHO -------------------------------

#getAPI_GHO <- function() {
#  res <- dbSendQuery(conn, "SELECT * FROM API_GHO")
  
#  API_GHO <- dbFetch(res)
#  dbClearResult(res)
# API_GHO$indicator_code <- as.factor(API_GHO$indicator_code)
#  API_GHO$iso <- as.factor(API_GHO$iso)
#  API_GHO$dim1_type <- as.factor(API_GHO$dim1_type)
#  API_GHO$dim1 <- as.factor(API_GHO$dim1)
#  API_GHO$dim2_type <- as.factor(API_GHO$dim2_type)
#  API_GHO$dim2 <- as.factor(API_GHO$dim2)
#  API_GHO$dim3_type <- as.factor(API_GHO$dim3_type)
#  API_GHO$dim3 <- as.factor(API_GHO$dim3)
  
#  #  df_API_GHO<-API_GHO%>% ## 
#  #    filter(indicator_code!="")%>%
#  #    select(indicator_code, iso,year_api,dim1_type,dim1, dim2_type,  dim2,
#  #          dim3_type,dim3,alpha_value, numeric_value)%>%
#  #  # left_join(getAPI_Country()%>%select(flag,iso,country), by=c("iso"="iso"))%>%
#  #    group_by(indicator_code,iso,year_api,dim1_type,dim1, dim2_type,  dim2,
#  #             dim3_type,dim3,alpha_value)%>%
#  #    dplyr::summariSe(numeric_value=round(sum(numeric_value), digit=0))%>%
#  #    as.data.table()

#    #  dbDisconnect(con)
#  return(API_GHO)
#}

#getAPI_GHO()



#007.1.5 EXTRACT TABLE: API_Repository -------------------------------

#getAPI_Repository <- function() {
#  res <- dbSendQuery(conn, "SELECT * FROM API_Repository")
  
#  API_Repository <- dbFetch(res)
#  dbClearResult(res)
#  API_Repository$component <- as.factor(API_Repository$component)
#  API_Repository$sub_component <- as.factor(API_Repository$sub_component)
#  API_Repository$indicator <- as.factor(API_Repository$indicator)
#  API_Repository$indicator_code <- as.factor(API_Repository$indicator_code)
#  API_Repository$country <- as.factor(API_Repository$country)
#  API_Repository$iso <- as.factor(API_Repository$iso)
#  API_Repository$dim1_type <- as.factor(API_Repository$dim1_type)
#  API_Repository$dim1 <- as.factor(API_Repository$dim1)
#  API_Repository$dim2_type <- as.factor(API_Repository$dim2_type)
#  API_Repository$dim2 <- as.factor(API_Repository$dim2)
#  API_Repository$dim3_type <- as.factor(API_Repository$dim3_type)
#  API_Repository$dim3 <- as.factor(API_Repository$dim3)
#  API_Repository$numeric_value <- as.numeric(API_Repository$numeric_value)
#  API_Repository$publish_date <- as.Date(API_Repository$publish_date)
  
#  #   df_API_Repository<-API_Repository%>% ## 
#  #     filter(indicator_code!="")%>%
#  #    select(component,sub_component,country,iso,indicator,indicator_code, time_dim,dim1_type,dim1, dim2_type,  dim2,
#  #            dim3_type,dim3,alpha_value, numeric_value)%>%
#  #     # left_join(getAPI_Country()%>%select(flag,iso,country), by=c("iso"="iso"))%>%
#  #     group_by(component,sub_component,country,iso,indicator,indicator_code, time_dim,dim1_type,dim1, dim2_type,  dim2,
#  #              dim3_type,dim3,alpha_value)%>%
#  #     dplyr::summarize(numeric_value=round(sum(numeric_value), digit=0))%>%
#  #     as.data.table()
  
#  #  dbDisconnect(con)
#  return(API_Repository)
#}

#getAPI_Repository()


#007.1.6 EXTRACT TABLE: API_Component -------------------------------

getAPI_Component <- function() {
  con_new <- dbConnect(SQLite(), "books_clean.sqlite")
  res <- dbSendQuery(con_new, "SELECT * FROM API_Component")
  
  API_Component <- dbFetch(res)
  dbClearResult(res)
  
  API_Component$component  <- as.factor(API_Component$component)
    
  return(API_Component)
  dbDisconnect(con_new)
}

# getAPI_Component()

#007.1.7 EXTRACT TABLE: API_SubComponent -------------------------------

getAPI_SubComponent <- function() {
  con_new <- dbConnect(SQLite(), "books_clean.sqlite")
  res <- dbSendQuery(con_new, "SELECT * FROM API_SubComponent")
  
  API_SubComponent <- dbFetch(res)
  dbClearResult(res)
  
  API_SubComponent$component  <- as.factor(API_SubComponent$component)
  API_SubComponent$sub_component  <- as.factor(API_SubComponent$sub_component)
 
  return(API_SubComponent)
  dbDisconnect(con_new)
}

# getAPI_SubComponent()

#007.1.8 EXTRACT TABLE: API_Surveyproject -------------------------------

#getAPI_Surveyproject <- function() {
#  res <- dbSendQuery(conn, "SELECT * FROM API_Surveyproject")
  
#  API_Surveyproject <- dbFetch(res)
#  dbClearResult(res)
  
#  API_Surveyproject$population  <- as.factor(API_Surveyproject$population)
#  API_Surveyproject$start_date <- as.Date(API_Surveyproject$start_date)
#  API_Surveyproject$end_date <- as.Date(API_Surveyproject$end_date)
#  API_Surveyproject$date_creation <- as.Date(API_Surveyproject$date_creation)
#  #  dbDisconnect(con)
#  return(API_Surveyproject)
#}

# getAPI_Surveyproject()



#007.1.9 EXTRACT TABLE: API_Surveydataset -------------------------------

#getAPI_Surveydataset <- function() {
#  res <- dbSendQuery(conn, "SELECT * FROM API_Surveydataset")
  
#  API_Surveydataset <- dbFetch(res)
#  dbClearResult(res)
  
#  API_Surveydataset$start_date <- as.Date(API_Surveydataset$start_date)
#  API_Surveydataset$end_date <- as.Date(API_Surveydataset$end_date)
#  API_Surveydataset$question  <- as.factor(API_Surveydataset$question)
#  #  dbDisconnect(con)
#  return(API_Surveydataset)
#}

# getAPI_Surveydataset()



#007.1.10 EXTRACT TABLE: authentication_basic, Server logic for BASIC AUTHENTICATION---------------------------------
getAuthenticate_basic <- function() {
  con_new <- dbConnect(SQLite(), "books_clean.sqlite")
  res <- dbSendQuery(con_new, "SELECT * FROM authentication_basic")
  authentication_basic <- dbFetch(res)
  dbClearResult(res)
  authentication_basic$user_name <-as.character(authentication_basic$user_name)
  authentication_basic$password <-as.character(authentication_basic$password)
  authentication_basic$permissions <-as.character(authentication_basic$permissions)
  authentication_basic$name <-as.character(authentication_basic$name)
  
  return(authentication_basic)
  dbDisconnect(con_new)
}
#getAuthenticate_basic()






#007.1.11 EXTRACT TABLE: Monitoring_tracker ------------------------------------------------------
getMonitoringTracker <- function() {
  con_new <- dbConnect(SQLite(), "books_clean.sqlite")
  
  res <- dbSendQuery(conn, "SELECT * FROM Monitoring_tracker")
  Monitoring_tracker <- dbFetch(res)
  dbClearResult(res)
  
  Monitoring_tracker$Area <-as.character(Monitoring_tracker$Area)
  Monitoring_tracker$Action_point <-as.character(Monitoring_tracker$Action_point)
  Monitoring_tracker$Trigger_date <-as.Date(Monitoring_tracker$Trigger_date, format = "%Y-%m-%d")
  #Monitoring_tracker$Focal_point <- strsplit(Monitoring_tracker$Focal_point, ';')
  Monitoring_tracker$Latest_update <-as.character(Monitoring_tracker$Latest_update)
  Monitoring_tracker$Date_of_update <-as.Date(Monitoring_tracker$Date_of_update ,format = "%Y-%m-%d")
  Monitoring_tracker$Status <-as.factor(Monitoring_tracker$Status)
  Monitoring_tracker$Complete_percent <-as.character(Monitoring_tracker$Complete_percent)
  
  return(Monitoring_tracker)
  
  dbDisconnect(con_new)
}
#str(Monitoring_tracker)
#getMonitoringTracker()
#Monitoring_tracker <- getMonitoringTracker()

##### Callback functions. FONCTION POUR INSERTION DES DONNEES DANS LA TABLE Monitoring_tracker DE LA BASE DE DONNEES SQLITE------------------------
Monitoring_tracker.insert.callback <- function(data, row) {
  con_new <- dbConnect(SQLite(), "books_clean.sqlite")
  query <- paste0("INSERT INTO Monitoring_tracker (id,Area,Action_point,Trigger_date,Focal_point,Latest_update,Date_of_update,Status,Complete_percent) VALUES (",
                  "",ifelse(max(getMonitoringTracker()$id)>0,max(getMonitoringTracker()$id) + 1,1), ", ",
                  "'", data[row,]$Area, "', ",
                  "'", data[row,]$Action_point, "', ",
                  "'", as.character(data[row,]$Trigger_date), "', ",
                  "'", paste0(data[row,]$Focal_point[[1]], collapse = ';'), "', ",
                  "'", data[row,]$Latest_update, "', ",
                  "'", as.character(data[row,]$Date_of_update), "', ",
                  "'", as.character(data[row,]$Status), "', ",
                  "'", data[row,]$Complete_percent, "' ",
                  ")")
  #print(query) # For debugging
  dbSendQuery(con_new, query)
  return(getMonitoringTracker())
  dbDisconnect(con_new)
}


##FONCTION POUR UPDATE OU EDITER OU MODIFIER LES DONNEES DANS LA TABLE Monitoring_tracker DE LA BASE DE DONNEES SQLITE------------------------
Monitoring_tracker.update.callback <- function(data, olddata, row) {
  con_new <- dbConnect(SQLite(), "books_clean.sqlite")
  query <- paste0("UPDATE Monitoring_tracker SET ",
                  "Area = '", data[row,]$Area, "', ",
                  "Action_point = '", data[row,]$Action_point, "', ",
                  "Trigger_date = '", as.character(data[row,]$Trigger_date), "', ",
                  "Focal_point = '", paste0(data[row,]$Focal_point[[1]], collapse = ';'), "', ",
                  "Latest_update = '", data[row,]$Latest_update, "', ",
                  "Date_of_update = '", as.character(data[row,]$Date_of_update), "', ",
                  "Status = '", as.character(data[row,]$Status), "', ",
                  "Complete_percent = '", data[row,]$Complete_percent, "' ",
                  "WHERE id = ", data[row,]$id)
  #print(query) # For debugging
  dbSendQuery(con_new, query)
  return(getMonitoringTracker())
  dbDisconnect(con_new)
}
##FONCTION POUR DELETE OU SUPPRIMER LES DONNEES DANS LA TABLE Monitoring_tracker DE LA BASE DE DONNEES SQLITE------------------------
Monitoring_tracker.delete.callback <- function(data, row) {
  con_new <- dbConnect(SQLite(), "books_clean.sqlite")
  query <- paste0('DELETE FROM Monitoring_tracker WHERE id = ', data[row,]$id)
  
  dbSendQuery(con_new, query)
  return(getMonitoringTracker())
  
  dbDisconnect(con_new)
}


#007.11 MERGE DATASET getAPI_Repository() AND getAPI_GHO()-------------------------------------------------

 #tvd_dts<-getAPI_GHO()%>% # Data from Global Health Observatory import automatically using api with Python Scrips
 #filter(iso!="MYT",indicator_code%in%"NTD_LEPR13")%>%
##  mutate(ref_data=case_when(
##    year_api>0~"gho",
##    TRUE~"Others"))%>% # put reference for data sources
 #  select(indicator_code, iso,year_api,dim1_type,dim1, dim2_type,  dim2,
 #         dim3_type,dim3,alpha_value, numeric_value)%>% # column for merge 
##  bind_rows(getAPI_Repository()%>% # Data from other source collected and upload in the system using Excel file
##              rename("year_api"="time_dim")%>% # rename the column name to hamonise with the previous dataset for gho
##              ungroup()%>%
##              mutate(ref_data=case_when(
##                year_api>0~"wco",
##                TRUE~"Others"))%>%  #put reference for data sources
##              select(indicator_code,iso,year_api,dim1_type,dim1, dim2_type,  dim2,
##                     dim3_type,dim3,alpha_value, numeric_value,ref_data))%>%
 #  left_join(getAPI_Country()#%>%filter(id<48)
 #            %>%select(country,iso), by = c("iso" = "iso"))%>%
 #  ungroup()%>%
 # left_join(getAPI_Indicator()%>%filter(indicator!="",ref_data%in%"gho")%>%select(component,sub_component,indicator,indicator_code,type_indicator,ref_data), by = c("indicator_code" = "indicator_code"))%>%
 # mutate(alpha_value = replace(alpha_value, numeric_value>0, "na"),
 #        indicator=str_replace_all(str_squish(str_sub(indicator, 1, 80)),"[\r\n\t]+", " "),
 #        year_api=as.numeric(year_api),
 #        numeric_value=as.numeric(numeric_value)
 #        )%>% #remplace tabulations et retours par un espace simple, supprime espaces multiples + début/fin et limiter à 80 caractères
#  # mutate(year=as.numeric(year_api))%>%
 #  mutate_if(is.numeric, funs(replace(., is.na(.), 0)))%>%
 #  mutate_if(is.character, funs(replace(., is.na(.), "na")))%>%
 # select(component,sub_component,indicator,indicator_code,type_indicator,country,iso,year_api,dim1_type,dim1,
 #        dim2_type,dim2,dim3_type,dim3,ref_data, alpha_value, numeric_value)%>%
 # as.data.table() 
  
 ##   CREATE THE MAIN DATASET USING FOR ANALYSIS-----------------------------------------------
 # library(dplyr)
 # library(stringr)

#tvd_dts <- getAPI_GHO()%>%
#   mutate(indicator_code = str_trim(indicator_code))%>%   # Nettoyage ici
#   filter(iso != "MYT") %>%
#   select(indicator_code, iso, year_api, alpha_value, numeric_value)%>% #dim1_type, dim1, dim2_type, dim2, dim3_type, dim3, 
#   left_join(
#     getAPI_Country()%>%
#       mutate(iso = str_trim(iso)) %>%                     # Nettoyage aussi côté clé
#       select(country, iso),
#     by = "iso"
#   )%>%
#   ungroup()%>%
#   left_join(
#     getAPI_Indicator()%>%
#       mutate(indicator_code = str_trim(indicator_code)) %>% # Nettoyage côté indicateurs
#       filter(component != "", indicator != "",indicator_code != "", ref_data %in% "gho") %>%
#       select(component, sub_component, indicator, indicator_code, type_indicator, ref_data),
#     by = "indicator_code"
#   )%>%
#   mutate(
#     alpha_value = replace(alpha_value, numeric_value > 0, "na"),
#     indicator = str_replace_all(
#       str_squish(str_sub(indicator, 1, 80)),
#       "[\r\n\t]+", " "
#     ),
#     year_api = as.numeric(year_api),
#     numeric_value = as.numeric(numeric_value)
#   )%>%
#   mutate(across(where(is.numeric), ~ replace(., is.na(.), 0)))%>%
#   mutate(across(where(is.character), ~ replace(., is.na(.), "na")))%>%
#   select(component, sub_component, indicator, indicator_code, type_indicator, #dim1_type, dim1,dim2_type, dim2, dim3_type, dim3,
#          country, iso, year_api,  ref_data,
#          alpha_value, numeric_value)%>%
#   as.data.table()
 




#library(dplyr)
#library(stringr)
#library(data.table)

# Fonction pour construire le tableau TVD
#build_tvd_dts <- function() {
#  tvd_dts <- getAPI_GHO() %>%
#    mutate(indicator_code = str_trim(indicator_code)) %>%   # Nettoyage ici
#    filter(iso != "MYT") %>%
#    select(indicator_code, iso, year_api, alpha_value, numeric_value) %>%
#    left_join(
#      getAPI_Country() %>%
#        mutate(iso = str_trim(iso)) %>%
#        select(country, iso),
#      by = "iso"
#    ) %>%
#    ungroup() %>%
#    left_join(
#      getAPI_Indicator() %>%
#        mutate(indicator_code = str_trim(indicator_code)) %>%
#        filter(component != "", indicator != "", indicator_code != "", ref_data %in% "gho") %>%
#        select(component, sub_component, indicator, indicator_code, type_indicator, ref_data),
#      by = "indicator_code"
#    ) %>%
#    mutate(
#      alpha_value = replace(alpha_value, numeric_value > 0, "na"),
#      indicator = str_replace_all(
#        str_squish(str_sub(indicator, 1, 80)),
#        "[\r\n\t]+", " "
#      ),
#      year_api = as.numeric(year_api),
#      numeric_value = as.numeric(numeric_value)
#    ) %>%
#    mutate(across(where(is.numeric), ~ replace(., is.na(.), 0))) %>%
#    mutate(across(where(is.character), ~ replace(., is.na(.), "na"))) %>%
#    select(component, sub_component, indicator, indicator_code, type_indicator,
#           country, iso, year_api, ref_data,
#           alpha_value, numeric_value) %>%
#    as.data.table()
#  
#  return(tvd_dts)
#}

# Exemple d’utilisation
#tvd_dts <- build_tvd_dts()

# Base utilisateur
#user_base_basic_tbl <- getAuthenticate_basic() %>%
#  as.data.table()




           
#007.12 USER DATA TABLE--------------------------------------
#user_base_basic_tbl<-getAuthenticate_basic()%>%
#  as.data.table()

#View(tvd_dts)

#exp_tvd_dts<-tvd_dts%>%
#  select(component,sub_component,indicator,indicator_code,iso,country,year_api,ref_data,numeric_value,alpha_value)%>%
#  as.data.table() 


#geo_countries <- read_csv("data/brut/dataSet/geo_countries.csv")%>%
#  as.data.table()


#country_list2 <- write_xlsx(x=exp_tvd_dts, path="exp_data_TVD.xls", col_names = TRUE)

#### NETOYER LA BASE SQLITE----------------------------



