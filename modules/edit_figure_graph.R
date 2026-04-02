
#source("modules/indicator_gpe_values.R")

selected_code <- tvd_dts[tvd_dts$indicator =="Malaria incidence per 100 000 population", "indicator_code"]
tbl_tvd01_df <-#tvd_df01()%>%
  tvd_dts%>%
  filter(#iso=="CMR",
    indicator_code==selected_code$indicator_code[1], ref_data=="wco",numeric_value>=0)%>%
  select(indicator_code,dim1,iso,year_api,numeric_value)%>%
  group_by(indicator_code,dim1,iso,year_api)%>% 
  summarise(numeric_value = round(mean(numeric_value, na.rm = T),2))%>%
  ungroup()


tbl_tvd02_df<-tbl_tvd01_df%>%
  select(dim1,iso,year_api,numeric_value)%>%
  mutate(kp=paste(iso,'-',year_api),sep="")%>%
  select(kp,numeric_value)%>%
  as.data.frame()

tbl_tvd03_df<-tbl_tvd01_df%>%
  select(dim1,iso,year_api,numeric_value)%>%
  mutate(year_api=as.numeric(year_api))%>%
  group_by(dim1,iso)%>%
  summarise(year_api = max(year_api))%>%
  group_by(year_api)%>%
  mutate(kp=paste(iso,'-',year_api),sep="")%>%
  select(dim1,iso,year_api,kp)%>%
  left_join(tbl_tvd02_df%>%select(kp,numeric_value))%>%
  ungroup()%>%
  select(dim1,iso,year_api,numeric_value)%>%
  ungroup()%>%
  select(dim1,year_api,numeric_value)%>%
  group_by(dim1,year_api)%>%
  summarise(numeric_value = round(mean(numeric_value, na.rm = T),2))%>%
  ungroup()

df_sex_tvd<-tbl_tvd03_df%>%
  filter(dim1!="NA" & numeric_value>=0,year_api%in%max(year_api))%>%
  select(dim1,year_api,numeric_value)%>%
  group_by(dim1)%>% 
  summarise(numeric_value = round(mean(numeric_value, na.rm = T),1))%>% 
  mutate(numeric_value=as.numeric(numeric_value),

         if (selected_code$indicator_code[1]=="NTD_BU_CONF") { # Number of confirmed cases of Buruli ulcer reported
           group=case_when(
             numeric_value>=99.6 ~"More than 100 cases",
             numeric_value>=9.6 & numeric_value<=99.5 ~"Between 9 and 100 cases",
             numeric_value>0.01 & numeric_value<9.6 ~"At least 10 cases",
             TRUE~"Data not available")
         } else {
           if (selected_code$indicator_code[1]=="NTD_1") { # Prevalence of anemia among non-pregnant women (% of women ages 15-49)
             group=case_when(
               numeric_value>=99.6 ~"More than 100 cases",
               numeric_value>=9.6 & numeric_value<=99.5 ~"Between 9 and 100 cases",
               numeric_value>0.01 & numeric_value<9.6 ~"At least 10 cases",
               TRUE~"Data not available")
           }else {
             if (selected_code$indicator_code[1]=="NTD_BU_SUSP") { # Prevalence of anemia among pregnant women (%)
               group=case_when(
                 numeric_value>=99.6 ~"More than 100 cases",
                 numeric_value>=9.6 & numeric_value<=99.5 ~"Between 9 and 100 cases",
                 numeric_value>0.01 & numeric_value<9.6 ~"At least 10 cases",
                 TRUE~"Data not available")
             }else {
               if (selected_code$indicator_code[1]=="NTD_BU_END") { # Number of women of reproductive age (15-49 years) affected by anemia (million)
                 group=case_when(
                   numeric_value=="Pending"~"Pending surveillance",
                   numeric_value=="no"~"No-Endemic",
                   numeric_value=="yes"~"Endemic",
                   TRUE~"No data")
               }else {
                 if (selected_code$indicator_code[1]=="NTD_LEISHCNUM" ||selected_code$indicator_code[1]=="NTD_LEISHVNUM_IM" ||selected_code$indicator_code[1]=="NTD_LEISHCNUM_IM" ||selected_code$indicator_code[1]=="WHS3_52") { # Prevalence of anemia among women of reproductive age (% of women ages 15-49)
                   group=case_when(
                     numeric_value>=99.6 ~"More than 100 cases",
                     numeric_value>=9.6 & numeric_value<=99.5 ~"Between 9 and 100 cases",
                     numeric_value>0.01 & numeric_value<9.6 ~"At least 10 cases",
                     TRUE~"Data not available")
                 }else {
                   if (selected_code$indicator_code[1]=="MALARIA_INDIG_STATUS" ||selected_code$indicator_code[1]=="NTD_ONCHSTATUS" ||selected_code$indicator_code[1]=="NTD_BU_END" ||selected_code$indicator_code[1]=="NTD_YAWSEND" ||selected_code$indicator_code[1]=="NTD_LEISHVEND") { # Status value
                     group=case_when(
                       numeric_value=="Pending"~"Pending surveillance",
                       numeric_value=="no"~"No-Endemic",
                       numeric_value=="yes"~"Endemic",
                       TRUE~"No data")
                   }else {
                     if (selected_code$indicator_code[1]=="MALARIA005" || selected_code$indicator_code[1]=="MDG_0000000016" || selected_code$indicator_code[1]=="MALARIA_EST_MORTALITY" || selected_code$indicator_code[1]=="WHS2_152") { # Percentage of children born in the last 2 years who were put to the breast within one hour of birth
                       group=case_when(
                         numeric_value>=90.6 ~">91 per one million",
                         numeric_value>=80.6 & numeric_value<=90.5 ~"81–90 per one million",
                         numeric_value>=69.6 & numeric_value<=80.5 ~"71–80 per one million",
                         numeric_value>=49.6 & numeric_value<69.5 ~"51-70 per one million",
                         numeric_value>=29.6 & numeric_value<50.5 ~"30-50 per one million",
                         numeric_value>0.01 & numeric_value<29.5 ~"<30 per one million",
                         TRUE~"Data not available")
                     }else {
                       if (selected_code$indicator_code[1]=="MALARIA001" || selected_code$indicator_code[1]=="MDG_0000000016" || selected_code$indicator_code[1]=="WHS2_152"|| selected_code$indicator_code[1]=="MALARIA004") { # Average dietary energy requirement (kcal/cap/day)
                         group=case_when(
                           numeric_value>=99.6 ~"More than 100 cases",
                           numeric_value>=9.6 & numeric_value<=99.5 ~"Between 9 and 100 cases",
                           numeric_value>0.01 & numeric_value<9.6 ~"At least 10 cases",
                           TRUE~"Data not available")
                       }else {
                         if (selected_code$indicator_code[1]=="MDG_0000000014" || selected_code$indicator_code[1]=="WHS2_164"||selected_code$indicator_code[1]=="MALARIA_IPTP3_COVERAGE"|| selected_code$indicator_code[1]=="MALARIA_ITN_COVERAGE") { # C
                           group=case_when(
                             numeric_value>80 ~"More 80%",
                             numeric_value>70 & numeric_value<=80 ~"71–80%",
                             numeric_value>50 & numeric_value<=70 ~"51-70%",
                             numeric_value>=30 & numeric_value<=50 ~"30-50%",
                             numeric_value>0 & numeric_value<30 ~"<30%",
                             TRUE~"Data not available")
                         }else {
                           if (selected_code$indicator_code[1]=="Deaths due to malaria (per 100 000 population)" || selected_code$indicator_code[1]=="Estimated malaria mortality rate (per 100 000 population)" || selected_code$indicator_code[1]=="Malaria incidence per 100 000 population") { # Incidence of caloric losses at retail distribution level (percent)
                             group=case_when(
                               numeric_value>=7 ~">=7 per 100000",
                               numeric_value>=4 & numeric_value<=6 ~"4–6 per 100000",
                               numeric_value>=2 & numeric_value<=3 ~"2–3 per 100000 ",
                               numeric_value>0.01 & numeric_value<1 ~"<1 per 100000 ",
                               TRUE~"Data not available")
                           }else {
                             if (selected_code$indicator_code[1]=="Malaria incidence (per 1 000 population at risk)") { # Minimum dietary energy requirement  (kcal/cap/day)
                               group=case_when(
                                 numeric_value>0.6 ~"More 0.3",
                                 numeric_value>=0.2 & numeric_value<=0.3 ~"0.2 to 0.3",
                                 numeric_value>0.01 & numeric_value<=0.1 ~"0.01 to 0.1",
                                 TRUE~"Data not available")
                             }else {
                               if (selected_code$indicator_code[1]=="MALARIA_RDT_TEST"||selected_code$indicator_code[1]=="MALARIA_SUSPECTS"|| selected_code$indicator_code[1]=="MALARIA_INDIG"||selected_code$indicator_code[1]=="MALARIA_PV_INDIG" || selected_code$indicator_code[1]=="MALARIA_CONF_CASES" || selected_code$indicator_code[1]=="MALARIA_1STLINE_TREATED"|| selected_code$indicator_code[1]=="MALARIA_RDT_POS"|| selected_code$indicator_code[1]=="MALARIA_MICR_POS") { # 
                                 group=case_when(
                                   numeric_value>=99.6 ~"More than 100 cases",
                                   numeric_value>=9.6 & numeric_value<=99.5 ~"Between 9 and 100 cases",
                                   numeric_value>0.01 & numeric_value<9.6 ~"At least 10 cases",
                                   TRUE~"Data not available")
                               }else {
                                 if (selected_code$indicator_code[1]=="MALARIA002" || selected_code$indicator_code[1]=="WHS3_48"|| selected_code$indicator_code[1]=="MALARIA_IMPORTED"||selected_code$indicator_code[1]=="MALARIA_MICR_TEST" ||selected_code$indicator_code[1]=="MALARIA_EST_CASES") { # 
                                   group=case_when(
                                     numeric_value>=99.6 ~"More than 100 cases",
                                     numeric_value>=9.6 & numeric_value<=99.5 ~"Between 9 and 100 cases",
                                     numeric_value>0.01 & numeric_value<9.6 ~"At least 10 cases",
                                     TRUE~"Data not available")
                                 }else {
                                   if (selected_code$indicator_code[1]=="NTD_4" || selected_code$indicator_code[1]=="NTD_5") { # Percentage of 6-23 months old children who received minimum meal frequency
                                     group=case_when(
                                       numeric_value>=99.6 ~"More than 100 cases",
                                       numeric_value>=9.6 & numeric_value<=99.5 ~"Between 9 and 100 cases",
                                       numeric_value>0.01 & numeric_value<9.6 ~"At least 10 cases",
                                       TRUE~"Data not available")
                                   }else {
                                     if (selected_code$indicator_code[1]=="MALARIA001" || selected_code$indicator_code[1]=="MALARIA004"|| selected_code$indicator_code[1]=="MALARIA003" ||selected_code$indicator_code[1]=="MALARIA_EST_DEATHS") { # Percentage of children 6-23 months of age who consumed eggs and/or flesh foods during the previous day
                                       group=case_when(
                                         numeric_value>=99.6 ~"More than 100 deaths",
                                         numeric_value>=9.6 & numeric_value<=99.5 ~"Between 9 and 100 deaths",
                                         numeric_value>0.01 & numeric_value<9.6 ~"At least 10 deaths",
                                         TRUE~"Data not available")
                                     }else {
                                       if (selected_code$indicator_code[1]=="Status of indigenous malaria cases") { # Percentage of children 6–23 months of age consuming foods and beverages from three or four out of eight defined food groups during the previous day.
                                         group=case_when(
                                           numeric_value=="Pending"~"Pending surveillance",
                                           numeric_value=="no"~"No-Endemic",
                                           numeric_value=="yes"~"Endemic",
                                           TRUE~"No data")
                                       }else {
                                         if (selected_code$indicator_code[1]=="MALARIA_ACT_TREATED" ||selected_code$indicator_code[1]=="MALARIA_IRS_COVERAGE"||selected_code$indicator_code[1]=="NTD_ONCTREAT" || selected_code$indicator_code[1]=="NTD_ONCHEMO") { # Percentage of children 6–23 months of age consuming foods and beverages from zero, one or two out of eight defined food groups during the previous day.
                                           group=case_when(
                                             numeric_value>80 ~"More 80%",
                                             numeric_value>70 & numeric_value<=80 ~"71–80%",
                                             numeric_value>50 & numeric_value<=70 ~"51-70%",
                                             numeric_value>=30 & numeric_value<=50 ~"30-50%",
                                             numeric_value>0 & numeric_value<30 ~"<30%",
                                             TRUE~"Data not available")
                                         }else {
                                           if (selected_code$indicator_code[1]=="MALARIA_PRES_CASES" || selected_code$indicator_code[1]=="MALARIA_TOTAL_CASES" ||selected_code$indicator_code[1]=="MALARIA_PF_INDIG") { # Infant mortality
                                             group=case_when(
                                               numeric_value>=99.6 ~"More than 100 cases",
                                               numeric_value>=9.6 & numeric_value<=99.5 ~"Between 9 and 100 cases",
                                               numeric_value>0.01 & numeric_value<9.6 ~"At least 10 cases",
                                               TRUE~"Data not available")
                                           }else {
                                             if (selected_code$indicator_code[1]=="WHS3_50" || selected_code$indicator_code[1]=="NTD_LEPR8"||selected_code$indicator_code[1]=="NTD_LEPR9"||selected_code$indicator_code[1]=="NTD_LEPR5") { # 
                                               group=case_when(
                                                 numeric_value>=99.6 ~"More than 100 cases",
                                                 numeric_value>=9.6 & numeric_value<=99.5 ~"Between 9 and 100 cases",
                                                 numeric_value>0.01 & numeric_value<9.6 ~"At least 10 cases",
                                                 TRUE~"Data not available")
                                             }else {
                                               if (selected_code$indicator_code[1]=="Status of endemicity of onchocerciasis") { # Under‐five mortality
                                                 group=case_when(
                                                   numeric_value=="Pending"~"Pending surveillance",
                                                   numeric_value=="no"~"No-Endemic",
                                                   numeric_value=="yes"~"Endemic",
                                                   TRUE~"No data")
                                               }else {
                                                 if (selected_code$indicator_code[1]=="NTD_LEPR3" ||selected_code$indicator_code[1]=="NTD_LEPR11" ||selected_code$indicator_code[1]=="WHS3_45") { # Per capita food production variability (constant 2014-2016 thousand int$ per capita).
                                                   group=case_when(
                                                     numeric_value>=99.6 ~"More than 100 cases",
                                                     numeric_value>=9.6 & numeric_value<=99.5 ~"Between 9 and 100 cases",
                                                     numeric_value>0.01 & numeric_value<9.6 ~"At least 10 cases",
                                                     TRUE~"Data not available")
                                                 }else {
                                                   if (selected_code$indicator_code[1]=="NTD_YAWSNUM" || selected_code$indicator_code[1]=="NTD_YAWSNUM_CONF" ||selected_code$indicator_code[1]=="NTD_YAWSNUM_SUSP"||selected_code$indicator_code[1]=="NTD_1") { # Per capita food supply variability (kcal/cap/day)
                                                     group=case_when(
                                                       numeric_value>50 ~"More 50 cases",
                                                       numeric_value>=21 & numeric_value<=50 ~"21 to 50 cases",
                                                       numeric_value>=11 & numeric_value<=20 ~"11 to 20 cases",
                                                       numeric_value>=2 & numeric_value<=10 ~"2 to 10 cases",
                                                       numeric_value>0.01 & numeric_value<=1 ~"<1 cases",
                                                       TRUE~"Data not available")
                                                   }else {
                                                     if (selected_code$indicator_code[1]=="NTD_BU_SUSP"|| selected_code$indicator_code[1]=="NTD_BU_CONF"|| selected_code$indicator_code[1]=="NTD_LEISHCNUM" || selected_code$indicator_code[1]=="NTD_LEISHCNUM_IM" || selected_code$indicator_code[1]=="NTD_LEISHVNUM") { # Prevalence of undernourishment (% of population)
                                                       group=case_when(
                                                         numeric_value>=57.7 ~"More 57.7 cases",
                                                         numeric_value>=42.7 & numeric_value<57.7 ~"42.7 to <57.7 cases",
                                                         numeric_value>=29.8 & numeric_value<42.7 ~"29.8 to <42.7 cases",
                                                         numeric_value>=15.3 & numeric_value<29.8 ~"15.3 to <29.8 cases",
                                                         numeric_value>0.01 & numeric_value<15.3 ~"<15.3 cases",
                                                         TRUE~"No data")
                                                     }else {
                                                       if (selected_code$indicator_code[1]=="Status of yaws endemicity") { # Children under five with diarrhea receiving care
                                                         group=case_when(
                                                           numeric_value=="Pending"~"Pending surveillance",
                                                           numeric_value=="no"~"No-Endemic",
                                                           numeric_value=="yes"~"Endemic",
                                                           TRUE~"No data")
                                                       }
                                                     }
                                                   }
                                                 }
                                               }
                                             }
                                           }
                                         }
                                       }
                                     }
                                   }
                                 }
                               }
                             }
                           }
                         }
                       }
                     }
                   }
                 }
               }
             }
           }
         })

  colnames(df_sex_tvd) <- c("dim1", "Value", "Category")
         
graph_sex_tvd<-df_sex_tvd%>% 
  #mutate(prop =round(result / sum(result)*100,1))%>%
  arrange(desc(Value))%>%
  hchart(type = "bar", hcaes(x = dim1, y = Value, group = Category),dataLabels = list(enabled = TRUE, format='{point.Value:.1f}'))%>%
  hc_colors(colors_pal)%>%
  hc_exporting(enabled = TRUE)%>%
  hc_title(text=paste0("good",#input$index_ind_dshb," in  ",#unique(max(input$progress_timingInput[2]))),
                       align="center"))%>%
  hc_credits(enabled = TRUE, 
             text = "Data Source: WHO‐UNICEF Joint Monitoring Programme, 2022",
             style = list(fontSize = "10px"))%>%
  hc_add_theme(hc_theme_smpl())

graph_sex_tvd
