# Charger les dépendances
source("dataprocessing.R")

############################################################
## Fonctions utilitaires
############################################################

# Design fluide pour UI
fluid_design <- function(id, w, x, y, z) {
  fluidRow(
    div(
      id = id,
      column(width = 6, uiOutput(w), uiOutput(y)),
      column(width = 6, uiOutput(x), uiOutput(z))
    )
  )
}

# ValueBox avec sparkline
valueBoxSpark <- function(value, title, sparkobj = NULL, subtitle, info = NULL, 
                          icon = NULL, color = "aqua", width = 3, href = NULL) {
  
  shinydashboard:::validateColor(color)
  if (!is.null(icon)) shinydashboard:::tagAssert(icon, type = "i")
  
  info_icon <- tags$small(
    tags$i(
      title = info,
      `data-toggle` = "tooltip",
      style = "color: rgba(255, 255, 255, 0.75);"
    ),
    class = "pull-right float-right"
  )
  
  boxContent <- div(
    class = paste0("small-box bg-", color),
    div(
      class = "inner",
      tags$h4(title, style = "color:white;"),   # titre en blanc
      if (!is.null(sparkobj)) info_icon,
      tags$h2(value, style = "color:white;"),   # valeur en blanc
      if (!is.null(sparkobj)) sparkobj,
      p(subtitle, style = "color:white;")       # sous-titre en blanc
    ),
    if (!is.null(icon)) div(class = "icon-large icon", icon)
  )
  
  if (!is.null(href)) boxContent <- a(href = href, boxContent)
  
  div(class = paste0("col-sm-", width), boxContent)
}



# ValueBox simplifié
valueBox2 <- function(value, title, subtitle, icon = NULL, color = "aqua", width = 3, href = NULL) {
  
  shinydashboard:::validateColor(color)
  if (!is.null(icon)) shinydashboard:::tagAssert(icon, type = "i")
  
  boxContent <- div(
    class = paste0("small-box bg-", color),
    div(
      class = "inner",
      h4(title),
      h3(value),
      h4(subtitle)
    ),
    if (!is.null(icon)) div(class = "icon-small", icon)
  )
  
  if (!is.null(href)) boxContent <- a(href = href, boxContent)
  
  div(class = paste0("col-sm-", width), boxContent)
}

# Date initiale
initial_date <- lubridate::today()

# Propriétés de mise en page
sect_properties <- prop_section(
  page_size = page_size(orient = "landscape"),
  type = "continuous",
  page_margins = page_mar()
)

# Style pour datatable
brks <- seq(5, 100, 5)
clrs <- colorRampPalette(c("white", "#E9967A"))(length(brks) + 1)

# Fonction pour ajouter IC
add_confidence_interval <- function(df, value_col = "value", se_col = NULL, level = 0.95, margin = 0.1) {
  if (!is.null(se_col) && se_col %in% names(df)) {
    z <- qnorm((1 + level) / 2)
    df %>%
      mutate(
        value_low  = .data[[value_col]] - z * .data[[se_col]],
        value_high = .data[[value_col]] + z * .data[[se_col]]
      )
  } else {
    df %>%
      mutate(
        value_low  = .data[[value_col]] * (1 - margin),
        value_high = .data[[value_col]] * (1 + margin)
      )
  }
}

# Fonction pour appliquer filtres
apply_filters <- function(df, inputs, years = NULL) {
  for (col in names(inputs)) {
    val <- inputs[[col]]
    if (!is.null(val)) {
      df <- df %>% filter(.data[[col]] %in% val)
    }
  }
  
  if (!is.null(years)) {
    df <- df %>% filter(year_api >= years[1], year_api <= years[2])
  }
  
  if (nrow(df) == 0) return(NULL)
  return(df)
}

# ---- Thème Highcharts OMS ----
hc_theme_oms <- hc_theme(
  chart = list(
    backgroundColor = "#FFFFFF",
    style = list(fontFamily = "Arial, Helvetica, sans-serif")
  ),
  title = list(style = list(fontSize = "16px", fontWeight = "bold", color = "#000000"), align = "center"),
  subtitle = list(style = list(fontSize = "13px", color = "#666666"), align = "center"),
  xAxis = list(labels = list(style = list(color = "#000000", fontSize = "12px"))),
  yAxis = list(gridLineColor = "#e6e6e6", labels = list(style = list(color = "#000000", fontSize = "12px"))),
  legend = list(backgroundColor = "#FFFFFF", borderColor = "#CCCCCC", itemStyle = list(color = "#000000", fontSize = "12px")),
  tooltip = list(backgroundColor = "#FCFFC5", borderColor = "#000000", style = list(color = "#000000", fontSize = "12px")),
  plotOptions = list(column = list(dataLabels = list(enabled = TRUE, style = list(fontSize = "11px", fontWeight = "bold", color = "#000000")))),
  colors = c("#CF5C78","#0072BC", "#92C5DE","#b2e2e2", "#2ca25f", "#d9d9d9", "#969696"),
  credits = list(enabled = TRUE, style = list(fontSize = "10px", color = "#666666"))
)


safe_datatable <- function(expr, default_msg = "Erreur lors de la génération du tableau") {
  tryCatch(
    {
      expr  # exécution du code principal
    },
    error = function(e) {
      showNotification(
        paste(default_msg, ":", e$message),
        type = "error",
        duration = NULL
      )
      
      # Tableau par défaut en cas d’erreur
      DT::datatable(
        data.frame(
          country = "Erreur",
          year_api = "None",
          numeric_value = "None"
        ),
        colnames = c('country', 'year_api', 'numeric_value'),
        rownames = FALSE,
        options = list(pageLength = 5)
      )
    }
  )
}


safe_summary <- function(x, fun = c("max","min","mean","sum","median")) {
  fun <- match.arg(fun)
  
  # Si vecteur vide ou uniquement NA → renvoie NA
  if (length(x) == 0 || all(is.na(x))) return(NA)
  
  switch(fun,
         max    = max(x, na.rm = TRUE),
         min    = min(x, na.rm = TRUE),
         mean   = mean(x, na.rm = TRUE),
         sum    = sum(x, na.rm = TRUE),
         median = median(x, na.rm = TRUE)
  )
}

