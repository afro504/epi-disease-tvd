#001.1 COLORS FOR FIGURE----------------------------------------------
colors_pal1 <- c("#999999", "#E69F00", "#56B4E9", "#009E73",
                 "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
colors_pal=c("green","#92C5DE","#2166AC","#F4A582","darkorange","#B2182B")

colors_pal2 <- c("#92C5DE", "#4393C3", "#2166AC","#B2182B", "#D6604D", "#F4A582")



#001.2 COLORS FOR INDICATOR PERFORMANCE----------------------------


fct_map_col_perf <- function(mapcolperf,a="input$epi_ui"){
  
  if (a=="Prevalence"){
    list(
      list(from=0.0, to=0.001, color="#999999", name="Zero advancement"),
      list(from=0.01, to=29.5, color="#D6604D", name="Weak progress (<30%)"),
      list(from=29.6, to=69.5, color="#E8AABE", name="Medium progress (30-70%)"),
      list(from=69.6, to=100, color="green", name="Strong progress (70-100%)")
    )
  } else {
    if (a=="Incidence") { # Number of women of reproductive age (15-49 years) affected by anemia (million)
      list(
        list(from=0.0, to=0.001, color="#999999", name="Zero advancement"),
        list(from=0.01, to=29.5, color="#D6604D", name="Weak progress (<30%)"),
        list(from=29.6, to=69.5, color="#E8AABE", name="Medium progress (30-70%)"),
        list(from=69.6, to=100, color="green", name="Strong progress (70-100%)")
      )
    }else {
      if (a=="Death") { # Percentage of children born in the last 2 years who were put to the breast within one hour of birth
        list(
          list(from=0.0, to=0.001, color="#999999", name="Zero advancement"),
          list(from=0.01, to=29.5, color="#D6604D", name="Weak progress (<30%)"),
          list(from=29.6, to=69.5, color="#E8AABE", name="Medium progress (30-70%)"),
          list(from=69.6, to=100, color="green", name="Strong progress (70-100%)")
        )
      }else {
        if (a=="Strategy") { 
          list(
            list(from=0.0, to=0.001, color="#999999", name="Zero advancement"),
            list(from=0.01, to=29.5, color="#D6604D", name="Weak progress (<30%)"),
            list(from=29.6, to=69.5, color="#E8AABE", name="Medium progress (30-70%)"),
            list(from=69.6, to=100, color="green", name="Strong progress (70-100%)")
          )
      }
    }
  }
  }
}




# Définition de la fonction
fct_map_status_colors <- function() {
  c(
    "Zero advancement" = "#fb6a4a",
    "Weak progress (<30%)" = "#E8AABE",
    "Medium progress (30-70%)" = "yellow",
    "Strong progress (70-100%)" = "green",
    "Non disponible" = "grey80"
  )
}

# Fonction qui retourne les labels
fct_map_status_labels <- function() {
  names(fct_map_status_colors())
}

# ---- 2. Catégorisation des couleurs pour hcmap ----

#,"NTD_LEISHCNUM","NTD_LEISHVNUM","NTD_LEISHCNUM_IM","NTD_LEISHVNUM_IM"
fct_map_col <- function(a) {
  if (a %in% c("NTD_LEPR11","WHS3_45","NTD_LEPR3","NTD_LEPR5","NTD_LEPR9","NTD_LEPR8","WHS3_50","MALARIA_PF_INDIG","MALARIA_TOTAL_CASES","MALARIA_PRES_CASES","NTD_TRA5","NTD_5","NTD_4","NTD_BU_CONF", "NTD_1", "NTD_BU_SUSP","MALARIA001","MDG_0000000016","WHS2_152","MALARIA004")) {
    list(
      list(from = 0, to = 9, color = "#fee5d9", name = "At least 100 cases"),
      list(from = 10, to = 50, color = "#fcae91", name = "Between 9 and 50 cases"),
      list(from = 51, to = 100, color = "#fb6a4a", name = "Between 9 and 100 cases"),
      list(from = 101, color = "#cb181d", name = "More than 100 cases")
    )
  } else if (a %in% c("NTD_LEPR7","NTD_LEPR4","NTD_LEPR2","NTD_LEPR13","MALARIA005","MDG_0000000016","MALARIA_EST_MORTALITY","WHS2_152")) {
    list(
      list(from = 0, to = 29, color = "#edf8fb", name = "<30 per one million"),
      list(from = 30, to = 50, color = "#b2e2e2", name = "30-50 per one million"),
      list(from = 51, to = 70, color = "#66c2a4", name = "51-70 per one million"),
      list(from = 71, to = 80, color = "#2ca25f", name = "71–80 per one million"),
      list(from = 81, to = 90, color = "#006d2c", name = "81–90 per one million"),
      list(from = 91, color = "#00441b", name = ">91 per one million")
    )
  } else if (a %in% c("NTD_LEPR3","NTD_LEPR11","NTD_LEPR5","NTD_LEPR9")) {
    list(
      list(from = 0, to = 9, color = "#fee5d9", name = "At least 10 cases"),
      list(from = 10, to = 50, color = "#fcae91", name = "Between 9 and 50 cases"),
      list(from = 51, to = 100, color = "#fb6a4a", name = "Between 9 and 100 cases"),
      list(from = 101, color = "#cb181d", name = "More than 100 cases")
    )
  } else if (a %in% c("MDG_0000000014","WHS2_164","MALARIA_IPTP3_COVERAGE","MALARIA_ITN_COVERAGE")) {
    list(
      list(from=0.01, to=29.5, color="#D6604D", name="<30%"),
      list(from=29.5, to=50.5, color="darkorange", name="30-50%"),
      list(from=50.5, to=69.5, color="#fcae91", name="51-70%"),
      list(from=69.5, to=80.5, color="#b2e2e2", name="71–80%"),
      list(from=80.5, to=90.5, color="#66c2a4", name="81–90%"),
      list(from=90.5, to=100, color="#00441b", name="≥91%")
    )
  } else if (a %in% c("MALARIA_EST_MORTALITY")) {
    list(
      list(from=0.01, to=1, color="#E8AABE", name="<1 per 100000"),
      list(from=2, to=3, color="darkorange", name="2–3 per 100000"),
      list(from=4, to=6, color="#fb6a4a", name="4–6 per 100000"),
      list(from=7, to=100, color="#D6604D", name=">=7 per 100000")
    )
  } else if (a %in% c("NTD_7","MALARIA_IRS_COVERAGE","MALARIA_ACT_TREATED","MALARIA_EST_DEATHS","MALARIA003","MALARIA004","MALARIA001","MALARIA_EST_CASES","MALARIA_MICR_TEST","MALARIA_IMPORTED","NTD_8","NTD_ONCTREAT","NTD_ONCHEMO","MALARIA002","MALARIA_RDT_TEST","MALARIA_SUSPECTS","MALARIA_INDIG","MALARIA_PV_INDIG","MALARIA_CONF_CASES","MALARIA_1STLINE_TREATED","MALARIA_RDT_POS","MALARIA_MICR_POS","WHS3_48")) {
    list(
      list(from=0.0, to=0.001, color="#999999", name="No PC required"),
      list(from=0.01, to=1000000, color="#D6604D", name="< one million"),
      list(from=1000000, to=2000000, color="darkorange", name="1 to 2 millions"),
      list(from=2000000, to=5000000, color="yellow", name="2 to 5 millions"),
      list(from=5000000, to=10000000, color="#92C5DE", name="5 to 10 millions"),
      list(from=10000000, to=80000000, color="green", name=">10 millions")
    )
  } 
  else if (a %in% c("NTD_RAB2","NTD_YAWSNUM_SUSP","NTD_YAWSNUM_CONF","NTD_YAWSNUM_SUSP","NTD_1")) {
    list(
      list(from=0.0, to=0.001, color="#999999", name="Data not available"),
      list(from=0.01, to=9.6, color="green", name="At least 10 cases"),
      list(from=9.6, to=50.5, color="#92C5DE", name="Between 9 and 50 cases"),
      list(from=50.5, to=99.5, color="yellow", name="Between 51 and 99 cases"),
      list(from=99.6, to=100, color="darkorange", name="More than 100 cases")
    )
  }else if (a %in% c("PMALARIA_NMCP_CALCULATIONS")) {
    list(
      list(from=0.0, to=0.001, color="#999999", name="Data not available"),
      list(from=0.01, to=5000, color="yellow", name="At least 5000$"),
      list(from=5000, to=10000, color="#E8AABE", name="Between 5000$ and 10000$"),
      list(from=10000, to=500000, color="#D6604D", name="More than 10000$")
    )
  }
  else if (a %in% c("VACCINECOVERAGE_YFV","MALARIA_IPTP3_COVERAGE","MALARIA_ITN_COVERAGE","MALARIA_IRS_COVERAGE")) {
    list(
      list(from=0.0, to=0.001, color="#999999", name="Data not available"),
      list(from=0.01, to=29.5, color="#D6604D", name="<30%"),
      list(from=29.5, to=50.5, color="#CF5C78", name="30-50%"),
      list(from=50.5, to=69.5, color="#E8AABE", name="51-70%"),
      list(from=69.5, to=80.5, color="yellow", name="71–80%"),
      list(from=80.5, to=90.5, color="#92C5DE", name="81–90%"),
      list(from=90.5, to=100, color="green", name="≥91%")
    )
  }else if (a %in% c("NTD_LEISHCNUM","NTD_LEISHVNUM","NTD_LEISHCNUM_IM","NTD_LEISHVNUM_IM")) {
    list(
      list(from = 0, to = 9, color = "#fee5d9", name = "At least 10 cases"),
      list(from = 100, to = 1000, color = "#fcae91", name = "Between 100 and 1000 cases"),
      list(from = 1001, to = 10000, color = "#fb6a4a", name = "Between 1000 and 10000 cases"),
      list(from = 10001, color = "#cb181d", name = "More than 10000 cases")
    )
  }
  else if (a %in% c("NTD_BU_END")) {
    list(
      list(from="Currently endemic", color="#E8AABE", name="Currently endemic"),
      list(from="Non-endemic", color="green", name="Non-endemic"),
      list(from="Previously endemic (current status unknown)", color="yellow", name="Previously endemic (current status unknown)")
    )
  }
  else if (a %in% c("NTD_LEISHCEND")) {
    list(
      list(from="No autochthonous cases reported", color="green", name="No autochthonous cases reported"),
      list(from="Endemic", color="#E8AABE", name="Endemic"),
      list(from="Previously reported cases", color="yellow", name="Previously reported cases")
    )
  }
  else if (a %in% c("NTD_LEISHVEND")) {
    list(
      list(from="Data not available", color="#999999", name="Data not available"),
      list(from="Previously reported cases", color="yellow", name="Previously reported cases"),
      list(from="No autochthonous cases reported", color="#92C5DE", name="No autochthonous cases reported"),
      list(from="Endemic", color="#D6604D", name="Endemic")
    )
  }
  else if (a %in% c("NTD_ONCHSTATUS")) {
    list(
      list(from="Data not available", color="#999999", name="Data not available"),
      list(from="Elimination verified", color="green", name="Elimination verified"),
      list(from="Surveillance", color="yellow", name="Surveillance"),
      list(from="Thought not requiring PC", color="#92C5DE", name="Thought not requiring PC"),
      list(from="Endemic", color="#D6604D", name="Endemic")
    )
  }
  else if (a %in% c("NTD_YAWSEND")) {
    list(
      list(from="Data not available", color="#999999", name="Data not available"),
      list(from="Previously endemic (current status unknown)", color="yellow", name="Previously endemic (current status unknown)"),
      list(from="Currently endemic", color="darkorange", name="Currently endemic"),
      list(from="No previous history of yaws", color="green", name="No previous history of yaws")
    )
  }else if (a %in% c("MALARIA_INDIG_STATUS")) {
    list(
      list(from="Data not available", color="#999999", name="Data not available"),
      list(from="One or more indigenous case", color="darkorange", name="One or more indigenous case"),
      list(from="No Malaria", color="yellow", name="No Malaria"),
      list(from="Certified malaria free after 2000", color="green", name="Certified malaria free after 2000")
    )
  }
  else {
    list(
      list(from = 0, to = 0.001, color = "#f0f0f0", name = "Data not available")
    )
  }
}







# Fonction dictionnaire OMS
fct_map_col_indicator <- function(a) {
  col_dict <- c(
    "At least 10 cases" = "#fee5d9",
    "Between 9 and 50 cases" = "#fcae91",
    "Between 51 and 100 cases" = "#fb6a4a",
    "More than 100 cases" = "#cb181d",
    ">100 cases"="#cb181d",
    "51–99 cases"="#fb6a4a",
    "10–50 cases"= "#fcae91",
    "<10 cases"= "#fee5d9",
    "More than 10000 cases"="#cb181d",
    "Between 1000 and 10000 cases"="darkorange",
    "Between 100 and 1000 cases"="#fcae91",
    "At least 100 cases"= "#fee5d9",
    "<30 per one million" = "#edf8fb",
    "30-50 per one million" = "#b2e2e2",
    "51-70 per one million" = "#66c2a4",
    "71–80 per one million" = "#2ca25f",
    "81–90 per one million" = "#006d2c",
    ">91 per one million" = "#00441b",
    
    "<30 per million" = "#edf8fb",
    "30–50 per million" = "#b2e2e2",
    "51–70 per million" = "#66c2a4",
    "71–80 per million" = "#2ca25f",
    "81–90 per million" = "#006d2c",
    "≥91 per million" = "#00441b",
    
   ">10 million"="#cb181d",
    "5–10 million"="darkorange",
  "2–5 million"="#fcae91",
    "1–2 million"="#b2e2e2",
    "<1 million"= "#66c2a4",
    
   ">10000$"="#D6604D",
  "5000–10000$"= "#fcae91",
  "<5000$"="#66c2a4",
    
    "<30%" = "#D6604D",
    "30-50%" = "darkorange",
    "51-70%" = "#fcae91",
    "71–80%" = "#b2e2e2",
    "81–90%" = "#66c2a4",
    "≥91%" = "#00441b",
    "<1 per 100000" = "#E8AABE",
    "2–3 per 100000" = "darkorange",
    "4–6 per 100000" = "#fb6a4a",
    ">=7 per 100000" = "#D6604D",
    "No PC required" = "#999999",
    "Currently endemic" = "#E8AABE",
    "Non-endemic" = "green",
    "Previously endemic (current status unknown)" = "yellow",
    "No autochthonous cases reported" = "#92C5DE",
    "Elimination verified" = "green",
    "Surveillance" = "yellow",
    "High burden" = "#cb181d",
    "Medium burden" = "darkorange",
    "Low burden" = "#fee5d9",
    "No data" = "#f0f0f0"
  )
  return(col_dict[a])
}



# ---- 3. Catégorisation des couleurs pour tmap ----



fct_group_colors <- function() {
  tm_scale_categorical(
    values = c(
      "< one million" = "#CC79A7",
      "1 to 2 millions" = "#F4A582",
      "2 to 5 millions" = "#56B4E9",
      "5 to 10 millions" = "#009E73",
      ">10 millions" = "#0072B2"
    )
  )
}


fct_dynamic_scale <- function(values) {
  if (is.numeric(values)) {
    # Choix de la méthode
    values_clean <- na.omit(values)
    ci <- classIntervals(values_clean, style = "jenks")
    breaks <- ci$brks

    tm_scale_intervals(
      breaks = breaks,
      values = "iridescent",   # palette cols4all
      label.style = "interval"
    )
  } else {
    tm_scale_categorical(
      values = "brewer.set3"
     # values = c("#CC79A7", "#F4A582", "#56B4E9", "#009E73", "#0072B2", "#f0f0f0"
      #)
    )
  }
}





