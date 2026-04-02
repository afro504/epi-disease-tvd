source("global.R")
source("modules/indicator_gpe_values.R")
source("modules/map_col.R")

# ---- Filtrer dataset par pays, indicateur, groupe et période ----
fct_tvd_dfs <- function(tvd_data, a="index_country", b="index_indicator", c="index_gpe", d="timingInput1", e="timingInput2"){ 
  
  # Code indicateur
  selected_code <- tvd_dts %>% filter(indicator %in% b) %>% pull(indicator_code)
 
  # Code pays
  selected_iso <- filter_country %>% filter(country %in% a) %>% pull(iso)
  
  # Filtrage
  filter_df_tvd <- tvd_dts %>%
    filter(
      indicator_code %in% selected_code[1],
      ref_data %in% c,
      year_api >= d & year_api <= e,
      if (!a %in% Afroname$country) iso %in% selected_iso[1] else TRUE
    )
  
  return(filter_df_tvd)
}

# ---- Afficher ref_data pour un indicateur ----
fct_show_ref_data <- function(a="index_ind_dshb"){
  selected_code <- tvd_dts %>% filter(indicator == a) %>% pull(indicator_code)
  
  show_ref <- tvd_dts %>%
    filter(indicator_code %in% selected_code[1]) %>%
    distinct(ref_data, .keep_all = TRUE) %>%
    select(ref_data)
  
  return(show_ref)
}

# ---- Afficher lien source pour un indicateur ----
fct_show_link_indicator <- function(a="index_ind_dshb"){
  selected_code <- tvd_dts %>% filter(indicator == a) %>% pull(indicator_code)
  
  show_link_ind <- tvd_indicator %>%
    filter(indicator_code %in% selected_code[1]) %>%
    distinct(indicator_source, .keep_all = TRUE) %>%
    select(indicator_source)
  
  return(show_link_ind)
}

# ---- Filtrer dataset pour section "progress" ----
fct_fliter_tvd_dfs <- function(tvd2_data, a="index_country", b="index_indicator", d="input$progress_timingInput"){ 
  
  selected_ref <- tvd_dts %>% filter(indicator %in% b) %>% pull(ref_data) %>% unique()
  selected_type <- tvd_dts %>% filter(indicator %in% b) %>% pull(type_indicator) %>% unique()
  selected_code <- tvd_dts %>% filter(indicator %in% b) %>% pull(indicator_code) %>% unique()
  selected_iso  <- filter_country %>% filter(country %in% a) %>% pull(iso) %>% unique()
  
  # Filtrage générique
  base_filter <- list(
    indicator_code = selected_code[1],
    ref_data = selected_ref[1]
  )
  if (!a %in% Afroname$country) {
    base_filter$iso <- selected_iso[1]
  }
  
  df <- apply_filters(df = tvd_dts, inputs = base_filter, years = d) %>%
    distinct() %>%
    mutate(
      year_api = as.numeric(year_api),
      kp = paste(indicator_code, iso, year_api, ref_data, sep = "-")
    )
  
  # Sélection selon type
  if (selected_type[1] == "Quali_ind") {
    df <- df %>% select(type_indicator, indicator_code, iso, country, year_api, ref_data, alpha_value, kp)
  } else if (selected_type[1] == "Quanti_ind") {
    df <- df %>% select(type_indicator, indicator_code, iso, country, year_api, ref_data, numeric_value, kp)
  }
  
  return(df)
}




# ---- Filtrer dataset (version 2) ----
fct2_tvd_dfs <- function(tvd2_data, a="index_country", b="index_indicator", c="index_gpe", d="timingInput1", e="timingInput2"){ 
  
  selected_code <- tvd_dts %>% filter(indicator %in% b) %>% pull(indicator_code) %>% unique()
  selected_ref  <- tvd_dts %>% filter(indicator %in% b) %>% pull(ref_data) %>% unique()
  selected_type <- tvd_dts %>% filter(indicator %in% b) %>% pull(type_indicator) %>% unique()
  selected_iso  <- filter_country %>% filter(country %in% a) %>% pull(iso) %>% unique()
  
  # Filtrage générique
  df <- tvd_dts %>%
    distinct() %>%
    filter(
      indicator_code %in% selected_code[1],
      ref_data %in% selected_ref[1],
      year_api >= d & year_api <= e,
      if (!a %in% Afroname$country) iso %in% selected_iso[1] else TRUE
    ) %>%
    mutate(
      year_api = as.numeric(year_api),
      kp = paste(indicator_code, iso, year_api, ref_data, sep = "-")
    )
  
  # Sélection selon type
  if (selected_type[1] == "Quali_ind") {
    df <- df %>% select(type_indicator, indicator_code, iso, country, year_api, ref_data, alpha_value, kp)
  } else if (selected_type[1] == "Quanti_ind") {
    df <- df %>% select(type_indicator, indicator_code, iso, country, year_api, ref_data, numeric_value, kp)
  }
  
  return(df)
}

# ---- Filtrer dataset (version 3) ----
fct3_tvd_dfs <- function(a){ 
  
  selected_type <- unique(a$type_indicator[1])
  
  if (selected_type == "Quali_ind") {
    df <- a %>%
      ungroup() %>%
      filter(!is.na(year_api)) %>%
      group_by(type_indicator, indicator_code, iso, country, ref_data) %>%
      summarise(year_api = safe_summary(year_api, fun = "max"), .groups = "drop") %>% # max(year_api, na.rm = TRUE)
      mutate(kp = paste(indicator_code, iso, year_api, ref_data, sep = "-")) %>%
      select(type_indicator, indicator_code, iso, country, year_api, ref_data, kp) %>%
      left_join(a %>% select(kp, alpha_value), by = "kp") %>%
      select(country, iso, type_indicator, indicator_code, year_api, ref_data, alpha_value)
    
  } else if (selected_type == "Quanti_ind") {
    df <- a %>%
      ungroup() %>%
      filter(!is.na(year_api)) %>%
      group_by(type_indicator, indicator_code, iso, country, ref_data) %>%
      summarise(year_api = safe_summary(year_api, fun = "max"), .groups = "drop") %>% # max(year_api, na.rm = TRUE)
      mutate(kp = paste(indicator_code, iso, year_api, ref_data, sep = "-")) %>%
      select(type_indicator, indicator_code, iso, country, year_api, ref_data, kp) %>%
      inner_join(a %>% select(kp, numeric_value), by = "kp") %>%
      select(country, iso, type_indicator, indicator_code, year_api, ref_data, numeric_value)
  }
  
  return(df)
}

## AGREGATE DATA FOR QUALITATIVE VALUE FOR EACH INDICATOR SELECTED -------------------------

## AGREGATE DATA FOR QUANTITATIVE VALUE FOR EACH INDICATOR SELECTED -------------------------

##. vbox_result01 for indicator progress ---------------------------
fct4_tvd_dfs <- function(tvd4_data, a="dataset", b="index_indicator", c="country", e="show_link_indicator()"){
  
  selected_unit <- tvd_indicator %>% filter(indicator %in% b) %>% pull(indicator_unit) %>% unique()
  type_indi     <- unique(a$type_indicator)[1]
  
  # Cas vide
  if (nrow(a) == 0) {
    return(
      valueBoxSpark(
        value = "",
        title = "Data for this indicator is unavailable",
        sparkobj = "",
        subtitle = "",
        width = 3,
        color = "red"
      )
    )
  }
  
  # ---- Cas quantitatif ----
  if (type_indi == "Quanti_ind") {
    # Agrégation par année
    select_result <- a %>%
      filter(numeric_value >= 0, year_api > 0) %>%
      group_by(year_api) %>%
      summarise(
        numeric_value = if (selected_unit[1] == "Number") {
          round(sum(numeric_value, na.rm = TRUE), 0)
        } else {
          round(mean(numeric_value, na.rm = TRUE), 2)
        },
        .groups = "drop"
      )
    
    # Valeurs min/max
    select_max <- select_result %>% filter(year_api == max(year_api, na.rm = TRUE))
    select_min <- select_result %>% filter(year_api == min(year_api, na.rm = TRUE))
    
    # Variation
    variation <- round((select_max$numeric_value - select_min$numeric_value) / select_max$numeric_value * 100, 1)
    variation_text <- paste0(variation, "% since ", select_min$year_api)
    
    # Sparkline
    tb_progress <- hchart(select_result, "area", hcaes(year_api, numeric_value), name = "value") %>% 
      hc_size(height = 50) %>% 
      hc_credits(enabled = TRUE) %>% 
      hc_add_theme(hc_theme_sparkline_vb())
    
    if (is.na(select_max$numeric_value)) return(NULL)
    
    return(
      valueBoxSpark(
        value = format(select_max$numeric_value, big.mark = " ", decimal.mark = ".") %>%
          paste0(if (selected_unit[1] == "Number") "" else selected_unit[1]),
        title = paste0(toupper(b), " ", select_max$year_api),
        sparkobj = tb_progress,
        subtitle = if (variation > 0) {
          tagList(HTML("&uarr;"), variation_text, c)
        } else {
          tagList(HTML("&darr;"), variation_text, c)
        },
        width = 3,
        color = "light-blue"
      )
    )
  }
  
  # ---- Cas qualitatif ----

  if (type_indi == "Quali_ind") {
    fig_pie <- a %>%
      group_by(year_api, alpha_value) %>%
      summarise(total = n(), .groups = "drop") %>%
      arrange(desc(total))
    
    total_countries <- sum(fig_pie$total)
    
    pie_chart <- hchart(fig_pie, type = "pie", hcaes(x = alpha_value, y = total)) %>%
      hc_add_theme(hc_theme_smpl()) %>%
      hc_title(
        text = paste(b, "-", c, ",", unique(fig_pie$year_api)),
        align = "center",
        style = list(color = "#0072bc", fontWeight = "bold", fontSize = "16px")
      ) %>%
      hc_colors(c("#0072bc", "#4daf4a", "#ffbf00", "#e41a1c")) %>%  # palette OMS
      hc_plotOptions(
        pie = list(
          allowPointSelect = TRUE,
          cursor = "pointer",
          borderWidth = 0,
          size = "100%",
          innerSize = "50%",        # transforme en donut
          dataLabels = list(
            enabled = TRUE,
            format = "<b>{point.name}</b><br>{point.y} pays<br>{point.percentage:.1f} %",
            distance = -30,
            style = list(fontSize = "12px", fontWeight = "bold", color = "white")
          )
        )
      ) %>%
      hc_exporting(enabled = TRUE) %>%
      hc_tooltip(pointFormat = "<b>{point.y}</b> pays ({point.percentage:.1f}%)") %>%
      hc_annotations(
        list(
          labels = list(
            list(
              point = list(x = 0, y = 0, xAxis = 0, yAxis = 0),
              text = paste0(total_countries, " pays"),
              style = list(color = "black", fontSize = "16px", fontWeight = "bold")
            )
          )
        )
      )
    
    return(
      valueBoxSpark(
        value = paste0(total_countries, " Countries"),
        title = "",
        sparkobj = pie_chart,
        subtitle = "",
        width = 3,
        color = "teal"
      )
    )
  }
  
  
  
  
  
  
  
}













fct5_tvd_dfs <- function(tvd5_data,
                         a = "index_dataset",
                         e = "show_link_indicator()",
                         f = "input$index_ind_dshb",
                         k = "input$progress_timingInput[2]") {
  
  selected_code <- tvd_dts %>% filter(indicator %in% f) %>% pull(indicator_code) %>% unique()
  selected_type <- tvd_dts %>% filter(indicator %in% f) %>% pull(type_indicator) %>% unique()
  
  # Options communes pour datatable
  dt_options <- list(
    select = list(style = 'os', items = 'row'),
    dom = 'Bfrtp',
    buttons = c('csv', 'excel', 'pdf','selectAll', 'selectNone', 'selectRows', 'selectColumns', 'selectCells'),
    style = "bootstrap",
    lengthMenu = c(seq(7, 150, 7)),
    initComplete = JS(
      "function(settings, json) {",
      "$(this.api().table().header()).css({'background-color': '#80dfff', 'color': 'black'});",
      "}")
  )
  
  caption_text <- htmltools::tags$caption(
    style = 'caption-side: bottom; text-align: center;',
    'Title', htmltools::em(paste0(f, " in WHO/Afro at ", unique(max(k)), " Data source: ", e))
  )
  
  # ---- Cas quantitatif ----
  if (selected_type[1] == "Quanti_ind") {
    tbl_result <- a %>%
      select(country, year_api, numeric_value) %>%
      mutate(group = categorize_group_fct(selected_code[1], numeric_value)) %>%
      arrange(desc(numeric_value)) %>%
      ungroup()
    
    return(
      datatable(
        tbl_result %>% mutate(numeric_value = format(numeric_value, big.mark = " ", decimal.mark = ".")),
        colnames = c('Country', 'Year', 'Value', 'Group'),
        rownames = FALSE,
        extensions = c('Select', 'Buttons'),
        options = dt_options,
        caption = caption_text,
        selection = 'none'   # ✅ Fix Select extension warning
      )
    )
  }
  
  # ---- Cas qualitatif ----
  if (selected_type[1] == "Quali_ind") {
    return(
      datatable(
        a,
        colnames = c('Country', 'ISO','Type','Indicator Code', 'Year', 'Ref Data','Alpha Value'),
        rownames = FALSE,
        extensions = c('Select', 'Buttons'),
        options = dt_options,
        caption = caption_text,
        selection = 'none'   # ✅ Fix Select extension warning
      )
    )
  }
  
  # ---- Cas absence de données ----
  return(
    datatable(
      data.frame(
        country = "There is an absence of data regarding this indicator",
        year_api = "None",
        numeric_value = "None"
      ),
      colnames = c('Country', 'Year', 'Value'),
      rownames = FALSE,
      extensions = c('Select', 'Buttons'),
      options = dt_options,
      caption = htmltools::tags$caption(
        style = 'caption-side: bottom; text-align: center;',
        'Title', htmltools::em("No recorded values exist for this indicator")
      ),
      selection = 'none'   # ✅ Fix Select extension warning
    )
  )
}


fct6_tvd_dfs <- function(tvd6_data, a="dataset", c="country", e="show_link_indicator()", f="input$index_ind_dshb"){
  
  selected_code <- tvd_dts %>% filter(indicator %in% f) %>% pull(indicator_code) %>% unique()
  selected_type <- tvd_dts %>% filter(indicator %in% f) %>% pull(type_indicator) %>% unique()
  selected_unit <- tvd_indicator %>% filter(indicator %in% f) %>% pull(indicator_unit) %>% unique()
  selected_year <- tvd_dts %>% filter(indicator %in% f) %>% pull(year_api) %>% max(na.rm = TRUE)
  
  # ---- Cas quantitatif ----
  if (selected_type[1] == "Quanti_ind") {
    graph_result <- a %>%
      left_join(flag_country %>% select(iso, subregion), by = "iso") %>%
      filter(!is.na(subregion), numeric_value > 0.1, country != "Missing data") %>%
      group_by(subregion) %>%
      summarise(
        numeric_value = if (selected_unit[1] == "Number") {
          round(sum(numeric_value, na.rm = TRUE), 0)
        } else {
          round(mean(numeric_value, na.rm = TRUE), 2)
        },
        .groups = "drop"
      ) %>%
      mutate(group = categorize_group_fct(selected_code[1], numeric_value)) %>%
      arrange(desc(numeric_value)) %>%
      rename(sub_region = subregion, value = numeric_value, Group = group) %>%
      hchart(type = "bar", hcaes(x = sub_region, y = value, color = Group),
             dataLabels = list(enabled = TRUE, format = '{point.value:.1f}')) %>%
      hc_exporting(enabled = TRUE) %>%
      hc_title(text = paste(f, "-", c, ",", selected_year), align = "center") %>%
      hc_legend(layout = "horizontal", align = "center", floating = TRUE) %>%
     # hc_add_theme(hc_theme_smpl()) %>%
      hc_add_theme(hc_theme_oms)%>%
      hc_credits(enabled = TRUE, text = "Data Source: WHO/AFRO/DPC/TVD Programme",
                 href = unique(e), style = list(fontSize = "10px"))
    
    return(graph_result)
  }
  
  # ---- Cas qualitatif ----
  graph_result <- a %>%
    filter(!is.na(year_api)) %>%
    filter(year_api == max(year_api, na.rm = TRUE)) %>%
    group_by(alpha_value) %>%
    summarise(total = n(), .groups = "drop") %>%
    mutate(
      pourcentage = round(total / sum(total) * 100, 1),
      prop_n = paste0(total, " (", pourcentage, "%)"),
      group_value = case_when(
        pourcentage >= 70 ~ "70-100%",
        pourcentage >= 30 ~ "30-70%",
        pourcentage > 0   ~ "<30%",
        TRUE ~ "No data"
      )
    ) %>%
    arrange(desc(pourcentage)) %>%
    hchart(type = "bar", hcaes(x = alpha_value, y = pourcentage, group = group_value),
           dataLabels = list(enabled = TRUE, format = '{point.prop_n}')) %>%
    hc_exporting(enabled = TRUE) %>%
    hc_xAxis(title = list(text = "Category")) %>%
    hc_yAxis(title = list(text = "")) %>%
    hc_title(text = paste("Proportion of countries according to", f, "-", c, ",", selected_year), align = "center") %>%
    hc_legend(layout = "horizontal", align = "center", floating = TRUE) %>%
    hc_add_theme(hc_theme_oms)%>%
   # hc_add_theme(hc_theme_smpl()) %>%
    hc_credits(enabled = TRUE, text = "Data Source: WHO/AFRO/DPC/TVD Programme",
               href = unique(e), style = list(fontSize = "10px"))
  
  return(graph_result)
}


#9 MAP FOR Indicator value BY COUNTRY-------------------------------------
#output$result01_map=renderHighchart({
fct7_tvd_dfs <- function(tvd7_data, g="index_dataset", c="country", e="show_link_indicator()", f="input$index_ind_dshb"){
  
  selected_code <- tvd_dts %>% filter(indicator %in% f) %>% pull(indicator_code) %>% unique()
  selected_type <- tvd_dts %>% filter(indicator %in% f) %>% pull(type_indicator) %>% unique()
  selected_year <- tvd_dts %>% filter(indicator %in% f) %>% pull(year_api) %>% max(na.rm = TRUE)
  
  # ---- Cas quantitatif ----
  if (selected_type[1] == "Quanti_ind") {
    result_map <- g %>%
      left_join(flag_country %>% select(flag, iso), by = "iso") %>%
      select(flag, numeric_value) %>%
      mutate(across(where(is.numeric), ~ replace(., is.na(.), 0))) %>%
      arrange(desc(numeric_value))
    
    map_result <- hcmap(
      map = "custom/africa",
      data = result_map,
      value = "numeric_value",
      joinBy = c("hc-key", "flag"),
      download_map_data = FALSE,
      animation = TRUE,
      borderColor = "black",
      borderWidth = 0.3,
      tooltip = list(valueDecimals = 2)
    ) %>%
      hc_colorAxis(dataClassColor = "numeric_value", dataClasses = fct_map_col(selected_code[1])) %>%
      hc_title(text = paste0(f, " - ", c, ", ", selected_year), align = "center") %>%
      hc_add_theme(hc_theme_smpl()) %>%
      hc_mapNavigation(enabled = TRUE, enableButtons = TRUE) %>%
      hc_exporting(enabled = TRUE) %>%
      hc_legend(layout = "vertical", align = "left", floating = TRUE) %>%
      hc_credits(enabled = TRUE, text = "Data Source: WHO/AFRO/DPC/TVD Programme", href = unique(e), style = list(fontSize = "10px"))
    
    return(map_result)
  }
  
  # ---- Cas qualitatif ----
  result_map <- g %>%
    filter(!is.na(year_api)) %>%
    filter(year_api == max(year_api, na.rm = TRUE)) %>%
    select(iso, alpha_value) %>%
    left_join(flag_country %>% select(flag, iso), by = "iso") %>%
    select(flag, alpha_value)
  
  map_result <- hcmap(
    map = "custom/africa",
    data = result_map,
    value = "alpha_value",
    joinBy = c("hc-key", "flag"),
    download_map_data = FALSE,
    animation = TRUE,
    borderColor = "black",
    borderWidth = 0.3,
    tooltip = list(valueDecimals = 2)
  ) %>%
    hc_colorAxis(dataClassColor = "alpha_value", dataClasses = fct_map_col(selected_code[1])) %>%
    hc_title(text = paste0(f, " - ", c, ", ", selected_year), align = "center") %>%
    hc_mapNavigation(enabled = TRUE, enableButtons = TRUE) %>%
    hc_exporting(enabled = TRUE) %>%
    hc_add_theme(hc_theme_smpl()) %>%
    hc_legend(layout = "vertical", align = "left", floating = TRUE) %>%
    hc_credits(enabled = TRUE, text = "Data Source: WHO/AFRO/DPC/TVD Programme", href = unique(e), style = list(fontSize = "10px"))
  
  return(map_result)
}


fct8_tvd_dfs <- function(tvd8_data, a="index_dataset", c="country", e="show_link_indicator()", f="input$index_ind_dshb"){
  
  selected_code <- tvd_dts %>% filter(indicator %in% f) %>% pull(indicator_code) %>% unique()
  selected_type <- tvd_dts %>% filter(indicator %in% f) %>% pull(type_indicator) %>% unique()
  selected_year <- tvd_dts %>% filter(indicator %in% f) %>% pull(year_api) %>% max(na.rm = TRUE)
  
  # ---- Cas quantitatif ----
  if (selected_type[1] == "Quanti_ind") {
    graph_result <- a %>%
      select(country, year_api, numeric_value) %>%
      mutate(group = categorize_group_fct(selected_code[1], numeric_value),
             numeric_value=round(numeric_value, digit=0) ) %>%
      arrange(desc(numeric_value)) %>%
      mutate(country = factor(country, levels = country)) %>%   # <-- ordre forcé
      hchart(type = "column", hcaes(x = country, y = numeric_value, group = group),
             dataLabels = list(enabled = TRUE, format = '{point.numeric_value:.0f}')) %>%
      hc_title(text = paste(f, "-", c, ",", selected_year), align = "center") %>%
      hc_tooltip(crosshairs = TRUE, backgroundColor = "#FCFFC5",
                 shared = TRUE, borderWidth = 2) %>%
      hc_add_theme(hc_theme_oms)%>%
     # hc_add_theme(hc_theme_smpl())%>%
      hc_exporting(enabled = TRUE) %>%
      hc_credits(enabled = TRUE, text = "Data Source: WHO/AFRO/DPC/TVD Programme", href = unique(e), style = list(fontSize = "10px"))
    
    return(graph_result)
  }
  
  # ---- Cas qualitatif ----
  graph_result <- a %>%
    filter(!is.na(year_api)) %>%
    filter(year_api == max(year_api, na.rm = TRUE)) %>%
    group_by(alpha_value) %>%
    summarise(total = n(), .groups = "drop") %>%
    mutate(
      pourcentage = round(total / sum(total) * 100, 1),
      prop_n = paste0(total, " (", pourcentage, "%)"),
      group_value = case_when(
        pourcentage >= 70 ~ "70-100%",
        pourcentage >= 30 ~ "30-70%",
        pourcentage > 0   ~ "<30%",
        TRUE ~ "No data"
      )
    ) %>%
    hchart(type = "pie", hcaes(x = alpha_value, y = pourcentage, group = group_value),
           dataLabels = list(enabled = TRUE, format = '{point.prop_n}')) %>%
    hc_title(text = paste(f, "-", c, ",", selected_year), align = "center") %>%
    hc_tooltip(crosshairs = TRUE, backgroundColor = "#FCFFC5",
               shared = TRUE, borderWidth = 2) %>%
    hc_add_theme(hc_theme_smpl())%>% 
    hc_exporting(enabled = TRUE) %>%
    hc_add_theme(hc_theme_oms)%>%
    hc_credits(enabled = TRUE, text = "Data Source: WHO/AFRO/DPC/TVD Programme", href = unique(e), style = list(fontSize = "10px"))
  
  return(graph_result)
}






fct9_tvd_dfs <- function(tvd9_data, a="index_dataset", b="index_year", f="input$index_ind_dshb"){
  
  selected_type <- tvd_dts %>% filter(indicator %in% f) %>% pull(type_indicator) %>% unique()
  selected_unit <- tvd_indicator %>% filter(indicator %in% f) %>% pull(indicator_unit) %>% unique()
  selected_code <- tvd_dts %>% filter(indicator %in% f) %>% pull(indicator_code) %>% unique()
  
  if (selected_type[1] == "Quanti_ind") {
    max_year <- a %>% filter(!is.na(year_api)) %>%
      summarise(year_api =safe_summary(year_api, fun = "max"))%>%# max(year_api, na.rm = TRUE)
     pull(year_api)
    
    # Données historiques
    lastYear_tvddf1 <- a %>%
      filter(!is.na(year_api), year_api <= (max_year - b), numeric_value >= 0) %>%
      group_by(country, iso) %>%
      summarise(year_api = safe_summary(year_api, fun = "max"), .groups = "drop") %>%#max(year_api, na.rm = TRUE)
      mutate(kp = paste(iso, year_api, sep = "-")) %>%
      select(country, iso, year_api, kp)
    
    lastYear_tvddf2 <- a %>%
      filter(numeric_value >= 0) %>%
      mutate(numeric_value = round(numeric_value, 2),
             kp = paste(iso, year_api, sep = "-")) %>%
      select(kp, numeric_value)
    
    lastYear_tvddf <- left_join(lastYear_tvddf1, lastYear_tvddf2, by = "kp") %>%
      distinct() %>%
      mutate(val = as.numeric(numeric_value))
    
    value_lastYear <- if (selected_unit[1] == "Number") {
      sum(lastYear_tvddf$numeric_value, na.rm = TRUE)
    } else {
      mean(lastYear_tvddf$numeric_value, na.rm = TRUE)
    }
    
    return(data.frame(year = max_year - b, val = value_lastYear))
    
  } else if (selected_type[1] == "Quali_ind") {
    tbl_result <- a %>%
      select(country, iso, year_api, alpha_value) %>%
      distinct() %>%
      pivot_wider(names_from = year_api, values_from = alpha_value) %>%
      mutate(across(where(is.numeric), ~ replace(., is.na(.), 0))) %>%
      mutate(across(where(is.character), ~ replace(., is.na(.), "Missing data"))) %>%
      distinct(country, .keep_all = TRUE)
    
    return(tbl_result)
  }
}


fct10_tvd_dfs <- function(tvd10_data, a="index_dataset", c="country", e="show_link_indicator()", f="input$index_ind_dshb"){
  
  selected_unit <- tvd_indicator %>% filter(indicator %in% f) %>% pull(indicator_unit) %>% unique()
  selected_type <- tvd_dts %>% filter(indicator %in% f) %>% pull(type_indicator) %>% unique()
  selected_code <- tvd_dts %>% filter(indicator %in% f) %>% pull(indicator_code) %>% unique()
  selected_ref  <- tvd_dts %>% filter(indicator %in% f) %>% pull(ref_data) %>% unique()
  selected_year <- tvd_dts %>% filter(indicator %in% f) %>% pull(year_api) %>% max(na.rm = TRUE)
  
  if (selected_type[1] == "Quanti_ind") {
    fig_tvd <- a %>%
      mutate(group = categorize_group_fct(selected_code[1], numeric_value))
    
    trend_fig <- hchart(fig_tvd, "line", hcaes(year, numeric_value, group),
                        lineWidth = 4, name = "Value",
                        dataLabels = list(enabled = TRUE,
                                          format = if (selected_unit[1] == "Number") "{y}" else "{point.numeric_value:.1f}",
                                          style = list(fontSize = "14px"))) %>%
      hc_colors(colors_pal) %>%
      hc_xAxis(title = list(text = "Years")) %>%
      hc_yAxis(title = list(text = paste0("Value (", selected_unit, ")"))) %>%
      hc_tooltip(shared = TRUE, borderWidth = 2) %>%
      hc_exporting(enabled = TRUE) %>%
      hc_title(text = paste(f, "-", c, ",", selected_year), align = "center") %>%
      hc_add_theme(hc_theme_oms)%>%
     # hc_add_theme(hc_theme_smpl()) %>%
      hc_credits(enabled = TRUE, text = "Data Source: WHO/AFRO/DPC/TVD Programme", href = unique(e), style = list(fontSize = "10px"))
    
    return(trend_fig)
    
  } else {
    graph_result <- tvd_dts %>%
      filter(!is.na(year_api),
             indicator_code %in% selected_code[1],
             ref_data %in% selected_ref[1]) %>%
      left_join(flag_country %>% select(iso, subregion), by = "iso") %>%
      filter(!is.na(subregion)) %>%
      filter(year_api == max(year_api, na.rm = TRUE)) %>%
      group_by(subregion, alpha_value) %>%
      summarise(total = n(), .groups = "drop") %>%
      mutate(pourcentage = total / sum(total) * 100) %>%
      hchart(type = "column", hcaes(x = alpha_value, y = pourcentage, color = subregion),
             dataLabels = list(enabled = TRUE, format = '{point.pourcentage:.1f}')) %>%
      hc_exporting(enabled = TRUE) %>%
      hc_title(text = paste("Proportion of countries according to", f, "-", c, ",", selected_year), align = "center") %>%
    #  hc_add_theme(hc_theme_smpl()) %>%
      hc_add_theme(hc_theme_oms)%>%
      hc_credits(enabled = TRUE, text = "Data Source: WHO/AFRO/DPC/TVD Programme", href = unique(e), style = list(fontSize = "10px"))
    
    return(graph_result)
  }
}

# ---- Préparation des données pour cartes ----
fct11_tvd_dfs <- function(tvd11_data, a="index_dataset"){
  
  type_indi <- unique(a$type_indicator)[1]
  
  if (type_indi == "Quanti_ind") {
    tbl_result <- a %>%
      ungroup() %>%
      select(country, iso, year_api, indicator_code, numeric_value) %>%
      mutate(group = categorize_group_fct(indicator_code, numeric_value)) %>%
      arrange(desc(numeric_value)) %>%
      select(iso, Group = group, numeric_value)
    
   
    
    return(tbl_result)
    
  } else if (type_indi == "Quali_ind") {
    tbl_result <- a %>%
      ungroup() %>%
      select(country, iso, year_api, alpha_value) %>%
      rename(Group = alpha_value) %>%
      select(iso, Group)
    
    return(tbl_result)
  }
}



fct_show_val_trend <- function(fct_val_trend,a="dataset",b="index_ind_dshb"){
  
  selected_code <-unique(tvd_dts[tvd_dts$indicator%in%b, "indicator_code"]) # Find indicator code based on s
  indicator_name <-unique(tvd_dts[tvd_dts$indicator%in%b, "indicator"]) # Find indicator name
  indicator_target <-unique(tvd_indicator[tvd_indicator$indicator%in%b, "indicator_target"]) # Find indicator name
  selected_type_indi <-unique(tvd_dts[tvd_dts$indicator%in%b, "type_indicator"])

  if (selected_type_indi$type_indicator[1]=="Quanti_ind"){
    show_val_trend <-a%>%#trends_year
      ungroup()%>%
      select(year,numeric_value)%>%
      mutate(
        indicator_target=ifelse(numeric_value>=0, as.numeric(indicator_target$indicator_target[1]) ,""),
        indicator_name=ifelse(numeric_value>=0,indicator_name$indicator[1],""))%>%
      select(indicator_name,year,indicator_target,numeric_value)%>%
      ungroup()%>%
      gather("group_ind", "value", 3:4)%>%
      mutate(
        categogies=as.character(group_ind),
        categogies=case_when(
          categogies=="indicator_target"~"Target",
          categogies=="numeric_value"~"Achievment",
          TRUE~"Achievment"),
        year=ifelse(categogies=="Target",2030,year),
        group_show=paste0(categogies,' (',year ,')'),sep="",
        pk_remove_dup=paste0(categogies,year,value))%>%
      ungroup()%>%
      unique()%>%
      select(indicator_name,year,categogies,group_show,value)

    data_proj<-show_val_trend%>%
      filter(year%in%2030)
    
    data_estim<-show_val_trend%>%
      filter(year!=2030)
    
    years_hist <-unique(data_estim$year)# 2021:2025
    values_hist <-unique(data_estim$value)#c(220, 210, 200, 190, 185)  # Exemple
    
    # Objectif 2030
    target2030 <-unique(data_proj$value)
    
    # Calcul des projections par interpolation linéaire
    years_proj_start <-max(data_estim$year, na.rm = TRUE)+1
    years_proj_end <-max(data_proj$year, na.rm = TRUE)
    
    years_proj <-years_proj_start:years_proj_end#2026:2030
    start_value <- tail(values_hist, 1)  # valeur en 2025
    end_value <- target2030              # valeur en 2030
    
    # Nombre d'années de projection
    n_proj <- length(years_proj)
    
    # Interpolation linéaire
    projection <- seq(start_value, end_value, length.out = n_proj)
    
    # Résultats
    projection_df <- data.frame(
      year = years_proj,
      projection = round(projection, 0))
    
    estim_projection_target<-projection_df%>%
      rename("year"="year",
             "value"="projection")%>%
      mutate(
        categogies=as.numeric(year),
        categogies=case_when(
          year==years_proj_end~"Target",
          TRUE~"Projection"),
        group_show=paste0(categogies,' (',year ,')'),sep="",
        indicator_name=ifelse(value>=0,unique(indicator_name$indicator),""))%>% #b= indicator name
      select(indicator_name,year,categogies,group_show,value)%>%
      rbind(data_estim%>%select(indicator_name,year,categogies,group_show,value))%>%
      arrange(year, .by_group = FALSE)
    
    return(estim_projection_target)
    
  }else{
    
  }
}





# ---- Calcul des tendances par année ----
fct_tvd_trend_years <- function(indicatorGlobal, a="dataset", b="index_year"){
  
  max_year <- a %>%
    filter(!is.na(year_api)) %>%
    summarise(year_api = safe_summary(year_api, fun = "max")) %>%#max(year_api, na.rm = TRUE)
    pull(year_api)
  
  tbl_tvd <- tvd_dts %>%
    filter(year_api <= (max_year - b), numeric_value >= 0) %>%
    group_by(iso, year_api) %>%
    summarise(numeric_value = round(mean(numeric_value, na.rm = TRUE), 2), .groups = "drop") %>%
    group_by(year_api) %>%
    summarise(numeric_value = round(mean(numeric_value, na.rm = TRUE), 2), .groups = "drop")
  
  trends_year <- data.frame(year_api = max_year - b, numeric_value = mean(tbl_tvd$numeric_value, na.rm = TRUE))
  
  return(trends_year)
}

# ---- Afficher unité et catégorie d’un indicateur ----
fct_show_unit_catg <- function(tvd_unit_catg, a="index_dataset", b="index_indicator"){ 
  
  selected_code <- tvd_dts %>% filter(indicator == b) %>% pull(indicator_code)
  
  shows_unit <- a %>%
    filter(indicator_code %in% selected_code[1]) %>%
    select(indicator, indicator_unit, category_indicator) %>%
    distinct(indicator_unit, .keep_all = TRUE)
  
  return(shows_unit)
}

# ---- Filtrer données par pays et maladie ----
fct_data_geo_disease <- function(fct_df_filter, a="index_country", b="disease_ui", d="timingInput1"){
  
  selected_code <- tvd_dts %>% filter(sub_component %in% b) %>% pull(sub_component)
  selected_iso  <- filter_country %>% filter(country %in% a) %>% pull(iso)
  
  if (!a %in% Afroname$country) {
    # Un seul pays sélectionné
    return(
      apply_filters(
        df = tvd_dts,
        inputs = list(sub_component = selected_code[1], iso = selected_iso[1]),
        years = d
      )
    )
  } else {
    # Tous les pays sélectionnés
    return(
      apply_filters(
        df = tvd_dts,
        inputs = list(sub_component = selected_code[1]),
        years = d
      )
    )
  }
}

#colnames(tvd_dts)



## FUNCTION FOR LAST VALUE IN SECTION INDICATOR PROGRESS--------------------------------------------------------
fct_first_last_value <- function(fct_df_indi,a="dataset", c="index_country",
                                 d="minMax(year_api)"){
  
  selected_iso <- filter_country[filter_country$country%in%c, "iso"]
  
  if (Afroname$country !=c) {
    
    tvd_r1<-a%>%
      filter(numeric_value>0, iso%in%selected_iso$iso[1])%>%
      select(iso,indicator_code,sub_component,year_api,numeric_value)%>%
      rename("Dimension"="sub_component")%>%
      mutate(sub_grps="All",numeric_value=as.numeric(numeric_value))%>%
      group_by(iso,indicator_code ,year_api,sub_grps,Dimension)%>%
      summarise(numeric_value = round(mean(numeric_value, na.rm = TRUE),0),
                .groups = "drop")%>%
      ungroup()
      ## dim1_type
      # bind_rows(a%>%
      #             filter(numeric_value>0, iso%in%selected_iso$iso[1])%>%
      #           select(iso,indicator_code,dim1_type,year_api,numeric_value)%>%
      #            rename("Dimension"="dim1_type")%>%
      #            mutate(sub_grps="dim1_type",numeric_value=as.numeric(numeric_value))%>%
      #            group_by(iso,indicator_code ,year_api,sub_grps,Dimension)%>%
      #            summarise(numeric_value = round(mean(numeric_value, na.rm = TRUE),0),
      #                      .groups = "drop")%>%
                  
      #            #summarise(numeric_value = round(mean(numeric_value, na.rm = TRUE),0))%>%
      #            ungroup()%>%
      #            filter(Dimension!="")
      # )%>%
      ## dim1
      # bind_rows(a%>%
      #             filter(numeric_value>0, iso%in%selected_iso$iso[1])%>%
      #            select(iso,indicator_code,dim1,year_api,numeric_value)%>%
      #             rename("Dimension"="dim1")%>%
      #            mutate(sub_grps="dim1",numeric_value=as.numeric(numeric_value))%>%
      #             group_by(iso,indicator_code ,year_api,sub_grps,Dimension)%>%
      #             summarise(numeric_value = round(mean(numeric_value, na.rm = TRUE),0),
      #                       .groups = "drop")%>%
      #             ungroup()%>%
      #             filter(Dimension!="")
      #  )%>%
      ## dim2_type
      #  bind_rows(a%>%
      #              filter(numeric_value>0, iso%in%selected_iso$iso[1])%>%
      #             select(iso,indicator_code,dim2_type,year_api,numeric_value)%>%
      #             rename("Dimension"="dim2_type")%>%
      #             mutate(sub_grps="dim2_type",numeric_value=as.numeric(numeric_value))%>%
      #             group_by(iso,indicator_code ,year_api,sub_grps,Dimension)%>%
      #             summarise(numeric_value = round(mean(numeric_value, na.rm = TRUE),0),
      #                       .groups = "drop")%>%
      #             ungroup()%>%
      #             filter(Dimension!="")
      #  )%>%
      ## dim2
      #  bind_rows(a%>%
      #              filter(numeric_value>0, iso%in%selected_iso$iso[1])%>%
      #              select(iso,indicator_code,dim2,year_api,numeric_value)%>%
      #             rename("Dimension"="dim2")%>%
      #              mutate(sub_grps="dim2",numeric_value=as.numeric(numeric_value))%>%
      #              group_by(iso,indicator_code ,year_api,sub_grps,Dimension)%>%
      #              summarise(numeric_value = round(mean(numeric_value, na.rm = TRUE),0),
      #                        .groups = "drop")%>%
      #             ungroup()%>%
      #             filter(Dimension!="")
      # )%>%
      ## dim3_type
      # bind_rows(a%>%
      #              filter(numeric_value>0, iso%in%selected_iso$iso[1])%>%
      #             select(iso,indicator_code,dim3_type,year_api,numeric_value)%>%
      #             rename("Dimension"="dim3_type")%>%
      #              mutate(sub_grps="dim3_type",numeric_value=as.numeric(numeric_value))%>%
      #              group_by(iso,indicator_code ,year_api,sub_grps,Dimension)%>%
      #              summarise(numeric_value = round(mean(numeric_value, na.rm = TRUE),0),
      #                        .groups = "drop")%>%
      #             ungroup()%>%
      #             filter(Dimension!="")
      #  )%>%
      ## dim3
      #  bind_rows(a%>%
      #              filter(numeric_value>0, iso%in%selected_iso$iso[1])%>%
      #              select(iso,indicator_code,dim3,year_api,numeric_value)%>%
      #              rename("Dimension"="dim3")%>%
      #              mutate(sub_grps="dim3",numeric_value=as.numeric(numeric_value))%>%
      #              group_by(iso,indicator_code ,year_api,sub_grps,Dimension)%>%
      #             summarise(numeric_value = round(mean(numeric_value, na.rm = TRUE),0),
      #                       .groups = "drop")%>%
      #             ungroup()%>%
      #             filter(Dimension!="")
      # )
    
    tvd_r2<-tvd_r1%>%
      filter(sub_grps=="All")%>%
      #select(country,iso,year_api,numeric_value)%>%
      mutate(kp=paste(iso,'-',year_api,'-',indicator_code,'-',sub_grps,'-',Dimension),sep="")%>%
      select(kp,numeric_value)%>%
      as.data.frame()
    
    tvd_r3_min_max<-tvd_r1%>%
      filter(sub_grps=="All")%>%
      mutate(year_api=as.numeric(year_api))%>%
      group_by(iso,indicator_code,sub_grps,Dimension)%>%
      summarise(year_api = d(year_api),
                .groups = "drop")%>%  # d= min(year_api) or max(year_api)
      group_by(year_api,indicator_code,sub_grps,Dimension)%>%
      mutate(kp=paste(iso,'-',year_api,'-',indicator_code,'-',sub_grps,'-',Dimension),sep="")%>%
      select(indicator_code,iso,year_api,sub_grps,Dimension,kp)%>%
      left_join(tvd_r2%>%select(kp,numeric_value), by = c("kp" = "kp"))%>%
      ungroup()%>%
      select(indicator_code,iso,year_api,sub_grps,Dimension,numeric_value)%>%
      ungroup()
    
    return(tvd_r3_min_max)
    
  }else{
    
    tvd_r1<-a%>%
      filter(numeric_value>0)%>%
      select(indicator_code,sub_component,year_api,numeric_value)%>%
      rename("Dimension"="sub_component")%>%
      mutate(sub_grps="All",numeric_value=as.numeric(numeric_value))%>%
      group_by(indicator_code ,year_api,sub_grps,Dimension)%>%
      summarise(numeric_value = round(mean(numeric_value, na.rm = TRUE),0),
                .groups = "drop")%>%
      ungroup()
      ## dim1_type
     # bind_rows(a%>%
      #             filter(numeric_value>0)%>%
      #             select(indicator_code,dim1_type,year_api,numeric_value)%>%
      #             rename("Dimension"="dim1_type")%>%
      #             mutate(sub_grps="dim1_type",numeric_value=as.numeric(numeric_value))%>%
      #             group_by(indicator_code ,year_api,sub_grps,Dimension)%>%
      #             summarise(numeric_value = round(mean(numeric_value, na.rm = TRUE),0),
      #                       .groups = "drop")%>%
      #             ungroup()%>%
      #             filter(Dimension!="")
      #  )%>%
      ## dim1
      #  bind_rows(a%>%
      #            filter(numeric_value>0)%>%
      #             select(indicator_code,dim1,year_api,numeric_value)%>%
      #              rename("Dimension"="dim1")%>%
      #              mutate(sub_grps="dim1",numeric_value=as.numeric(numeric_value))%>%
      #              group_by(indicator_code ,year_api,sub_grps,Dimension)%>%
      #              summarise(numeric_value = round(mean(numeric_value, na.rm = TRUE),0),
      #                        .groups = "drop")%>%
      #              ungroup()%>%
      #              filter(Dimension!="")
      #  )%>%
      ## dim2_type
      #  bind_rows(a%>%
      #              filter(numeric_value>0)%>%
      #               select(indicator_code,dim2_type,year_api,numeric_value)%>%
      #               rename("Dimension"="dim2_type")%>%
      #              mutate(sub_grps="dim2_type",numeric_value=as.numeric(numeric_value))%>%
      #              group_by(indicator_code ,year_api,sub_grps,Dimension)%>%
      #              summarise(numeric_value = round(mean(numeric_value, na.rm = TRUE),0),
      #                        .groups = "drop")%>%
      #              ungroup()%>%
      #              filter(Dimension!="")
      #   )%>%
      ## dim2
      #  bind_rows(a%>%
      #               filter(numeric_value>0)%>%
      #               select(indicator_code,dim2,year_api,numeric_value)%>%
      #               rename("Dimension"="dim2")%>%
      #              mutate(sub_grps="dim2",numeric_value=as.numeric(numeric_value))%>%
      #              group_by(indicator_code ,year_api,sub_grps,Dimension)%>%
      #               summarise(numeric_value = round(mean(numeric_value, na.rm = TRUE),0),
      #                        .groups = "drop")%>%
      #              ungroup()%>%
      #              filter(Dimension!="")
      #  )%>%
      ## dim3_type
      #  bind_rows(a%>%
      #              filter(numeric_value>0)%>%
      #              select(indicator_code,dim3_type,year_api,numeric_value)%>%
      #             rename("Dimension"="dim3_type")%>%
      #              mutate(sub_grps="dim3_type",numeric_value=as.numeric(numeric_value))%>%
      #              group_by(indicator_code ,year_api,sub_grps,Dimension)%>%
      #              summarise(numeric_value = round(mean(numeric_value, na.rm = TRUE),0),
      #                        .groups = "drop")%>%
      #              ungroup()%>%
      #             filter(Dimension!="")
      #   )%>%
      #   ## dim3
      #   bind_rows(a%>%
      #               filter(numeric_value>0)%>%
      #              select(indicator_code,dim3,year_api,numeric_value)%>%
      #             rename("Dimension"="dim3")%>%
      #             mutate(sub_grps="dim3",numeric_value=as.numeric(numeric_value))%>%
      #             group_by(indicator_code ,year_api,sub_grps,Dimension)%>%
      #             summarise(numeric_value = round(mean(numeric_value, na.rm = TRUE),0),
      #                       .groups = "drop")%>%
      #             ungroup()%>%
      #             filter(Dimension!="")
      #  )
    
    tvd_r2<-tvd_r1%>%
      filter(sub_grps=="All")%>%
      #select(country,iso,year_api,numeric_value)%>%
      mutate(kp=paste(year_api,'-',indicator_code,'-',sub_grps,'-',Dimension),sep="")%>%
      select(kp,numeric_value)%>%
      as.data.frame()
    
    tvd_r3_min_max<-tvd_r1%>%
      filter(sub_grps=="All")%>%
      mutate(year_api=as.numeric(year_api))%>%
      group_by(indicator_code,sub_grps,Dimension)%>%
      summarise(year_api = d(year_api),
                .groups = "drop")%>%  # d= min(year_api) or max(year_api)
      group_by(year_api,indicator_code,sub_grps,Dimension)%>%
      mutate(kp=paste(year_api,'-',indicator_code,'-',sub_grps,'-',Dimension),sep="")%>%
      select(indicator_code,year_api,sub_grps,Dimension,kp)%>%
      left_join(tvd_r2%>%select(kp,numeric_value), by = c("kp" = "kp"))%>%
      ungroup()%>%
      select(indicator_code,year_api,sub_grps,Dimension,numeric_value)%>%
      ungroup()
    
    
    return(tvd_r3_min_max)
    
    
  }
}
















## FUNCTION Merge first and last data according disease----------------------------

fct_merge_first_Last <- function(fct_view_indi,a="tvd_first_r1",b="tvd_last_r1",c="index_country"){
  
  # Find country code based on selected country name
  selected_iso <- filter_country[filter_country$country%in%c, "iso"]
  
  
  if (Afroname$country !=c) {
    #if(nrow(unique(a$iso))>1){
    
    # MERGE FIRTS AND LAST YEAR
    tvd_first_Last<-a%>% # tvd_first_r1()
      filter(iso%in%selected_iso$iso[1])%>%
      select(indicator_code,year_api,sub_grps,Dimension,numeric_value)%>%
      group_by(indicator_code,year_api,sub_grps,Dimension)%>%
      summarise(numeric_value = round(mean(numeric_value, na.rm = TRUE),0),
                .groups = "drop")%>%
      ungroup()%>%
      
      mutate(kp=paste(indicator_code,'-',sub_grps,'-',Dimension),sep="")%>%
      rename("first_year"="year_api",
             "first_value"="numeric_value")%>%
      select(indicator_code,sub_grps,Dimension,first_year,first_value,kp)%>%
      inner_join(b%>% #tvd_last_r1()
                   filter(iso%in%selected_iso$iso[1])%>%
                   select(indicator_code,year_api,sub_grps,Dimension,numeric_value)%>%
                   group_by(indicator_code,year_api,sub_grps,Dimension)%>%
                   summarise(numeric_value = round(mean(numeric_value, na.rm = TRUE),0),
                             .groups = "drop")%>%
                   ungroup()%>%
                   mutate(kp=paste(indicator_code,'-',sub_grps,'-',Dimension),sep="")%>%
                   rename("last_year"="year_api",
                          "last_value"="numeric_value")%>%
                   select(last_year,last_value,kp), by=c("kp"="kp"))%>%
      select(indicator_code,sub_grps,Dimension,first_year,first_value,last_year,last_value)%>%
      mutate(p_variation=paste(first_year,'to',last_year),sep="",
             ecart=as.numeric(round(last_value-first_value, digit=1)),
             first_value=format(first_value, big.mark = " ", decimal.mark = "."),
             baseline=paste0(first_value,' (',first_year,')'),sep="",
             last_value=format(last_value, big.mark = " ", decimal.mark = ".")## séparateur des milliers
      )%>%
      select(indicator_code,sub_grps,Dimension,baseline, last_value,p_variation,ecart)%>%
      left_join(tvd_indicator%>%select(indicator_code,indicator,performance_indicator,category_indicator,indicator_source), by=c("indicator_code"="indicator_code"))%>%
      mutate(status_test = ifelse(category_indicator == "Death" & ecart<0, 1, ifelse(category_indicator == "Strategy" & ecart>0, 1,ifelse(category_indicator == "Prevalence" & ecart<0, 1,ifelse(category_indicator == "Incidence" & ecart<0, 1, 0)))))%>% # Test condition if rigth put 1 or 0
      select(category_indicator,indicator,sub_grps,Dimension,baseline, last_value,p_variation,ecart,status_test,indicator_source)
    
    return(tvd_first_Last)
    
  }else{
    
    # MERGE FIRTS AND LAST YEAR
    tvd_first_Last<-a%>% # tvd_first_r1()
      ungroup()%>%
      select(indicator_code,year_api,sub_grps,Dimension,numeric_value)%>%
      group_by(indicator_code,year_api,sub_grps,Dimension)%>%
      summarise(numeric_value = round(mean(numeric_value, na.rm = TRUE),0),
                .groups = "drop")%>%
      ungroup()%>%
      filter(numeric_value>=0)%>%
      
      mutate(kp=paste(indicator_code,'-',sub_grps,'-',Dimension),sep="")%>%
      rename("first_year"="year_api",
             "first_value"="numeric_value")%>%
      select(indicator_code,sub_grps,Dimension,first_year,first_value,kp)%>%
      inner_join(b%>% #tvd_last_r1()
                   select(indicator_code,year_api,sub_grps,Dimension,numeric_value)%>%
                   group_by(indicator_code,year_api,sub_grps,Dimension)%>%
                   summarise(numeric_value = round(mean(numeric_value, na.rm = TRUE),0),
                             .groups = "drop")%>%
                   ungroup()%>%
                   filter(numeric_value>=0)%>%
                   mutate(kp=paste(indicator_code,'-',sub_grps,'-',Dimension),sep="")%>%
                   rename("last_year"="year_api",
                          "last_value"="numeric_value")%>%
                   select(last_year,last_value,kp), by=c("kp"="kp"))%>%
      select(indicator_code,sub_grps,Dimension,first_year,first_value,last_year,last_value)%>%
      mutate(p_variation=paste(first_year,'to',last_year),sep="",
             ecart=as.numeric(round(last_value-first_value, digit=1)),
             first_value=format(first_value, big.mark = " ", decimal.mark = "."),
             baseline=paste0(first_value,' (',first_year,')'),sep="",
             last_value=format(last_value, big.mark = " ", decimal.mark = ".")## séparateur des milliers
      )%>%
      select(indicator_code,sub_grps,Dimension,baseline, last_value,p_variation,ecart)%>%
      left_join(tvd_indicator%>%select(indicator_code,indicator,performance_indicator,category_indicator,indicator_source), by=c("indicator_code"="indicator_code"))%>%
      #select(iso,category_indicator,indicator,sub_grps,Dimension,baseline, last_value,p_variation,ecart,performance_indicator,indicator_source)%>%
      # mutate(status_test = ifelse(performance_indicator == "Low" & ecart<0, 1, ifelse(performance_indicator == "High" & ecart>0 & category_indicator=="Strategy", 1, 0)))%>% # Test condition if rigth put 1 or 0
      mutate(status_test = ifelse(category_indicator == "Death" & ecart<0, 1, 
                                  ifelse(category_indicator == "Strategy" & ecart>0, 1,
                                         ifelse(category_indicator == "Prevalence" & ecart<0, 1,
                                                ifelse(category_indicator == "Incidence" & ecart<0, 1, 0)))))%>% # Test condition if rigth put 1 or 0
      
      select(category_indicator,indicator,sub_grps,Dimension,baseline, last_value,p_variation,ecart,status_test,indicator_source)
    
    
    
    
    return(tvd_first_Last)
  }
  
}




# ---- Compter les indicateurs avec bonne performance ----
fct_nb_indicator_perf <- function(fct_nb_perf,a="dataset"){
  nb_bonne_perf<-a%>% #a
    ungroup()%>%
    select(category_indicator,indicator,status_test)%>%
    #select(iso,category_indicator,indicator,status_test)%>%
    #group_by(iso,category_indicator)%>%
    group_by(category_indicator)%>%
    summarise(nb_indicator = n_distinct(indicator),
              nb_goog_perf = sum(status_test >= 1),
              prop_good_perf=paste0(round(mean(status_test >= 1)*100, digit=1),"% ","(",nb_goog_perf,"/",nb_indicator,")"),
              .groups = "drop"
    )%>%
    # mutate(nb_goog_perf=ifelse(nb_goog_perf>nb_indicator, nb_indicator, nb_goog_perf))%>%
    as.data.frame()
  
  return(nb_bonne_perf)
}



#View(nb_bonne_perf_vbox)
## FUNCTION TO Fetch the value of the Vbox field----------------------------
fct_vbox_data <- function(fct_vbox_value,a="dataset"){
  
  if(length(a) == 0){
    
    nb_bonne_perf_vbox <- data.frame(
      death_percent = c("0% (0/0)"),
      incidence_percent = c("0% (0/0)"),
      prevalence_percent = c("0% (0/0)"),
      strategy_percent = c("0% (0/0)")
    )
    return(nb_bonne_perf_vbox)
  }else{
    
    nb_bonne_perf_vbox<- a%>%#a%>% #nb_bonne_perf
      #  filter(iso%in%"AGO")%>%
      select(category_indicator,nb_indicator ,nb_goog_perf)%>%
      
      group_by(category_indicator)%>%
      summarise(nb_t_indicator = sum(nb_indicator),
                nb_t_goog_perf = sum(nb_goog_perf),
                .groups = "drop")%>%
      gather("gpe_indicator", "total_value", 2:3)%>%
      ungroup()%>%
      mutate(pk=paste0(category_indicator,gpe_indicator))%>%
      select(pk,total_value)%>%
      pivot_wider(names_from = pk , values_from = total_value, values_fn = mean)%>%
      # names(.) récupère les noms des colonnes du data.frame courant dans le pipe.
      # if (!"new_col" %in% names(.)) 0 else new_col :
      # Si la colonne "new_col" n’existe pas, elle est créée avec la valeur 0.
      # Sinon, on conserve la colonne existante.
      mutate(
        Incidencenb_t_indicator = if (!"Incidencenb_t_indicator" %in% names(.)) 0 else Incidencenb_t_indicator,
        Incidencenb_t_goog_perf = if (!"Incidencenb_t_goog_perf" %in% names(.)) 0 else Incidencenb_t_goog_perf,
        Prevalencenb_t_indicator = if (!"Prevalencenb_t_indicator" %in% names(.)) 0 else Prevalencenb_t_indicator,
        Prevalencenb_t_goog_perf = if (!"Prevalencenb_t_goog_perf" %in% names(.)) 0 else Prevalencenb_t_goog_perf,
        Deathnb_t_indicator = if (!"Deathnb_t_indicator" %in% names(.)) 0 else Deathnb_t_indicator,
        Deathnb_t_goog_perf = if (!"Deathnb_t_goog_perf" %in% names(.)) 0 else Deathnb_t_goog_perf,
        Strategynb_t_indicator = if (!"Strategynb_t_indicator" %in% names(.)) 0 else Strategynb_t_indicator,
        Strategynb_t_goog_perf = if (!"Strategynb_t_goog_perf" %in% names(.)) 0 else Strategynb_t_goog_perf,
        
        
        t_death =as.numeric(unlist(Deathnb_t_indicator)),
        t_incidence =as.numeric(unlist(Incidencenb_t_indicator)),
        
        t_prevalence=as.numeric(unlist(Prevalencenb_t_indicator)),
        t_strategy=as.numeric(unlist(Strategynb_t_indicator)),
        
        g_death =as.numeric(unlist(Deathnb_t_goog_perf)),
        g_incidence =as.numeric(unlist(Incidencenb_t_goog_perf)),
        g_prevalence=as.numeric(unlist(Prevalencenb_t_goog_perf)),
        g_strategy=as.numeric(unlist(Strategynb_t_goog_perf)),
        
        death_percent=paste0(if(is.nan(round(as.numeric(g_death/t_death*100), digit=1))) 0 else round(as.numeric(g_death/t_death*100), digit=1),"% ","(",g_death,"/",t_death,")"),
        
        
        incidence_percent=paste0(if(is.nan(round(as.numeric(g_incidence/t_incidence*100), digit=1))) 0 else round(as.numeric(g_incidence/t_incidence*100), digit=1)   ,"% ","(",g_incidence,"/",t_incidence,")"),
        prevalence_percent=paste0(if(is.nan(round(as.numeric(g_prevalence/t_prevalence*100), digit=1))) 0 else round(as.numeric(g_prevalence/t_prevalence*100), digit=1),"% ","(",g_prevalence,"/",t_prevalence,")"),
        strategy_percent=paste0(if(is.nan(round(as.numeric(g_strategy/t_strategy*100), digit=1))) 0 else round(as.numeric(g_strategy/t_strategy*100), digit=1),"% ","(",g_strategy,"/",t_strategy,")")
      )%>%
      select(death_percent,incidence_percent,prevalence_percent,strategy_percent)%>%
      as.data.frame()
    
    return(nb_bonne_perf_vbox)
    
    
  }
}






## FUNCTION Display the progress indicators for each selected disease----------------------------
fct_progress_view <- function(fct_prog_indi,a="dataset",b="title", c="report_edit"){
  
  
  border_style = officer::fp_border(color="black", width=1)
  
  tvd_first_Last_view<-a%>%#a%>%
   # filter(iso=="BEN")%>%
    select(category_indicator,indicator,sub_grps,Dimension ,baseline,last_value,p_variation,ecart,status_test,indicator_source)%>% ## Non include group
    arrange(category_indicator,indicator,sub_grps,Dimension)%>%
    flextable::flextable()%>% 
    autofit()%>% 
    
    add_header_row(
      top = TRUE,                
      values = c( "Area ",    
                 "Indicator",
                 "Aggregate",
                 "Dimension",
                 "Baseline",
                 "Estimates",
                 "Growth",
                 "",
                 "Trend (good: 1; bad: 0)",
                 "source"))%>% 
    set_header_labels(         # Renommer les colonnes de la ligne d'en-tête originale
      category_indicator = "", 
      indicator = "",                  
      sub_grps = "",
      Dimension="",
      baseline="",
      last_value = "",
      p_variation = "first and last year",
      ecart = "difference",
      status_test="",
      indicator_source="")%>% 
    # merge_at(i = 1, j = 5:6, part = "header") %>% 
    merge_at(i = 1, j = 7:8, part = "header") %>% # Fusionner horizontalement les colonnes 3 à 5 dans une nouvelle ligne d'en-tête
    # merge_at(i = 1, j = 5:10, part = "header")%>%      # Fusionnez horizontalement les colonnes 6 à 8 dans une nouvelle ligne d'en-tête.
    
    # Enlever toutes les bordures existantes
    border_remove() %>%  
    
    # ajouter des lignes horizontales via un thème prédéterminé
    theme_booktabs() %>% 
    
    # ajouter des lignes verticales pour séparer les sections "Recovered" et "Died"
    vline(part = "all", j = 2, border = border_style) %>%   # a la colonne 2 
    vline(part = "all", j = 4, border = border_style) %>%       # a la colonne 4
    vline(part = "all", j = 5, border = border_style) %>% 
    vline(part = "all", j = 6, border = border_style) %>% 
    vline(part = "all", j = 8, border = border_style) %>% 
    vline(part = "all", j = 9, border = border_style) %>% 
    hline(border = border_style) %>%       # a la colonne 10
    # vline(part = "all", j = 11, border = border_style) %>%       # a la colonne 11
    
    flextable::align(align = "center", j = c(5:9), part = "all") %>%  
    fontsize(i = 1, size = 12, part = "header") %>%   # ajuster la taille de la police de l'en-tête
    bold(i = 1, bold = TRUE, part = "header") %>%     # ajuster le caractère en gras de l'en-tête
    # bold(i = c(7:7), bold = TRUE, part = "body")%>%           # ajuster les caractères en gras de la ligne totale (ligne 7 du corps de la table)
    
    merge_at(i = 1:2, j = 1, part = "header") %>% 
    merge_at(i = 1:2, j = 2, part = "header")%>% 
    merge_at(i = 1:2, j = 3, part = "header")%>% 
    merge_at(i = 1:2, j = 4, part = "header")%>% 
    merge_at(i = 1:2, j = 5, part = "header")%>% 
    merge_at(i = 1:2, j = 6, part = "header")%>% 
    merge_at(i = 1:2, j = 9, part = "header")%>% 
    merge_at(i = 1:2, j = 10, part = "header")%>% 
    bg(part = "body", bg = "gray95")  %>% 
    bg(j = 8, i = ~ status_test ==1, part = "body", bg = "#3CB371") %>% 
    bg(j = 8, i = ~ status_test ==0, part = "body", bg = "#E8AABE") %>% 
    bg(j = 8, i = ~ status_test <0 , part = "body", bg = "#CBC8E0") %>% 
 
    #  bg(., i= ~ output_code == "Total", part = "body", bg = "#91c293") 
    merge_v(j = "category_indicator",  target = c("category_indicator"), part = "body")%>%
    merge_v(j = "indicator",  target = c("indicator"), part = "body")%>%
    colformat_num(
      big.mark = " ", decimal.mark = ",",
      na_str = "na") %>% 
    colformat_int(big.mark = " ") %>% 
    colformat_date(fmt_date = "%d/%m/%Y")%>% # format of value in the table
    mk_par(j = "category_indicator", 
           value = as_paragraph(
             as_chunk(category_indicator, 
                      props = fp_text_default(color = "#C32900", bold = TRUE)))) %>% 
    mk_par(j = "indicator_source", 
           value = as_paragraph(
             as_chunk(indicator_source, 
                      props = fp_text_default(color = "#006699", bold = FALSE))))%>%
    hrule(rule = "exact", part = "body") %>% 
    width(width =  1.05) %>%  #regular appearance, all cells will be sized to 1 inches in width and height.
    set_table_properties(layout = "fixed")%>%
    add_header_lines(b)%>%
    add_footer_lines(c) #"Data source: AFRO/DPC/TVD - 2026"
  
  
  return(tvd_first_Last_view)
}


## Function to display vbox --------------------------
fct_vbox_view <- function(tvd_vbox_view,a="dataset_col", b="title", c="color", d="input$disease_ui"){
  
  if (!is.null(a)){ ## if variable value not null  
    vbx_view<-valueBoxSpark(
      value = a#%>% #data_report_dashboards()$total_staff
      #  paste0("(",data_report_dashboards()$prop_Trained,"%)")
      ,
      title = b #paste0(toupper("Enrolled staffs"))
      ,
      sparkobj = "",
      subtitle ="",
      #icon = icon("user"),
      width = 3,
      color = c, #"light-blue"
      href = NULL)
    
    }else{
      
      #  "No data from the country’s survey"
      vbx_view<-valueBoxSpark(
        value = "",
        title = paste0("No data from this matter ", d), #input$disease_ui
        sparkobj = "",
        subtitle = "",
        #  info = "",
        #icon = icon("user"),
        width = 3,
        color = "maroon",
        href = NULL)
    }
    
  

return(vbx_view)
}



## FUNCTION Merge first and last data according diseas FOR GRAPHIC AND MAP----------------------------

fct_merge_first_Last_dt <- function(fct_dt_indi,a="dataset",b="category_indicator"){
  
  tvd_r1<-a%>%# a%>%
    filter(numeric_value>0)%>%
    select(iso,indicator_code,sub_component,year_api,numeric_value)%>%
    rename("Dimension"="sub_component")%>%
    mutate(sub_grps="All",numeric_value=as.numeric(numeric_value))%>%
    group_by(iso,indicator_code ,year_api,sub_grps,Dimension)%>%
    summarise(numeric_value = round(mean(numeric_value, na.rm = TRUE),0),
              .groups = "drop")%>%
    ungroup()
    ## dim1_type
  #  bind_rows(a%>%
    #               filter(numeric_value>0)%>%
    #               select(iso,indicator_code,dim1_type,year_api,numeric_value)%>%
    #               rename("Dimension"="dim1_type")%>%
    #              mutate(sub_grps="dim1_type",numeric_value=as.numeric(numeric_value))%>%
    #              group_by(iso,indicator_code ,year_api,sub_grps,Dimension)%>%
    #              summarise(numeric_value = round(mean(numeric_value, na.rm = TRUE),0),
    #                        .groups = "drop")%>%
    #              ungroup()%>%
    #              filter(Dimension!="")
    #  )%>%
    ## dim1
    #  bind_rows(a%>%
    #               filter(numeric_value>0)%>%
    #               select(iso,indicator_code,dim1,year_api,numeric_value)%>%
    #              rename("Dimension"="dim1")%>%
    #              mutate(sub_grps="dim1",numeric_value=as.numeric(numeric_value))%>%
    #              group_by(iso,indicator_code ,year_api,sub_grps,Dimension)%>%
    #              summarise(numeric_value = round(mean(numeric_value, na.rm = TRUE),0),
    #                        .groups = "drop")%>%
    #              ungroup()%>%
    #              filter(Dimension!="")
    #  )%>%
    ## dim2_type
    #  bind_rows(a%>%
    #               filter(numeric_value>0)%>%
    #               select(iso,indicator_code,dim2_type,year_api,numeric_value)%>%
    #               rename("Dimension"="dim2_type")%>%
    #              mutate(sub_grps="dim2_type",numeric_value=as.numeric(numeric_value))%>%
    #              group_by(iso,indicator_code ,year_api,sub_grps,Dimension)%>%
    #              summarise(numeric_value = round(mean(numeric_value, na.rm = TRUE),0),
    #                        .groups = "drop")%>%
    #              ungroup()%>%
    #              filter(Dimension!="")
    #  )%>%
    #   ## dim2
    #   bind_rows(a%>%
    #               filter(numeric_value>0)%>%
    #              select(iso,indicator_code,dim2,year_api,numeric_value)%>%
    #              rename("Dimension"="dim2")%>%
    #               mutate(sub_grps="dim2",numeric_value=as.numeric(numeric_value))%>%
    #               group_by(iso,indicator_code ,year_api,sub_grps,Dimension)%>%
    #               summarise(numeric_value = round(mean(numeric_value, na.rm = TRUE),0),
    #                         .groups = "drop")%>%
    #               ungroup()%>%
    #                filter(Dimension!="")
    #   )%>%
    ## dim3_type
    #    bind_rows(a%>%
    #               filter(numeric_value>0)%>%
    #               select(iso,indicator_code,dim3_type,year_api,numeric_value)%>%
    #               rename("Dimension"="dim3_type")%>%
    #                mutate(sub_grps="dim3_type",numeric_value=as.numeric(numeric_value))%>%
    #               group_by(iso,indicator_code ,year_api,sub_grps,Dimension)%>%
    #               summarise(numeric_value = round(mean(numeric_value, na.rm = TRUE),0),
    #                        .groups = "drop")%>%
    #               ungroup()%>%
    #               filter(Dimension!="")
    #   )%>%
    #   ## dim3
    #    bind_rows(a%>%
    #                filter(numeric_value>0)%>%
    #                select(iso,indicator_code,dim3,year_api,numeric_value)%>%
    #                rename("Dimension"="dim3")%>%
    #                mutate(sub_grps="dim3",numeric_value=as.numeric(numeric_value))%>%
    #                group_by(iso,indicator_code ,year_api,sub_grps,Dimension)%>%
    #               summarise(numeric_value = round(mean(numeric_value, na.rm = TRUE),0),
    #                         .groups = "drop")%>%
    #               ungroup()%>%
    #                filter(Dimension!="")
    #   )
  
  tvd_r2<-tvd_r1%>%
    filter(sub_grps=="All")%>%
    #select(country,iso,year_api,numeric_value)%>%
    mutate(kp=paste(iso,'-',year_api,'-',indicator_code,'-',sub_grps,'-',Dimension),sep="")%>%
    select(kp,numeric_value)%>%
    as.data.frame()
  
  tvd_r3_min<-tvd_r1%>%
    filter(sub_grps=="All")%>%
    mutate(year_api=as.numeric(year_api))%>%
    group_by(iso,indicator_code,sub_grps,Dimension)%>%
    summarise(year_api = safe_summary(year_api, fun = "min"), #min(year_api)
              .groups = "drop")%>%  # d= min(year_api) or max(year_api)
    group_by(year_api,indicator_code,sub_grps,Dimension)%>%
    mutate(kp=paste(iso,'-',year_api,'-',indicator_code,'-',sub_grps,'-',Dimension),sep="")%>%
    select(indicator_code,iso,year_api,sub_grps,Dimension,kp)%>%
    left_join(tvd_r2%>%select(kp,numeric_value), by = c("kp" = "kp"))%>%
    ungroup()%>%
    select(indicator_code,iso,year_api,sub_grps,Dimension,numeric_value)%>%
    ungroup()#%>%
  
  
  tvd_r3_max<-tvd_r1%>%
    filter(sub_grps=="All",!is.na(year_api))%>%
    mutate(year_api=as.numeric(year_api))%>%
    group_by(iso,indicator_code,sub_grps,Dimension)%>%
    summarise(year_api = max(year_api, na.rm = TRUE),
              .groups = "drop")%>%  # d= min(year_api) or max(year_api)
    group_by(year_api,indicator_code,sub_grps,Dimension)%>%
    mutate(kp=paste(iso,'-',year_api,'-',indicator_code,'-',sub_grps,'-',Dimension),sep="")%>%
    select(indicator_code,iso,year_api,sub_grps,Dimension,kp)%>%
    left_join(tvd_r2%>%select(kp,numeric_value), by = c("kp" = "kp"))%>%
    ungroup()%>%
    select(indicator_code,iso,year_api,sub_grps,Dimension,numeric_value)%>%
    ungroup()
  
  
  
  
  
  # MERGE FIRTS AND LAST YEAR
  tvd_first_Last_gph<-tvd_r3_min%>% # tvd_first_r1()
    select(indicator_code,iso,year_api,sub_grps,Dimension,numeric_value)%>%
    group_by(indicator_code,iso,year_api,sub_grps,Dimension)%>%
    summarise(numeric_value = round(mean(numeric_value, na.rm = TRUE),0),
              .groups = "drop")%>%
    ungroup()%>%
    
    mutate(kp=paste(iso,indicator_code,'-',sub_grps,'-',Dimension),sep="")%>%
    rename("first_year"="year_api",
           "first_value"="numeric_value")%>%
    select(indicator_code,iso,sub_grps,Dimension,first_year,first_value,kp)%>%
    inner_join(tvd_r3_max%>% #tvd_last_r1()
                 select(indicator_code,iso,year_api,sub_grps,Dimension,numeric_value)%>%
                 group_by(indicator_code,iso,year_api,sub_grps,Dimension)%>%
                 summarise(numeric_value = round(mean(numeric_value, na.rm = TRUE),0),
                           .groups = "drop")%>%
                 ungroup()%>%
                 mutate(kp=paste(iso,indicator_code,'-',sub_grps,'-',Dimension),sep="")%>%
                 rename("last_year"="year_api",
                        "last_value"="numeric_value")%>%
                 select(last_year,last_value,kp), by=c("kp"="kp"))%>%
    select(iso,indicator_code,sub_grps,Dimension,first_year,first_value,last_year,last_value)%>%
    mutate(p_variation=paste(first_year,'to',last_year),sep="",
           ecart=as.numeric(round(last_value-first_value, digit=1)),
           first_value=format(first_value, big.mark = " ", decimal.mark = "."),
           baseline=paste0(first_value,' (',first_year,')'),sep="",
           last_value=format(last_value, big.mark = " ", decimal.mark = ".")## séparateur des milliers
    )%>%
    select(indicator_code,iso,sub_grps,Dimension,baseline, last_value,p_variation,ecart)%>%
    left_join(tvd_indicator%>%select(indicator_code,indicator,performance_indicator,category_indicator,indicator_source), by=c("indicator_code"="indicator_code"))%>%
    mutate(status_test = ifelse(category_indicator == "Death" & ecart<0, 1, ifelse(category_indicator == "Strategy" & ecart>0, 1,ifelse(category_indicator == "Prevalence" & ecart<0, 1,ifelse(category_indicator == "Incidence" & ecart<0, 1, 0)))),
           group_value = case_when(
             status_test >= 1 ~ "Progress",
             TRUE        ~ "Zero advancement"
           ))%>% # Test condition if rigth put 1 or 0
   
    filter(category_indicator%in%b)%>% #b= categorie indicator (Parameters)
    left_join(filter_country%>%select(country,iso), by = c("iso" = "iso"))%>%
    select(country,iso,category_indicator,indicator,sub_grps,Dimension,baseline, last_value,p_variation,ecart,status_test,indicator_source,group_value)
  
  return(tvd_first_Last_gph)
  
}
  

fct_merge_first_Last_gph <- function(fct_gphs_indi, a="dataset", b=NULL){
  
  df <- a %>%
    ungroup() %>%
    distinct(country, iso, category_indicator, indicator, status_test)
  
  if (!is.null(b)) {
    df <- df %>% filter(category_indicator %in% b)
  }
  
  nb_bonne_perf_gph <- df %>%
    group_by(country, iso, category_indicator) %>%
    summarise(
      nb_indicator = n_distinct(indicator),
      nb_good_perf = sum(status_test >= 1, na.rm = TRUE),
      prop_good = round(mean(status_test >= 1, na.rm = TRUE) * 100, 1),
      prop_good_perf = paste0(prop_good, "% (", nb_good_perf, "/", nb_indicator, ")"),
      .groups = "drop"
    ) %>%
    filter(nb_indicator > 0) %>%
    mutate(
      value = round(prop_good, 0),
      performance = prop_good_perf,
      group_value = case_when(
        value >= 70 ~ "Strong progress (70-100%)",
        value >= 30 ~ "Medium progress (30-70%)",
        value > 0   ~ "Weak progress (<30%)",
        TRUE        ~ "Zero advancement"
      )
    ) %>%
    arrange(desc(value))
  
  return(nb_bonne_perf_gph)
}



### FUNCTION FOR FACT SHEET IN MARKDOWN-----------------------------------

fct1_data_map_facsheet <- function(indi_fctsh1, a="dataset"){
  
  result_map_nb_countries_df <- a %>%
    group_by(iso, sub_component) %>%
    filter(year_api == max(year_api, na.rm = TRUE)) %>%
    ungroup() %>%
    distinct(iso, .keep_all = TRUE) %>%
    mutate(index = ifelse(year_api > 0, 1, 0)) %>%
    right_join(flag_country %>% select(flag, iso), by = "iso") %>%
    mutate(across(where(is.numeric), ~ replace(., is.na(.), 0)),
           across(where(is.character), ~ replace(., is.na(.), "no data"))) %>%
    mutate(group_index = case_when(
      index > 0 ~ "Available Data",
      index == 0 ~ "No Data Available",
      TRUE ~ "Unknown"
    ),
    iso = ifelse(iso == "SSD", "SDS", iso)) %>%
    select(iso, flag, group_index)
  
  map_nb_countries_df <- result_map_nb_countries_df %>%
    right_join(geo_countries, by = c("iso" = "brk_a3")) %>%
    mutate(across(where(is.numeric), ~ replace(., is.na(.), 0)),
           across(where(is.character), ~ replace(., is.na(.), "non afro"))) %>%
    select(sov_a3, flag, name_sort, group_index) %>%
    arrange(sov_a3)
  
  return(map_nb_countries_df)
}

fct1_data_map_facsheet <- function(indi_fctsh1, a="dataset"){
  
  result_map_nb_countries_df<-a%>%
    select(iso,sub_component,year_api)%>%
    group_by(iso,sub_component,year_api)%>% 
    filter(year_api%in%max(year_api))%>%
    ungroup()%>%
    distinct(iso,  .keep_all = TRUE)%>%  ## delete duplicate for item in column
    mutate(index=as.numeric(ifelse(year_api>0, 1,0)))%>%
    right_join(flag_country%>%select(flag,iso), by = c("iso" = "iso"))%>%
    mutate(across(where(is.numeric), ~ replace(., is.na(.), 0)),
           across(where(is.character), ~ replace(., is.na(.), "no data"))) %>%
    #ungroup()%>%
    select(iso,flag,sub_component,index)%>%
    mutate(group_index = case_when(
      index > 0 ~ "Available Data",
      index == 0 ~ "No Data Available",
      TRUE ~ "Unknown"
    ))%>%
    ungroup()%>%
    select(iso,flag,group_index)
  
  result_map_nb_countries_df$iso <- ifelse(result_map_nb_countries_df$iso %in%"SSD",
                                           "SDS",  
                                           result_map_nb_countries_df$iso)  
  
  map_nb_countries_df<-result_map_nb_countries_df%>%
    right_join(geo_countries, by = c("iso" = "brk_a3"))%>%
    
    mutate(across(where(is.numeric), ~ replace(., is.na(.), 0)),
           across(where(is.character), ~ replace(., is.na(.), "non afro"))) %>%
    ungroup()%>%
    select(sov_a3,flag,name_sort,group_index)%>%
    arrange(sov_a3)
  
  return(map_nb_countries_df)
}


fct4_data_map_facsheet <- function(indi_fctsh4, a="dataset"){
  
  show_ref_1 <- a %>%
    distinct(indicator_code, ref_data) %>%
    left_join(tvd_indicator %>% 
                select(indicator_code, indicator, category_indicator, indicator_source),
              by = "indicator_code") %>%
    group_by(ref_data, indicator_source, category_indicator) %>%
    summarise(
      n_indicators = n_distinct(indicator),
      list_indicators = paste(head(unique(indicator), 5), collapse = ", "),
      .groups = "drop"
    ) %>%
    arrange(desc(n_indicators)) %>%
    gt() %>%
    tab_header(title = "Data Sources Overview")
  
  return(show_ref_1)
}


## FUNCTION Merge first and last data according diseas FOR GRAPHIC AND MAP----------------------------

fct_progress_fctsheet <- function(fct_dt_in,a="dataset",b="Disease", c="category_indicator"){
  
  tvd_progress <- a%>%
    filter(numeric_value>0,sub_component %in%b) %>%
    mutate(year_api = as.numeric(year_api)) %>%
    filter(year_api == min(year_api) | year_api == max(year_api)) %>%
    group_by(iso, indicator_code,year_api) %>%
    summarise(numeric_value = round(mean(numeric_value, na.rm = TRUE), 0),
              .groups = "drop") %>%
    left_join(tvd_indicator %>% select(indicator_code, indicator, category_indicator),
              by = "indicator_code") %>%
    filter(year_api== max(year_api),category_indicator%in%c)%>%
    left_join(filter_country %>% select(country, iso), by = "iso") %>%
    select(country, indicator, year_api, numeric_value)%>%
    unique()

  return(tvd_progress)
  
}



fct_first_last_fctsheet <- function(fct_df_indi,a="dataset"){
  
  
  tvd_r1<-a%>%#a%>%
    filter(numeric_value>0)%>%
    select(iso,indicator_code,sub_component,year_api,numeric_value)%>%
    rename("Dimension"="sub_component")%>%
    mutate(sub_grps="All",numeric_value=as.numeric(numeric_value))%>%
    group_by(iso,indicator_code ,year_api,sub_grps,Dimension)%>%
    summarise(numeric_value = round(mean(numeric_value, na.rm = TRUE),0),
              .groups = "drop")%>%
    ungroup()
  
  
  tvd_r2<-tvd_r1%>%
    filter(sub_grps=="All")%>%
    #select(country,iso,year_api,numeric_value)%>%
    mutate(kp=paste(iso,'-',year_api,'-',indicator_code,'-',sub_grps,'-',Dimension),sep="")%>%
    select(kp,numeric_value)%>%
    as.data.frame()
  
  
  ## Data for min_year
  tvd_r3_min<-tvd_r1%>%
    filter(sub_grps=="All")%>%
    mutate(year_api=as.numeric(year_api))%>%
    group_by(iso,indicator_code,sub_grps,Dimension)%>%
    summarise(year_api = safe_summary(year_api, fun = "min"), #min(year_api)
              .groups = "drop")%>%  # d= min(year_api) or max(year_api)
    group_by(year_api,indicator_code,sub_grps,Dimension)%>%
    mutate(kp=paste(iso,'-',year_api,'-',indicator_code,'-',sub_grps,'-',Dimension),sep="")%>%
    select(indicator_code,iso,year_api,sub_grps,Dimension,kp)%>%
    left_join(tvd_r2%>%select(kp,numeric_value), by = c("kp" = "kp"))%>%
    ungroup()%>%
    select(indicator_code,iso,year_api,sub_grps,Dimension,numeric_value)%>%
    ungroup()
  
  ## Data for max_year
  tvd_r3_max<-tvd_r1%>%
    filter(sub_grps=="All")%>%
    mutate(year_api=as.numeric(year_api))%>%
    group_by(iso,indicator_code,sub_grps,Dimension)%>%
    summarise(year_api = safe_summary(year_api, fun = "max"), #max(year_api)
              .groups = "drop")%>%  # d= min(year_api) or max(year_api)
    group_by(year_api,indicator_code,sub_grps,Dimension)%>%
    mutate(kp=paste(iso,'-',year_api,'-',indicator_code,'-',sub_grps,'-',Dimension),sep="")%>%
    select(indicator_code,iso,year_api,sub_grps,Dimension,kp)%>%
    left_join(tvd_r2%>%select(kp,numeric_value), by = c("kp" = "kp"))%>%
    ungroup()%>%
    select(indicator_code,iso,year_api,sub_grps,Dimension,numeric_value)%>%
    ungroup()
  
  
  
  # MERGE MIN AND MAX YEAR
  tvd_first_Last<-tvd_r3_min%>% # min yeay
    select(iso,indicator_code,year_api,sub_grps,Dimension,numeric_value)%>%
    group_by(iso,indicator_code,year_api,sub_grps,Dimension)%>%
    summarise(numeric_value = round(mean(numeric_value, na.rm = TRUE),0),
              .groups = "drop")%>%
    ungroup()%>%
    
    mutate(kp=paste(iso,indicator_code,'-',sub_grps,'-',Dimension),sep="")%>%
    rename("first_year"="year_api",
           "first_value"="numeric_value")%>%
    select(iso,indicator_code,sub_grps,Dimension,first_year,first_value,kp)%>%
    inner_join(tvd_r3_max%>% #max year
                 select(iso,indicator_code,year_api,sub_grps,Dimension,numeric_value)%>%
                 group_by(iso,indicator_code,year_api,sub_grps,Dimension)%>%
                 summarise(numeric_value = round(mean(numeric_value, na.rm = TRUE),0),
                           .groups = "drop")%>%
                 ungroup()%>%
                 mutate(kp=paste(iso,indicator_code,'-',sub_grps,'-',Dimension),sep="")%>%
                 rename("last_year"="year_api",
                        "last_value"="numeric_value")%>%
                 select(last_year,last_value,kp), by=c("kp"="kp"))%>%
    select(iso,indicator_code,sub_grps,Dimension,first_year,first_value,last_year,last_value)%>%
    mutate(p_variation=paste(first_year,'to',last_year),sep="",
           ecart=as.numeric(round(last_value-first_value, digit=1)),
           first_value=format(first_value, big.mark = " ", decimal.mark = "."),
           baseline=paste0(first_value,' (',first_year,')'),sep="",
           last_value=format(last_value, big.mark = " ", decimal.mark = ".")## séparateur des milliers
    )%>%
    select(iso,indicator_code,sub_grps,Dimension,baseline, last_value,p_variation,ecart)%>%
    left_join(tvd_indicator%>%select(indicator_code,indicator,performance_indicator,category_indicator,indicator_source), by=c("indicator_code"="indicator_code"))%>%
    mutate(status_test = ifelse(category_indicator == "Death" & ecart<0, 1, ifelse(category_indicator == "Strategy" & ecart>0, 1,ifelse(category_indicator == "Prevalence" & ecart<0, 1,ifelse(category_indicator == "Incidence" & ecart<0, 1, 0))))#,
           #  iso_country=ifelse(status_test==1,iso,"")
    )%>% # Test condition if rigth put 1 or 0
    select(category_indicator,indicator,sub_grps,Dimension,baseline, last_value,p_variation,ecart,status_test,iso)%>%
    ## filter(category_indicator == "Prevalence")%>%
    mutate(name_indic=as.character(indicator),
           list_country=as.numeric(status_test),
           list_country=case_when(
             list_country==1 ~"",
             list_country==0~iso,
             TRUE~"No country")
    )%>%
    unique()%>%
    
    left_join(filter_country%>%filter(index_country<48)%>%select(country,iso), by=c("iso"="iso"))%>%
    select(name_indic,indicator,country)
  return(tvd_first_Last)
}


fct_show_val_month_arima <- function(fct_val_trend, a="dataset", b="index_ind_dshb", horizon = 60, freq = 12){
  
  selected_type <- tvd_dts %>% filter(indicator %in% b) %>% pull(type_indicator) %>% unique()
  
  if (selected_type[1] == "Quanti_ind") {
    
    data_estim <- a %>%
      mutate(year_api = as.numeric(year_api)) %>%
      filter(!is.na(year_api), year_api != 2030) %>%
      select(year_api, numeric_value)
    
    if (nrow(data_estim) < 5) {
      warning("Pas assez de données pour ajuster un modèle ARIMA")
      return(NULL)
    }
    
    ts_data <- ts(data_estim$numeric_value,
                  start = min(data_estim$year_api),
                  frequency = freq)
    
    fit <- auto.arima(ts_data)
    forecast_res <- forecast(fit, h = horizon)
    
    forecast_df <- data.frame(
      date = seq(as.Date(paste0(max(data_estim$year_api), "-12-01")),
                 by = "month", length.out = horizon),
      forecast = as.numeric(forecast_res$mean),
      lower80 = forecast_res$lower[,1],
      upper80 = forecast_res$upper[,1],
      lower95 = forecast_res$lower[,2],
      upper95 = forecast_res$upper[,2]
    )
    
    return(forecast_df)
  }
  
  return(NULL)
}





#tvd_dts%>%filter(indicator%in%"Number of suspected yaws cases reported")

## classification des pays en fonction des valeurs des indicateurs quantitative-----------------------
fct_class_dfm_stat <- function(class_dfm_stat, a="index_dataset"){
  
  selected_type <- a%>% select(type_indicator) %>% pull(type_indicator) %>% unique()
  selected_code <- a%>% select(indicator_code) %>% pull(indicator_code) %>% unique()
  
  max_year <- a%>%
    #filter(indicator %in% "Number of suspected yaws cases reported") %>%
    filter(!is.na(year_api)) %>%
    summarise(year_api = safe_summary(year_api, fun = "max")) %>%#max(year_api, na.rm = TRUE)
    pull(year_api)

  if (selected_type[1] == "Quanti_ind") {
  
    # Données historiques
    data_st <- dfm_stat %>%
      filter(indicator_code %in% selected_code[1], year_api %in% max_year[1]) %>%
      select(iso, population, numeric_value) %>%
      distinct(iso, .keep_all = TRUE) %>%
      left_join(filter_country %>% filter(index_country < 48), by = c("iso" = "iso")) %>%
      select(country, population, numeric_value) %>%
      filter(numeric_value > 0) %>%
      mutate(
        population = as.numeric(gsub("[^0-9.]", "", as.character(population))),
        numeric_value = as.numeric(gsub("[^0-9.]", "", as.character(numeric_value)))
      )
    
    # Normalisation et scoring
    selected_data <- data_st %>% select(population, numeric_value)
    selected_data[is.na(selected_data)] <- 0
    data_norm <- as.data.frame(scale(selected_data))
    row.names(data_norm) <- data_st$country
    data_norm$Score <- rowMeans(data_norm, na.rm = TRUE)
    
    ranking <- data.frame(
      Country = row.names(data_norm),
      Population = data_st$population,
      NumericValue = data_st$numeric_value,
      Score = round(data_norm$Score, 2),
      Rang = rank(-data_norm$Score, ties.method = "min")
    ) %>% arrange(Rang)
    
    
    ranking <- ranking %>%
      mutate(CountryLabel = paste0(Country, " (Rang ", Rang, ")"))
    

    #--- Tableau GT style OMS avec entête bilingue et note méthodologique ---
    gt_table <- ranking %>%
      gt() %>%
      fmt_number(
        columns = c(Population, NumericValue),
        sep_mark = " ",
        decimals = 0
      ) %>%
      fmt_number(
        columns = Score,
        sep_mark = " ",
        decimals = 2
      ) %>%
      tab_header(
        title = md("**Classement des pays selon Population et Valeur numérique**  
                **Country ranking based on Population and Numeric Value**"),
        subtitle = md("Interprétation / Interpretation :  
                  Le score est une moyenne normalisée des indicateurs Population et Valeur numérique.  
                  The score is a normalized average of Population and Numeric Value indicators.  
                  Plus le score est élevé, plus le pays est classé haut dans le rang.  
                  The higher the score, the higher the country ranks.")
      ) %>%
      data_color(
        columns = c(Score),#vars(Score)
        colors = scales::col_numeric(
          palette = c("#f2f6fa", "#0072bc"),
          domain = NULL
        )
      ) %>%
      data_color(
        columns = c(Rang),#vars(Rang)
        colors = scales::col_numeric(
          palette = c("#4daf4a", "#e41a1c"),
          domain = NULL
        )
      ) %>%
      tab_source_note(
        source_note = md("Méthodologie / Methodology :  
    Les valeurs de Population et NumericValue ont été converties en format numérique, normalisées (mise à l’échelle), puis combinées en une moyenne.  
    Population and NumericValue were converted to numeric format, normalized (scaled), and combined into an average.  
    Le Score reflète cette moyenne normalisée. Le Rang est attribué en ordre décroissant du Score.  
    The Score reflects this normalized average. Rank is assigned in descending order of Score.")
      )
    
    
    gt_table
    

    
  } else if (selected_type[1] == "Quali_ind") {
   
    data_st <- dfm_stat %>%
      filter(indicator_code %in% selected_code[1], year_api %in% max_year[1]) %>%
      select(iso, population, alpha_value) %>%
      distinct(iso, .keep_all = TRUE) %>%
      left_join(filter_country %>% filter(index_country < 48), by = c("iso" = "iso")) %>%
      select(country, population, alpha_value) %>%
      filter(!is.na(alpha_value))%>%
      select(country, population, alpha_value)%>%
      unique() %>%
      arrange(alpha_value)%>%
      gt() %>%
      tab_header(
        title = "Carte de chaleur des risques par pays",
        subtitle = "Interprétation : Les pays sont classés par rang et colorés selon leur niveau de risque."
      ) %>%
      data_color(
        columns = c(alpha_value),#vars(alpha_value)
        colors = c("#4daf4a",  "#ffbf00",  "#e41a1c")
      ) %>%
      tab_source_note(
        source_note = "Méthodologie : Le Score est calculé comme moyenne normalisée des indicateurs Population et Valeur numérique. Les catégories de risque sont définies par seuils."
      )
    data_st
    
  }
}





## classification des pays en fonction des valeurs des indicateurs quantitative-----------------------
fct_class_dfm_stat_exp <- function(class_dfm_stat_exp, a="index_dataset"){
  
  selected_type <- a%>% select(type_indicator) %>% pull(type_indicator) %>% unique()
  selected_code <- a%>% select(indicator_code) %>% pull(indicator_code) %>% unique()
  
  max_year <- a%>%
    #filter(indicator %in% "Number of suspected yaws cases reported") %>%
    filter(!is.na(year_api)) %>%
    summarise(year_api = safe_summary(year_api, fun = "max")) %>%#year_api = max(year_api, na.rm = TRUE)
    pull(year_api)
  
  if (selected_type[1] == "Quanti_ind") {
    
    # Données historiques
    data_st <- dfm_stat %>%
      filter(indicator_code %in% selected_code[1], year_api %in% max_year[1]) %>%
      select(iso, population, numeric_value) %>%
      distinct(iso, .keep_all = TRUE) %>%
      left_join(filter_country %>% filter(index_country < 48), by = c("iso" = "iso")) %>%
      select(country, population, numeric_value) %>%
      filter(numeric_value > 0) %>%
      mutate(
        population = as.numeric(gsub("[^0-9.]", "", as.character(population))),
        numeric_value = as.numeric(gsub("[^0-9.]", "", as.character(numeric_value)))
      )
    
    # Normalisation et scoring
    selected_data <- data_st %>% select(population, numeric_value)
    selected_data[is.na(selected_data)] <- 0
    data_norm <- as.data.frame(scale(selected_data))
    row.names(data_norm) <- data_st$country
    data_norm$Score <- rowMeans(data_norm, na.rm = TRUE)
    
    ranking <- data.frame(
      Country = row.names(data_norm),
      Population = data_st$population,
      NumericValue = data_st$numeric_value,
      Score = round(data_norm$Score, 2),
      Rang = rank(-data_norm$Score, ties.method = "min")
    ) %>% arrange(Rang)
    
    
    # Préparation des données
    ranking <- ranking %>%
      mutate(
        CountryLabel = paste0(Country, " (Rang ", Rang, ")")
      )
    
    # Création du tableau DT avec style OMS
    datatable(
      ranking %>% select(CountryLabel, Population, NumericValue, Score, Rang),
      extensions = c("Buttons"),
      options = list(
        pageLength = 10,
        dom = "Bfrtip",
        buttons = c("copy", "csv", "excel", "pdf", "print"),
        searchHighlight = TRUE,
        autoWidth = TRUE,
        columnDefs = list(list(className = "dt-center", targets = "_all"))
      ),
      filter = "top",
      caption = htmltools::tags$caption(
        style = 'caption-side: top; text-align: left; color:#0072bc; font-weight:bold;',
        htmltools::tags$div(
          htmltools::tags$strong("Classement des pays selon les valeur des indicateurs et la population"),
          htmltools::tags$br(),
          "Country ranking based on indicator value and Population",
          htmltools::tags$br(), htmltools::tags$br(),
          "Interprétation / Interpretation :",
          htmltools::tags$br(),
          "Le score est une moyenne normalisée des valeurs des indicateurs  et la Population.",
          htmltools::tags$br(),
          "The score is a normalized average of Value indicators  and Population .",
          htmltools::tags$br(),
          "Plus le score est élevé, plus le pays est classé haut dans le rang.",
          htmltools::tags$br(),
          "The higher the score, the higher the country ranks."
        )
      )
    ) %>%
      formatStyle(
        "Score",
        background = styleColorBar(c(min(ranking$Score), max(ranking$Score)), "#0072bc"),
        backgroundSize = "98% 88%",
        backgroundRepeat = "no-repeat",
        backgroundPosition = "center"
      ) %>%
      formatStyle(
        "Rang",
        backgroundColor = styleInterval(
          c(min(ranking$Rang), max(ranking$Rang)/2),
          c("#4daf4a", "#ffbf00", "#e41a1c")
        ),
        color = "white"
      ) %>%
      formatStyle(
        "CountryLabel",
        fontWeight = "bold"
      ) %>%
      formatStyle(
        columns = c("Population", "NumericValue"),
        `text-align` = "right"
      )
    
    
    
    
  } else if (selected_type[1] == "Quali_ind") {
    
    data_st <- dfm_stat %>%
      filter(indicator_code %in% selected_code[1], year_api %in% max_year[1]) %>%
      select(iso, population, alpha_value) %>%
      distinct(iso, .keep_all = TRUE) %>%
      left_join(filter_country %>% filter(index_country < 48), by = c("iso" = "iso")) %>%
      select(country, population, alpha_value) %>%
      filter(!is.na(alpha_value))%>%
      unique()%>%
    unique() %>%
      arrange(alpha_value)
    
      datatable(
        data_st %>% select(country, population, alpha_value),
        extensions = c("Buttons"),
        options = list(
          pageLength = 10,
          dom = "Bfrtip",
          buttons = c("copy", "csv", "excel", "pdf", "print"),
          searchHighlight = TRUE,
          autoWidth = TRUE,
          columnDefs = list(list(className = "dt-center", targets = "_all"))
        ))%>% htmlwidgets::prependContent(htmltools::tags$style(css_oms))
      

  }
}


####EXO -RISK ANALYSIS--------------------
fct_risk_map <- function(risk_dfm_stat,
                         a = afro_data_risk(),
                         b = input$disease_risk,
                         c = max_year_risk()[1],
                         k = "title") {
  
  afro_dfm <- a
  
  # --- Generic empty map fallback ---
  empty_map <- leaflet() %>%
    addTiles() %>%
    addControl(
      html = "<b>No data available</b>",
      position = "topright"
    )
  
  # --- Wrap risky code in tryCatch ---
  result <- tryCatch({
    n <- nrow(afro_dfm)
    if (is.null(n) || n < 1) {
      return(empty_map)
    }
    
    # Palette function
    oms_palette <- function(n) {
      base_colors <- c(
        "Faible / Low"    = "#fcae91",
        "Modéré / Moderate" = "#4daf4a",
        "Élevé / High"    = "yellow"
      )
      if (n <= length(base_colors)) {
        return(base_colors[1:n])
      } else {
        return(colorRampPalette(base_colors)(n))
      }
    }
    
    real_categories <- setdiff(unique(afro_dfm$RiskLevel),
                               c(NA, "Data not available"))
    
    pal <- colorFactor(
      palette = oms_palette(length(real_categories)),
      domain  = real_categories
    )
    
    legend_title <- paste0(k, toupper(b), " - ", c)
    
    title_html <- paste0(
      "<div style='text-align:center;
                   font-weight:bold;
                   font-size:clamp(14px, 1.5vw, 18px);
                   background:white;
                   padding:5px;
                   border:1px solid grey;
                   width:100%;'>",
      legend_title,
      "</div>"
    )
    
    legend_items <- c(sort(real_categories), "NA", "Data not available")
    
    legend_html <- paste0(
      "<div style='background:white;
                   padding:8px;
                   border:1px solid grey;
                   font-size:clamp(12px, 1.5vw, 16px);
                   max-width:200px;'>",
      "<b>Legend</b><br/>",
      paste0(
        sapply(legend_items, function(g) {
          if (g == "NA") {
            col <- "white"
          } else if (g == "Data not available") {
            col <- "#969696"
          } else {
            col <- pal(g)
          }
          paste0(
            "<div style='margin:2px; display:flex; align-items:center;'>",
            "<span style='display:inline-block;width:15px;height:15px;
                        background:", col, ";border:1px solid #000;
                        margin-right:5px;'></span>",
            g,
            "</div>"
          )
        }),
        collapse = ""
      ),
      "</div>"
    )
    
    leaflet(afro_dfm) %>%
      addProviderTiles("Esri.WorldGrayCanvas") %>%
      addPolygons(
        fillColor = ~ifelse(is.na(RiskLevel), "white",
                            ifelse(RiskLevel == "Data not available",
                                   "#969696", pal(RiskLevel))),
        color = "grey",
        weight = 0.5,
        opacity = 1,
        fillOpacity = 0.7,
        label = ~paste0(
          name, ": ",
          ifelse(is.na(RiskLevel), "NA",
                 ifelse(RiskLevel == "Data not available",
                        "Data not available", RiskLevel))
        ),
        popup = ~paste0(
          "<b>", name, "</b><br/>Category: ",
          ifelse(is.na(RiskLevel), "NA",
                 ifelse(RiskLevel == "Data not available",
                        "Data not available", RiskLevel))
        )
      ) %>%
      addControl(html = title_html, position = "topleft") %>%
      addControl(html = legend_html, position = "bottomleft")
    
  }, error = function(e) {
    # If any error occurs, return the generic empty map
    empty_map
  })
  
  return(result)
}


# --- Fonction ARIMA cumulative ---
# --- Fonction ARIMA cumulative ---
predict_indicator_arima <- function(indicator_name, dfm_stat, years, country_name) {
  
  selected_code <- tvd_dts %>% 
    filter(indicator %in% indicator_name) %>% 
    pull(indicator_code) %>% 
    unique()
  
  selected_iso  <- filter_country %>% 
    filter(country %in% country_name) %>% 
    pull(iso) %>% 
    unique()
  
  # Déterminer min et max année
  min_yearS <- dfm_stat %>%
    filter(year_api >= years[1], year_api <= years[2],
           indicator_code %in% selected_code[1],
           numeric_value > 0) %>%
    { if (selected_iso[1] %in% Afroname$iso) . else filter(., iso %in% selected_iso[1]) } %>%
    summarise(min_year = safe_summary(year_api, fun = "min")) %>%
    pull(min_year)
  
  max_yearS <- dfm_stat %>%
    filter(year_api >= years[1], year_api <= years[2],
           indicator_code %in% selected_code[1],
           numeric_value > 0) %>%
    { if (selected_iso[1] %in% Afroname$iso) . else filter(., iso %in% selected_iso[1]) } %>%
    summarise(max_year = safe_summary(year_api, fun = "max")) %>%
    pull(max_year)
  
  # Filtrer données historiques
  df_ind <- dfm_stat %>%
    filter(indicator_code %in% selected_code[1],
           numeric_value > 0,
           year_api %in% c(min_yearS, max_yearS)) %>%
    { if (selected_iso[1] %in% Afroname$iso) . else filter(., iso %in% selected_iso[1]) } %>%
    arrange(year_api) %>%
    mutate(Date = as.Date(paste0(year_api, "-01-01"))) %>%
    filter(!is.na(numeric_value))   # remove missing values
  
  # Fallback if not enough data
  if (nrow(df_ind) < 2) {
    p <- ggplot() +
      annotate("text", x = 0, y = 0,
               label = "Pas assez de données pour cet indicateur") +
      theme_void()
    return(list(base_data = df_ind,
                predictions_display = NULL,
                plot = p))
  }
  
  # Série annuelle
  ts_data <- ts(df_ind$numeric_value, start = min(df_ind$year_api), frequency = 1)
  fit <- auto.arima(ts_data)
  
  # Prévoir 12 mois
  forecast_values <- forecast(fit, h = 12)
  
  # Créer un vecteur de dates mensuelles pour 2026
  dates_2026 <- seq(as.Date("2026-01-01"), by = "month", length.out = 12)
  
  # Dataframe des prévisions cumulatives
  pred_df <- data.frame(
    Date  = dates_2026,
    Pred  = cumsum(as.numeric(forecast_values$mean)),
    Lower = cumsum(as.numeric(forecast_values$lower[,2])),
    Upper = cumsum(as.numeric(forecast_values$upper[,2]))
  ) %>%
    filter(!is.na(Pred), !is.na(Lower), !is.na(Upper))   # remove missing
  
  # Pour le tableau DT : version formatée
  pred_df_display <- pred_df %>%
    mutate(
      Pred  = format(round(Pred, 1), big.mark = " ", decimal.mark = ","),
      Lower = format(round(Lower, 1), big.mark = " ", decimal.mark = ","),
      Upper = format(round(Upper, 1), big.mark = " ", decimal.mark = ",")
    )
  
  # Graphique ggplot
  p <- ggplot() +
    geom_point(data = df_ind, aes(x = Date, y = numeric_value),
               color = "blue", size = 3) +
    geom_line(data = pred_df, aes(x = Date, y = Pred),
              color = "red", linewidth = 1) +
    geom_ribbon(data = pred_df, aes(x = Date, ymin = Lower, ymax = Upper),
                fill = "pink", alpha = 0.3) +
    scale_x_date(
      date_labels = "%b-%Y",
      date_breaks = "1 months",
      limits = c(min(c(df_ind$Date, pred_df$Date)),
                 max(c(df_ind$Date, pred_df$Date)))
    ) +
    labs(title = paste("Tendance cumulative", years[1], "–", years[2], 
                       "et prévisions mensuelles 2026 pour :", indicator_name, "-", country_name),
         x = "Temps", y = "Valeur cumulée prédite") +
    theme_minimal(base_size = 14) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  return(list(base_data = df_ind,
              predictions_display = pred_df_display,
              plot = p))
}


