# ---- 1. Catégorisation numérique ----
categorize_group_fct <- function(indicator_code, numeric_value) {
  dplyr::case_when(
    # Cas malaria/leprosy avec seuils en nombre de cas
    indicator_code %in% c("NTD_RAB2","NTD_LEPR11","WHS3_45","NTD_LEPR3","NTD_LEPR5","NTD_LEPR9",
                          "NTD_LEPR8","WHS3_50","MALARIA_PF_INDIG","MALARIA_TOTAL_CASES",
                          "MALARIA_PRES_CASES","NTD_TRA5","NTD_5","NTD_4","NTD_BU_CONF",
                          "NTD_1","NTD_BU_SUSP","MALARIA001","MDG_0000000016","WHS2_152","MALARIA004") ~ dplyr::case_when(
                            numeric_value >= 99.6 ~ ">100 cases",
                            numeric_value >= 50.6 ~ "51–99 cases",
                            numeric_value >= 9.6  ~ "10–50 cases",
                            numeric_value > 0     ~ "<10 cases",
                            TRUE ~ "Data not available"
                          ),
    # Cas leishmaniasis avec seuils en nombre de cas
    indicator_code %in% c("NTD_LEISHCNUM","NTD_LEISHVNUM","NTD_LEISHCNUM_IM","NTD_LEISHVNUM_IM") ~ dplyr::case_when(
                            numeric_value >= 10000 ~ "More than 10000 cases",
                            numeric_value >= 1000 ~ "Between 1000 and 10000 cases",
                            numeric_value >= 100  ~ "Between 100 and 1000 cases",
                            numeric_value > 10     ~ "At least 100 cases",
                            TRUE ~ "Data not available"
                          ),
    # Cas mortalité par million
    indicator_code %in% c("NTD_LEPR7","NTD_LEPR4","NTD_LEPR2","NTD_LEPR13","MALARIA005",
                          "MDG_0000000016","MALARIA_EST_MORTALITY","WHS2_152") ~ dplyr::case_when(
                            numeric_value >= 90.6 ~ "≥91 per million",
                            numeric_value >= 80.6 ~ "81–90 per million",
                            numeric_value >= 69.6 ~ "71–80 per million",
                            numeric_value >= 49.6 ~ "51–70 per million",
                            numeric_value >= 29.6 ~ "30–50 per million",
                            numeric_value > 0     ~ "<30 per million",
                            TRUE ~ "Data not available"
                          ),
    
    # Cas couverture (%)
    indicator_code %in% c("MDG_0000000014","WHS2_164","MALARIA_IPTP3_COVERAGE","MALARIA_ITN_COVERAGE",
                          "VACCINECOVERAGE_YFV","MALARIA_IRS_COVERAGE") ~ dplyr::case_when(
                            numeric_value >= 90.6 ~ "≥91%",
                            numeric_value >= 80.6 ~ "81–90%",
                            numeric_value >= 69.6 ~ "71–80%",
                            numeric_value >= 50.6 ~ "51–70%",
                            numeric_value >= 29.5 ~ "30–50%",
                            numeric_value > 0     ~ "<30%",
                            TRUE ~ "Data not available"
                          ),
    
    # Cas mortalité pour 100000
    indicator_code %in% c("MALARIA_EST_MORTALITY") ~ dplyr::case_when(
      numeric_value >= 7 ~ "≥7 per 100000",
      numeric_value >= 4 ~ "4–6 per 100000",
      numeric_value >= 2 ~ "2–3 per 100000",
      numeric_value > 0  ~ "<1 per 100000",
      TRUE ~ "Data not available"
    ),
    
    # Cas grands nombres (millions)
    indicator_code %in% c("NTD_7","MALARIA_ACT_TREATED","MALARIA_EST_DEATHS","MALARIA003",
                          "MALARIA004","MALARIA001","MALARIA_EST_CASES","MALARIA_MICR_TEST",
                          "MALARIA_IMPORTED","NTD_8","NTD_ONCTREAT","NTD_ONCHEMO","MALARIA002",
                          "MALARIA_RDT_TEST","MALARIA_SUSPECTS","MALARIA_INDIG","MALARIA_PV_INDIG",
                          "MALARIA_CONF_CASES","MALARIA_1STLINE_TREATED","MALARIA_RDT_POS",
                          "MALARIA_MICR_POS","WHS3_48") ~ dplyr::case_when(
                            numeric_value > 10000000 ~ ">10 million",
                            numeric_value > 5000000  ~ "5–10 million",
                            numeric_value > 2000000  ~ "2–5 million",
                            numeric_value > 1000000  ~ "1–2 million",
                            numeric_value > 0        ~ "<1 million",
                            TRUE ~ "Data not available"
                          ),
    
    # Cas financiers
    indicator_code %in% c("MALARIA_NMCP_CALCULATIONS") ~ dplyr::case_when(
      numeric_value >= 10001 ~ ">10000$",
      numeric_value >= 5000  ~ "5000–10000$",
      numeric_value > 0      ~ "<5000$",
      TRUE ~ "Data not available"
    ),
    
    TRUE ~ "Data not available"
  )
}

# ---- 2. Catégorisation alpha ----
categorize_group_alpha_fct <- function(indicator_code, alpha_value) {
  dplyr::case_when(
    indicator_code == "NTD_BU_END" ~ dplyr::case_when(
      alpha_value %in% c("Previously endemic (current status unknown)") ~ alpha_value,
      alpha_value %in% c("Non-endemic","Currently endemic") ~ alpha_value,
      TRUE ~ "No data"
    ),
    indicator_code == "MALARIA_INDIG_STATUS" ~ dplyr::case_when(
      alpha_value %in% c("One or more indigenous case","Certified malaria free after 2000","No Malaria") ~ alpha_value,
      TRUE ~ "No data"
    ),
    indicator_code == "NTD_ONCHSTATUS" ~ dplyr::case_when(
      alpha_value %in% c("Endemic","Surveillance","Thought not requiring PC","Elimination verified") ~ alpha_value,
      TRUE ~ "No data"
    ),
    indicator_code %in% c("NTD_LEISHCEND","NTD_LEISHVEND") ~ dplyr::case_when(
      alpha_value %in% c("Endemic","No autochthonous cases reported","Previously reported cases") ~ alpha_value,
      TRUE ~ "No data"
    ),
    indicator_code == "NTD_YAWSEND" ~ dplyr::case_when(
      alpha_value %in% c("Previously endemic (current status unknown)","Currently endemic","No previous history of yaws") ~ alpha_value,
      TRUE ~ "No data"
    ),
    TRUE ~ "Data not available"
  )
}
