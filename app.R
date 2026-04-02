# This is a Shiny web application. Authr: Wilson Ondon: ondona@who.int 
#    Cerated at 03/01/2026

#001 LINK TO OTHER SOURCE OF APP-------------------------------------------


# UPLOAD MODULES  
source("modules/map_col.R")
source("modules/filter_dataset.R")
library(tmap) 
library(sf)

#002 DEFINE UI FOR SHINY APPLICATION======================================================================================================================================================

ui <- dashboardPage(
  skin = "blue-light",
  # skin = "blue",
  
  #002.1 ############   HEADER   ############
  dashboardHeader(
    title = div(
      style = "display:flex; align-items:center;height:40px;",  # pas de height fixe
      
      # Premier logo
      img(src = "logowho.png", height = 50, style = "margin-right:10px;"),
      
      # Deuxième logo
      img(src = "logodpc.png", height = 40, style = "margin-right:10px;")#,
      
      # Titre du dashboard
    #  span("Dashboard", style="font-size:20px; font-weight:bold; margin-left:10px;")
    ),
    
    titleWidth = 350,   # élargir pour accueillir les deux logos + texte
    disable = FALSE,
    
    tags$li(
      a(
        tags$code(
          strong(
            span(
              "TROPICAL AND VECTOR-BORN DISEASES (TVD)", 
              style = "
                font-size:18px; 
                font-weight:bold; 
                color:#670011; 
                background-color:#FFFFFF; 
                padding:8px 12px; 
                display:inline-block; 
                height:40px; 
                line-height:30px; 
                border-radius:5px;"
                )
          )
        )
      ),
      class = "dropdown"
    ),
    
    tags$li(
      a(strong("WHO African Region"),
        height = 40,
        href = "",
        title = "",
        target = "",
        center = TRUE),
      class = "dropdown"
    ),
    
    tags$li(
      a(strong("Log-out"),
        height = 40,
        href = "",
        title = "",
        target = "",
        center = TRUE),
      class = "dropdown"
    )
  )
  ,

  #br(),
  #br(),
  #002.2 ###########   SIDEBAR   ############
  dashboardSidebar(
    #002.3.1 STYLE FOR SIBVAR----------------------------
    tags$style(
      "li a {
                  font-size: 13px;
                  font-weight: bold;
                      }
                .navbar-nav li a {
                    font-size: 12px;
                    font-weight: bold;
                }
                  .navbar-nav > li:first-child > a {
                      font-size: 13px;
                      font-weight: bold;
                    }
                    .navbar-nav > li:first-child > a::before {
                      content: '✌️'
                    }
                    .smaller--h1 {
                font-size: 0.75em;
              }
              .smaller--p {
                font-size: 80%;
              }
                "
    ),
    tags$head(
      tags$style(HTML("
                /* Sidebar background */
                .main-sidebar {
                  background-color: #FFFFFF !important;
                  margin-top: 10px;
                }
                /* Sidebar text */
                .sidebar a {
                  color: #000000 !important;  /* Texte noir */
                  font-size: 13px !important; /* ajuste la taille ici */
                  font-weight: bold; font-weight: bold;
                }
                /* Active menu item */
                .sidebar-menu > li.active > a {
                  background-color: #F0F0F0 !important;
                  color: #000000 !important;
                  font-size: 13px !important;
                }
                /* Hover effect */
                .sidebar-menu > li > a:hover {
                  background-color: #F0F0F0 !important;/* Hover gris clair */
                  color: #000000 !important;
                }
              "))
    ),
    
    tags$link(rel="stylesheet", type="text/css", href="oms_style.css"),
    
    id="sidebar",width = 250,  # largeur, if we dont need show disable=TRUE
    useShinyjs(),  # Include shinyjs IT IS IMPORT TO USE shinyjs::hide()
    sidebarMenu(id="sidebarmenu",
                br(),
                #002.3.2 SECTION 1: VIEW LOGIN---------------------------------------------------- 
                menuItem(
                  "LOGIN",
                  icon = icon("user"),
                  menuSubItem("VIEW", tabName = "viewLogin")
                ),
                br(),
                br(),
                #002.3.3 SECTION 2: VIEW DATASET----------------------------------------------------       
                menuItem(
                  "TVD Program",
                  icon = icon("spinner"),
                  menuSubItem("VIEW", tabName = "viewDataSet")
                ), 
    
             
                #002.3.8 SECTION 5: ACTION TRACKER----------------------------------------------------   
                br(),
                br(),
           #     menuItem(
           #       "ACTION TRACKER",
           #       icon = icon("list-alt"),
           #       menuSubItem("VIEW", tabName = "viewMonitoringProgess"),
           #       menuItem("Update", icon = icon("share-square"), href = "https://worldhealthorg.sharepoint.com/:x:/r/sites/AFRO-DPC-TVD/_layouts/15/Doc.aspx?sourcedoc=%7BD295EB92-9127-4C01-98F0-BAF96BC9969C%7D&file=Actions_tracker.xlsx&action=default&mobileredirect=true")
           #     ),
           #     br(),
           #     br(),
                #                menuItem(
                #                  "SETTINGS",
                #                  icon = icon("users"),
                #                  menuSubItem("VIEW", tabName = "viewSettings")
                #                ), 
                
                #002.3.9 SECTION 5: AFFICAGE DE LA NOTE DE MISE A JOUR------------------------------------------------------------------------------------------------------------------
                br(),
                menuItem("Updated on March 22, 2026")
    )
    
  ),
  
  #003 ###########   BODY   ############
  # start body
  dashboardBody(
    # theme = bs_theme(
    #    version = 5,
    #   bg = "#003366", fg = "#FFFFFF", primary = "#003366",
    #   base_font = font_google("Space Mono")
    #   ),
    #  theme = my_theme,
    # theme =  bslib::bs_theme(bootswatch = "litera"),
    tags$head(
      tags$style(HTML("
            /* Header background */
            .main-header .navbar {
              background-color: #003366 !important;
              font-size: 19px !important; /* ajuste la taille ici */
            }
            /* Logo area */
            .main-header .logo {
              background-color: #003366 !important;
              color: #FFFFFF  !important;
              font-weight: bold;
              font-size: 19px !important; /* ajuste la taille ici */
            }
            /* Navigation links */
            .main-header .navbar .nav > li > a {
              color: #FFFFFF !important;
              font-size: 13px !important; /* ajuste la taille ici */
            }
            
                /* ===== BODY ===== */
            .content-wrapper {
              background-color: #FFFFFF !important; /* Fond blanc */
              color: #000000 !important;
              font-size: 14px !important;
            }
            
            /* ===== BOUTONS ===== */
            .btn-primary {
              background-color: #003366 !important;
              border-color: #003366 !important;
              color: #FFFFFF !important;
            }
            .btn-warning {
              background-color: #FFCC00 !important; /* Jaune OMS */
              border-color: #FFCC00 !important;
              color: #000000 !important;
            }
            .btn-success {
              background-color: #32907c !important; /* Vert OMS */
              border-color: #32907c !important;
              color: #FFFFFF !important;
            }
            .btn-danger {
              background-color: #a75502 !important; /* Rouge OMS */
              border-color: #a75502 !important;
              color: #FFFFFF !important;
            }
            
            /* ===== TABLES & GRAPHIQUES ===== */
            .table {
              font-size: 13px !important;
            }
            .dataTables_wrapper .dataTables_filter input {
              border: 1px solid #003366;
            }
           
        /* Conteneur des cases à cocher */
        .checkbox-group {
          text-align: left;
          margin-left: 5px;
          margin-right: 0px; /* réduit l’espace blanc */
          background-color: #f9f9f9; /* fond gris clair type OMS */
          border: 1px solid #ddd;
          border-radius: 6px;
          padding: 10px;
        }
        /* Titre */
        .checkbox-group label {
          font-weight: bold;
          font-size: 15px;
          color: #2c3e50; /* gris foncé OMS */
          margin-bottom: 8px;
          display: block;
        }
        /* Cases à cocher */
        .checkbox input[type='checkbox'] {
          transform: scale(1.5); /* agrandir les cases */
          margin-right: 8px;
        }
        /* Texte des options */
        .checkbox {
          font-size: 14px;
          margin-bottom: 6px;
        }
        .shiny-progress .progress-bar {
        background-color: #0072BC; /* Bleu OMS principal */
      }
      .shiny-progress .progress {
        background-color: #99d8c9; /* Vert pastel OMS */
      }
          "))
    ),
    useShinyjs(),
    # tabPanel("Info",
    #         h2("Informations"),
    #          p("You have declined the terms and conditions. Here is an information page.")
    # ),
    
    tabItems(
      ##003.1 SECTION 1: VIEW LOGIN: BASIC AUTHENTICATION -------------------------------------------------------------
      
      tabItem(tabName = "viewLogin",
              useShinyjs(),  # Include shinyjs IT IS IMPORT TO USE shinyjs::hide()
              br(),
              br(),
              tabPanel(
                useShinyjs(),  # Include shinyjs
                
                div(
                  class = "container",
                  #003.1.1 section 1.1.1 - login form ----
                  column(
                    width = 12,
                    div(
                      id = "login-basic",
                      style = "width: 500px; max-width: 100%; margin: 0 auto;",
                      div(
                        class = "well",
                        #  h4("Welcome to the app",style = "color: blue;",class = "text-center"),
                        # textOutput("status"),
                        h4(class = "text-center", "Please login"),
                        p(class = "text-center", tags$small("AFRO/DPC/TVD Data Warehouse")),
                        textInput(
                          inputId     = "ti_user_name_basic",
                          label       = tagList(icon("user"), "User Name"),
                          placeholder = "Enter user name"
                        ),
                        passwordInput(
                          inputId     = "ti_password_basic",
                          label       = tagList(icon("unlock-alt"),
                                                "Password"),
                          placeholder = "Enter password"
                        ),
                        div(
                          class = "text-center",
                          actionButton(
                            inputId = "ab_login_button_basic",
                            label = "Log in",
                            class = "btn-primary"
                          )
                        )
                      )
                    ),
                    #003.1.2 section 1.2.1 - app ----
                    uiOutput(outputId = "display_content_basic")
                  )
                )
              ),
              tabPanel(
                useShinyjs(),  # Include shinyjs
                div(
                  id = "info-decline",
                  class = "text-center",
                  div(style="font-size:13px; color:#333;",class = "well",h4("Informations"),
                      p("You have declined the terms and conditions. Here is an information page.."),
                      tags$a(
                        href = "https://tvdindicator.shinyapps.io/tvdforecasting/",   # lien vers le site OMS
                        target = "_blank",                 # ouvre dans un nouvel onglet
                        class = "btn btn-info",
                        "Back to home page"
                      )
                    #  actionButton("back_home", "Back to home page", class = "btn btn-warning")
                      )
                )
              )
      ),
      ##003.2 SECTION 2: VIEW DATASET -------------------------------------------------------------
      tabItem(tabName = "viewDataSet",
              # h1("Survey summary data!", align = "center"),
              #  h5("Don't need any sidebar, navbar, ...", align = "center"),
              #  h5("Only focus on basic elements for a pure interface", align = "center"),
              #options("device"),
              # tmap_mode("view"),
              
              panel(
                #   heading = "A famous table",
                #   status = "primary",
                #  footer = "Something",
                top = 0, right = 0, style = "z-index:50; text-align: center;",
                # tags$h2("AFRO VPD Program"),
                #  tags$a("About this dashboard", href=""),
                tabsetPanel(
                  
                  #### RISK HEATMAP---------------------------------------
                  tabPanel(
                    title = tagList(icon("fire"), "Risk heatmap"),
                    
                    tags$div(
                      style = "display: flex; justify-content: right; gap: 30px; padding: 10px;",
                      dropMenu(
                        actionButton(
                          "go_risk", "Apply Filter",
                          icon = icon("filter"),
                          style = "color: #fff; background-color: #385678; border-color: #385678; font-weight: bold;"
                        ),
                        tags$h6("Choose Inputs to Display dashboard"),
                        sliderInput(
                          inputId = "risk_timingInput",
                          label = "📅 Filter by Year",
                          min = min(dfm_stat$year_api, na.rm = TRUE),
                          max = max(dfm_stat$year_api, na.rm = TRUE),
                          value = c(min(dfm_stat$year_api, na.rm = TRUE), max(dfm_stat$year_api, na.rm = TRUE)),
                          step = 1
                        ),
                        selectInput(
                          inputId = "disease_risk",
                          label = "🌐 Disease :", 
                          choices = unique(data_st_disease_all$sub_component),
                          selected = unique(data_st_disease_all$sub_component)[1]
                        ),
                        div(
                          style = "display: flex; justify-content: center; gap: 15px; margin-top: 10px;",
                          actionButton(
                            "apply_risk", "Apply Filter", 
                            icon = icon("redo"), 
                            style = "color: #fff; background-color: #32907c; border-color: #32907c; font-weight: bold;"
                          ),
                          downloadButton(
                            "risk_tvd_Data", "Export Data",
                            icon = icon("download"),
                            style = "color: #fff; background-color: #87cefa; border-color: #87cefa; font-weight: bold; font-size:13px"
                          )
                        )
                      )
                    ),
                    
                    shinyjs::useShinyjs(),
                    fluidRow(
                      # Colonne 1 : Checkbox
                      column(
                        width = 3,
                        div(class = "checkbox-group",
                            checkboxGroupInput(
                              inputId = "index_ind_risk",
                              label = "📊 Indicateurs de surveillance :",
                              choices = "",   # rempli dynamiquement par le server
                              selected = NULL,
                              inline = FALSE
                            )
                        )
                      ),
                      
                      # Colonne 2 : Tableaux GT et DT
                      column(
                        width = 5,
                        style = "padding-left:0px; padding-right:0px;",  # réduit l’espace blanc
                        # Ajout du titre bilingue
                       # tags$h4("Analyse des risques - Scores normalisés et classement des pays"),
                       # tags$h4("Risk Analysis - Normalized Scores and Country Ranking"),
                        
                        tabsetPanel(
                          tabPanel(
                            "Linear Model", icon = icon("chart-line"),
                            box(
                              div(withSpinner(gt_output("gt_table"), type = 8)),
                              collapsible = TRUE, status = "primary", collapsed = FALSE, solidHeader = FALSE, width = 12
                            )
                          ),
                          tabPanel(
                            "Risk heatmap", icon = icon("fire"),
                            tabsetPanel(
                              tabPanel("Data Table", tags$div(align = "center", withSpinner(DTOutput("dt_table"), type = 8), width = 12)),
                              tabPanel("Data Export", DTOutput("dt_export"))
                            )
                          )
                        )
                      ),
                      
                      # Colonne 3 : Carte Leaflet
                      column(
                        width = 4,
                        style = "padding-left:0px;",   # réduit l’espace blanc
                        withSpinner(leafletOutput("mymap_risk", height = "700px"), type = 4)
                      )
                    )
                  ),
                  
                  #### ANALYSE EN CLUSTER---------------------------------------
                  tabPanel(
                    title = tagList(icon("project-diagram"), "Clustering"),
                    
                    tags$div(
                      style = "display: flex; justify-content: right; gap: 30px; padding: 10px;",
                      dropMenu(
                        actionButton(
                          "go_cluster", "Apply Filter",
                          icon = icon("filter"),
                          style = "color: #fff; background-color: #385678; border-color: #385678; font-weight: bold;"
                        ),
                        tags$h6("Choose Inputs to Display dashboard"),
                        sliderInput(
                          inputId = "cluster_timingInput",
                          label = "📅 Filter by Year",
                          min = min(dfm_stat$year_api, na.rm = TRUE),
                          max = max(dfm_stat$year_api, na.rm = TRUE),
                          value = c(min(dfm_stat$year_api, na.rm = TRUE), max(dfm_stat$year_api, na.rm = TRUE)),
                          step = 1
                        ),
                        selectInput(
                          inputId = "disease_cluster",
                          label = "🌐 Disease :", 
                          choices = unique(data_st_disease_all$sub_component),
                          selected = unique(data_st_disease_all$sub_component)[1]
                        ),
                        div(
                          style = "display: flex; justify-content: center; gap: 15px; margin-top: 10px;",
                          actionButton(
                            "apply_cluster", "Apply Filter", 
                            icon = icon("redo"), 
                            style = "color: #fff; background-color: #32907c; border-color: #32907c; font-weight: bold;"
                          ),
                          downloadButton(
                            "cluster_tvd_Data", "Export Data",
                            icon = icon("download"),
                            style = "color: #fff; background-color: #87cefa; border-color: #87cefa; font-weight: bold; font-size:13px"
                          )
                        )
                      )
                    ),
                    
                    shinyjs::useShinyjs(),
                    fluidRow(
                      # Colonne 1 : Checkbox
                      column(
                        width = 2,
                        
                        # Encadré pour la méthode de clustering
                        div(
                          style = "margin-bottom:20px; padding:10px; border:1px solid #ddd; border-radius:6px; background-color:#f9f9f9;",
                          tags$h4("Method of Clustering"),
                          selectInput("method", "Select Method :", 
                                      choices = c("Hierarchy_based", "K-means")),
                          numericInput("k", "Set Number of Clusters (k-means) :", 
                                       value = 3, min = 2, max = 6)
                        ),
                       
                        # Encadré pour les indicateurs
                        div(
                          style = "padding:10px; border:1px solid #ddd; border-radius:6px; background-color:#f9f9f9;",
                          tags$h4("📊 Surveillance Indicators"),
                          br(),
                          div(
                            class = "checkbox-group",
                            checkboxGroupInput(
                              inputId = "index_ind_cluster",
                              label = NULL,
                              choices = "",   # rempli dynamiquement par le server
                              selected = NULL,
                              inline = FALSE
                            )
                          )
                        )
                      ),
                      # Colonne 2 : Tableaux GT et DT
                      column(
                        width = 6,  # élargir la colonne centrale
                        style = "padding-left:10px; padding-right:10px;",
                        tags$h3(
                          textOutput("title_disease_cluster"),
                          style = "margin-top:20px; margin-bottom:20px; color:#2c3e50; font-weight:bold; text-align:center;"
                        ),
                        tabsetPanel(
                          tabPanel(
                            "Clustering Results", icon = icon("object-group"),
                            box(
                              div(withSpinner(plotOutput("clusterPlot", height = "600px"), type = 8)),
                              collapsible = FALSE, status = "primary", solidHeader = FALSE, width = 12
                            )
                          ),
                          tabPanel(
                            "Descriptive Statistics", icon = icon("braille"),
                            div(withSpinner(verbatimTextOutput("summary"), type = 8))
                          )
                        )
                      ),
                      
                      # Colonne 3 : Carte Leaflet
                      column(
                        width = 4,
                        style = "padding-left:0px;",   # réduit l’espace blanc
                        withSpinner(leafletOutput("mymap_cluster", height = "700px"), type = 8)
                      )
                    )
                  ),

                  
                  #### ANALYSE ANOVA AND REGRESSION---------------------------------------
                  tabPanel(
                    title = tagList(icon("calculator"), "Statistical Analysis"),

                    shinyjs::useShinyjs(),
                    fluidRow(
                      # Titre principal après fluidRow
                      tags$h3(
                        textOutput("title_disease_statistic"),
                        
                        style = "margin-top:20px; margin-bottom:20px; color:#2c3e50; font-weight:bold; text-align:center;"
                      ),
                      tags$h5(
                      textOutput("subtitle_disease_statistic"), color="black"
                      ),
                      # Colonne 1 : Choix et méthodes statistiques
                      column(
                        width = 3,
                        div(
                          style = "
                              margin-bottom:20px; 
                              padding:15px; 
                              border:1px solid #ddd; 
                              border-radius:8px; 
                              background-color:#f9f9f9;
                              box-shadow: 2px 2px 6px rgba(0,0,0,0.1);
                            ",
                          tags$h6("Choose Inputs to Display dashboard"),
                          sliderInput(
                            inputId = "statistic_timingInput",
                            label = "📅 Filter by Year",
                            min = min(dfm_stat$year_api, na.rm = TRUE),
                            max = max(dfm_stat$year_api, na.rm = TRUE),
                            value = c(min(dfm_stat$year_api, na.rm = TRUE), max(dfm_stat$year_api, na.rm = TRUE)),
                            step = 1
                          ),
                          selectInput(
                            inputId = "disease_statistic",
                            label = "🌐 Disease :", 
                            choices = unique(dfm_stat$sub_component),
                            selected = unique(dfm_stat$sub_component)[1],
                            width = "100%"
                          ),
                          selectInput(
                            "indicator_filter", 
                            "Select indicator :", 
                            choices = NULL, 
                            width = "100%"   # champ étendu sur toute la largeur
                          ),
                          selectizeInput(
                            inputId = "index_country_statistic",
                            label = "🏳️Geographic level",
                            choices = NULL,
                            multiple = TRUE, 
                            width = "100%"
                          ),
                        ),
                      #  tags$hr(),
                        div(
                          style = "padding:10px; border:1px solid #ddd; border-radius:6px; background-color:#f9f9f9;",
                          
                          h4("ANOVA Module"),
                          selectInput("anova_y", "Dependent variable for ANOVA:", choices = NULL,width = "100%"),
                          selectInput("anova_group", "Grouping factor:", choices = NULL,width = "100%"),
                          actionButton("run", "Run ANOVA/Tukey", class = "btn btn-success"),
                        #  div(
                        #    style = "margin-top:10px;",
                        #    tags$div(
                        #      style = "display:flex; gap:10px; flex-wrap:wrap;",
                        #      downloadButton("downloadData", "Download Tukey results (CSV)"),
                        #      downloadButton("downloadPlot", "Download Tukey plot (PNG)"),
                        #      downloadButton("downloadPlotPDF", "Download Tukey plot (PDF)")
                        #    )
                        #  ),
                          
                          tags$hr(),
                          h4("Regression Module"),
                          selectInput("yvar", "Dependent variable:", choices = NULL,width = "100%"),
                          selectInput("xvars", "Independent variables:", choices = NULL, multiple = TRUE,width = "100%"),
                          actionButton("run_reg", "Run Regression", class = "btn btn-success"),
                        #  div(
                        #    style = "margin-top:10px;",
                        #    downloadButton("downloadReg", "Download Regression results (CSV)")
                        #  )
                        
                        tags$hr(),
                          div(
                            style = "margin-top:10px;",
                            tags$div(
                              style = "display:flex; gap:10px; flex-wrap:wrap;",
                              downloadButton("downloadData", "Download Tukey results (CSV)"),
                              downloadButton("downloadPlot", "Download Tukey plot (PNG)"),
                              downloadButton("downloadPlotPDF", "Download Tukey plot (PDF)"),
                              downloadButton("downloadReg", "Download Regression results (CSV)")
                            )
                          )
                        )
                      ),
                      
                      # Colonne 2 : Résultats
                      column(
                        width = 9,
                        style = "padding-left:10px; padding-right:10px;",
                        tabsetPanel(
                          tabPanel(
                            "ANOVA Narrative Interpretation", icon = icon("chart-bar"),
                            box(
                              div(withSpinner(DTOutput("tukey_table", height = "600px"), type = 8)),
                              div(withSpinner(plotOutput("tukey_plot", height = "600px"), type = 8)),
                              collapsible = FALSE, status = "primary", solidHeader = FALSE, width = 12
                            )
                          ),
                          tabPanel(
                            "ANOVA Results", icon = icon("list"),
                            div(withSpinner(verbatimTextOutput("anova_res"), type = 8))
                          ),
                          tabPanel(
                            "Regression Results", icon = icon("chart-pie"),
                            box(
                              div(withSpinner(DTOutput("reg_table", height = "600px"), type = 8)),
                              div(withSpinner(plotOutput("reg_plot", height = "600px"), type = 8)),
                              collapsible = FALSE, status = "primary", solidHeader = FALSE, width = 12
                            )
                          ),
                          tabPanel(
                            "Regression statistic", icon = icon("list"),
                            div(withSpinner(verbatimTextOutput("reg_res"), type = 8))
                          )
                        )
                      )
                    )
                    
                    
                  ),
                  
                  
                  #### Predilection ---------------------------------------
                  tabPanel(
                    title = tagList(icon("chart-line"), "Forecasts"),
                    shinyjs::useShinyjs(),
                    fluidRow(
                      tags$h3(
                        textOutput("title_disease_predict"),
                        style = "margin-top:20px; margin-bottom:20px; color:#2c3e50; font-weight:bold; text-align:center;"
                      ),
                      tags$h4(
                        textOutput("subtitle_disease_predict"), color="black"
                      ),
                      column(
                        width = 3,
                        div(
                          style = "
                            margin-bottom:20px; 
                            padding:15px; 
                            border:1px solid #ddd; 
                            border-radius:8px; 
                            background-color:#f9f9f9;
                            box-shadow: 2px 2px 6px rgba(0,0,0,0.1);
                          ",
                          tags$h6("Choose Inputs to Display Dashboard"),
                          sliderInput(
                            inputId = "predict_timingInput",
                            label = "📅 Filter by Year",
                            min = min(dfm_stat$year_api, na.rm = TRUE),
                            max = max(dfm_stat$year_api, na.rm = TRUE),
                            value = c(min(dfm_stat$year_api, na.rm = TRUE), max(dfm_stat$year_api, na.rm = TRUE)),
                            step = 1
                          ),
                          selectInput(
                            inputId = "disease_predict",
                            label = "🌐 Disease:", 
                            choices = unique(dfm_stat$sub_component),
                            selected = unique(dfm_stat$sub_component)[1],
                            width = "100%"
                          ),
                          selectInput(
                            "indicator_predict", 
                            "Select Indicator:", 
                            choices = NULL, 
                            width = "100%"
                          ),
                          selectizeInput(
                            inputId = "index_country_predict",
                            label = "🏳️ Geographic Level",
                            choices = NULL,
                            multiple = FALSE, 
                            width = "100%"
                          ),
                          actionButton("run_forecast", "Launch Forecast", class = "btn btn-success")
                        )
                      ),
                      column(
                        width = 9,
                        style = "padding-left:10px; padding-right:10px;",
                        tabsetPanel(
                          tabPanel(
                            "Linear Model", icon = icon("chart-line"),
                            tags$div(
                              align="center",
                              box(
                                div(withSpinner(highchartOutput("first_fig_tvd_predict"), type=8)),
                                title = h4(strong("Projected Indicator Results (Linear Interpolation from Previous Period)", style = "color:#3498db")),
                                collapsible = TRUE, status = "primary", collapsed = FALSE, solidHeader = FALSE, width = 12
                              )
                            )
                          ),
                          tabPanel(
                            "Monthly Forecast (ARIMA)", icon = icon("calendar-alt"),
                            box(
                              div(withSpinner(DTOutput("forecast_table", height = "600px"), type = 8)),
                              div(withSpinner(plotOutput("forecast_plot", height = "600px"), type = 8)),
                              downloadButton("download_csv", "Download Predictions (CSV)"),
                              downloadButton("download_png", "Download Chart (PNG)"),
                              collapsible = FALSE, status = "primary", solidHeader = FALSE, width = 12
                            )
                          ),
                          tabPanel(
                            "Annual Forecast (ARIMA)", icon = icon("chart-line"),
                            box(
                              div(withSpinner(highchartOutput("first_fig_tvd_arima_predict")),type=8),
                              collapsible = FALSE, status = "primary", solidHeader = FALSE, width = 12
                            )
                          ),
                          tabPanel(
                            "Statistical Summary", icon = icon("list")
                          )
                        )
                      )
                    )
                  ),
                  
                  
                  
                  
                  #003.2.1 SECTION TO SHOW MAP AND DOWNLOAD DATASET---------------------------
                  tabPanel("Indicator overview", icon = icon("chart-bar"),
                           # hr(),
                           tags$div(
                             style = "display: flex; justify-content: right; gap: 30px; padding: 10px;",
                             
                             dropMenu( # ADD OTHER DROPDOWN TO SELECTION DATA USING IN MAP
                               actionButton("go_map", "Apply Filter",
                                            icon = icon("filter"),
                                            style = "color: #fff; background-color: #385678; border-color: #385678; font-weight: bold;"),
                               
                               tags$h6("Choose Inputs to Display dashboard"),
                               
                               sliderInput(
                                 inputId = "progress_timingInput",
                                 label = "📅 Filter by Year",
                                 min = min(tvd_dts$year_api, na.rm = FALSE),
                                 max = max(tvd_dts$year_api, na.rm = FALSE),
                                 value = c(min(tvd_dts$year_api, na.rm = FALSE), max(tvd_dts$year_api, na.rm = FALSE)),
                                 step = 1
                               ),
                               
                               selectInput(inputId="index_component_dshb",
                                           label="🌐 Area :", 
                                           choices = unique(tvd_indicator$component)),
                               
                               selectInput(inputId="index_subcomponent_dshb",
                                           label="🦠 Disease:", 
                                           choices ="", selected = ""),
                               
                               selectInput(inputId="index_ind_dshb",
                                           label="📊 Indicator:", 
                                           choices ="", selected = ""),
                               
                               selectizeInput(
                                 inputId = "index_country_dshb",
                                 label = "🏳️Geographic level",
                                 choices = NULL,
                                 multiple = FALSE
                               ),
                               
                               # Boutons côte à côte
                               div(
                                 style = "display: flex; justify-content: center; gap: 15px; margin-top: 10px;",
                                 
                                 actionButton("apply_tracker", "Apply Filter", 
                                              icon = icon("redo"), 
                                              style = "color: #fff; background-color: #32907c; border-color: #32907c; font-weight: bold;"),
                                 
                                 downloadButton("map_tvd_Data", "Mapping Data Inputs",
                                                icon = icon("download"),
                                                style = "color: #fff; background-color: #87cefa; border-color: #87cefa; font-weight: bold; font-size:13px")
                               )
                             ),
                             
                             dropMenu( # ADD OTHER DROPDOWN TO SELECTION DATA FOR DOWNLOAD
                               actionButton("go", "Export Data",
                                            icon = icon("file-export"),
                                            style = "color: #fff; background-color: #a75502; border-color: #a75502; font-size:12px; font-weight: bold;"),
                               
                               tags$h4("Some inputs to Download"),
                               
                               sliderInput(
                                 inputId = "tvd_timingInput",
                                 label = "📅 Filter by Year",
                                 min = min(tvd_dts$year_api, na.rm = FALSE),
                                 max = max(tvd_dts$year_api, na.rm = FALSE),
                                 value = c(min(tvd_dts$year_api, na.rm = FALSE), max(tvd_dts$year_api, na.rm = FALSE)),
                                 step = 1
                               ),
                               
                               selectInput(inputId="index_component_export",
                                           label="🌐 Component:", 
                                           choices = unique(tvd_indicator$component)),
                               
                               selectInput(inputId="index_subcomponent_export",
                                           label="📌 Sub Component:", 
                                           choices ="", selected = ""),
                               
                               selectInput(inputId="index_ind_export",
                                           label="📊 Indicator:", 
                                           choices ="", selected = ""),
                               
                               radioButtons(
                                 "group_estimate", "Choice estimation:",
                                 c("No estimate" = "wco",
                                   "Estimate" = "gho"),
                                 inline = TRUE
                              ),
                               
                               selectizeInput(
                                 inputId = "index_ind_download_country",
                                 label = "🏳️Geographic level",
                                 choices = NULL,
                                 multiple = FALSE
                               ),
                               
                               # Bouton de téléchargement
                               div(
                                 style = "display: flex; justify-content: center; margin-top: 10px;",
                                 
                                 downloadButton("download_tvd_Data", "Download Data",
                                                icon = icon("download"),
                                                style = "color: #000; background-color: #ffff99; border-color: #ffff99; font-weight: bold; font-size:13px")
                               )
                             )
                           ),
                           
                           shinyjs::useShinyjs(),
                           tags$style(HTML('#Table1 table.dataTable tr.selected td, table.dataTable td.selected {background-color: black !important;}')),
                           theme = bslib::bs_add_rules(
                             bslib::bs_theme(),
                             sass::as_sass("table.dataTable tbody tr.active td {
                               color: black !important;
                               box-shadow: inset 0 0 0 9999px yellow !important;}"
                             )),
                           fluidRow(
                             column(
                               width = 8, 
                               #h5(p(em("Distribution of Results "),icon("chart-pie",lib = "font-awesome"),style="color:black;text-align:center")),
                               #   tags$h5("Latest Indicator Results"),
                               panel(
                                 top = 0, right = 0, style = "z-index:50; text-align: center;",

                                 shinyjs::useShinyjs(),
                                 # Title="view_tracker_indicator", h4(strong("Latest Indicator Results",style = "color:#3498db")),
                                 h4(strong(textOutput("title_indictor_tracker")),style = "color:black"),
                                 h5(p(em(textOutput("subtitle_indictor_tracker")),style="color:black")),
                                 valueBoxOutput("vbox_prevalence",  width = 4),
                               ),
                               tabsetPanel(
                                
                                # tabPanel("Linear Model",icon = icon("chart-line"), tags$div(align="center", box(div(withSpinner(highchartOutput("first_fig_tvd")),type=8), title = h4(strong("Projected Indicator Results (Linear Interpolation from Previous Period)",style = "color:#3498db")),collapsible = TRUE, status = "primary", collapsed = FALSE,   solidHeader = FALSE,width = 12))),
                                # tabPanel("ARIMA Model",icon = icon("project-diagram"), tags$div(align="center", box(div(withSpinner(highchartOutput("first_fig_tvd_arima")),type=8), title = textOutput(""),collapsible = TRUE, status = "primary", collapsed = FALSE,   solidHeader = FALSE,width = 12))),
                                 
                                 tabPanel("By Country",icon = icon("globe"), tags$div(align="center", box(div(highchartOutput("fig_tvd_country")), title = textOutput(""),collapsible = TRUE, status = "primary", collapsed = FALSE,   solidHeader = FALSE,width = 12))),
                                 tabPanel("Trends",icon = icon("chart-area"), tags$div(align="center", box(div(highchartOutput("plot_tvd_yrs_trends")), title = textOutput(""),collapsible = TRUE, status = "primary", collapsed = FALSE,   solidHeader = FALSE,width = 12))),
                                 tabPanel("By sub region",icon = icon("map"),  tags$div(align="center", box(highchartOutput("fig_tvd_subregion"), title = textOutput(""),collapsible = TRUE, status = "primary", collapsed = FALSE,   solidHeader = FALSE,  width = 12))),
                                 tabPanel("Map", icon = icon("map-marked-alt"),  tags$div(align="center", box(withSpinner(highchartOutput("result01b_map"),type = 6),  title = textOutput(""),collapsible = TRUE, status = "primary", collapsed = FALSE,   solidHeader = FALSE,  width = 12))),
                                 tabPanel("Data summary",icon = icon("table"), tags$div(align="center",box(div(DT::DTOutput("tbl2_result01")), title = textOutput(""),collapsible = TRUE, status = "primary", collapsed = FALSE,   solidHeader = FALSE,  width = 12))),
                                 tabPanel("Risk heatmap",icon = icon("fire"), 
                                          tabsetPanel(
                                            tabPanel("Tableau", tags$div(align="center", div(withSpinner(gt_output("gt_ranking_indicator")),type=8), width = 12)),
                                            tabPanel("Exportation", 
                                                     # h4("Options d’exportation"),
                                                     #  p("Utilisez les boutons ci-dessous pour exporter les données :"),
                                                     DTOutput("dt_ranking_indicator"))
                                          ))
                               )
                             ),
                             column(
                               width = 4, 
                              # h5(p(em("MAP "),icon("map",lib = "font-awesome"),style="color:black;text-align:center")),
                               # tags$h5("MAP",icon = icon("map")),
                               fluidRow(
                                 shinyjs::useShinyjs(),
                                 withSpinner(leafletOutput("mymap", height = "700px"), type = 8)
                               )
                             #  panel(
                             #    shinyjs::useShinyjs(),
                             #    extra = withSpinner(tmapOutput(outputId = "mymap", height = "800px"),type = 4) #height = 500
                             #  )
                             )
                           )
                  ),
                  ### MONITORING INDICATOR--------------------------
                  tabPanel("Disease overview",icon = icon("virus"),
                           # hr(),
                           tags$div(
                             style = "display: flex; justify-content: right; gap: 30px; padding: 10px;",
                             
                             dropMenu( # ADD OTHER DROPDOWN TO SELECTION DATA USING IN MAP
                               
                               actionButton("go_metric", "Apply Filter",
                                            icon = icon("filter"),
                                            style = "color: #fff; background-color: #385678; border-color: #385678; font-weight: bold;"),
                               sliderInput(
                                 inputId = "date_timingInput",
                                 label = "📅 Filter by Year",
                                 min = min(tvd_dts$year_api, na.rm = FALSE),
                                 max = max(tvd_dts$year_api, na.rm = FALSE),
                                 value = c(min(tvd_dts$year_api, na.rm = FALSE), max(tvd_dts$year_api, na.rm = FALSE)),
                                 step = 1
                               ),
                               selectInput(inputId="index_component_v1",
                                           label="🌐 Component:", 
                                           choices = unique(tvd_indicator$component),
                                           selected = NULL),
                               
                               selectInput(inputId="disease_ui",
                                           label="🦠 Disease:", 
                                           choices ="", selected = ""),
                               
                               selectizeInput(
                                 inputId = "index_country_prog",
                                 label = "🏳️ Select Country or Region",
                                 choices = NULL,
                                 multiple = FALSE
                               ),
                               # Boutons côte à côte
                               div(
                                 style = "display: flex; justify-content: center; gap: 15px; margin-top: 10px;",
                                 
                                 actionButton("apply_disease", "Apply Filter", 
                                              icon = icon("redo"), 
                                              style = "color: #fff; background-color: #32907c; border-color: #32907c; font-weight: bold;"),
                                 
                                 downloadButton("download_progress", "Save as Excel",
                                                icon = icon("file-excel"),
                                                style = "color: #fff; background-color: #87cefa; border-color: #87cefa; font-weight: bold; font-size:13px")
                               )
                             )
                           ),
                           tags$style(HTML('#Table1 table.dataTable tr.selected td, table.dataTable td.selected {background-color: black !important;}')),
                           theme = bslib::bs_add_rules(
                             bslib::bs_theme(),
                             sass::as_sass("table.dataTable tbody tr.active td {
                 color: black !important;
                 box-shadow: inset 0 0 0 9999px yellow !important;}"
                             )),
                           fluidRow(
                             column(
                               width = 6, 
                              # h5(p(em("Display the progress report for disease‑related indicator linking"),icon("chart-pie",lib = "font-awesome"),style="color:black;text-align:center")),
                               #   tags$h5("Latest Indicator Results"),
                               panel(
                                 top = 0, right = 0, style = "z-index:50; text-align: center;",
                                 shinyjs::useShinyjs(),
                                 h5(strong(textOutput("title_indictor_progress"))),
                                 h5(p(em(textOutput("subtitle_indictor_progress")),style="color:black")),
                                 h6(p(em("Indicator Showing Good Progress"),style="color:black;text-align:center")),
                                 fluidRow(
                                   valueBoxOutput("vbx_prevalence",  width = 3),
                                   valueBoxOutput("vbx_incidence",  width = 3),
                                   valueBoxOutput("vbx_death",  width = 3),
                                   valueBoxOutput("vbx_strategy",  width = 3),
                                 ),
                                 fluidRow(
                                 selectInput(inputId="epi_ui",
                                               label="Epidemiological class ::", 
                                               choices ="", selected = ""),
                                   # Choix du format de téléchargement
                                   selectInput("download_format", "Format de téléchargement",
                                               choices = c("PNG" = "png", "PDF" = "pdf"),
                                               selected = "png"),
                                   
                                   downloadButton("download_map", "Télécharger la carte")
                                 ),
                                 tabsetPanel(
                                   tabPanel("Map of status",icon = icon("map-marked-alt"), tags$div(align="center", box(withSpinner(plotOutput("perf_map_plot", height = "600px"),type=8),title =textOutput(""), collapsible = TRUE, status = "primary", collapsed = FALSE,   solidHeader = FALSE,width = 12))),
                                   tabPanel("country status", icon = icon("globe"),tags$div(align="center", box(div(withSpinner(highchartOutput("plot_perf_tvd_indi_country")),type=8), title = textOutput(""),collapsible = TRUE, status = "primary", collapsed = FALSE,   solidHeader = FALSE,width = 12))),
                                   tabPanel("Country list",icon = icon("list-ol"),  tags$div(align="center", box(withSpinner(DT::dataTableOutput("nb_country_perf"),type=8),title =h5(p(em("List of Country according to their performance indicator status "),icon("list-ol",lib = "font-awesome"),style="color:black;text-align:center")), collapsible = TRUE, status = "primary", collapsed = FALSE,   solidHeader = FALSE,width = 12)))
                                 )
                               )),
                             column(
                               width = 6, 
                             #  h5(p(em("Breakdown of indicator trend by Area "),icon("book",lib = "font-awesome"),style="color:black;text-align:center")),
                               # tags$h5("MAP",icon = icon("map")),
                               panel(
                                 shinyjs::useShinyjs(),
                                 tags$div(align="center", box(
                                   downloadButton(
                                     outputId = "download_flextable_perf_indic",
                                     label = "Export to Word",
                                     icon = icon("file-word"),
                                     # style = "color: black; ma
                                     #style = "color:rgin-left: 15px; margin-bottom: 5px;"
                                     style = "color: #fff; background-color: #32907c; border-color: #32907c"
                                   ),
                                   withSpinner(uiOutput("progress_flex_disease"),type=8), title = textOutput(""),collapsible = TRUE, status = "primary", collapsed = FALSE,   solidHeader = FALSE,  width = 12))
                               )
                             )
                           )
                  ),
                  ### FACT SHEET-----------------------------------
                  tabPanel("Fact Sheet", icon = icon("file-alt"),
                           tags$div(
                             style = "display: flex; justify-content: right; gap: 20px; padding: 15px; 
           background-color: #f9f9f9; border-radius: 8px; border: 1px solid #e0e0e0;",
                             dropMenu(
                               actionButton("go_factSheet", "Apply Filter",
                                            icon = icon("filter"),
                                            style = "color: #fff; background-color: #003366; border-color: #003366; font-weight: bold;"),
                               
                               sliderInput(
                                 inputId = "factsheet_imingInput",
                                 label = "📅 Filter by Year",
                                 min = min(tvd_dts$year_api, na.rm = FALSE),
                                 max = max(tvd_dts$year_api, na.rm = FALSE),
                                 value = c(min(tvd_dts$year_api, na.rm = FALSE), max(tvd_dts$year_api, na.rm = FALSE)),
                                 step = 1
                               ),
                               selectInput(inputId="index_component_fsheet",
                                           label="🌐 Area :", 
                                           choices = unique(tvd_indicator$component),
                                           selected = NULL),
                               
                               selectInput(inputId="disease_fsheet",
                                           label="🦠 Disease:", 
                                           choices ="", selected = ""),
                               selectizeInput(
                                 inputId = "id_country_factsheet",
                                 label = "🏳️ Select Country or Region",
                                 choices = NULL,
                                 multiple = FALSE
                               ),
                               div(
                                 style = "display: flex; justify-content: center; gap: 20px; margin-top: 10px;",
                                 
                                 actionButton("apply_factSheet", "Apply Filter", 
                                              icon = icon("redo"), 
                                              style = "color: #fff; background-color: #32907c; border-color: #32907c; font-weight: bold;"),
                                 
                              #   downloadButton("download_dataFactSheet", "Save as Excel",
                              #                  icon = icon("file-excel"),
                              #                  style = "color: #fff; background-color: #FFCC00; border-color: #FFCC00; font-weight: bold; font-size:13px")
                               )
                             )
                           ),
                           tags$style(HTML('#Table1 table.dataTable tr.selected td, table.dataTable td.selected {background-color: black !important;}')),
                           theme = bslib::bs_add_rules(
                             bslib::bs_theme(),
                             sass::as_sass("table.dataTable tbody tr.active td {
                 color: black !important;
                 box-shadow: inset 0 0 0 9999px yellow !important;}"
                             )),
                           
                           sidebarLayout(
                             sidebarPanel(
                               textInput("filename_factsheet_file", "File name:", "FactSheet"),
                               radioButtons("format_factsheet", "Document format:",
                                            choices = c("HTML", "PDF", "Word"), inline = TRUE),
                            
                               downloadButton(outputId = "factsheet_file",
                                              label = "Generate report",
                                              icon = icon("download"),
                                              #  style = "color: black; margin-left: 15px; margin-bottom: 5px;"
                                              style = "color: #fff; background-color: #32907c; border-color: #32907c")
                               ),
                             mainPanel(
                               tags$h4("Preview of the Fact Sheet"),
                             #  pboptions(type = "txt"),
                               pbsapply(1:15, function(z) Sys.sleep(0.5)),
                               withSpinner(uiOutput("reportPreview"),type = 8) # HTML preview
                             )
                           )
                  ),
                  #003.2.2 SECTION FOR FILTERING  DATASET --------------------------
                  tabPanel("Filter dataset", icon = icon("filter"),
                           fluidRow(
                             column(
                               width = 10, offset = 1,
                               tags$h5("Select Group to Filter Data"),
                               panel(
                                 select_group_ui(# selectizeGroupUI(
                                   id = "my_filters",
                                   params = list(
                                     country = list(inputId = "country", title = "Country:"),
                                     component = list(inputId = "component", title = "Component:"),
                                     sub_component = list(inputId = "sub_component", title = "Area"),
                                     indicator = list(inputId = "indicator", title = "Indicator:"),
                                     year_api = list(inputId = "year_api", title = "Year:"),
                                     alpha_value = list(inputId = "alpha_value", title = "alpha value:"),
                                     numeric_value = list(inputId = "numeric_value", title = "numeric value:"),
                                     ref_data = list(inputId = "ref_data", title = "Order")
                                   )
                                 ), status = "primary"
                               ),
                               withSpinner(DT::dataTableOutput(outputId = "table_tvd"),type=8) 
                             )
                           )
                  ),
                  #003.2.3 SECTION FOR PIVOT CROSS TABLE--------------------------------
                  tabPanel("Pivot data", icon = icon("table"),
                           fluidRow(
                             column(
                               width = 2, #offset = 1,
                               actionButton("runit", "RUN QUERY",
                                            style = "color: #fff; background-color: #32907c; border-color: #32907c"),
                               hr(),
                               h4(HTML("&nbsp"), "Select Table Rows"),
                               uiOutput('rowSelect'),
                               hr(),
                               h4(HTML("&nbsp"), "Select Table Columns"),
                               uiOutput('colSelect'),
                               hr(),
                               h4(HTML("&nbsp"), "Select Table Cell Fill"),
                               uiOutput('aggSelect'),
                               hr()
                             ),
                             column(
                               width = 10, #offset = 1,
                               #  tags$h3("Filter data with selectize group"),
                               withSpinner(DT::dataTableOutput(outputId = "data_pivot_tbl"), type = 8)
                             )
                           )
                  ),
                  #003.2.4 SECTION FOR LIST OF MALARIA ------------------------------
                  tabPanel("Metadata", icon = icon("database"),
                           tags$style(".fa fa-list-ol {color:#E87722}"),
                           h5(p(em("Diseases with indicators Included in the Dashboard"),icon("list-ol",lib = "font-awesome"),style="color:black;text-align:center")),
                           fluidRow(
                             tags$div(align="center", box(withSpinner(DT::dataTableOutput("list_disease_indicator"),type=8),title =textOutput(""), collapsible = TRUE, status = "primary", collapsed = FALSE,   solidHeader = FALSE,width = 12))
                           )
                           
                  ),
                  #003.2.4 SECTION FOR LIST OF MALARIA ------------------------------
                  tabPanel("Additional information", icon = icon("info-circle"),
                           uiOutput(outputId = "display_content_info")
                  )
                  
                  #003.2.5 SECTION FOR DATA ENTRY------------------------------
                  #003.2.6 SECTION FOR QUESTIONNAIRE----------------------------       
                )
              )
      ),

      ##005.5 SECTION 4: FACT SHEET -------------------------------------------------------------
      tabItem(tabName = "viewFactSheet",
              # options(pbapply.pboptions = list(type = "txt")),
              fluidRow(
                # titlePanel("Generate the fact sheet for the disease selected"),
                # tags$h4("Select disease → Choice country → Download report → Generate fact sheet ."),
              )),
      
      
      ##005.6 SECTION 4: SETTINGS -------------------------------------------------------------
      tabItem(tabName = "viewSettings",
              fluidRow(
                column(
                  width = 4,
                  textInput(
                    inputId = "filename_all_dataset",
                    placeholder = "Name download data file",
                    label = "Download Database"
                  ),
                  div(
                    downloadButton(
                      outputId = "download_all_dataset",
                      label = "Download Database",
                      icon = icon("download"),
                      #style = "color: black; margin-left: 15px; margin-bottom: 5px;"
                      style = "color: #fff; background-color: #32907c; border-color: #32907c"
                    )
                  )
                ),
                column(
                  width = 8,
                  tags$h4("Overview of the Database"),
                  tags$br(),
                  dropMenu(
                    actionButton("see_database", "Data inside", style = "color: #fff; background-color: #32907c; border-color: #32907c"),
                    DT::DTOutput(outputId = "database_df")
                    # uiOutput('mreportPreviewown')
                  )
                )
              )
      ),
      ##007. SECTION 7.1: ACTIVITY TRACKER OF MONITORING PROGRESS -------------------------------------------------------------
      tabItem(tabName = "viewMonitoringProgess",
              Title="", h5(strong("Task Tracking Tool",style = "color:#3498db")),
              # a("Accéder au site SharePoint", href = "https://worldhealthorg.sharepoint.com/:x:/s/NUTUNIT/IQAWkV-0d-TKQprCPUIYAM9uAcFVfYmPRgOxM5QNDZAz01E?e=0q7LpE", target = "_blank"),
              panel(
                #   heading = "A famous table",
                #   status = "primary",
                #  footer = "Something",
                top = 0, right = 0, style = "z-index:50; text-align: center;",
                # tags$h2("AFRO VPD Program"),
                #  tags$a("About this dashboard", href=""),
                tabsetPanel(
                  
                  # SECTION 7.1.2 Activity tracker --------------------------
                  tabPanel("Task tracker",
                           h5(p(em("Brief overview of Key Action Points"),style="color:black;text-align:center")),
                           
                           fluidRow(   
                             valueBoxOutput("vbox_total_action",  width = 3),
                             valueBoxOutput("vbox_closed_action",  width = 3),
                             valueBoxOutput("vbox_open_action",  width = 3),
                             valueBoxOutput("vbox_Suspended_action",  width = 3)),
                           
                           h5(p(em("Details of the implementation of action points"),icon("table",lib = "font-awesome"),style="color:black;text-align:center")),
                           fluidRow(width = 12,
                                    tags$div(align="center", box(div(DT::DTOutput("activity_tracker_dashbord")), title = textOutput(""),collapsible = TRUE, status = "primary", collapsed = FALSE,   solidHeader = FALSE,  width = 12))
                                    
                           ),
                           
                           
                  ),
                  # SECTION 7.1.1 Edit Actions---------------------------
                  tabPanel("Edit Actions",
                           # hr(),
                           
                           fluidRow(
                             
                             column(
                               width = 12,
                               tags$h5("Create, Update, and Remove Monitoring Actions"),
                               tags$br(),
                               withSpinner(uiOutput('Monitoring_tracker'), type = 4)## put the formular from server
                               
                               
                             )
                           )
                  ),
                  tabPanel("Download",
                           # hr(),
                           
                           
                           div(
                             downloadButton(
                               outputId = "download_activity_tracker",
                               label = "Export Action Point Report",
                               icon = icon("download"),
                               #  style = "color: black; margin-left: 15px; margin-bottom: 5px;"
                               style = "color: #fff; background-color: #32907c; border-color: #32907c"
                             ))
                           
                           
                  )
                  
                )
              )
              
      ),
      
      ##005.7 AFFICAHE NOTE DE NOTE-----------------------------------
      tabItem(tabName = "viewUpload",
              tabPanel(
                fluidRow(
                  verbatimTextOutput(outputId = "file_value")
                ))
      )
    )
  )
)



# end body
# Define server logic required
#006.###########   SERVER   ############

server <- function(input, output, session) {
  
  
  # Variable réactive pour stocker l'acceptation
  accepted <- reactiveVal(FALSE)
  
  # Boîte de dialogue affichée dès l'ouverture
  showModal(modalDialog(
    title = div(style="color:#009dda; font-weight:bold;", "Please read and accept the following terms"),
    easyClose = FALSE,
    footer = tagList(
      actionButton("accept", "I accept",style="color:#ffffff; background-color: #2c51ae"),
      actionButton("decline", "I decline",style="color:#ffffff; background-color: #370028")
    ),
   #2c51ae
    div(style="font-size:13px; color:#333;",
        
        # Bloc de texte inséré
        tagList(
          
          p("This application is best viewed with internet connection." , style="color:#131d25; font-weight:bold;"),
          
          h5("Terms of Use", style="color:#009dda; font-weight:bold;"),
          p("The Dashboard is the property of the WHO/AFRO/TVD Team and its licensors. By using the Dashboard, you agree to the terms of use, and confirm that you have read and accepted the following information. If you do not agree to the terms, do not use the Dashboard. WHO reserves the right at any time - and with its sole discretion - to modify these Terms of Use. You are responsible for periodically reviewing the Terms of Use. These Terms of Use override any others relating to the Dashboard where a conflict in terms may exist. Compliance with these Terms of Use grants you a non-exclusive, non-transferable, limited privilege to use the Dashboard."),
          
          h5("Privacy Policy", style="color:#009dda; font-weight:bold;"),
          p("Please refer to the WHO Privacy Policy describing the collection and use of visitors' information."),
          
          p("The App may contain links to third party websites. Any link you make to or from the third party website will be at your own risk. Any use of the third party website will be subject to - and any information you provide will be governed by - the terms of the third party website, including those relating to confidentiality, data privacy, and security.")
        )
        )
  ))
  
  # Réactions aux boutons
  observeEvent(input$accept, {
    accepted(TRUE)
    shinyjs::hide(id = "info-decline")
    shinyjs::hide(id="sidebar")
    removeModal()

  })
  
  # Quand l'utilisateur clique sur "Refuser"
  observeEvent(input$decline, {
    # Redirection vers l'onglet "Info"
    shinyjs::hide(id = "login-basic")
    shinyjs::hide(id="sidebar")
    shinyjs::show(id = "info-decline")
    
    updateTabsetPanel(session, "tabs", selected = "Info")
    removeModal()
   # stopApp("The user has declined the terms and conditions.")  # Ferme l'application
  })
  
  # Exemple : bloquer l'action tant que non accepté
  observeEvent(input$action, {
    if (!accepted()) {
      showNotification("⚠️ You must accept the terms and conditions before using the application..", type = "error")
    } else {
      showNotification("✅ Aperation successfully completed.", type = "message")
    }
  })
  
  output$status <- renderText({
    if (accepted()) {
      "Terms accepted: access authorized."
    } else {
      "Terms not accepted: access blocked."
    }
  })
  

  
 
 ##006.1 IEW LOGIN: BASIC AUTHENTICATION--------------------------------------------------------
  
  #006.1.1 section 1.1.1 - login form----------------------------------------
   #Create filter userbase for basic authentication
  base_user_filter_name<-reactive(
    if(!is.na(input$ti_user_name_basic)){
      user_base_basic_tbl%>%filter(user_name==input$ti_user_name_basic)
    }
    
  )
  base_user_filter_password<-reactive(
    if(!is.na(input$ti_password_basic)){
      user_base_basic_tbl%>%filter(password==input$ti_password_basic)
    }
  )
  
  #Check credentials vs tibble
  validate_password_basic <- eventReactive(input$ab_login_button_basic, {
    
    validate <- FALSE
    
    if (input$ti_user_name_basic == base_user_filter_name()$user_name &&
        input$ti_password_basic == base_user_filter_password()$password){
      return(validate <- TRUE)
    }
  })
  
  #hide form
  observeEvent(validate_password_basic(), {
    shinyjs::hide(id = "login-basic")
    shinyjs::show(id="sidebar")
  })
  
  # info-decline
  #006.1.2 section 1.2.1 - Start app---------------
  output$display_content_basic <- renderUI({
    req(validate_password_basic())
    
    if(!is.null(base_user_filter_name()$permissions) &&  base_user_filter_name()$permissions=="admin"){
       shinyjs::hide("login-basic")
      return(
        div(
          style="font-size:13px; color:#333; background-color:#E6F2FA; padding:15px; border-radius:8px;",
          id = "success_basic",
          
          h3(icon("unlock-alt"), " Access granted!"),
          h4(icon("user-shield"), " Welcome to the secure AFRO/TVD dashboard, designed to support your analysis"),
          h4(icon("envelope"), " For further information, please contact us at fosaha@who.int"),
          h4(icon("chart-line"), " The application illustrates trends in tropical and vector‑borne disease indicators within WHO/AFRO member countries"),
          
          h4(icon("database"), " The TVD Dashboard draws its data from four primary sources:"),
          tags$ul(   
            tags$li(icon("globe"), 
                    tags$strong(" World Health Organization – Global Health Estimates: "),
                    tags$a("https://www.who.int/data/global-health-estimates", 
                           href = "https://www.who.int/data/global-health-estimates", target = "_blank")),
            tags$li(icon("chart-bar"), 
                    tags$strong(" World Health Organization – Global Health Observatory: "),
                    tags$a("https://www.who.int/data/gho", 
                           href = "https://www.who.int/data/gho/info/gho-odata-api", target = "_blank")),
            tags$li(icon("hospital"), 
                    tags$strong(" Institute for Health Metrics and Evaluation – Global Burden of Disease Study: "),
                    tags$a("https://www.healthdata.org/", 
                           href = "https://www.healthdata.org/", target = "_blank")),
            tags$li(icon("users"), 
                    tags$strong(" Demographic and Health Surveys (DHS): "),
                    tags$a("https://www.dhsprogram.com/", 
                           href = "https://www.dhsprogram.com/", target = "_blank"))
          ),
          
          h4(icon("layer-group"), " This application consists of several sections:"),
          tags$ul(
            tags$li(icon("sign-in-alt"), tags$strong(" Login: "), " Secure access to the application."),
            tags$li(icon("fire"), tags$strong(" Risk Heatmap: "), " Risk Analysis – Normalized Scores and Country Ranking."),
            tags$li(icon("project-diagram"), tags$strong(" Clustering: "), " Cluster Analysis of Countries Based on Disease Indicators."),
            tags$li(icon("calculator"), tags$strong(" Statistical Analysis: "), " ANOVA, TukeyHSD, and Regression Output."),
            tags$li(icon("chart-line"), tags$strong(" Forecasts: "), " Predicted Indicator Values for Disease – WHO African Region."),
            tags$li(icon("map"), tags$strong(" Indicator Overview: "), " New Reported Cases of Disease & Map."),
            tags$li(icon("virus"), tags$strong(" Disease Overview: "), " Indicator Value Differences Between Current Estimates and Baseline."),
            tags$li(icon("file-alt"), tags$strong(" Fact Sheet: "), " Overview of major epidemiological trends."),
            tags$li(icon("filter"), tags$strong(" Filter Dataset: "), " Dataset Filtering by Segment and Export."),
            tags$li(icon("table"), tags$strong(" Pivot Data: "), " Pivot Table Based on Disease, Indicator, and Value."),
            tags$li(icon("database"), tags$strong(" Metadata: "), " List of Diseases and Indicators Used.")
          ),
          
          h4(icon("comments"), " Understanding of the Dashboard"),
          tags$a("Your Feedback Matters", 
                 href = "https://forms.office.com/Pages/ResponsePage.aspx?id=t8AQ9iS9OUuBCz3CgK-1kP5cIpkEi5VJrEuTrtGyMDdUN1hDUFhCUDdaSTRMU01SSU5HNzZVQTJaTi4u",
                 target = "_blank")
        )
        
    
      )}
    else if(!is.null(base_user_filter_name()$permissions) && base_user_filter_name()$permissions=="standard"){
      shinyjs::hide("login-basic")
      return(
        div(
          class = "bg-info",
          id = "success_basic",
          h4("Access granted!"),
          h5("Welcome to the secure AFRO/TVD dashboard, designed to support your analysis"),
          h5("For further information, please contact us at ondona@who.int")
        )
      )
    }
    else{
      return(NULL)
    }
  })
  
  
  #observeEvent(is.null(base_user_filter_name()$permissions),{
   #   shinyjs::hide(id = "formular-afro-staff")
   #   shinyjs::show(id = "formular-afro-staff")
   # })
  
  
  # section 3.1.3 - hide form ogin-basic and show sidebarmenu ----
  observeEvent(validate_password_basic(), {
    shinyjs::show("sidebarmenu")
    shinyjs::hide("login-basic")
    
  })
 
 ##006.2 AFFICAHE NOTE DE NOTE -------------------------------------------------
  showNotification(
    "Developed under the AFRO/DPC/TVD Programme – ondona@who.int",
    duration = 5,
    type = "message"
  )
  
 
 ##006.3 VIEW DATASET
  
  #006.3.1a LIST EN CASCADE Area, Disease and  Indicator For map visualization--------------------------
  
  
  #006.3.1b LIST EN CASCADE Area, Disease and  Indicator befor Export dataset--------------------------
  
    observeEvent(## Fill the dropdown of Disease
      input$index_component_export,
      updateSelectInput(session,"index_subcomponent_export", "Disease",
                        choices = tvd_indicator$sub_component[tvd_indicator$component%in%input$index_component_export])
    )

  observeEvent(## Fill the dropdown of indicator name
    input$index_subcomponent_export,
    updateSelectInput(session,"index_ind_export", "indicator",
                      choices = tvd_indicator$indicator[tvd_indicator$sub_component%in%input$index_subcomponent_export])
  )
  
  
  
  observeEvent(input$index_ind_export, {
    # Filter countries based on disease selection
    countries <- unique(na.omit(tvd_dts$country[tvd_dts$indicator %in% input$index_ind_export]))
    
    # Build grouped choices: Countries vs Regions
    choices <- list(
      "Countries" = setNames(countries, countries),
      "WHO African Region"   = c("WHO African Region" = "WHO African Region")
    )
    
    # Update with server-side selectize
    updateSelectizeInput(
      session,
      inputId = "index_ind_download_country",
      choices = choices,
      selected = "WHO African Region",  # valeur par défaut forcée
      server = TRUE   # key: enables server-side loading
    )
  })
  
  
  #006.3.2 SELECT TVD DATA FOR DOWNLOAD----------------------------------
  tvd_filter_data_export<-reactive({
    # function from source("modules/filter_dataset.R")
    fct_tvd_dfs(a=input$index_ind_download_country, b=input$index_ind_export, c=input$group_estimate, d=input$tvd_timingInput[1], e=input$tvd_timingInput[2])

  })
  
  
  
  #006.3.3 DOWNLOAD SELECTION MAP DATA TO CSV FILE-----------------------------------------
  output$download_tvd_Data <- downloadHandler(
    
    filename = function() {
      selected_code <- tvd_dts[tvd_dts$indicator == input$index_ind_export, "indicator_code"]
      paste("TVD_",input$index_ind_download_country, "_",selected_code[1],"_",Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      req(validate_password_basic()) # show only if authentication is true
      if(!is.null(base_user_filter_name()$permissions) &&  base_user_filter_name()$permissions=="admin"){ # download only if permission is admin account
        
        write_csv(tvd_filter_data_export()%>%select(component,sub_component,component,sub_component,indicator,indicator_code,country,iso,
                                                    year_api,dim1_type,dim1,dim2_type,dim2,dim3_type,dim3,alpha_value,
                                                    numeric_value,ref_data)%>%
                    left_join(tvd_indicator%>%filter(indicator_code!="")%>%select(indicator_code,indicator_source), by = c("indicator_code" = "indicator_code")), file)
      }
    }
  )
  
  
  
  #006.3.4a View MAP IN DOWNLOAD DATA- Nous avons mis les parmettre de map dans la funtion de traker-----------------------------------
  
 # tvd2_df02_map <- eventReactive(input$apply_map, {
 #   showNotification("✅ ApFilter applied for, indiator  & country"  ,type = "message")
   
 #   fct_fliter_tvd_dfs(a=input$index_country_dshb, b=input$index_ind_dshb, d=input$progress_timingInput)
    
 # })
  
 # tvd2_df02_map<-reactive({
    # function from source("modules/filter_dataset.R")
 #   fct_fliter_tvd_dfs(a=input$index_ind_map_country, b=input$index_ind_map, d=input$tvd_timingInput_map)
    
  #  fct2_tvd_dfs(a=input$index_ind_map_country, b=input$index_ind_map, c="gho", d=input$tvd_timingInput_map[1], e=input$tvd_timingInput_map[2])
#  })
  
  
  #006.3.5 FILTER MY DATASET-----------------------------------------------------
  
  # Exemple de données
  data_extra <- tvd_dts%>%ungroup()%>%filter(!is.na(year_api))%>%
    unique()%>%
    select(country,component,sub_component,indicator,year_api,alpha_value,numeric_value,ref_data)
  
  # Module serveur
  res <- select_group_server(
    id = "my_filters",
    data = reactive(data_extra),
    vars = c("country","component","sub_component","indicator","year_api","alpha_value","numeric_value","ref_data") # colonnes filtrables
  )

  output$table_tvd <- DT::renderDT(
    if(!is.null(base_user_filter_name()$permissions) &&  base_user_filter_name()$permissions=="admin"){ # download only if permission is admin account
      res()#res_mod()
    }else{
      data =tvd_dts[1,]%>%ungroup()%>%unique()%>%select(country,component,sub_component,indicator,year_api,alpha_value,numeric_value,ref_data)
    },
    rownames = FALSE,
    extensions = list("ColReorder" = NULL,
                      "Buttons" = NULL,
                      "FixedColumns" = list(leftColumns=1)),
    options = list(
      dom = 'BRrltpi',
      autoWidth=TRUE,
      lengthMenu = list(c(10, 50, -1), c('10', '50', 'All')),
      ColReorder = TRUE,
      buttons =
        list(
          'copy',
          'print',
          list(
            extend = 'collection',
            buttons = c('csv', 'excel', 'pdf'),
            text = 'Download'
          ),
          I('colvis')
        ),
      initComplete = JS(
        "function(settings, json) {",
        "$(this.api().table().header()).css({'background-color': 'moccasin', 'color': '1c1b1b'});",
        "}"),
      columnDefs=list(list(className='dt-center',targets="_all"))
    ))
  
  
  
  #006.3.6 PIVOT TABLE--------------------------------------
  
  data <- tvd_dts%>%
    unique()%>%
    select(component,sub_component,indicator,ref_data,country,year_api,numeric_value)%>%
    mutate(year_api=as.character(year_api),
           component=as.factor(component),
           sub_component=as.factor(sub_component),
           indicator=as.factor(indicator),
           ref_data=as.factor(ref_data),
           country=as.factor(country),
           numeric_value=as.numeric(numeric_value))
    #Identify Measures, Dimensions, and Functions 
  
  dimensions <- colnames(data)[!sapply(data, is.numeric)]
  measures <- colnames(data)[sapply(data, is.numeric)]
  functions_string <- c("mean", "sum", "max", "min")
  
  output$rowSelect <- renderUI({
    selectizeInput(
      inputId = "dimensions",
      label = NULL,
      multiple = TRUE,
      choices = dimensions,
      selected = c()
    )
  })
  
  output$colSelect <- renderUI({
    selectizeInput(
      inputId = "measures",
      label = NULL,
      multiple = TRUE,
      choices = measures,
      selected = c()
    )
  })
  
  output$aggSelect <- renderUI({
    selectizeInput(
      inputId = "funChoices",
      label = NULL,
      multiple = TRUE,
      choices = functions_string,
      selected = c()
    )
  })
  
  pivotData <- eventReactive(input$runit, {
    measuresVec <- input$measures
    dimensionsVec <- input$dimensions
    
    fun_list <- lapply(input$funChoices, match.fun)
    names(fun_list) <- input$funChoices
    pivotData <- data %>%
      group_by(across(all_of(dimensionsVec))) %>%
      summarise(across(all_of(measuresVec), fun_list, na.rm = TRUE))
    
    return(pivotData)
    
  })
  

  
  output$data_pivot_tbl <- DT::renderDT({
    
    req(validate_password_basic()) # afficher seulement si authentification OK
    
    if (!is.null(base_user_filter_name()$permissions) && 
        base_user_filter_name()$permissions == "admin") { # afficher seulement si admin
      
      tabledata <- pivotData()
      
      DT::datatable(
        tabledata,
        rownames = FALSE,
        extensions = c("ColReorder", "Buttons", "FixedColumns"),
        options = list(
          dom = 'Bfrtip',   # plus standard que 'BRrltpi'
          autoWidth = TRUE,
          lengthMenu = list(c(10, 25, 50, -1), c('10', '25', '50', 'All')),
          ColReorder = TRUE,
          buttons = list(
            'copy',
            'print',
            list(
              extend = 'collection',
              buttons = c('csv', 'excel', 'pdf'),
              text = 'Download'
            ),
            'colvis'
          ),
          initComplete = DT::JS(
            "function(settings, json) {",
            "$(this.api().table().header()).css({'background-color': 'moccasin', 'color': '#1c1b1b'});",
            "}"
          ),
          columnDefs = list(list(className = 'dt-center', targets = "_all"))
        ),
        filter = "top",
        selection = 'multiple',
        style = 'bootstrap'
      )
    }
  })
  
  
  #006.3.7 LIST OF DISEASE AND INDICATOR--------------------------------------
  
  output$list_disease_indicator <- DT::renderDT({
    
    disease_list<-tvd_indicator%>%
      ungroup()%>%
      select(sub_component,indicator, indicator_code,category_indicator, indicator_source)%>%
      rename("Disease"="sub_component", "Indicator"="indicator", "Code"="indicator_code", "Type"="category_indicator", "Link"="indicator_source")%>%
      arrange(Disease)
      
    
    
    datatable(
      disease_list[order(disease_list$Disease), ],
      extensions = c('RowGroup','Buttons'),
      options = list(rowGroup = list(dataSrc = 1), dom = 'Bfrtip',buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),pageLength = 10),
      selection = 'none'
    )
  }, server = FALSE)
  
  
  
  
  

  
  #003.4  SECTION 4: VIEW INDICATOR TRACKER ------------------------------------
  #003.4.0 CASCADE LIST FOR Component-Sub component-Indicator------------------------------- 
  observeEvent(
    input$index_component_dshb,
    updateSelectInput(session,"index_subcomponent_dshb", "Disease",
                      choices = tvd_subcomponent$sub_component[tvd_subcomponent$component%in%input$index_component_dshb])
  )
  
  observeEvent(
    input$index_subcomponent_dshb,
    updateSelectInput(session,"index_ind_dshb", "indicator",
                      choices = tvd_indicator$indicator[tvd_indicator$sub_component%in%input$index_subcomponent_dshb])
  )
  
  
  observeEvent(input$index_ind_dshb, {
    # Filter countries based on disease selection
    countries <- unique(na.omit(tvd_dts$country[tvd_dts$indicator %in% input$index_ind_dshb]))
    
    # Build grouped choices: Countries vs Regions
    choices <- list(
      "Countries" = setNames(countries, countries),
      "WHO African Region"   = c("WHO African Region" = "WHO African Region")
    )
    
    # Update with server-side selectize
    updateSelectizeInput(
      session,
      inputId = "index_country_dshb",
      choices = choices,
      selected = "WHO African Region",  # valeur par défaut forcée
      server = TRUE   # key: enables server-side loading
    )
  })
  
  
  
  #006.4.4.2 SHOW LINK OF INDICATOR RESULT -----------------------------------
  show_link_indicator<-reactive({
    fct_show_link_indicator(a=input$index_ind_dshb)
  })
  
  #006.4.4.3 SHOW ESTIMATE OR NO ESTIMATE VALUES BY INDICATORS------------------------------------
  show_ref_data<-reactive({
    fct_show_ref_data(a=input$index_ind_dshb)# Function from filter_dataset.R
  })
  
  #006.4.4.4 SHOW UNIT AND CATEGORY OF INDICATOR (incidence, Prevalence, Death, Coverage, strategy)--------------
  show_unit_data<-reactive({
    fct_show_unit_catg(a=tvd_indicator, b=input$index_ind_dshb)
  })
  
  
  # Déclenche automatiquement le bouton au démarrage
  observe({
    shinyjs::click("apply_tracker")
  })
  
  
  # --- INDICATOR TRACKER -------------------------------------------------
  tracker_data <- eventReactive(input$apply_tracker, {
    showNotification("✅ Apply filter for indicator and country selected ", type = "message")
    fct_fliter_tvd_dfs(a=input$index_country_dshb, b=input$index_ind_dshb, d=input$progress_timingInput)
    
  })
  
  
  
  #fct3_tvd_dfs
  tvd2_df03_map<-reactive({
    # function from source("modules/filter_dataset.R")
    fct3_tvd_dfs(a=tracker_data())#b=input$index_ind_map
  })
  
  tvd11_df_map<-reactive({
    # function from source("modules/filter_dataset.R")
    fct11_tvd_dfs(a=tvd2_df03_map())#, f=input$index_ind_map
  })
  
 
  
  # Préparation des données
  afro_data <- reactive({
    spdf_africa2a %>%
      left_join(
        tvd11_df_map() %>% 
          group_by(iso) %>% 
          summarise(Group = first(Group)),
        by = c("iso_a3" = "iso")
      ) %>%
      sf::st_make_valid()
  })
  
  # Calcul de l'année max
  max_year <- reactive({
    max_yearS <- ifelse(
      all(is.na(tvd2_df03_map()$year_api)) || length(tvd2_df03_map()$year_api) == 0,
      NA,
      max(tvd2_df03_map()$year_api, na.rm = TRUE)
    )
    max_yearS
  })
  
  output$mymap <- renderLeaflet({
    req(validate_password_basic())
    req(tracker_data())

    afro_dfm <- afro_data()
    
    # Fonction palette OMS dynamique
    
    oms_palette <- function(n) {
      base_colors <- c(
       
        "#99d8c9",  # bleu pastel
        "#2ca25f",  # vert OMS
        "#F4A582",  # orange/rose OMS
        "#E8AABE",  # rose clair
        "#fee5d9",  # rose très pâle
        "#fb6a4a",  # rouge OMS (décès)
        "#66c2a4",  # bleu-vert foncé
        "#92C5DE",  # bleu clair OMS
        "#0072BC"   # bleu OMS principal
        

      )
      
      # Si plus de catégories que de couleurs de base,
      # on recycle ou génère des déclinaisons
      if (n <= length(base_colors)) {
        return(base_colors[1:n])
      } else {
        # Générer des déclinaisons plus claires/foncées
        return(colorRampPalette(base_colors)(n))
      }
    }
    
    # Catégories réelles (exclure NA et "Données non disponibles")
    real_categories <- setdiff(unique(afro_dfm$Group), c(NA, "Data not available"))
    
    # Palette OMS pour les catégories réelles
    pal <- colorFactor(
      palette = oms_palette(length(real_categories)),
      domain = c(real_categories, "Data not available")
    )
    
    
    # Couleurs fixes pour NA et "Données non disponibles"
    na_color <- "white"          # gris clair
    dna_color <- "#969696"         # gris plus foncé
    
    # Palette dynamique en fonction du nombre de catégories
    
 #   pal <- colorFactor(
    #      palette = c(
    #        oms_palette(length(unique(afro_dfm$Group[!is.na(afro_dfm$Group)]))), 
    #        "white",  # light gray for NA
    #         "#969696"   # darker gray for Data not available
    #      ),
    #      domain = c(unique(afro_dfm$Group), "Data not available", NA)

    #    )
    
    
    # Construire le titre
    legend_title <- paste0(
      "[", input$index_subcomponent_dshb, "]: ",
      toupper(input$index_ind_dshb), " - ",
      max_year()
    )
    
    # HTML pour le titre centré en haut (responsive)
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
    
    
    # HTML pour la légende personnalisée (responsive)
    legend_items <- c(sort(real_categories), NA, "Data not available")
    #legend_items <- c(
    #  sort(setdiff(unique(afro_dfm$Group), "Data not available")),  # real categories
     # NA,                                                           # NA always included
    #  "Data not available"                                          # forced once
   # )
    
    
    legend_html <- paste0(
      "<div style='background:white;
                 padding:8px;
                 border:1px solid grey;
                 font-size:clamp(12px, 1.5vw, 16px);
                 max-width:200px;'>",
      "<b>Legend</b><br/>",
      paste0(
        sapply(legend_items, function(g) {
          # Assign colors
          if (is.na(g)) {
            col <- "white"   # gray for NA
            label <- "NA"
          } else if (g == "Data not available") {
            col <- "#969696"   # darker gray for Data not available
            label <- "Data not available"
          } else {
            col <- pal(g)
            label <- g
          }
          paste0(
            "<div style='margin:2px; display:flex; align-items:center;'>",
            "<span style='display:inline-block;width:15px;height:15px;
                      background:", col, ";border:1px solid #000;
                      margin-right:5px;'></span>",
            ifelse(is.na(g), "NA", g),
            "</div>"
          )
        }),
        collapse = ""
      ),
      "</div>"
    )
    
    
    # Boutons zoom sous le titre
    zoom_buttons <- "
    <div style='text-align:center; margin-top:5px;'>
      <button onclick=\"map.zoomIn();\" 
              style='padding:5px 10px; font-size:14px; margin-right:5px;'>
        +
      </button>
      <button onclick=\"map.zoomOut();\" 
              style='padding:5px 10px; font-size:14px;'>
        -
      </button>
    </div>
  "
    
    leaflet(afro_dfm) %>%
      addProviderTiles("Esri.WorldGrayCanvas") %>%
      addPolygons(
        fillColor = ~ifelse(is.na(Group), "white",
                            ifelse(Group == "Data not available", "#969696", pal(Group))),
        
       # ~ifelse(is.na(Group), "white", pal(Group)),
        color = "grey",
        weight = 0.5,
        opacity = 1,
        fillOpacity = 0.7,
        label = ~paste0(
          name, ": ",
          ifelse(is.na(Group), "NA",
                 ifelse(Group == "Data not available", "Data not available", Group)
          )
        ),
        popup = ~paste0(
          "<b>", name, "</b><br/>Category: ",
          ifelse(is.na(Group), "NA",
                 ifelse(Group == "Data not available", "Data not available", Group)
          )
        )
      ) %>%
     
      # Titre en haut centré
      addControl(html = title_html, position = "topleft") %>%
      # Boutons zoom juste sous le titre
    #  addControl(html = zoom_buttons, position = "topleft") %>%
      
      # Légende personnalisée en bas à gauche
      addControl(html = legend_html, position = "bottomleft")
  })
  
  
  
  #006.3.3 DOWNLOAD SELECTION MAP DATA TO CSV FILE-----------------------------------------
  output$map_tvd_Data <- downloadHandler(
    
    filename = function() {
      selected_code <-unique(tvd_dts[tvd_dts$indicator == input$index_ind_dshb, "indicator_code"])
      paste("TVD_",input$index_country_dshb, "_",selected_code$indicator_code[1],"_",Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      req(validate_password_basic()) # show only if authentication is true
      if(!is.null(base_user_filter_name()$permissions) &&  base_user_filter_name()$permissions=="admin"){ # download only if permission is admin account
        
        write_csv(tvd2_df03_map()%>%
                    left_join(tvd_indicator%>%filter(indicator_code!="")%>%
                                select(indicator_code,indicator), by = c("indicator_code" = "indicator_code")), file)
      }
    }
  )
  
  
  
  
  #006.4.4.1 FILTER DATASET BY COUNTRY OR REGIONAL LEVEL AND BY ONE INDICATOR ------------------------------
 # tvd_df01<-reactive({
    # function from source("modules/filter_dataset.R")
 #   fct_tvd_dfs(a=input$index_country_dshb, b=input$index_ind_dshb, c=show_ref_data()$ref_data, d=input$progress_timingInput[1], e=input$progress_timingInput[2])
 # })
  
  
  
 # output$tracker_table <- renderUI({
  #   df <- tracker_data()
  #    if (is.null(df)) {
  #      div(style="color:red; text-align:center; font-weight:bold;",
  #          "⚠️ No records found with these filters")
  #   } else {
  #     renderTable(df)
  #   }
  # })
  
  #006.4.4.1 FILTER DATASET BY COUNTRY OR REGIONAL LEVEL AND BY ONE INDICATOR ------------------------------
  tvd2_df02<-reactive({
    # function from source("modules/filter_dataset.R")
    fct2_tvd_dfs(a=input$index_country_dshb, b=input$index_ind_dshb, c=show_ref_data()$ref_data, d=input$progress_timingInput[1], e=input$progress_timingInput[2])
  })
  
  #fct3_tvd_dfs
  tvd2_df03<-reactive({
    # function from source("modules/filter_dataset.R")
    fct3_tvd_dfs(a=tracker_data())#, b=input$index_ind_dshb
  })
  
  
  output$result01b_map=renderHighchart({
    req(tracker_data())
    fct7_tvd_dfs(g=tvd2_df03(),c=input$index_country_dshb, e=show_link_indicator()$indicator_source[1],f=input$index_ind_dshb)
    
  })
  
   
    
  output$vbox_prevalence <- renderValueBox({
    
    tryCatch({
      # Vérification des entrées
      req(tracker_data())
      req(input$index_ind_dshb)
      req(input$index_country_dshb)
      req(show_link_indicator())
      
      # Appel de la fonction principale
      fct4_tvd_dfs(
        a = tracker_data(),
        b = input$index_ind_dshb,
        c = input$index_country_dshb,
        e = show_link_indicator()
      )
      
    }, error = function(e) {
      # Gestion des erreurs globales
      showNotification(
        paste("Please select the filter parameters :", e$message),
        type = "error"
      )
      
      # Valeur par défaut affichée si erreur
      valueBox(
          value = "N/A",
           subtitle = "Please select the filter parameters",
           icon = icon("exclamation-triangle"),
          color = "teal"
        )
    })
  })
  
 
  
  
  
  
 # output$vbox_prevalence <- renderValueBox({
 #   fct4_tvd_dfs(a=tracker_data(), b=input$index_ind_dshb,c=input$index_country_dshb,e=show_link_indicator())
#  })
  
  
  
  output$tbl2_result01 <- DT::renderDT({
    
    req(validate_password_basic()) 
    req(tracker_data())
    
    safe_datatable({
      if (!is.null(base_user_filter_name()$permissions) && 
          base_user_filter_name()$permissions == "admin") {
        
        fct5_tvd_dfs(
          a = tvd2_df03(),
          e = show_link_indicator(),
          f = input$index_ind_dshb,
          k = input$progress_timingInput[2]
        )
        
      } else {
        df <- tvd2_df03()
        validate(
          need(!is.null(df), "No data available."),
          need(!is.null(df$year_api), "No year_api variable in the data.")
        )
        
        datatable(
          data.frame(
            country = "There is an absence of data regarding this indicator",
            year_api = "None",
            numeric_value = "None"
          ),
          colnames = c('country', 'year_api', 'numeric_value'), 
          rownames = FALSE,
          extensions = c('Buttons'),
          options = list(
            dom = 'Bfrtip',
            buttons = c('csv','excel','pdf'),
            pageLength = 10
          )
        )
      }
    }, default_msg = "Check generating the table")
  }, server = FALSE)
  

  #fct8_tvd_dfs
    
  
  
    
   # data_show_val_subregion<-reactive({
      
  #    fct6_tvd_dfs(a=tvd2_df03(),c=input$index_country_dshb,e=show_link_indicator(),f=input$index_ind_dshb,k=input$index_ind_dshb, k=input$progress_timingInput[2])%>%
  #      ungroup()
  #  })
 
    
    #fct_show_val_trend
    output$fig_tvd_subregion <- renderHighchart({
      req(tracker_data())
      fct6_tvd_dfs(a=tvd2_df03(),c=input$index_country_dshb,e=show_link_indicator()$indicator_source,f=input$index_ind_dshb)
    })
    

    
    output$fig_tvd_country <- renderHighchart({
      req(tracker_data())
      tryCatch({
        # Vérification des entrées nécessaires
        req(tvd2_df03())
        req(input$index_country_dshb)
        req(input$index_ind_dshb)
        req(show_link_indicator())
        
        # Appel de la fonction principale
        fct8_tvd_dfs(
          a = tvd2_df03(),
          c = input$index_country_dshb,
          e = show_link_indicator(),
          f = input$index_ind_dshb
        )
        
      }, error = function(e) {
        # Gestion des erreurs globales
        showNotification(
          paste("Check generating the chart:", e$message),
          type = "error"
        )
        
        # Graphique par défaut en cas d’erreur
        highchart() %>%
          hc_title(text = "USER – Data unavailable") %>%
          hc_subtitle(text = "Please check your settings or your data") %>%
          hc_xAxis(categories = NULL) %>%
          hc_yAxis(title = list(text = "N/A")) %>%
          hc_add_theme(hc_theme_oms)%>%
          hc_add_series(name = "No data available", data = list())
      })
    })
    
    
    #fct_show_val_trend
  #  output$fig_tvd_country <- renderHighchart({
      
  #    fct8_tvd_dfs(a=tvd2_df03(),c=input$index_country_dshb, e=show_link_indicator(), f=input$index_ind_dshb)
  #  })
    
  
    
    
    tvd_trend_df <- reactive({
      
      # function from source("modules/filter_dataset.R")
      value_max_year<-fct9_tvd_dfs(a=tracker_data(),b=0,f=input$index_ind_dshb)
      value_max_year_1<-fct9_tvd_dfs(a=tracker_data(),b=1,f=input$index_ind_dshb)
      value_max_year_2<-fct9_tvd_dfs(a=tracker_data(),b=2,f=input$index_ind_dshb)
      value_max_year_3<-fct9_tvd_dfs(a=tracker_data(),b=3,f=input$index_ind_dshb)
      
      fig_tvd_trend_years_df<-rbind(value_max_year, value_max_year_1,value_max_year_2,value_max_year_3)%>%
        mutate(year=as.numeric(year),
               numeric_value=round(val, digit=2))%>%
        select(year,numeric_value)%>%
        filter(numeric_value>0)%>%
        as.data.table()
      
      fig_tvd_trend_years_df
      
    })
    
    
  
    #output$plot_tvd_yrs_trends <- renderHighchart({
      
    #  fct10_tvd_dfs(a=tvd_trend_df(),c=input$index_country_dshb, e=show_link_indicator(), f=input$index_ind_dshb)
      
   # })
    
    output$plot_tvd_yrs_trends <- renderHighchart({
      req(tracker_data())
      tryCatch({
        # Vérification des entrées nécessaires
        req(tvd_trend_df())
        req(input$index_country_dshb)
        req(input$index_ind_dshb)
        req(show_link_indicator())
        
        # Appel de la fonction principale
        fct10_tvd_dfs(
          a = tvd_trend_df(),
          c = input$index_country_dshb,
          e = show_link_indicator(),
          f = input$index_ind_dshb
        )
        
      }, error = function(e) {
        # Gestion des erreurs globales
        showNotification(
          paste("Check generating the chart :", e$message),
          type = "error"
        )
        
        # Graphique par défaut en cas d’erreur
        highchart() %>%
          hc_title(text = "Error – Data unavailable") %>%
          hc_subtitle(text = "Please check your settings or your data") %>%
          hc_xAxis(categories = NULL) %>%
          hc_yAxis(title = list(text = "N/A")) %>%
          hc_add_theme(hc_theme_oms)%>%
          hc_add_series(name = "No data available", data = list())
      })
    })
    
    
    
    
    
# display Localisation level, Disease and indicator  
    output$title_indictor_tracker <- renderText({
      paste("Profile for", input$index_country_dshb,"[",input$index_subcomponent_dshb,"]",":",input$index_ind_dshb)
    })
    
    output$subtitle_indictor_tracker <- renderText({
      paste("Analytical Overview of ",min(tracker_data()$year_api)," - ", max(tracker_data()$year_api))
    })
    
    
    
    
    
    ## OTHER GRAPHIC--------------------------------
    
    data_show_val_trend<-reactive({
      
      fct_show_val_trend(a=tvd_trend_df(),b=input$index_ind_dshb)%>%
        ungroup()
    })
    #fct_show_val_trend

    
    output$fig_tvd <- renderHighchart({
      req(tracker_data())
      tryCatch({
        # Vérification des entrées nécessaires
        req(data_show_val_trend())
        req(input$index_ind_dshb)
        req(input$index_country_dshb)
        req(show_link_indicator())
        
        # Vérification que le dataframe contient bien la variable attendue
        df <- data_show_val_trend()
        validate(
          need(!is.null(df$year_api), "The variable year_api is missing from the data."),
          need(nrow(df) > 0, "No data available for this indicator.")
        )
        
        # Graphique principal
        hchart(df, "column", 
               hcaes(group_show, value, group = categogies),
               dataLabels = list(enabled = TRUE, format='{point.value:.1f}')) %>% 
          hc_colors(c("#2166AC","#999999")) %>%
          hc_xAxis(title = list(text = "")) %>% 
          hc_yAxis(title = list(text = "")) %>% 
          hc_exporting(enabled = TRUE) %>%
          hc_tooltip(crosshairs = TRUE, backgroundColor = "#FCFFC5",
                     shared = TRUE, borderWidth = 2) %>%
          hc_title(text = paste("Number of", input$index_ind_dshb, " ",
                                min(df$year_api), " and ",
                                max(df$year_api), "-", input$index_country_dshb),
                   align = "center") %>%
          hc_subtitle(text = "", align = "center") %>%
          hc_add_theme(hc_theme_smpl()) %>% 
          hc_credits(enabled = TRUE, 
                     text = "Data Source: WHO/AFRO/DPC/TVD Programme",
                     href = unique(show_link_indicator()$indicator_source),
                     style = list(fontSize = "10px"))
        
      }, error = function(e) {
        # Gestion des erreurs globales
        showNotification(
          paste("Check generating the chart:", e$message),
          type = "error"
        )
        
        # Graphique par défaut en cas d’erreur
        highchart() %>%
          hc_title(text = "Error – Data unavailable") %>%
          hc_subtitle(text = "Please check your settings or your data") %>%
          hc_xAxis(categories = NULL) %>%
          hc_yAxis(title = list(text = "N/A")) %>%
          hc_add_theme(hc_theme_oms)%>%
          hc_add_series(name = "No data available", data = list())
      })
    })
    
    
    
    ####-------------------
    output$first_fig_tvd <- renderHighchart({
      req(tracker_data())
      # Vérification que les données existent
     # req(data_show_val_trend())
      
    #  req(!is.null(data_show_val_trend()))   # stoppe proprement si df est NULL
      # Encapsuler dans tryCatch pour capturer les erreurs
      tryCatch({

        
        # Données avec IC
        estim_df <- data_show_val_trend() %>%
          filter(categogies == "Achievment") %>%
          add_confidence_interval(value_col = "value", se_col = "se", margin = 0.1)
        
        proj_df <- data_show_val_trend() %>%
          filter(categogies != "Achievment") %>%
          add_confidence_interval(value_col = "value", se_col = "se", margin = 0.1)
        
        target_df <- data_show_val_trend() %>%
          filter(categogies == "Target")
        
        
        
        nb_proj <- length(unique(proj_df$year))
        nb_estim <- length(unique(estim_df$year))
        
        years <- data_show_val_trend()$year
        estimations <- estim_df$value
        projection <- proj_df$value
        
        # Ajustement du modèle linéaire
        lm_model <- lm(value ~ year, data = estim_df)
        coefs <- coef(lm_model)
        intercept <- round(coefs[1], 2)
        slope <- round(coefs[2], 2)
        model_equation <- paste0("y = ", intercept, " + ", slope, "·year")
        
        # Construction du graphique
        highchart() %>%
          hc_title(text = paste(input$index_ind_dshb," ",
                                min(data_show_val_trend()$year)," and ",
                                max(data_show_val_trend()$year),"-",
                                input$index_country_dshb)) %>%
          hc_xAxis(categories = years,
                   title = list(text = "Year"),
                   plotLines = list(list(
                     value = length(years) - 1,
                     color = "red",
                     width = 2,
                     dashStyle = "Dash",
                     label = list(text = paste("Target ", max(target_df$year)),
                                  style = list(fontSize = "14px", color = "red"))
                   ))) %>%
          hc_yAxis(title = list(text = "Values"),
                   labels = list(format = "{value}")) %>%
          hc_exporting(enabled = TRUE) %>%
          hc_tooltip(crosshairs = TRUE, backgroundColor = "#FCFFC5",
                     shared = TRUE, borderWidth = 2,
                     pointFormat = "Valeur: <b>{point.y}</b><br>IC95%: <b>{point.low}–{point.high}</b>") %>%
          
          # Courbe Achievment
          hc_add_series(
            name = paste("Achievment (", min(estim_df$year), "-", max(estim_df$year), ")"),
            data = c(estimations, rep(NA, nb_proj)),
            type = "line",
            color = "#1f77b4",
            lineWidth = 4,
            dataLabels = list(enabled = TRUE, format = "{y}", style = list(fontSize = "12px"))
          ) %>%
          
          # IC Achievment
          hc_add_series(
            name = "IC Achievment",
            data = purrr::map2(estim_df$value_low, estim_df$value_high, ~list(.x, .y)),
            type = "arearange",
            linkedTo = ":previous",
            color = "#1f77b4",
            fillOpacity = 0.2,
            lineWidth = 0
          ) %>%
          
          # Courbe Projection
          hc_add_series(
            name = paste("Projections (", min(proj_df$year), "-", max(proj_df$year), ")"),
            data = c(rep(NA, nb_estim), projection),
            type = "line",
            color = "#ff7f0e",
            lineWidth = 4,
            dataLabels = list(enabled = TRUE, format = "{y}", style = list(fontSize = "12px"))
          ) %>%
          
          # IC Projection
          hc_add_series(
            name = "IC Projections",
            data = c(rep(list(list(NA, NA)), nb_estim), 
                     purrr::map2(proj_df$value_low, proj_df$value_high, ~list(.x, .y))),
            type = "arearange",
            linkedTo = ":previous",
            color = "#ff7f0e",
            fillOpacity = 0.2,
            lineWidth = 0
          ) %>%
          
          # Annotation avec équation du modèle
          hc_annotations(list(
            labels = list(
              list(
                point = list(x = length(years) - 2,
                             y = max(c(estim_df$value_high, proj_df$value_high), na.rm = TRUE)),
                text = paste("Linear model: ", model_equation),
                backgroundColor = "rgba(255,255,255,0.7)",
                borderColor = "black",
                borderRadius = 5,
                style = list(fontSize = "13px")
              )
            )
          )) %>%
          
          hc_credits(enabled = TRUE,
                     text = "Data Source: WHO/AFRO/DPC/TVD Programme",
                     href = unique(show_link_indicator()$indicator_source),
                     style = list(fontSize = "11px"))
        
      }, error = function(e) {
        # Gestion des erreurs globales
        showNotification(paste("Error during chart generation :", e$message),
                         type = "error")
        return(NULL)  # évite le blocage de l’application
      })
    })
    
   

    output$first_fig_tvd_arima <- renderHighchart({
      req(tracker_data())
      tryCatch({
          # Données Achievment
          estim_df <- data_show_val_trend() %>%
            filter(categogies == "Achievment")
          
          years <- estim_df$year
          estimations <- estim_df$value
          
          # Ajustement ARIMA sur la série Achievment
          ts_estim <- ts(estimations, start = min(years), frequency = 1)
          fit_arima <- auto.arima(ts_estim)
          
          # Projection sur nb_proj années
          nb_proj <- length(unique(data_show_val_trend()$year)) - length(unique(estim_df$year))
          forecast_arima <- forecast(fit_arima, h = nb_proj)
          
          projection <- as.numeric(forecast_arima$mean)
          proj_years <- seq(max(years) + 1, by = 1, length.out = nb_proj)
          
          # IC de la projection
          proj_low <- as.numeric(forecast_arima$lower[,2])  # IC95% borne basse
          proj_high <- as.numeric(forecast_arima$upper[,2]) # IC95% borne haute
          
          # Équation ARIMA
          model_equation <- paste0("ARIMA(", paste(fit_arima$arma[c(1,6,2)], collapse = ","), ")")
          
          # Construction du graphique
          highchart() %>%
            hc_title(text = paste(input$index_ind_dshb," ",
                                  min(years)," - ",
                                  max(years) + nb_proj," - ",
                                  input$index_country_dshb)) %>%
            hc_xAxis(categories = c(years, proj_years),
                     title = list(text = "Year"),
                     plotLines = list(list(
                       value = length(c(years, proj_years)) - 1,
                       color = "red",
                       width = 2,
                       dashStyle = "Dash",
                       label = list(text = paste("Target ", max(c(years, proj_years))),
                                    style = list(fontSize = "14px", color = "red"))
                     ))) %>%
            hc_yAxis(title = list(text = "Values"),
                     labels = list(format = "{value}")) %>%
            hc_exporting(enabled = TRUE) %>%
            hc_tooltip(crosshairs = TRUE, backgroundColor = "#FCFFC5",
                       shared = TRUE, borderWidth = 2,
                       pointFormat = "Valeur: <b>{point.y}</b><br>IC95%: <b>{point.low}–{point.high}</b>") %>%
            
            # Courbe Achievment avec valeurs
            hc_add_series(
              name = paste("Achievment (", min(years), "-", max(years), ")"),
              data = c(estimations, rep(NA, nb_proj)),
              type = "line",
              color = "#1f77b4",
              lineWidth = 4,
              dataLabels = list(enabled = TRUE, format = "{y}", style = list(fontSize = "12px"))
            ) %>%
            
            # Courbe Projection ARIMA avec valeurs
            hc_add_series(
              name = paste("Projection ARIMA (", min(proj_years), "-", max(proj_years), ")"),
              data = c(rep(NA, length(years)), projection),
              type = "line",
              color = "#ff7f0e",
              lineWidth = 4,
              dataLabels = list(enabled = TRUE, format = "{y}", style = list(fontSize = "12px"))
            ) %>%
            
            # IC Projection ARIMA
            hc_add_series(
              name = "IC Projection ARIMA",
              data = c(rep(list(list(NA, NA)), length(years)),
                       purrr::map2(proj_low, proj_high, ~list(.x, .y))),
              type = "arearange",
              linkedTo = ":previous",
              color = "#ff7f0e",
              fillOpacity = 0.2,
              lineWidth = 0
            ) %>%
            
            # Annotation flottante avec équation ARIMA
            hc_annotations(list(
              labels = list(
                list(
                  point = list(x = length(c(years, proj_years)) - 2,
                               y = max(c(estimations, proj_high), na.rm = TRUE)),
                  text = paste("Modèle: ", model_equation),
                  backgroundColor = "rgba(255,255,255,0.7)",
                  borderColor = "black",
                  borderRadius = 5,
                  style = list(fontSize = "13px")
                )
              )
            )) %>%
            
            hc_credits(enabled = TRUE,
                       text = "Data Source: WHO/AFRO/DPC/TVD Programme",
                       href = unique(show_link_indicator()$indicator_source),
                       style = list(fontSize = "11px"))
          
      
      }, error = function(e) {
        # Gestion des erreurs globales
        showNotification(paste("Error during chart generation :", e$message),
                         type = "error")
        return(NULL)  # évite le blocage de l’application
      })
    })
    
    

    
    output$forecast_chart_arima <- renderHighchart({
      req(tracker_data())
      tryCatch({
      
            # Données observées
            data_estim <- tvd2_df03() %>%
              mutate(year_api = as.numeric(year_api)) %>%
              filter(!is.na(year_api) & year_api != 2030) %>%
              select(year_api, numeric_value)
            
            
            forecast_df <- fct_show_val_month_arima(a=tvd2_df03(), b=input$index_ind_dshb)
            
            highchart() %>%
              hc_title(text = "Prévisions mensuelles ARIMA avec données observées") %>%
              hc_xAxis(type = "datetime") %>%
              
              # Série observée
              hc_add_series(
                name = "Observé",
                data = list_parse2(
                  data.frame(
                    x = datetime_to_timestamp(as.Date(paste0(data_estim$year_api, "-12-01"))),
                    y = data_estim$numeric_value
                  )
                ),
                type = "line",
                color = "blue"
              ) %>%
              
              # Série prévision
              hc_add_series(
                name = "Prévision",
                data = list_parse2(
                  data.frame(
                    x = datetime_to_timestamp(forecast_df$date),
                    y = forecast_df$forecast
                  )
                ),
                type = "line",
                color = "darkgreen"
              ) %>%
              # Intervalle de confiance 80% (orange)
              hc_add_series(
                name = "Intervalle 80%",
                data = list_parse2(
                  data.frame(
                    x = datetime_to_timestamp(forecast_df$date),
                    low = forecast_df$lower80,
                    high = forecast_df$upper80
                  )
                ),
                type = "arearange",
                color = hex_to_rgba("orange", 0.3),
                linkedTo = ":previous"
              ) %>%
              
              
              # Intervalle de confiance 95% en zone ombrée
              hc_add_series(
                name = "Intervalle 95%",
                data = list_parse2(
                  data.frame(
                    x = datetime_to_timestamp(forecast_df$date),
                    low = forecast_df$lower95,
                    high = forecast_df$upper95
                  )
                ),
                type = "arearange",
                color = hex_to_rgba("pink", 0.5), # rouge transparent
                linkedTo = ":previous"
              ) %>%
              
              hc_tooltip(shared = TRUE, crosshairs = TRUE)
            
            }, error = function(e) {
              # Gestion des erreurs globales
              showNotification(paste("Error during chart generation :", e$message),
                               type = "error")
              return(NULL)  # évite le blocage de l’application
      })
    })
    
    
    output$gt_ranking_indicator <-render_gt({
      req(tracker_data())
      fct_class_dfm_stat(a=tracker_data())
    })
    
    
    output$dt_ranking_indicator <- renderDT({
      fct_class_dfm_stat_exp(a=tracker_data())

    })
   
    
    
    
   
   #INICATOR PROGRESS---------------------------------------------  
  
  #007.1 FILTER FOR DISEASE, GROUP INDICATOR, DIMENSION------------------------------------------
  
  
  
  observeEvent(
    input$index_component_v1,
    updateSelectInput(session,"disease_ui", "Disease",
                      choices = tvd_indicator$sub_component[tvd_indicator$component%in%input$index_component_v1])
  )
   
    observeEvent(input$disease_ui, {
      # Filter countries based on disease selection
      countries <- unique(na.omit(tvd_dts$country[tvd_dts$sub_component %in% input$disease_ui]))
      
      # Build grouped choices: Countries vs Regions
      choices <- list(
        "Countries" = setNames(countries, countries),
        "WHO African Region"   = c("WHO African Region" = "WHO African Region")
      )
      
      # Update with server-side selectize
      updateSelectizeInput(
        session,
        inputId = "index_country_prog",
        choices = choices,
        selected = "WHO African Region",  # valeur par défaut forcée
        server = TRUE   # key: enables server-side loading
      )
    })
    
  
 
  ### ANALYSE: Provide the results for each indicator ---------------------------------
  
  
  
 # shinyjs::hide('hide_period')
  #006.4.4 FILTER THE DATASET BY ONE INDICATOR AND BY GEOGRAPHIC LEVEL---------------------------------------


  
  #006.4.4.7 MAP COLORS-----------------------------
  
  map_cols_perf_tvd <- reactive({
    fct_map_col_perf(a=input$epi_ui) # Import for other file.R including into the project directory
  })
  
  
  ###007 ANALYSE: DISPLAY THIS PERFORMANCE OF INDICATEURS RESULTS===================================
  
  
 
  
  
   #007.1.1 Dynamic filtering of diseases according to their components---------
 # output$disease_ui <- renderUI({
 #   req(input$index_component_v1)
 #   diseases <- unique(tvd_indicator %>% filter(component%in%input$index_component_v1) %>% pull(sub_component))
 #   selectInput("disease_ui", "Choose disease :", choices = diseases)
 # })
  
 # observeEvent(
#    input$index_component_v1,
#    updateSelectInput(session,"disease_ui", "Disease",
#                      choices = tvd_indicator$component[tvd_indicator$component%in%input$index_component_v1])
#  )
    #007.1.2 Dynamic filtering of indicator group according to their diseases---------------------
  observeEvent(
    input$disease_ui,
    updateSelectInput(session,"epi_ui", "Indicator option",
                      choices = tvd_indicator$category_indicator[tvd_indicator$sub_component%in%input$disease_ui])
  )
  
 # observeEvent(
#    input$disease_ui,
#    updateSelectInput(session,"index_ind_dshb", "indicator",
#                      choices = tvd_indicator$indicator[tvd_indicator$sub_component%in%input$index_subcomponent_dshb])
#  )
 
    #007.1.3 Dynamic filtering of dimension by indicator group according to their diseases---------------
 # observeEvent(
 #   input$disease_ui,
 #   updateSelectInput(session,"dimension_ui", "Dimension",
 #                     choices = lbl_gpe_reports$sub_grps[lbl_gpe_reports$sub_component%in%input$disease_ui])
 # )
  
 
  
  #007.2 FILTER DATASET BY DISEASE ------------------------------
  
    ##007.2.1 Filter Dataset by country, disease and date covert for reporting--------------------
    
    # Déclenche automatiquement le bouton au démarrage
    observe({
      shinyjs::click("apply_disease")
    })
    
    
    
    tvd_disease_r1 <- eventReactive(input$apply_disease, {
      showNotification("✅ Apply filter for indicator and country selected ", type = "message")
      fct_data_geo_disease(a=input$index_country_prog, b=input$disease_ui, d=input$date_timingInput)
      
    })
    

    ##007.2.2 Filter Dataset by first year of reporting--------------------
    tvd_first_r1<-reactive({
      req(tvd_disease_r1())
      # function from source("modules/filter_dataset.R")
      fct_first_last_value(a=tvd_disease_r1(),c=input$index_country_prog,#c=input$dimension_ui, #b=input$epi_ui,
                           d=min)
      #c=input$dimension_ui,
    })
  
    ##007.2.3 Filter Dataset by last year of reporting--------------------
    tvd_last_r1<-reactive({
      req(tvd_disease_r1())
      # function from source("modules/filter_dataset.R")
      fct_first_last_value(a=tvd_disease_r1(),c=input$index_country_prog,#c=input$dimension_ui, #b=input$epi_ui,# c=input$dimension_ui,
                           d=max)
    })
    
    ##007.2.4 Merge first and last data according disease--------------------
    tvd_first_Last<-reactive({
      req(tvd_first_r1())
      fct_merge_first_Last(a=tvd_first_r1(), b=tvd_last_r1(),c=input$index_country_prog) # function from source("modules/filter_dataset.R")
    })
  
    ##007.2.5 Count how many indicators show good progress----------------------
    tvd_nb_perf<-reactive({
      req(tvd_first_Last())
        fct_nb_indicator_perf(a=tvd_first_Last()) # function from source("modules/filter_dataset.R")
      })
    
    ##007.2.6 Fetch the value of the Vbox field----------------------
    tvd_vbox_value<-reactive({
      fct_vbox_data(a=tvd_nb_perf()) # function from source("modules/filter_dataset.R")
    })
  
   ##007.2.7 Display the progress indicators for each selected disease
  
    
    output$fig_tvd <- renderHighchart({
      req(tvd_disease_r1())
      
      tryCatch({
        # Vérification des entrées nécessaires
        req(data_show_val_trend())
        req(input$index_ind_dshb)
        req(input$index_country_dshb)
        req(show_link_indicator())
        
        df <- data_show_val_trend()
        
        # Vérification que le dataframe contient bien la variable attendue
        validate(
          need(!is.null(df$year_api), "The variable year_api is missing from the data."),
          need(nrow(df) > 0, "No data available for this indicator.")
        )
        
        # Graphique principal
        hchart(df, "column", 
               hcaes(group_show, value, group = categogies),
               dataLabels = list(enabled = TRUE, format='{point.value:.1f}')) %>% 
          hc_colors(c("#2166AC","#999999")) %>%
          hc_xAxis(title = list(text = "")) %>% 
          hc_yAxis(title = list(text = "")) %>% 
          hc_exporting(enabled = TRUE) %>%
          hc_tooltip(crosshairs = TRUE, backgroundColor = "#FCFFC5",
                     shared = TRUE, borderWidth = 2) %>%
          hc_title(text = paste("Number of", input$index_ind_dshb, " ",
                                min(df$year_api), " and ",
                                max(df$year_api), "-", input$index_country_dshb),
                   align = "center") %>%
          hc_subtitle(text = "", align = "center") %>%
          hc_add_theme(hc_theme_smpl()) %>% 
          hc_credits(enabled = TRUE, 
                     text = "Data Source: WHO/AFRO/DPC/TVD Programme",
                     href = unique(show_link_indicator()$indicator_source),
                     style = list(fontSize = "10px"))
        
      }, error = function(e) {
        # Gestion des erreurs globales
        showNotification(
          paste("Data unavailable. Please check your settings or your data:", e$message),
          type = "error"
        )
        
        # Graphique par défaut en cas d’erreur
        highchart() %>%
          hc_title(text = "User – Data unavailable") %>%
          hc_subtitle(text = "Please check your settings or your data") %>%
          hc_xAxis(categories = NULL) %>%
          hc_yAxis(title = list(text = "N/A")) %>%
          hc_add_series(name = "No data available", data = list())
      })
    })
    
 #   output$progress_flex_disease <- renderUI({
#      fct_progress_view(a=tvd_first_Last(),
 #                       b=paste("Indicator Results for" ,input$disease_ui," and Value Differences Between Current Estimates and Baseline "," in the period from ",min(tvd_first_r1()$year_api)," to", max(tvd_last_r1()$year_api)," - ",input$index_country_prog), 
 #                       c="Note Green indicates positive progress toward targets compared with baseline values, while brown indicates negative progress toward targets compared with baseline values.")%>%
 #       htmltools_value()
 #   })
    output$progress_flex_disease <- renderUI({
      req(tvd_disease_r1())
      tryCatch({
        # Vérification des entrées nécessaires
        req(tvd_first_Last())
       
        
        # Vérification que les dataframes contiennent bien la variable attendue
        
        
        # Appel de la fonction principale
        fct_progress_view(
          a = tvd_first_Last(),
          b = paste("Indicator Results for", input$disease_ui,
                    " and Value Differences Between Current Estimates and Baseline ",
                    " in the period from ", min(tvd_first_r1()$year_api),
                    " to ", max(tvd_last_r1()$year_api),
                    " - ", input$index_country_prog),
          c = "Note Green indicates positive progress toward targets compared with baseline values, while brown indicates negative progress toward targets compared with baseline values."
        ) %>%
          htmltools_value()
        
      }, error = function(e) {
        # Gestion des erreurs globales
        showNotification(
          paste("Review the filter settings. :", e$message),
          type = "error"
        )
        
        # UI par défaut en cas d’erreur
        htmltools::div(
          style = "color:red; font-weight:bold; text-align:center;",
          "Data unavailable. Please check your settings or your data.."
        )
      })
    })
    
    
    # SERVER (UI.002.2) Display EXPIRY OF FUNDS.DOWNLOAD FELEXITABLE IN WORD DOCUMENT -------------------------------
    output$download_flextable_perf_indic<- downloadHandler(
      
      filename = function() {
        paste("Report_",input$index_country_prog,"_",input$disease_ui,"_",Sys.Date(), ".docx", sep = "")
      },
      content = function(file) {
        
        save_as_docx("Monitoring Report" = fct_progress_view(a=tvd_first_Last(),
                                                                                b=paste("Indicator Results for" ,input$disease_ui," and Value Differences Between Current Estimates and Baseline "," in the period from ",min(tvd_first_r1()$year_api)," to", max(tvd_last_r1()$year_api)," - ",input$index_country_prog), 
                                                                                c="Note Green indicates positive progress toward targets compared with baseline values, while brown indicates negative progress toward targets compared with baseline values."), path =file,pr_section = sect_properties,  align = "left")
        
      }
    )
    
    
    
    #007.2.8 VALUE INBOX FOR PREVALENCE ---------------------------
    output$vbx_prevalence <- renderValueBox({
      req(tvd_disease_r1())
      fct_vbox_view(a=tvd_vbox_value()$prevalence_percent, b="Strong Progress on Prevalence Indicator", c="light-blue", d=input$disease_ui)
    })
    
    
    #007.2.9 VALUE INBOX FOR INCIDENCE ---------------------------
    output$vbx_incidence <- renderValueBox({
      req(tvd_disease_r1())
      fct_vbox_view(a=tvd_vbox_value()$incidence_percent, b="Strong Progress on Incidence Indicator", c="yellow", d=input$disease_ui)
    })
    
    #007.2.10 VALUE INBOX FOR DEATH ---------------------------
    output$vbx_death <- renderValueBox({
      req(tvd_disease_r1())
      fct_vbox_view(a=tvd_vbox_value()$death_percent, b="Strong Progress on indicators of Mortality", c="red", d=input$disease_ui)
    })
    
    #007.2.11 VALUE INBOX FOR STRATEGY ---------------------------
    output$vbx_strategy <- renderValueBox({
      fct_vbox_view(a=tvd_vbox_value()$strategy_percent, b="Strong Progress on indicator of Health services", c="green", d=input$disease_ui)
    })
    #death_percent,incidence_percent,prevalence_percent,strategy_percent
    
    
    
    
    
    
    
    
    #006.4.3 VIEW GEOGRAPHIC LEVEL AMONG THE SELECTED FROM INDICATOR PROGRESS---------------------------------
    output$title_indictor_progress <- renderText({
      req(tvd_disease_r1())
      paste("Profile for", input$index_country_prog,"[",input$index_component_v1,"]",":",input$disease_ui)
    })
    
    output$subtitle_indictor_progress <- renderText({
      req(tvd_disease_r1())
      paste("Analytical review of the period ",min(tvd_first_r1()$year_api)," - ", max(tvd_last_r1()$year_api))
    })
    
    data_perf_indi_flex<-reactive({
      # function from source("modules/filter_dataset.R")
      fct_merge_first_Last_dt(a=tvd_disease_r1(),b=input$epi_ui)
    })
    
   

    data_perf_indi_tvd<-reactive({
      # function from source("modules/filter_dataset.R")
      fct_merge_first_Last_gph(a=data_perf_indi_flex())
    })
    
   
    
    
    ##1010 GRAPH BY COUNTRY F THIS INDICATOR PROGRESS --------------------------------------    
    
  #  output$plot_perf_tvd_indi_country<- renderHighchart({
      
    #     req(validate_password_basic()) # show only if authentication is true
    #     if(!is.null(base_user_filter_name()$permissions) &&  base_user_filter_name()$permissions=="admin"){ # download only if permission is admin account

    #         hchart(data_perf_indi_tvd() ,"column", hcaes(country, value, group = group_value),dataLabels = list(enabled = TRUE, format='{point.performance:.1f}')) %>% 
    #           hc_colors(colors_pal)%>%
    #           hc_xAxis(title = list(text = "")) %>% 
    #           hc_yAxis(title = list(text = ""))%>% 
    #           hc_exporting(enabled = TRUE)%>%
    #          hc_tooltip(crosshairs = TRUE, backgroundColor = "#FCFFC5",
    #                     shared = TRUE, borderWidth = 2) %>%
    #         hc_title(text=paste("Number of",input$disease_ui," ",input$epi_ui, "indicators that recorded a reduction in frequency between",min(tvd_first_r1()$year_api)," and ", max(tvd_last_r1()$year_api),"-",input$index_country_prog),
    #                  align="center") %>%
    #         hc_subtitle(text="",align="center") %>%
    #          hc_add_theme(hc_theme_smpl())%>% 
    #          hc_credits(enabled = TRUE, 
    #                    text = "Data Source: WHO/AFRO/DPC/TVD Programme",
    #                    style = list(fontSize = "10px")) 

    #    }
    #  })
    
    
    output$plot_perf_tvd_indi_country <- renderHighchart({
      req(tvd_disease_r1())
      tryCatch({
        # Vérification de l’authentification
        req(validate_password_basic())
        
        # Vérification des permissions
        if (!is.null(base_user_filter_name()$permissions) && 
            base_user_filter_name()$permissions == "admin") {
          
          # Vérification des données
          req(data_perf_indi_tvd())
         
          
          df <- data_perf_indi_tvd()
          
          
          
          # Graphique principal
          hchart(df, "column", 
                 hcaes(country, value, group = group_value),
                 dataLabels = list(enabled = TRUE, format='{point.performance:.1f}')) %>% 
            hc_colors(colors_pal) %>%
            hc_xAxis(title = list(text = "")) %>% 
            hc_yAxis(title = list(text = "")) %>% 
            hc_exporting(enabled = TRUE) %>%
            hc_tooltip(crosshairs = TRUE, backgroundColor = "#FCFFC5",
                       shared = TRUE, borderWidth = 2) %>%
            hc_title(text = paste("Number of", input$disease_ui, " ", input$epi_ui,
                                  " indicators that recorded a reduction in frequency between ",
                                  min(tvd_first_r1()$year_api), " and ",
                                  max(tvd_last_r1()$year_api), " - ", input$index_country_prog),
                     align = "center") %>%
            hc_subtitle(text = "", align = "center") %>%
            hc_add_theme(hc_theme_smpl()) %>% 
            hc_credits(enabled = TRUE, 
                       text = "Data Source: WHO/AFRO/DPC/TVD Programme",
                       style = list(fontSize = "10px"))
        }
        
      }, error = function(e) {
        # Gestion des erreurs globales
        showNotification(
          paste("Error during graph generation :", e$message),
          type = "error"
        )
        
        # Graphique par défaut en cas d’erreur
        highchart() %>%
          hc_title(text = "Orientation") %>%
          hc_subtitle(text = "Please select your filter settings") %>%
          hc_xAxis(categories = NULL) %>%
          hc_yAxis(title = list(text = "N/A")) %>%
          hc_add_series(name = "No data", data = list())
      })
    })
    
    
   
  
      
      # Fonction qui génère la carte ggplot
      perf_map_plot_fun <- reactive({
        req(tvd_disease_r1())
        req(validate_password_basic())
        
        if (!is.null(base_user_filter_name()$permissions) &&
            base_user_filter_name()$permissions == "admin") {
          
          # Préparation des données
          result01_map_df <- data_perf_indi_tvd() %>%
            left_join(flag_country, by = c("iso" = "iso")) %>%
            select(flag, value) %>%
            mutate(across(where(is.numeric), ~replace_na(., 0))) %>%
            ungroup()
          
          spdf_africa2a$hc_key <- as.character(spdf_africa2a$brk_a3)
          result01_map_df$hc_key <- as.character(result01_map_df$flag)
          
          spdf_africa_perf <- spdf_africa2a %>%
            left_join(result01_map_df, by = "hc_key")
          
          spdf_africa_perf <- spdf_africa_perf %>%
            mutate(status_class = case_when(
              value == 0 ~ "Zero advancement",
              value < 30 ~ "Weak progress (<30%)",
              value < 70 ~ "Medium progress (30-70%)",
              value <= 100 ~ "Strong progress (70-100%)",
              TRUE ~ "Non disponible"
            ))
          
          # Forcer status_class comme facteur avec les bons niveaux
          spdf_africa_perf$status_class <- factor(
            spdf_africa_perf$status_class,
            levels = names(fct_map_status_colors())
          )
          
          # Palette de 5 couleurs (par ex. "Set2")
          status_colors <- brewer.pal(5, "Set2")
          
          # Associer les couleurs aux catégories
          names(status_colors) <- c(
            "Zero advancement",
            "Weak progress (<30%)",
            "Medium progress (30-70%)",
            "Strong progress (70-100%)",
            "Non disponible"
          )
          
          ggplot(spdf_africa_perf) +
            geom_sf(aes(fill = status_class), color = "black", size = 0.3) +
            scale_fill_manual(values = status_colors, drop = FALSE, na.value = "lightgrey") +
            labs(
              title = paste(
                "Nombre de", input$disease_ui, input$epi_ui,
                "indicateurs ayant enregistré une réduction de fréquence entre",
                min(tvd_first_r1()$year_api), "et", max(tvd_last_r1()$year_api),
                "-", input$index_country_prog
              ),
              fill = "Statut"
            ) +
            theme_minimal() +
            theme(
              plot.title = element_text(hjust = 0.5, size = 14),
              legend.position = "bottom",
              legend.title = element_text(size = 12, face = "bold"),
              legend.text = element_text(size = 10)
            )
          
        }
      })
      
      # Affichage de la carte
      output$perf_map_plot <- renderPlot({
        perf_map_plot_fun()
      })
      
      # Téléchargement de la carte
      output$download_map <- downloadHandler(
        filename = function() {
          paste0("carte_perf_", Sys.Date(), ".png")
        },
        content = function(file) {
          ggsave(file, plot = perf_map_plot_fun(), width = 10, height = 7)
        }
      )
    
    
    
    
    
    
    
    #)
    ##10;9 MAP FOR Indicator value BY COUNTRY-------------------------------------
    output$perf_map <- renderHighchart({
      req(tvd_disease_r1())
      req(validate_password_basic()) # affichage seulement si authentification OK
      
      # Vérifie les permissions
      if (!is.null(base_user_filter_name()$permissions) && base_user_filter_name()$permissions == "admin") {
        
        # Préparation des données
        result01_map_df <- data_perf_indi_tvd() %>%
          left_join(flag_country, by = c("iso" = "iso")) %>%
          select(flag, value) %>%
          mutate(across(where(is.numeric), ~replace_na(., 0))) %>%
          ungroup()
        
        # Création de la carte
        map1_result01 <- hcmap(
          map = "custom/africa",
          data = result01_map_df,
          value = "value",
          joinBy = c("hc-key", "flag"),
          name = "name",
          download_map_data = FALSE,
          animation = TRUE,
          dataLabels = list(enabled = TRUE, format = ""),
          borderColor = "black",
          borderWidth = 0.3,
          tooltip = list(valueDecimals = 2, valuePrefix = "", valueSuffix = "")
        ) %>%
          hc_colorAxis(
            dataClassColor = "value",
            dataClasses = map_cols_perf_tvd()
          ) %>%
          hc_title(
            text = paste(
              "Number of", input$disease_ui, input$epi_ui,
              "indicators that recorded a reduction in frequency between",
              min(tvd_first_r1()$year_api), "and", max(tvd_last_r1()$year_api),
              "-", input$index_country_prog
            ),
            align = "center"
          ) %>%
          hc_mapNavigation(enabled = TRUE, enableButtons = TRUE) %>%
          hc_exporting(enabled = TRUE) %>%
          hc_legend(
            layout = "vertical", align = "left",
            floating = TRUE, valueDecimals = 0, valueSuffix = ""
          ) %>%
          hc_credits(
            enabled = TRUE,
            text = "Data Source: WHO/AFRO/DPC/TVD Programme;",
            style = list(fontSize = "10px")
          )
        
        map1_result01
      }
    })
    
    #11 LIST OF COUNTRY WOTH GOOD PERFORMANCE-------------------------------------------------------------

    
    output$nb_country_perf <- DT::renderDT({
      req(tvd_disease_r1())
      dset2_perf<-data_perf_indi_flex()%>%
        arrange(status_test,country)%>%
        select(country,category_indicator,indicator, baseline,last_value,p_variation,ecart,group_value)%>% #sub_grps,Dimension,
        ungroup()
      
      datatable(
        dset2_perf[order(dset2_perf$group_value), ],
        extensions = c('RowGroup','Buttons'),
        options = list(rowGroup = list(dataSrc = 8), dom = 'Bfrtip',buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),pageLength = 5),
        selection = 'none'
      )
    }, server = FALSE)
    
    
    ### EXPORT DATASET TO EXCEL ------------------------------------
    output$download_progress <- downloadHandler(
      filename = function() {
        paste(input$filename_progress, "_",input$disease_ui,"_", Sys.Date(), ".xlsx", sep = "")
      },
      content = function(file) {
        
        req(validate_password_basic()) # show only if authentication is true
        if(!is.null(base_user_filter_name()$permissions) &&  base_user_filter_name()$permissions=="admin"){ # download only if permission is admin account
          write_xlsx(tvd_disease_r1(), file)
        #  write_csv(tvd_disease_r1(), file)
        }
      }
    )
    ### DATASET OF DASHBOARD OF ACTIVITY TRACKER----------------------------------------
    
    
    data_activity_trackeraggr<-reactive({
      
     # con <- dbConnect(SQLite(), dbname="books.sqlite")
      #  dbWriteTable(con, "Monitoring_tracker", data.frame(value1 = input$value1, value2 = input$value2, stringsAsFactors = FALSE), append = TRUE)
    #  data <- dbReadTable(conn, "Monitoring_tracker")
   #   dbDisconnect(con)
      
      data_activity_tracker_df<-Monitoring_tracker%>% ## Filter by budget center
        select(Area, Action_point,Trigger_date, Focal_point , Latest_update, Date_of_update,
               Status,Complete_percent)%>%
        group_by(Area, Action_point,Trigger_date, Focal_point , Latest_update, Date_of_update,
                 Status,Complete_percent)%>%
        summarise(count_action = n(), .groups = "drop")%>% # calculate number of rows
        ungroup()%>%
        mutate(duration=ifelse(Status=="Closed",ymd(Date_of_update)-ymd(Trigger_date),today()-ymd(Trigger_date)), ## operation sur les dates
               Area =as.factor(Area),
               Complete_percent=paste0(as.numeric(Complete_percent),"%"))
    })
    
    
    box_activity_trackeraggr<-reactive({
      
      data_activity_tracker_df2<-data_activity_trackeraggr()%>%
        select(Status,count_action)%>%
        as.data.frame()%>%
        pivot_wider(names_from = Status , values_from = count_action, values_fn = sum)%>%
        mutate(Closed =as.numeric(unlist(Closed)),
               Open =as.numeric(unlist(Open)),
               Suspended=as.numeric(unlist(Suspended)),
               total=Closed+Open+Suspended,
               closed_percent=paste0(Closed,"(",round(as.numeric(Closed/total*100), digit=1),"%",")"),
               Suspended_percent=paste0(Suspended,"(",round(as.numeric(Suspended/total*100), digit=1),"%",")"),
               Open_percent=paste0(Open,"(",round(as.numeric(Open/total*100), digit=1),"%",")"))%>%
        select(total,Open_percent,closed_percent,Suspended_percent)
      
      data_activity_tracker_df2
    })
    
    
    
    
    ## SEVER DYSPLAY TABLE INTO MONITORING PROGRESS DASHBOARD -----------------------
    
    
    output$activity_tracker_dashbord <- DT::renderDT({
      
      if(req(validate_password_basic()) && !is.null(base_user_filter_name()$permissions) &&  base_user_filter_name()$permissions=="admin"||base_user_filter_name()$permissions=="superAdmin"){ # download only if permission is admin account
        datatable(data_activity_trackeraggr()%>%
                    select(Area, Action_point,Trigger_date, Focal_point , Latest_update, Date_of_update,
                           Status,Complete_percent,duration),
                  colnames = c('Area', 'Action point', 'Trigger date', 'Assignee', 'Latest Update', 'Date of Update','Status','complete (%)','Duration since Initiated (day)'), 
                  rownames = FALSE,
                  extensions = c('Select', 'Buttons'),
                  options = list(
                    select =list(style = 'os', items = 'row'),
                    dom = 'Bfrtp',
                    buttons = c('csv', 'excel', 'pdf','selectAll', 'selectNone', 'selectRows', 'selectColumns', 'selectCells'),
                    style = "bootstrap",
                    lengthMenu = c(seq(7, 150, 7)),
                    initComplete = JS(
                      "function(settings, json) {",
                      "$(this.api().table().header()).css({'background-color': '#80dfff', 'color': 'black'});",
                      "}")
                  ),
                  caption = htmltools::tags$caption(
                    style = 'caption-side: bottom; text-align: center;',
                    'Title', htmltools::em(paste0("Responsibilities for Action Points and Progress Tracking."),"WHO/AFRO/DPC/TVD-2026")
                  ))%>%
          formatStyle(columns = "Status",
                      color="white",
                      #color =ifelse(data_activity_trackeraggr()$Status=="Closed",'white', 'black'),
                      backgroundColor = styleEqual(
                        #  c("Closed", "Suspended", "Open"), c('purple', "fuchsia", 'yellow')))%>%
                        c("Closed", "Suspended", "Open"), c('#1CAF70', "#7C7CBC", '#FFAB4B')),
                      fontWeight = 'bold')%>%
          #  formatStyle(c("duration"), backgroundColor = styleInterval(brks, clrs),fontWeight = 'bold')%>%
          formatStyle(
            'duration',
            color = styleInterval(c(20, 21), c('white', '#006d2c', 'red')),
            backgroundColor = styleInterval(20, c('gray', '#FFF68F')),
            backgroundPosition = 'center',
            fontWeight = 'bold'
          ) 
      }else{
        data =data_activity_trackeraggr()[1,]%>%select(Area, Action_point,Trigger_date, Focal_point , Latest_update, Date_of_update,
                                                       Status,Complete_percent,duration)
      }
      
      
      #  formatStyle(
      #   columns = "duration",
      #   backgroundColor = styleInterval(10, c('#FFF68F','#E9967A' )))#%>%
      #  formatter("Complete_percent",
      #           style = x ~ style(
      #              font.weight = "bold",
      #              color = ifelse(x=="50%", "forestgreen", ifelse(x=="100%", "red", "black"))
      #            ))
      
    }, server = FALSE)
    
    
    
    
    
    output$vbox_total_action <- renderValueBox({
      if(req(validate_password_basic()) && !is.null(base_user_filter_name()$permissions) &&  base_user_filter_name()$permissions=="admin" ||base_user_filter_name()$permissions=="superAdmin"){
        valueBoxSpark(
          value = box_activity_trackeraggr()$total%>%
            paste0(" Action points"),
          title =  
            paste0(" TOTAL ACTION POINTS"),
          sparkobj = "",
          subtitle = "",
          width = 3,
          color = "light-blue",
          href = NULL)
        
      }else{
        
      }
      
    })
    
    
    
    output$vbox_open_action <- renderValueBox({
      if(req(validate_password_basic()) && !is.null(base_user_filter_name()$permissions) &&  base_user_filter_name()$permissions=="admin"||base_user_filter_name()$permissions=="superAdmin"){
        valueBoxSpark(
          value = box_activity_trackeraggr()$Open_percent%>%
            paste0(" Open"),
          title =  
            paste0(" TOTAL ACTION POINTS OPEN"),
          sparkobj = "",
          subtitle = "",
          width = 3,
          color = "yellow",
          href = NULL)
        
      }else{
      }
    })
    
    
    
    output$vbox_closed_action <- renderValueBox({
      if(req(validate_password_basic()) && !is.null(base_user_filter_name()$permissions) &&  base_user_filter_name()$permissions=="admin"||base_user_filter_name()$permissions=="superAdmin"){
        valueBoxSpark(
          value = box_activity_trackeraggr()$closed_percent%>%
            paste0(" Closed"),
          title =  
            paste0(" TOTAL ACTION POINTS CLOSED"),
          sparkobj = "",
          subtitle = "",
          width = 3,
          color = "olive",
          href = NULL)
        
      }else{
      }
      
    })
    
    
    output$vbox_Suspended_action <- renderValueBox({
      if(req(validate_password_basic()) && !is.null(base_user_filter_name()$permissions) &&  base_user_filter_name()$permissions=="admin"||base_user_filter_name()$permissions=="superAdmin"){
        valueBoxSpark(
          value = box_activity_trackeraggr()$Suspended_percent%>%
            paste0(" Suspended"),
          title =  
            paste0(" TOTAL ACTION POINTS SUSPENDED"),
          sparkobj = "",
          subtitle = "",
          width = 3,
          color = "purple",
          href = NULL)
        
      }else{
        
      }
      
      
    })
    
    
    
    #SERVER_13 PRINT  REPORT AT THE WORD FORMAT FOR ACTIVITY TRACKER--------------------------------------------
    
    generate_report_word_tracker <- reactive({

      bborder_style = officer::fp_border(color="gray", width=1)
      report_summary_stracker<-data_activity_trackeraggr()%>%
        ungroup()%>%
        select(Area,Action_point,Trigger_date,Latest_update,Date_of_update,Status,Complete_percent,duration)%>% ## Non include group
        flextable::flextable()%>% 
        autofit()%>% 
        add_header_row(
          top = TRUE,                # Nouvel en-tête placé au-dessus de la rangée d'en-tête existante
          values = c("Area",     # Valeurs d'en-tête pour chaque colonne ci-dessous
                     "Action point",    # Celui ci servira d'en-tête de niveau supérieur pour cette colonne et les deux suivantes
                     "Trigger date",
                     "Update",
                     "",
                     "Progress",
                     "",
                     ""))%>% 
        set_header_labels(         # Renommer les colonnes de la ligne d'en-tête originale
          Area  = "", 
          Action_point = "",                  
          Trigger_date = "",
          Latest_update="Latest",
          Date_of_update="Date",
          Status = "Status",
          Complete_percent  = "complete(%)",
          duration  = "Duration since Initiated (day)")%>% 
        
        merge_at(i = 1, j = 4:5, part = "header") %>% # Fusionner horizontalement les colonnes 3 à 5 dans une nouvelle ligne d'en-tête
        merge_at(i = 1, j = 6:8, part = "header")%>%      # Fusionnez horizontalement les colonnes 6 à 8 dans une nouvelle ligne d'en-tête.
        
        # Enlever toutes les bordures existantes
        border_remove() %>%  
        
        # ajouter des lignes horizontales via un thème prédéterminé
        theme_booktabs() %>% 
        
        # ajouter des lignes verticales pour séparer les sections "Recovered" et "Died"
        vline(part = "all", j = 2, border = border_style) %>%   # a la colonne 2 
        vline(part = "all", j = 3, border = border_style) %>%       # a la colonne 4
        vline(part = "all", j = 5, border = border_style) %>% 
        # vline(part = "all", j = 6, border = border_style) %>% 
        # vline(part = "all", j = 8, border = border_style) %>% 
        hline(border = border_style) %>%       # a la colonne 10
        # vline(part = "all", j = 11, border = border_style) %>%       # a la colonne 11
        
        flextable::align(align = "center", j = c(5:8), part = "all") %>%  
        fontsize(i = 1, size = 12, part = "header") %>%   # ajuster la taille de la police de l'en-tête
        bold(i = 1, bold = TRUE, part = "header") %>%     # ajuster le caractère en gras de l'en-tête
        
        merge_at(i = 1:2, j = 1, part = "header")%>% 
        merge_at(i = 1:2, j = 2, part = "header")%>% 
        merge_at(i = 1:2, j = 3, part = "header")%>% 
        
        
        bg(j = 6, i = ~ Status=="Closed", part = "body", bg = "#1CAF70") %>% 
        bg(j = 6, i = ~ Status=="Open", part = "body", bg = "#FFAB4B")%>% 
        bg(j = 6, i = ~ Status=="Suspended", part = "body", bg = "#7C7CBC")%>% 
        
        bg(j = 8, i = ~ duration >30, part = "body", bg = "#E9967A") %>% 
        bg(j = 8, i = ~ duration<=30, part = "body", bg = "#FFF68F")%>% 
        bg(j = 8, i = ~ duration<=20, part = "body", bg = "gray")%>% 
        
        
        merge_v(j = "Area",  target = c("Area"), part = "body")%>%
        merge_v(j = "Action_point",  target = c("Action_point"), part = "body")%>%
        colformat_num(
          big.mark = " ", decimal.mark = ",",
          na_str = "na") %>% 
        colformat_int(big.mark = " ") %>% 
        colformat_date(fmt_date = "%d/%m/%Y")%>% # format of value in the table
        mk_par(j = "Area", 
               value = as_paragraph(
                 as_chunk(Area, 
                          props = fp_text_default(color = "#C32900", bold = TRUE)))) %>% 
        mk_par(j = "Action_point", 
               value = as_paragraph(
                 as_chunk(Action_point, 
                          props = fp_text_default(color = "#006699", bold = TRUE))))%>%
        hrule(rule = "exact", part = "body") %>% 
        width(width =  3.05)%>%  #regular appearance, all cells will be sized to 1 inches in width and height.
        set_table_properties(layout = "autofit")%>%
        add_footer_lines("Data source: WHO/AFRO/TVD-2026") 

      report_summary_stracker
      
    })
    
    ##SERVER_14 DOWNLOAD SELECTION REPORT DATA TO WORD FILE FOR MONITORING TRACKER -----------------------------------------
    # Download Handler
    
    
    
    output$download_activity_tracker<- downloadHandler(
      
      filename = function() {
        paste("report_",Sys.Date(), ".docx", sep = "")
      },
      content = function(file) {
        req(validate_password_basic()) # show only if authentication is true
        if(!is.null(base_user_filter_name()$permissions) &&  base_user_filter_name()$permissions=="admin"||base_user_filter_name()$permissions=="superAdmin"){ # download only if permission is admin account
          save_as_docx("Summary report on the status of implementation of action points\n for TVD Program" = generate_report_word_tracker(), path =file,pr_section = sect_properties,  align = "left")
          
        }else{
          
        }
      }
    )
    
    ## GET IP ADRESS------------------------------------------
    
    output$ip <- reactive(
      if(!is.null(base_user_filter_name()$permissions) &&  base_user_filter_name()$permissions=="superAdmin"){
        input$getIP
      }else{
        
      }
      
      
    )
    
    ##SERVER_04 FORMULAR FOR Monitoring_tracker---------------------------------------------------------------
   # conn <- dbConnect(SQLite(), dbname="books.sqlite")
    #  dbWriteTable(con, "Monitoring_tracker", data.frame(value1 = input$value1, value2 = input$value2, stringsAsFactors = FALSE), append = TRUE)
     #    Monitoring_tracker <- getMonitoringTracker()
   # dbDisconnect(conn)
    
   
    Monitoring_tracker_dt <-dtedit(input, output,
                                   name = 'Monitoring_tracker',
                                   #  req(validate_password_basic()), # show only if authentication is true
                                   thedata = Monitoring_tracker,
                                   edit.cols = c('Area', 
                                                 'Action_point', 
                                                 'Trigger_date', 
                                                 'Focal_point',
                                                 'Latest_update',
                                                 'Date_of_update',
                                                 'Status',
                                                 'Complete_percent'
                                   ),
                                   
                                   
                                   # edit.cols = c('Name', 'Email', 'Position', 'Organization','Unit','Formed','Dates','Modules','Location','Certificate','User'),
                                   #  edit.label.cols = c('Staff Name', 'E-mail', 'Position Title', 'Budget center','Unit/Team','Participate to the SPM training','Date of training','Module learned','Training location','Certificate Received','User category'),
                                   edit.label.cols = c('Area', 
                                                       'Action point', 
                                                       'Trigger date', 
                                                       'Assignee',
                                                       'Latest update',
                                                       'Date of update',
                                                       'Status',
                                                       '% complete'
                                   ),
                                   #  input.types = c(name_staff='textAreaInput'),
                                   input.choices = list(Focal_point = unique(unlist(bms_teams$Focal_point))#,
                                                        #   Position =factor(levels=category_staff$Position)
                                   ),
                                   input.types = c(Action_point='textAreaInput', Latest_update='textAreaInput'),
                                   #   selectInput =list(type_staff = unique(unlist(category_staff$category_name, use.names = FALSE))),
                                   #input.choices = list(budget_center = unique(unlist(budget_center_staff$budget_center))),
                                   view.cols = names(Monitoring_tracker)[c(1,2,3,4,5,6,7)],
                                   #view.label.cols = c_v_colnames,
                                   # view.label.cols =c('name_staff', 'email_staff', 'type_staff', 'budget_center','participate_training','date_training','module_learned','training_location','certificate_succes'),
                                   callback.update = Monitoring_tracker.update.callback,
                                   callback.insert = Monitoring_tracker.insert.callback,
                                   callback.delete = Monitoring_tracker.delete.callback)
    
    
## DISPLAY FACT SHEET---------------------------------------------------------------

    
    #007.1 FILTER FOR DISEASE, FROM COMPONENT FOR FACT SHEET------------------------------------------
    
    
    
    observeEvent(
      input$index_component_fsheet,
      updateSelectInput(session,"disease_fsheet", "Disease",
                        choices = tvd_indicator$sub_component[tvd_indicator$component%in%input$index_component_fsheet])
    )
    

    observeEvent(input$disease_fsheet, {
      req(input$disease_fsheet)   # Vérifie que la maladie est bien sélectionnée
      
      # Filter countries based on disease selection
      countries <- unique(na.omit(
        tvd_dts$country[tvd_dts$sub_component %in% input$disease_fsheet]
      ))
      
      if (length(countries) == 0) {
        showNotification("⚠️ Aucun pays disponible pour cette maladie", type = "warning")
        return(NULL)
      }
      
      # Build grouped choices: Countries vs Regions
      choices <- list(
        "Countries" = setNames(countries, countries),
        "WHO African Region" = c("WHO African Region" = "WHO African Region")
      )
      # Update with server-side selectize
      updateSelectizeInput(
        session,
        inputId = "id_country_factsheet",
        choices = choices,
        selected = "WHO African Region",# valeur par défaut forcée
        server = TRUE # key: enables server-side loading
      )
    })
    


    
    
    
    
    
    
    


    ##11.2 FILTER THE DATASET FOR REPORT MreportPreviewOWN FOR QUANTITATIVE VALUE---------------------------------------
    # Déclenche automatiquement le bouton au démarrage
    observe({
      shinyjs::click("apply_factSheet")
    })
    
    
    tvd_disease_r1_factsheet <- eventReactive(input$apply_factSheet, {
      showNotification("✅ Apply filter for indicator and country selected ", type = "message")
      fct_data_geo_disease(a=input$id_country_factsheet, b=input$disease_fsheet, d=input$factsheet_imingInput)
      
    })
    
    
   
    ## Title for MreportPreviewown report----------------------------------
    # Fact Sheet: Human African Trypanosomiasis in the WHO African Region – TVD Program
    
    ## Data and Progress on Surveillance and Control
    
    country_name_report_mrkdown <- reactive({
      #paste(input$id_country_factsheet)
      if (length(unique(tvd_disease_r1_factsheet()$country))>1) {
        paste("WHO AFRO Members states")
      }else if (length(unique(tvd_disease_r1_factsheet()$country))==1) {
        paste(unique(tvd_disease_r1_factsheet()$country))
      }
    })
    
    
    title_name_report_mrkdown <- reactive({
      paste("Epidemiology of ",unique(tvd_disease_r1_factsheet()$sub_component),"in the",country_name_report_mrkdown(),"in ",unique(max(tvd_disease_r1_factsheet()$year_api)))
    })
    
  #  subtitle_name_report_mrkdown <- reactive({
 #     paste("Data and Progress on Surveillance and Control")
 #   })
    
    
    
    ##11.3 FILTER THE DATASET FOR COUNTRIES SUBMITTED DATA---------------------------------------
    
    tvd_disease_r2_factsheet <- reactive({
      fct1_data_map_facsheet(a=tvd_disease_r1_factsheet())
      
    })
    
   
    
    ##10.15 FUNCTION TO CREATE MAP AND WORD FORMAT FOR QUALITATIVE VARIABLE IN MreportPreviewOWN COMPONENT SECTION---------------------------------------------------
    
    
    
    
    fct3_data_map_facsheet <- function(indi_fctsh3, a = "dataset") {
      
      req(tvd_disease_r1_factsheet())
      
      # Détection de la langue (par défaut FR si non défini)
      lang <- if (!is.null(input$lang)) input$lang else "fr"
      
      # Fonction utilitaire pour générer un message HTML
      msg_html <- function(title_fr, text_fr, title_en, text_en) {
        if (lang == "en") {
          return(paste0("<html><body><h3 style='color:red;'>", title_en, "</h3><p>", text_en, "</p></body></html>"))
        } else {
          return(paste0("<html><body><h3 style='color:red;'>", title_fr, "</h3><p>", text_fr, "</p></body></html>"))
        }
      }
      
      # Vérifie dataset
      if (is.null(a) || nrow(a) == 0) {
        showNotification(if (lang == "en") "⚠️ Dataset is empty" else "⚠️ Le dataset est vide", type = "error")
        return(tags$iframe(
          srcdoc = msg_html("Carte indisponible", "Le dataset est vide.",
                            "Map unavailable", "Dataset is empty."),
          style = "width:100%; height:600px; border:none;"
        ))
      }
      
      # Vérifie colonnes
      if (!("sov_a3" %in% names(a))) {
        showNotification(if (lang == "en") "⚠️ Column 'sov_a3' missing" else "⚠️ Colonne 'sov_a3' absente", type = "error")
        return(tags$iframe(
          srcdoc = msg_html("Carte indisponible", "Colonne 'sov_a3' manquante.",
                            "Map unavailable", "Column 'sov_a3' missing."),
          style = "width:100%; height:600px; border:none;"
        ))
      }
      if (!("brk_a3" %in% names(spdf_africa2a))) {
        showNotification(if (lang == "en") "⚠️ Column 'brk_a3' missing" else "⚠️ Colonne 'brk_a3' absente", type = "error")
        return(tags$iframe(
          srcdoc = msg_html("Carte indisponible", "Colonne 'brk_a3' manquante dans l'objet spatial.",
                            "Map unavailable", "Column 'brk_a3' missing in spatial object."),
          style = "width:100%; height:600px; border:none;"
        ))
      }
      
      # Harmonise les types
      a$sov_a3 <- as.character(a$sov_a3)
      spdf_africa2a$brk_a3 <- as.character(spdf_africa2a$brk_a3)
      
      # Jointure sécurisée
      spdf_africa_prod_sh_disease <- tryCatch({
        spdf_africa2a %>% left_join(a, by = c("brk_a3" = "sov_a3"))
      }, error = function(e) {
        showNotification(if (lang == "en") paste("⚠️ Error during join:", e$message) else paste("⚠️ Erreur lors de la jointure :", e$message), type = "error")
        return(NULL)
      })
      
      if (is.null(spdf_africa_prod_sh_disease)) {
        return(tags$iframe(
          srcdoc = msg_html("Carte indisponible", "Erreur lors de la jointure.",
                            "Map unavailable", "Error during join."),
          style = "width:100%; height:600px; border:none;"
        ))
      }
      
      # Correction géométries
      spdf_africa_prod_sh_disease <- tryCatch({
        sf::st_make_valid(spdf_africa_prod_sh_disease)
      }, error = function(e) {
        showNotification(if (lang == "en") paste("⚠️ Error fixing geometries:", e$message) else paste("⚠️ Erreur lors de la correction des géométries :", e$message), type = "error")
        return(NULL)
      })
      
      if (is.null(spdf_africa_prod_sh_disease)) {
        return(tags$iframe(
          srcdoc = msg_html("Carte indisponible", "Erreur lors de la correction des géométries.",
                            "Map unavailable", "Error fixing geometries."),
          style = "width:100%; height:600px; border:none;"
        ))
      }
      
      # Création carte
      my_map_africa_word <- tryCatch({
        tm_shape(spdf_africa_prod_sh_disease,
                 crs = "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0") +
          tm_polygons(
            fill = "group_index",
            fill.scale = tm_scale(values = c('#b2e2e2','#fee5d9','snow')),
            fill.legend = tm_legend(title = if (lang == "en") "Status" else "Statut"),
            col = 'black',
            lwd = 0.5
          ) +
          tm_layout(
            main.title = if (lang == "en") 
              "Countries in the WHO African Region Included in the Fact Sheet \n Information based on available data sources" 
            else 
              "Pays de la Région Afrique de l’OMS inclus dans la fiche \n Informations basées sur les sources disponibles",
            main.title.size = 1.0,
            outer.margins = c(0,0,0,0),
            legend.position = c("left","bottom"),
            legend.outside = FALSE,
            main.title.position = "center",
            inner.margins = c(0,0,0,0),
            frame = FALSE
          ) +
          tm_compass(position = c("right","top"), size = 2)
      }, error = function(e) {
        showNotification(if (lang == "en") paste("⚠️ Error creating map:", e$message) else paste("⚠️ Erreur lors de la création de la carte :", e$message), type = "error")
        return(NULL)
      })
      
      if (is.null(my_map_africa_word)) {
        return(tags$iframe(
          srcdoc = msg_html("Carte indisponible", "Erreur lors de la création de la carte.",
                            "Map unavailable", "Error creating map."),
          style = "width:100%; height:600px; border:none;"
        ))
      }
      
      return(my_map_africa_word)
    }
    
    
    
    
    ## Display number of countries wwith data--------------------
    fct3b_group_facsheet <- function(indi_fctsh3b, a = "dataset") {
      req(tvd_disease_r1_factsheet())
      if (is.null(a) || nrow(a) == 0) {
        showNotification("⚠️ Le dataset est vide, impossible de générer le tableau des indicateurs.", type = "error")
        return(NULL)
      }
      
      required_cols <- c("category_indicator", "indicator", "baseline", "last_value", 
                         "p_variation", "ecart", "status_test", "country", "Dimension", "year_api")
      missing_cols <- setdiff(required_cols, names(a))
      if (length(missing_cols) > 0) {
        showNotification(paste("⚠️ Colonnes manquantes :", paste(missing_cols, collapse = ", ")), type = "error")
        return(NULL)
      }
      
      summary_table <- tryCatch({
        a %>%
          select(category_indicator, indicator, baseline, last_value, p_variation, ecart, status_test, country) %>%
          group_by(category_indicator, indicator, baseline, last_value, p_variation, ecart, status_test) %>%
          summarise(
            n_countries = n_distinct(country),
            country = paste(unique(country), collapse = ", "),
            # Gestion sécurisée de year_api
            year_api_min = if (all(is.na(year_api))) NA_integer_ else min(year_api, na.rm = TRUE),
            year_api_max = if (all(is.na(year_api))) NA_integer_ else max(year_api, na.rm = TRUE)
          ) %>%
          ungroup() %>%
          arrange(desc(n_countries)) %>%
          gt(groupname_col = "category_indicator") %>%
          tab_header(
            title = paste(
              "Indicator Results for", unique(a$Dimension),
              "and Value Differences Between Current Estimates and Baseline",
              "in the period from", min(a$year_api, na.rm = TRUE), "to", max(a$year_api, na.rm = TRUE),
              "-", input$id_country_factsheet
            )
          ) %>%
          cols_label(
            indicator = "Indicator",
            baseline = "Baseline",
            last_value = "Latest Value",
            p_variation = "% Variation",
            ecart = "Difference",
            status_test = "Status"
          ) %>%
          fmt_number(columns = c(baseline, last_value, p_variation, ecart), decimals = 2) %>%
          tab_options(table.font.size = "small", heading.align = "center", data_row.padding = px(3)) %>%
          opt_table_outline() %>%
          opt_row_striping()
      }, error = function(e) {
        showNotification(paste("⚠️ Erreur lors de la génération du tableau des indicateurs :", e$message), type = "error")
        return(NULL)
      })
      
      # Ajout des styles conditionnels
      summary_table2 <- summary_table %>%
        tab_style(style = list(cell_fill(
          #color = "red"
          
          fn = scales::col_numeric(
            palette = c("white", "red"),
            domain = NULL
          )
          
          )), locations = cells_body(rows = status_test == 2)) %>%
        tab_style(style = list(cell_fill(
          
          fn = scales::col_numeric(
            palette = c("white", "#b2e2e2"),
            domain = NULL
          )
          
         # color = "#b2e2e2"
          
          
          )
          
          ), locations = cells_body(rows = status_test == 1)) %>%
        tab_style(style = list(cell_fill(
          
          fn = scales::col_numeric(
            palette = c("white", "#fee5d9"),
            domain = NULL
          )
          
          
       #   color = "#fee5d9"
          
          
          )), locations = cells_body(rows = status_test == 0)) %>%
        tab_source_note(
          source_note = "Note : Light blue = progrès positif, brown = progrès négatif par rapport aux valeurs de référence."
        )
      
      return(summary_table2)
    }
    
    
    ##007.2.2 Filter Dataset by first year of reporting--------------------
    tvd_first_r1_factsheet<-reactive({
      req(tvd_disease_r1_factsheet())
      # function from source("modules/filter_dataset.R")
      fct_first_last_value(a=tvd_disease_r1_factsheet(),c=input$id_country_factsheet,#c=input$dimension_ui, #b=input$epi_ui,
                           d=min)
      #c=input$dimension_ui,
    })
    
    ##007.2.3 Filter Dataset by last year of reporting--------------------
    tvd_last_r1_factsheet<-reactive({
      req(tvd_disease_r1_factsheet())
      # function from source("modules/filter_dataset.R")
      fct_first_last_value(a=tvd_disease_r1_factsheet(),c=input$id_country_factsheet,#c=input$dimension_ui, #b=input$epi_ui,# c=input$dimension_ui,
                           d=max)
    })
    
    ##007.2.4 Merge first and last data according disease--------------------
    tvd_first_Last_factsheet<-reactive({
      req(tvd_disease_r1_factsheet())
      fct_merge_first_Last(a=tvd_first_r1_factsheet(), b=tvd_last_r1_factsheet(),c=input$id_country_factsheet) # function from source("modules/filter_dataset.R")
    })
    
    tvd_min_max_factsheet<-reactive({
      req(tvd_disease_r1_factsheet())
      fct_first_last_fctsheet(a=tvd_disease_r1_factsheet()) # function from source("modules/filter_dataset.R")
    })
    
    
    tvd_factsheet_r<-reactive({
        tvd_first_Last_factsheet()%>%
          left_join(tvd_min_max_factsheet(),by=c("indicator"="indicator"))%>%
        select(category_indicator,indicator, baseline, last_value, p_variation, ecart, status_test,country)
      
    })
    
    
    
   
   
    
    
    ## Display number of countries wwith data--------------------
    
    
    fct3b_group_facsheet <- function(indi_fctsh3b, a="dataset"){
      req(tvd_disease_r1_factsheet())
      summary_table <- a %>%
        select(category_indicator, indicator, baseline, last_value, p_variation, ecart, status_test, country) %>%
        group_by(category_indicator, indicator, baseline, last_value, p_variation, ecart, status_test) %>%
        summarise(
          n_countries = n_distinct(country),
          country = paste(unique(country), collapse = ", ")
        ) %>%
        ungroup() %>%
        arrange(desc(n_countries)) %>%
        gt(groupname_col = "category_indicator") %>%   # <-- this groups rows by category_indicator
        tab_header(
          title = paste(
            "Indicator Results for", unique(a$Dimension),
            "and Value Differences Between Current Estimates and Baseline",
            "in the period from", min(a$year_api), "to", max(a$year_api),
            "-", input$id_country_factsheet
          )
        ) %>%
        cols_label(
          indicator = "Indicator",
          baseline = "Baseline",
          last_value = "Latest Value",
          p_variation = "% Variation",
          ecart = "Difference",
          status_test = "Status"
        ) %>%
        fmt_number(
          columns = c(baseline, last_value, p_variation, ecart),
          decimals = 2
        ) %>%
        tab_options(
          table.font.size = "small",
          heading.align = "center",
          data_row.padding = px(3)
        ) %>%
        opt_table_outline() %>%
        opt_row_striping()
      
      
      summary_table2 <- summary_table %>%
        tab_style(
          style = list(cell_fill(color = "red")),
          locations = cells_body(rows = status_test == 2)
        ) %>%
        tab_style(
          style = list(cell_fill(color = "#b2e2e2")),
          locations = cells_body(rows = status_test == 1)
        ) %>%
        tab_style(
          style = list(cell_fill(color = "#fee5d9")),
          locations = cells_body(rows = status_test == 0)
        )%>%
        tab_source_note(
          source_note = "Note : Light blue indicates positive progress toward targets compared with baseline values, while brown indicates negative progress toward targets compared with baseline values."
        )
      
      return(summary_table2)
      
    }
    
    
    
    
    ## DATA FOR COUNTRY ABOUT INDICATOR -------------------------------------------
  #PREVALENCE
    data1_perf_indi_prevalence<-reactive({
      fct_merge_first_Last_dt(a=tvd_disease_r1_factsheet(),b="Prevalence")
    })

    data2_perf_indi_prevalence<-reactive({
      fct_merge_first_Last_gph(a=data1_perf_indi_prevalence())
    })
 
    prevalence_factsheet<-reactive({
      fct_progress_fctsheet(a=tvd_disease_r1_factsheet(), b=input$disease_fsheet, c="Prevalence") 
    })
    
    
    # Preview HTML version inside Shiny-------------------------------------
    output$reportPreview <- renderUI({
      # Render to a temporary HTML file
      tempReport <- tempfile(fileext = ".html")
      
      rmarkdown::render(
        "factSheetTVD.Rmd",
        output_format = rmarkdown::html_document(),  # <-- fully qualified
        output_file = tempReport,
        quiet = TRUE
      )
      
      tags$iframe(
        srcdoc = paste(readLines(tempReport), collapse = "\n"),
        style = "width:100%; height:600px; border:none;"
      )
    })
    
    
    
    
    ### ANALYSE RISK BY DISEASE-------------------------------------------
#001-CASCADE LIST DISEASE-INDICATOR---------------------------
    
    observeEvent(input$disease_risk, {
      
      # Extraire les indicateurs liés à la maladie choisie
      indicators <- data_st_disease_all %>%
        filter(sub_component %in% input$disease_risk, numeric_value>0)%>%
        distinct(indicator_code) %>%
        left_join(tvd_indicator%>%
                    filter(sub_component %in% input$disease_risk)%>%
                    select(indicator_code,indicator), by=c("indicator_code"="indicator_code"))%>%
        distinct(indicator_code, indicator)   # garder code + nom
      
      # Construire une liste nommée : noms visibles, codes comme valeurs
      choices <- setNames(indicators$indicator_code, indicators$indicator)
      
      # Ajouter "Population" comme indicateur supplémentaire
      choices <- c("population" = "population", choices)
      
      
      # Ajouter "population" comme indicateur supplémentaire
    #  choices <- c("population", indicators)
      
      # Mise à jour du checkboxGroupInput
      updateCheckboxGroupInput(
        session,
        inputId = "index_ind_risk",
        label = "📊 Choose Indicators to Include:",
        choices = choices,
        selected = choices   # tous cochés par défaut
      )
    })
    
    #002-ESTIMATE THE RISQK BY DISEASE--------------------------- 
    # Préparation des données
    reactive_ranking <- reactive({
      
      
      data_st_disease_select<-data_st_disease_all%>%
        ungroup()%>%
        filter(indicator_code%in%input$index_ind_risk) %>%#input$disease_risk
        pivot_wider(names_from = indicator_code, values_from = numeric_value) %>%
        mutate(across(where(is.numeric), ~ replace(., is.na(.), 0))) %>%
        mutate(across(where(is.character), ~ replace(., is.na(.), "Missing data"))) %>%
        distinct(iso, .keep_all = TRUE) %>%
        left_join(
          filter_country %>%
            filter(index_country < 48) %>%
            select(iso, country),
          by = "iso"
        ) %>%
        left_join(
          dfm_stat %>%
            ungroup()%>%
            filter(indicator_code%in%input$index_ind_risk) %>%#input$disease_risk
            select(iso, population) %>%
            distinct(),
          by = "iso"
        )%>%select(-c(iso, year_api))%>%
        select(country,sub_component, population,everything())%>%
        select(-c(sub_component))
      
      selected_data <- data_st_disease_select[, input$index_ind_risk, drop = FALSE]
      data_norm <- as.data.frame(scale(selected_data))
      row.names(data_norm) <- data_st_disease_select$country
      
      data_norm$Score <- rowMeans(data_norm)
      
      ranking <- data.frame(
        Country = row.names(data_norm),
        Population = data_st_disease_select$population,
        Score = round(data_norm$Score, 2),
        Rang = rank(-data_norm$Score, ties.method = "min")
      )
      
      ranking <- ranking[order(ranking$Rang), ]
      
      ranking %>%
        dplyr::mutate(
          RiskLevel = case_when(
            Score < 0 ~ "Faible / Low",
            Score >= 0 & Score < 1 ~ "Modéré / Moderate",
            Score >= 1 ~ "Élevé / High"
          ),
          CountryLabel = paste0(Country, " (Rang ", Rang, ")"),
          LabelDetail = paste0("Score: ", round(Score, 2)),
          Population = formatC(Population, format = "d", big.mark = " ", decimal.mark = ".")
        )
    })
    
    # Calcul de l'année max
    max_year_risk <- reactive({
      max_yearS <- data_st_disease_all%>%
        ungroup()%>%
        filter(sub_component %in%input$disease_risk, numeric_value>0)%>%
        select(year_api)%>%filter(year_api==max(year_api, na.rm = TRUE))%>%
        distinct()
      
      max_yearS
    })
    
    #003-RENDER RISK RESULT IN FORMAT gt() to UI--------------------------- 
    
    # Tableau GT
    output$gt_table <- render_gt({
      req(reactive_ranking())
      reactive_ranking() %>%
        select(CountryLabel,Population, Score, Rang, RiskLevel) %>%
        gt() %>%
        data_color(
          columns = c(Score),#vars(Score)
          colors = scales::col_numeric(
            palette = c("#f2f6fa", "#0072bc"),
            domain = NULL
          )
        ) %>%
        data_color(
          columns = c(Rang),#
          colors = scales::col_numeric(
            palette = c("#fcae91", "#4daf4a"),
            domain = NULL
          )
        ) %>%
        tab_header(
          title = md("**Analyse des risques - Scores normalisés et classement des pays**  
                    **Risk Analysis - Normalized Scores and Country Ranking**"),
          subtitle = md("Interprétation / Interpretation :  
                      Les pays sont classés par rang et colorés selon leur niveau de risque.  
                      Countries are ranked and colored according to their risk level.")
        ) %>%
        data_color(
          columns = "RiskLevel",
          colors = c("Faible / Low" = "#fcae91",
                     "Modéré / Moderate" ="#4daf4a",
                     "Élevé / High" = "yellow")
        ) %>%
        tab_source_note(
          source_note = md("Méthodologie / Methodology :  
        Le Score est calculé comme moyenne normalisée des indicateurs  et l'effectif de la Population.  
        The Score is calculated as a normalized average of Value indicators and Population .  
        Les catégories de risque sont définies par seuils (Faible, Modéré, Élevé).  
        Risk categories are defined by thresholds (Low, Moderate, High).")
        )
    })
    
    #004-RENDER RISK RESULT IN FORMAT dt() to UI--------------------------- 
    # Tableau DT principal
    output$dt_table <- renderDT({
      req(reactive_ranking())
      datatable(
        reactive_ranking() %>% select(Country,Population, Score, Rang, RiskLevel),
        options = list(pageLength = 10),
        filter = "top"
      )
    })
    
    #004-RENDER RISK RESULT IN FORMAT dt() FOR EXPORT TO EXCEL FILE --------------------------- 
    # Tableau DT avec export
    output$dt_export <- renderDT({
      req(reactive_ranking())
      datatable(
        reactive_ranking() %>% select(CountryLabel,Population, Score, Rang, RiskLevel),
        extensions = "Buttons",
        options = list(
          dom = "Bfrtip",
          buttons = c("copy", "csv", "excel", "pdf", "print")
        )
      )
    })
    
    

    
    #005-REACTION DATABASE FOR MAP RISK--------------------------- 
    # Préparation des données
    afro_data_risk <- reactive({
      
      ranking_map<-reactive_ranking() %>% 
        select(Country,RiskLevel)%>%
        left_join(
          filter_country %>%
            filter(index_country < 48) %>%
            select(iso, country),
          by =c("Country"="country")
        )%>%select(iso,RiskLevel)
      
      spdf_africa2a %>%
        left_join(
          ranking_map %>% 
            select(iso,RiskLevel),
          by = c("iso_a3" = "iso")
        ) %>%
        sf::st_make_valid()
    })
    
   
    
    
    #006-GENERATE MAP RISK--------------------------- 
    
    output$mymap_risk <- renderLeaflet({
      req(validate_password_basic())
      req(reactive_ranking())
      
      fct_risk_map(a=afro_data_risk(),b=input$disease_risk,c=max_year_risk()[1],k="Standardized scores and country rankings for : " )
      
     
    })
    
    
    #0000-ANALYSIS OF CLUTERS BY DISEASE--------------------------- 
    
    
    #001-CASCADE LIST DISEASE-INDICATOR---------------------------
    
    observeEvent(input$disease_cluster, {
      
      # Extraire les indicateurs liés à la maladie choisie
      indicators <- data_st_disease_all %>%
        filter(sub_component %in% input$disease_cluster, numeric_value>0)%>%
        distinct(indicator_code) %>%
        left_join(tvd_indicator%>%
                    filter(sub_component %in% input$disease_cluster)%>%
                    select(indicator_code,indicator), by=c("indicator_code"="indicator_code"))%>%
        distinct(indicator_code, indicator)   # garder code + nom
      
      # Construire une liste nommée : noms visibles, codes comme valeurs
      choices <- setNames(indicators$indicator_code, indicators$indicator)
      
      # Ajouter "Population" comme indicateur supplémentaire
      choices <- c("population" = "population", choices)
      
      
      # Ajouter "population" comme indicateur supplémentaire
      #  choices <- c("population", indicators)
      
      # Mise à jour du checkboxGroupInput
      updateCheckboxGroupInput(
        session,
        inputId = "index_ind_cluster",
        label = "📊 Choose Indicators to Include:",
        choices = choices,
        selected = choices   # tous cochés par défaut
      )
    })
    
    ### CALCULATE THE REACTIVE DATASET FOR CLUSTER ANALYSIS-------------------------
    
    reactive_cluster <- reactive({
      
      data_st_disease_all %>%
        ungroup() %>%
        filter(!is.na(year_api),  numeric_value>0,indicator_code%in%input$index_ind_cluster) %>%   # uso == en lugar de %in% para un solo valor
        group_by(sub_component, indicator_code, iso) %>%
        summarise(year_api = safe_summary(year_api, fun = "max"), .groups = "drop") %>% #max(year_api, na.rm = TRUE)
        ungroup() %>%
        mutate(kp = paste(indicator_code, iso, year_api, sep = "-")) %>%
        select(sub_component, indicator_code, iso, year_api, kp) %>%
        left_join(
          data_st_disease_all %>%
            filter(!is.na(year_api), numeric_value>0,indicator_code%in%input$index_ind_cluster) %>%
            mutate(kp = paste(indicator_code, iso, year_api, sep = "-")) %>%
            select(kp, numeric_value),
          by = "kp"
        ) %>%
        select(iso, sub_component, indicator_code, year_api, numeric_value) %>%
        distinct() %>%
        pivot_wider(names_from = indicator_code, values_from = numeric_value) %>%
        mutate(across(where(is.numeric), ~ replace(., is.na(.), 0))) %>%
        mutate(across(where(is.character), ~ replace(., is.na(.), "Missing data"))) %>%
        distinct(iso, .keep_all = TRUE) %>%
        left_join(
          filter_country %>%
            filter(index_country < 48) %>%
            select(iso, country),
          by = "iso"
        ) %>%
        left_join(
          dfm_stat %>%
            select(iso, population) %>%
            distinct(),
          by = "iso"
        )%>%select(-c(iso, year_api,sub_component, population))%>%
        select(country,everything())

    })
    
    
    ### RENDER THE RESULT GENERATE BY THE CLUSTER ANALYSIS--------------------
    output$clusterPlot <- renderPlot({
      req(validate_password_basic())
      req(reactive_cluster())
      
      names_data <- reactive_cluster()$country
      test_datas <- reactive_cluster()[, -1]
      
      if (input$method == "Hierarchy_based") {
        if (nrow(test_datas) < 2) {
          plot.new()
          text(0.5, 0.5, "Need at least 2 indicator for clustering", cex = 1.2)
        } else {
          dist_mat <- dist(scale(test_datas))
          hc <- hclust(dist_mat, method = "ward.D2")
          hc$labels <- names_data
          plot(hc, main = "Hierarchical Clustering of Countries", cex = 0.9)
        }
      } else {
        if (nrow(test_datas) < input$k) {
          plot.new()
          text(0.5, 0.5, "Not enough countries for k-means clustering", cex = 1.2)
        } else {
          km <- kmeans(scale(test_datas), centers = input$k)
          df <- data.frame(country = names_data, Cluster = factor(km$cluster))
          
          ggplot(df, aes(x = Cluster, y = country, fill = Cluster)) +
            geom_tile(color = "white") +
            geom_text(aes(label = country), color = "black", size = 3) +
            theme_minimal(base_size = 14) +
            labs(title = "Ranking of countries by cluster using the k-means method") +
            theme(
              axis.text.x = element_text(size = 14),
              axis.text.y = element_text(size = 14)
            )
        }
      }
    })
    
    
    output$summary <- renderPrint({
      req(validate_password_basic())
      req(reactive_cluster())
      
      names_data<- reactive_cluster()$country
      test_datas <- reactive_cluster()[, -1]
      
      if (input$method == "Hierarchy_based") {
        dist_mat <- dist(scale(test_datas))
        hc <- hclust(dist_mat, method = "ward.D2")
        hc$labels <- names_data   # noms des pays
        print(hc)
      } else {
        km <- kmeans(scale(test_datas), centers = input$k)
        df <- data.frame(country = names_data, Cluster = km$cluster)
        
        #  df1<-df%>%
        #  group_by(Cluster) %>%
        #    summarise(score_moyen = mean(score_normalise, na.rm = TRUE)) %>%
        #   arrange(desc(score_moyen))
        print(df)   # tableau lisible pour les donateurs
      }
    })
    
    
    # Calcul de l'année max
    max_year_cluster <- reactive({
      max_yearS <- data_st_disease_all%>%
        ungroup()%>%
        filter(sub_component %in%input$disease_cluster, numeric_value>0)%>%
        select(year_api)%>%filter(year_api==max(year_api, na.rm = TRUE))%>%
        distinct()
      
      max_yearS
    })
    
    
    output$title_disease_cluster <- renderText({
      paste(input$disease_cluster,"Cluster analysis of countries based on diseases indicators","-",max_year_cluster()[1])
    })
   
    afro_data_cluster <- reactive({
      # Get reactive data
      names_data <- reactive_cluster()$country
      test_datas <- reactive_cluster()[, -1]
      
      # --- Safeguard: check for empty or invalid data ---
      if (is.null(test_datas) || nrow(test_datas) < 1 || is.null(input$k) || input$k > nrow(test_datas)) {
        # If no valid data, return NULL (or a blank sf object)
        return(
          spdf_africa2a %>%
            dplyr::mutate(RiskLevel = NA) %>%
            sf::st_make_valid()
        )
      }
      
      # --- Safe k-means clustering ---
      km <- kmeans(scale(test_datas), centers = input$k)
      df <- data.frame(country = names_data, Cluster = km$cluster)
      
      cluster_map <- df %>%
        dplyr::mutate(
          RiskLevel = case_when(
            Cluster == 1 ~ "cluster 1",
            Cluster == 2 ~ "cluster 2",
            Cluster == 3 ~ "cluster 3",
            Cluster == 4 ~ "cluster 4",
            Cluster == 5 ~ "cluster 5",
            Cluster == 6 ~ "cluster 6"
          )
        ) %>%
        dplyr::select(country, RiskLevel) %>%
        left_join(
          filter_country %>%
            filter(index_country < 48) %>%
            select(iso, country),
          by = c("country" = "country")
        ) %>%
        dplyr::select(iso, RiskLevel)
      
      spdf_africa2a %>%
        left_join(cluster_map, by = c("iso_a3" = "iso")) %>%
        sf::st_make_valid()
    })
    
    #006-GENERATE MAP Cluster--------------------------- 
    
    output$mymap_cluster <- renderLeaflet({
       req(validate_password_basic())
       req(afro_data_cluster())
      
      fct_risk_map(a=afro_data_cluster(),b=input$disease_cluster,c=max_year_cluster()[1],k="Cluster analysis of countries based on diseases : " )

    })
    
    ### STATISTIC: ANOVA, TUKY AND REGRESSION-------------------------------------------
    
    #001-CASCADE LIST DISEASE-INDICATOR---------------------------
    observeEvent(
      input$disease_statistic,
      updateSelectInput(session,"indicator_filter", "Select Indicator",
                        choices = tvd_indicator$indicator[tvd_indicator$sub_component%in%input$disease_statistic])
    )
    
    observeEvent(input$indicator_filter, {
      # Filter countries based on disease selection
      countries <- unique(na.omit(tvd_dts$country[tvd_dts$indicator %in% input$indicator_filter]))
      
      # Build grouped choices: Countries vs Regions
      choices <- list(
        "Countries" = setNames(countries, countries),
        "WHO African Region"   = c("WHO African Region" = "WHO African Region")
      )
      
      # Update with server-side selectize
      updateSelectizeInput(
        session,
        inputId = "index_country_statistic",
        choices = choices,
        selected = "WHO African Region",  # valeur par défaut forcée
        server = TRUE,   # key: enables server-side loading
        options = list(multiple = TRUE)   # <-- autorise plusieurs choix
      )
    })
    # Calcul de l'année max
    max_year_statistic <- reactive({
      
      
      selected_code <- tvd_dts %>% filter(indicator %in% input$indicator_filter) %>% pull(indicator_code) %>% unique()
      selected_iso  <- filter_country %>% filter(country %in%input$index_country_statistic) %>% pull(iso) %>% unique()
      
      max_yearS <- dfm_stat%>%
        ungroup()%>%
        filter(indicator_code %in% selected_code[1],
               numeric_value>0,year_api >= input$statistic_timingInput[1], year_api <= input$statistic_timingInput[2])%>%
        { 
          if (selected_iso[1] %in% Afroname$iso) . else filter(., iso %in% selected_iso[1]) 
        }%>%
        select(year_api)%>%filter(year_api==max(year_api, na.rm = TRUE))%>%
        distinct()

      max_yearS
    })
    
    output$title_disease_statistic <- renderText({
      paste(input$disease_statistic,"Statistical Analysis: ANOVA, Tukey and Regression ", "-",max_year_statistic()[1])
    })
    
    
    output$subtitle_disease_statistic <- renderText({
      paste("Surveillance indicator","-",input$indicator_filter)
    })
    
    # Load data
    data_loaded <- reactive({
      if (!is.null(dfm_stat)) {
       
        selected_code <- tvd_dts %>% filter(indicator %in% input$indicator_filter) %>% pull(indicator_code) %>% unique()
        selected_iso  <- filter_country %>% filter(country %in%input$index_country_statistic) %>% pull(iso) %>% unique()
        
        dfm_stat %>%filter(indicator_code %in% selected_code[1],
                           numeric_value>0,
                           year_api >= input$statistic_timingInput[1],
                           year_api <= input$statistic_timingInput[2])%>%
          #accepter plusieurs pays
          {
            if (any(selected_iso %in% Afroname$iso)) .
            else filter(., iso %in% selected_iso)
          }
      } else {
         # your default dataframe
      }
    })
    
    # Update choices
    observe({
      df <- data_loaded()
     # updateSelectInput(session, "indicator_filter", choices = unique(df$indicator))
      updateSelectInput(session, "anova_y", choices ="numeric_value") # names(df)
      updateSelectInput(session, "anova_group", choices =c("subregion","country_class"))# names(df)
      updateSelectInput(session, "yvar", choices = "numeric_value")#names(df)
      updateSelectInput(session, "xvars", choices =c("subregion","country_class","year_api"))# names(df)
    })
    
    
    # Filter by indicator
    filtered_data <- reactive({
      req(input$indicator_filter)
      selected_code <- tvd_dts %>% filter(indicator %in% input$indicator_filter) %>% pull(indicator_code) %>% unique()
      data_loaded() %>% filter(indicator_code%in%selected_code[1], year_api >= input$statistic_timingInput[1], year_api <= input$statistic_timingInput[2])
    })
    
    
    # Déclenche automatiquement le bouton au démarrage
    observe({
      shinyjs::click("run")
    })
    
    
    # ANOVA + Tukey
    observeEvent(input$run, {
      df <- filtered_data()
      y <- input$anova_y
      group <- input$anova_group
      if (is.null(y) || is.null(group)) return(NULL)
      
      formula <- as.formula(paste(y, "~", group))
      res <- aov(formula, data = df)
      
      # ANOVA summary
      output$anova_res <- renderPrint({ summary(res) })
      
      # Narrative interpretation for ANOVA
      output$anova_narrative <- renderText({
        s <- summary(res)[[1]]
        pval <- s["Pr(>F)"][1]
        pval <- round(pval, 4)
        if (pval < 0.05) {
          paste("The ANOVA indicates a statistically significant difference in", y,
                "across levels of", group, "(p =", pval, ").")
        } else {
          paste("The ANOVA shows no statistically significant difference in", y,
                "across levels of", group, "(p =", pval, ").")
        }
      })
      
      # Tukey test
      tukey <- TukeyHSD(res)
      tukey_df <- as.data.frame(tukey[[group]])
      tukey_df$comparison <- rownames(tukey_df)
      tukey_df$significant <- ifelse(tukey_df$`p adj` < 0.05, "Yes", "No")
      tukey_df <- tukey_df %>% mutate(across(where(is.numeric), ~ round(., 4)))
      
      # Narrative interpretation for Tukey
      tukey_df$interpretation <- apply(tukey_df, 1, function(row) {
        comp <- row["comparison"]
        diff <- as.numeric(row["diff"])
        signif <- row["significant"]
        groups <- unlist(strsplit(comp, "-"))
        if (signif == "Yes") {
          if (diff > 0) paste(groups[1], "has a significantly higher mean than", groups[2])
          else paste(groups[2], "has a significantly higher mean than", groups[1])
        } else {
          paste("No significant difference between", groups[1], "and", groups[2])
        }
      })
      
      output$tukey_table <- renderDT({
        datatable(tukey_df, options = list(pageLength = 5),
                  caption = htmltools::tags$caption(
                    style = 'caption-side: top; text-align: center; font-size:16px; font-weight:bold;',
                    "TukeyHSD Test Results with Interpretation"
                  )) %>%
          formatStyle("significant", target = "cell",
                      backgroundColor = styleEqual(c("Yes", "No"), c("lightgreen", "lightcoral")),
                      color = "black", fontWeight = "bold")
      })
      
      # Tukey plot
      p <- ggplot(tukey_df, aes(x = comparison, y = diff, ymin = lwr, ymax = upr)) +
        geom_pointrange(aes(color = significant)) +
        geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
        scale_color_manual(values = c("Yes" = "darkgreen", "No" = "grey")) +
        coord_flip() +
        labs(title = "TukeyHSD Comparisons",
             y = "Mean Difference", x = "Comparison") +
        theme_minimal(base_size = 14)
      
      output$tukey_plot <- renderPlot({ p })
      
      # Export CSV
      output$downloadData <- downloadHandler(
        filename = function() { paste0("tukey_results_", input$indicator_filter, ".csv") },
        content = function(file) { write.csv(tukey_df, file, row.names = FALSE) }
      )
      
      # Export PNG/PDF
      output$downloadPlot <- downloadHandler(
        filename = function() { paste0("tukey_plot_", input$indicator_filter, ".png") },
        content = function(file) { ggsave(file, plot = p, device = "png") }
      )
      output$downloadPlotPDF <- downloadHandler(
        filename = function() { paste0("tukey_plot_", input$indicator_filter, ".pdf") },
        content = function(file) { ggsave(file, plot = p, device = "pdf") }
      )
    })
    
    # Regression with highcharter
    # Regression with highcharter
    observeEvent(input$run_reg, {
      df <- filtered_data()
      y <- input$yvar
      x <- input$xvars
      if (is.null(y) || length(x) == 0) return(NULL)
      
      formula <- as.formula(paste(y, "~", paste(x, collapse = "+")))
      model <- lm(formula, data = df)
      
      output$reg_res <- renderPrint({ summary(model) })
      
      coef_df <- as.data.frame(summary(model)$coefficients)
      coef_df$Variable <- rownames(coef_df)
      names(coef_df) <- c("Estimate", "Std.Error", "t.value", "p.value", "Variable")
      
      # Round to 4 digits
      coef_df <- coef_df %>% mutate(across(where(is.numeric), ~ round(., 4)))
      
      # Narrative interpretation
      coef_df$Interpretation <- apply(coef_df, 1, function(row) {
        est <- as.numeric(row["Estimate"])
        pval <- as.numeric(row["p.value"])
        var <- row["Variable"]
        
        if (var == "(Intercept)") {
          return("Intercept: baseline value of Y when predictors = 0")
        }
        if (pval < 0.05) {
          if (est > 0) {
            paste(var, "→ significant positive effect on", y)
          } else {
            paste(var, "→ significant negative effect on", y)
          }
        } else {
          paste(var, "→ not statistically significant")
        }
      })
      
      # Interactive regression table
      output$reg_table <- renderDT({
        datatable(coef_df, options = list(pageLength = 5),
                  caption = htmltools::tags$caption(
                    style = 'caption-side: top; text-align: center; font-size:16px; font-weight:bold;',
                    "Regression Coefficients with Interpretation"
                  )) %>%
          formatStyle("p.value", target = "cell",
                      backgroundColor = styleInterval(0.05, c("lightgreen", "lightcoral")),
                      color = "black", fontWeight = "bold")
      })
      
      # Interactive regression plot with proper list arguments
      output$reg_plot <- renderPlot({
        if (length(x) == 1) {
          df$pred <- predict(model)
          ggplot(df, aes(x = !!sym("x"), y = !!sym("y")) #aes_string(x = x, y = y)
                 
                 
                 ) +
            geom_point(color = "blue") +
            geom_line(aes(y = pred), color = "red", linewidth = 1) +
            labs(title = paste("Linear Regression:", y, "~", x),
                 x = x, y = y) +
            theme_minimal(base_size = 14)
        } else {
          res <- resid(model)
          df_res <- data.frame(Index = 1:length(res), Residuals = res)
          ggplot(df_res, aes(x = Index, y = Residuals)) +
            geom_line(color = "darkgreen") +
            geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
            labs(title = "Residuals (multi-variable regression)",
                 x = "Index", y = "Residuals") +
            theme_minimal(base_size = 14)
        }
      })
      
      
      # Export CSV
      output$downloadReg <- downloadHandler(
        filename = function() { paste0("regression_results_", input$indicator_filter, ".csv") },
        content = function(file) { write.csv(coef_df, file, row.names = FALSE) }
      )
    })
    
    
    ### PREDILECTION -------------------------------------------
    
    #001-CASCADE LIST DISEASE-INDICATOR---------------------------
    observeEvent(
      input$disease_predict,
      updateSelectInput(session,"indicator_predict", "Select Indicator",
                        choices = tvd_indicator$indicator[tvd_indicator$sub_component%in%input$disease_predict])
    )
    
    
    observeEvent(input$indicator_predict, {
      # Filter countries based on disease selection
      countries <- unique(na.omit(tvd_dts$country[tvd_dts$indicator %in% input$indicator_predict]))
      
      # Build grouped choices: Countries vs Regions
      choices <- list(
        "Countries" = setNames(countries, countries),
        "WHO African Region"   = c("WHO African Region" = "WHO African Region")
      )
      
      # Update with server-side selectize
      updateSelectizeInput(
        session,
        inputId = "index_country_predict",
        choices = choices,
        selected = "WHO African Region",  # valeur par défaut forcée
        server = TRUE   # key: enables server-side loading
      )
    })
    # Calcul de l'année max
    max_year_predict <- reactive({
      selected_code <- tvd_dts %>% filter(indicator %in% input$indicator_predict) %>% pull(indicator_code) %>% unique()
      selected_iso  <- filter_country %>% filter(country %in%input$index_country_predict) %>% pull(iso) %>% unique()
      
      max_yearS <- dfm_stat%>%
        ungroup()%>%
        filter(indicator_code %in% selected_code[1],
               numeric_value>0)%>%
        { 
          if (selected_iso[1] %in% Afroname$iso) . else filter(., iso %in% selected_iso[1]) 
        }%>%
        select(year_api)%>%filter(year_api==max(year_api, na.rm = TRUE))%>%
        distinct()
      
      max_yearS
    })
    
    output$title_disease_predict <- renderText({
      paste("Estimation of Predicted Indicator Values for",input$disease_predict," in the",input$index_country_predict,"-",max_year_predict()[1])
    })
    
    
    output$subtitle_disease_predict <- renderText({
      paste("Surveillance indicator","-",input$indicator_predict)
    })
    
    
    # Charger les données
    data_loaded_predict <- reactive({
      selected_code <- tvd_dts %>% filter(indicator %in% input$indicator_predict) %>% pull(indicator_code) %>% unique()
      selected_iso  <- filter_country %>% filter(country %in% input$index_country_predict) %>% pull(iso) %>% unique()
      
      dfm_stat %>%filter(indicator_code %in% selected_code[1],
                         numeric_value>0)%>%
        { 
          if (selected_iso[1] %in% Afroname$iso) . else filter(., iso %in% selected_iso[1]) 
        }%>%left_join(filter_country%>%select(country,iso), by = c("iso" = "iso"))
     
    })
    
    # Mettre à jour la liste des indicateurs
   # observe({
  #    df <- data_loaded()
  #    updateSelectInput(session, "indicator_predict", choices = unique(df$indicator))
  #  })
    
    # Déclenche automatiquement le bouton au démarrage
    observe({
      shinyjs::click("run_forecast")
    })
    
    
    # Lancer la prévision------------------------------
    forecast_result <- eventReactive(input$run_forecast, {
      req(input$indicator_predict)
      predict_indicator_arima(input$indicator_predict, data_loaded_predict(),input$predict_timingInput,input$index_country_predict)
    })
    
    
    
    
    
    # Tableau des prévisions---------------------------
   output$forecast_table <- renderDT({
      req(forecast_result())
      datatable(forecast_result()$predictions_display, options = list(pageLength = 12))
    })

    # Graphique-------------------------------
    output$forecast_plot <- renderPlot({
      req(forecast_result())
      forecast_result()$plot
    })
    
    # Export CSV---------------------------------
    output$download_csv <- downloadHandler(
      filename = function() { paste0("forecast_", input$indicator_predict, ".csv") },
      content = function(file) {
        write.csv(forecast_result()$predictions, file, row.names = FALSE)
      }
    )
    
    # Export PNG
    output$download_png <- downloadHandler(
      filename = function() { paste0("forecast_", input$indicator_predict, ".png") },
      content = function(file) {
        ggsave(file, plot = forecast_result()$plot, width = 8, height = 5)
      }
    )


    
    
    
    tvd_trend_df_predict <- reactive({
      
      # function from source("modules/filter_dataset.R")
      value_max_year<-fct9_tvd_dfs(a=data_loaded_predict(),b=0,f=input$indicator_predict)
      value_max_year_1<-fct9_tvd_dfs(a=data_loaded_predict(),b=1,f=input$indicator_predict)
      value_max_year_2<-fct9_tvd_dfs(a=data_loaded_predict(),b=2,f=input$indicator_predict)
      value_max_year_3<-fct9_tvd_dfs(a=data_loaded_predict(),b=3,f=input$indicator_predict)
      
      fig_tvd_trend_years_df<-rbind(value_max_year, value_max_year_1,value_max_year_2,value_max_year_3)%>%
        mutate(year=as.numeric(year),
               numeric_value=round(val, digit=2))%>%
        select(year,numeric_value)%>%
        filter(numeric_value>0)%>%
        as.data.table()
      
      fig_tvd_trend_years_df
      
    })
    
    
    
    
    
    data_show_val_trend_predict<-reactive({
      
      fct_show_val_trend(a=tvd_trend_df_predict(),b=input$indicator_predict)%>%
        ungroup()
    })
    
    
    # Render the datatable# TEST -------------------------
    #  output$mytable <- renderDT({
    #      datatable(
    #        data_loaded_predict(),  # Example dataset
    #        options = list(pageLength = 5, autoWidth = TRUE)
    #      )
    #    })
    
    
    
    output$first_fig_tvd_predict <- renderHighchart({
      req(tvd_trend_df_predict())
 
      tryCatch({

        # Données avec IC
        estim_df <- data_show_val_trend_predict() %>%
          filter(categogies == "Achievment") %>%
          add_confidence_interval(value_col = "value", se_col = "se", margin = 0.1)
        
        proj_df <- data_show_val_trend_predict() %>%
          filter(categogies != "Achievment") %>%
          add_confidence_interval(value_col = "value", se_col = "se", margin = 0.1)
        
        target_df <- data_show_val_trend_predict() %>%
          filter(categogies == "Target")

        nb_proj <- length(unique(proj_df$year))
        nb_estim <- length(unique(estim_df$year))
        
        years <- data_show_val_trend_predict()$year
        estimations <- estim_df$value
        projection <- proj_df$value
        
        # Ajustement du modèle linéaire
        lm_model <- lm(value ~ year, data = estim_df)
        coefs <- coef(lm_model)
        intercept <- round(coefs[1], 2)
        slope <- round(coefs[2], 2)
        model_equation <- paste0("y = ", intercept, " + ", slope, "·year")
        
        # Construction du graphique
        highchart() %>%
          hc_title(text = paste(input$indicator_predict," ",
                                min(data_show_val_trend_predict()$year)," and ",
                                max(data_show_val_trend_predict()$year),"-",
                                input$index_country_predict)) %>%
          hc_xAxis(categories = years,
                   title = list(text = "Year"),
                   plotLines = list(list(
                     value = length(years) - 1,
                     color = "red",
                     width = 2,
                     dashStyle = "Dash",
                     label = list(text = paste("Target ", max(target_df$year)),
                                  style = list(fontSize = "14px", color = "red"))
                   ))) %>%
          hc_yAxis(title = list(text = "Values"),
                   labels = list(format = "{value}")) %>%
          hc_exporting(enabled = TRUE) %>%
          hc_tooltip(crosshairs = TRUE, backgroundColor = "#FCFFC5",
                     shared = TRUE, borderWidth = 2,
                     pointFormat = "Valeur: <b>{point.y}</b><br>IC95%: <b>{point.low}–{point.high}</b>") %>%
          
          # Courbe Achievment
          hc_add_series(
            name = paste("Achievment (", min(estim_df$year), "-", max(estim_df$year), ")"),
            data = c(estimations, rep(NA, nb_proj)),
            type = "line",
            color = "#1f77b4",
            lineWidth = 4,
            dataLabels = list(enabled = TRUE, format = "{y}", style = list(fontSize = "12px"))
          ) %>%
          
          # IC Achievment
          hc_add_series(
            name = "IC Achievment",
            data = purrr::map2(estim_df$value_low, estim_df$value_high, ~list(.x, .y)),
            type = "arearange",
            linkedTo = ":previous",
            color = "#1f77b4",
            fillOpacity = 0.2,
            lineWidth = 0
          ) %>%
          
          # Courbe Projection
          hc_add_series(
            name = paste("Projections (", min(proj_df$year), "-", max(proj_df$year), ")"),
            data = c(rep(NA, nb_estim), projection),
            type = "line",
            color = "#ff7f0e",
            lineWidth = 4,
            dataLabels = list(enabled = TRUE, format = "{y}", style = list(fontSize = "12px"))
          ) %>%
          
          # IC Projection
          hc_add_series(
            name = "IC Projections",
            data = c(rep(list(list(NA, NA)), nb_estim), 
                     purrr::map2(proj_df$value_low, proj_df$value_high, ~list(.x, .y))),
            type = "arearange",
            linkedTo = ":previous",
            color = "#ff7f0e",
            fillOpacity = 0.2,
            lineWidth = 0
          ) %>%
          
          # Annotation avec équation du modèle
          hc_annotations(list(
            labels = list(
              list(
                point = list(x = length(years) - 2,
                             y = max(c(estim_df$value_high, proj_df$value_high), na.rm = TRUE)),
                text = paste("Linear model: ", model_equation),
                backgroundColor = "rgba(255,255,255,0.7)",
                borderColor = "black",
                borderRadius = 5,
                style = list(fontSize = "13px")
              )
            )
          )) %>%
          
          hc_credits(enabled = TRUE,
                     text = "Data Source: WHO/AFRO/DPC/TVD Programme",
                     #href = unique(show_link_indicator()$indicator_source),
                     style = list(fontSize = "11px"))
        
      }, error = function(e) {
        # Gestion des erreurs globales
        showNotification(paste("Error during chart generation :", e$message),
                         type = "error")
        return(NULL)  # évite le blocage de l’application
      })
    })
    
    
 
    
    
    output$first_fig_tvd_arima_predict <- renderHighchart({
      req(data_show_val_trend_predict())
      tryCatch({
        # Données Achievment
        estim_df <- data_show_val_trend_predict() %>%
          filter(categogies == "Achievment")
        
        years <- estim_df$year
        estimations <- estim_df$value
        
        # Ajustement ARIMA sur la série Achievment
        ts_estim <- ts(estimations, start = min(years), frequency = 1)
        fit_arima <- auto.arima(ts_estim)
        
        # Projection sur nb_proj années
        nb_proj <- length(unique(data_show_val_trend_predict()$year)) - length(unique(estim_df$year))
        forecast_arima <- forecast(fit_arima, h = nb_proj)
        
        projection <- as.numeric(forecast_arima$mean)
        proj_years <- seq(max(years) + 1, by = 1, length.out = nb_proj)
        
        # IC de la projection
        proj_low <- as.numeric(forecast_arima$lower[,2])  # IC95% borne basse
        proj_high <- as.numeric(forecast_arima$upper[,2]) # IC95% borne haute
        
        # Équation ARIMA
        model_equation <- paste0("ARIMA(", paste(fit_arima$arma[c(1,6,2)], collapse = ","), ")")
        
        # Construction du graphique
        highchart() %>%
          hc_title(text = paste(input$indicator_predict," ",
                                min(years)," - ",
                                max(years) + nb_proj," - ",
                                input$index_country_predict)) %>%
          hc_xAxis(categories = c(years, proj_years),
                   title = list(text = "Year"),
                   plotLines = list(list(
                     value = length(c(years, proj_years)) - 1,
                     color = "red",
                     width = 2,
                     dashStyle = "Dash",
                     label = list(text = paste("Target ", max(c(years, proj_years))),
                                  style = list(fontSize = "14px", color = "red"))
                   ))) %>%
          hc_yAxis(title = list(text = "Values"),
                   labels = list(format = "{value}")) %>%
          hc_exporting(enabled = TRUE) %>%
          hc_tooltip(crosshairs = TRUE, backgroundColor = "#FCFFC5",
                     shared = TRUE, borderWidth = 2,
                     pointFormat = "Valeur: <b>{point.y}</b><br>IC95%: <b>{point.low}–{point.high}</b>") %>%
          
          # Courbe Achievment avec valeurs
          hc_add_series(
            name = paste("Achievment (", min(years), "-", max(years), ")"),
            data = c(estimations, rep(NA, nb_proj)),
            type = "line",
            color = "#1f77b4",
            lineWidth = 4,
            dataLabels = list(enabled = TRUE, format = "{y}", style = list(fontSize = "12px"))
          ) %>%
          
          # Courbe Projection ARIMA avec valeurs
          hc_add_series(
            name = paste("Projection ARIMA (", min(proj_years), "-", max(proj_years), ")"),
            data = c(rep(NA, length(years)), projection),
            type = "line",
            color = "#ff7f0e",
            lineWidth = 4,
            dataLabels = list(enabled = TRUE, format = "{y}", style = list(fontSize = "12px"))
          ) %>%
          
          # IC Projection ARIMA
          hc_add_series(
            name = "IC Projection ARIMA",
            data = c(rep(list(list(NA, NA)), length(years)),
                     purrr::map2(proj_low, proj_high, ~list(.x, .y))),
            type = "arearange",
            linkedTo = ":previous",
            color = "#ff7f0e",
            fillOpacity = 0.2,
            lineWidth = 0
          ) %>%
          
          # Annotation flottante avec équation ARIMA
          hc_annotations(list(
            labels = list(
              list(
                point = list(x = length(c(years, proj_years)) - 2,
                             y = max(c(estimations, proj_high), na.rm = TRUE)),
                text = paste("Modèle: ", model_equation),
                backgroundColor = "rgba(255,255,255,0.7)",
                borderColor = "black",
                borderRadius = 5,
                style = list(fontSize = "13px")
              )
            )
          )) %>%
          
          hc_credits(enabled = TRUE,
                     text = "Data Source: WHO/AFRO/DPC/TVD Programme",
                #     href = unique(show_link_indicator()$indicator_source),
                     style = list(fontSize = "11px"))
        
        
      }, error = function(e) {
        # Gestion des erreurs globales
        showNotification(paste("Error during chart generation :", e$message),
                         type = "error")
        return(NULL)  # évite le blocage de l’application
      })
    })
    
    
    
    ### NOTE INFORMATION POUR UTULISATEUR-------------------------------------
    
    ### USER INFORMATION NOTE -------------------------------------
    # Helper function defined OUTSIDE renderUI
    # Helper function defined OUTSIDE renderUI
    panel_block <- function(title, menu, figure, interpretation, method, recommendation, icon_name="chart-bar") {
      tags$div(
        style="text-align:left; margin-bottom:25px;",  # bloc espacé
        
        tags$h3(style="color:#003366; margin-top:20px; text-align:left;", icon(icon_name), title),
        
        tags$h4(style="margin-left:10px; text-align:left;", "Menu Title"),
        tags$p(style="margin-left:20px; text-align:left;", menu),
        
        tags$h4(style="margin-left:10px; text-align:left;", "Figure Title"),
        tags$p(style="margin-left:20px; text-align:left;", figure),
        
        tags$h4(style="margin-left:10px; text-align:left;", "Interpretation"),
        tags$div(
          style="background-color:#f0f8ff; padding:10px; border-radius:5px; margin:10px 0 15px 20px; text-align:left;",
          interpretation
        ),
        
        tags$h4(style="margin-left:10px; text-align:left;", "Statistical Method"),
        tags$p(style="margin-left:20px; text-align:left;", method),
        
        tags$h4(style="margin-left:10px; text-align:left;", "Recommendation"),
        tags$div(
          style="background-color:#e6ffe6; padding:10px; border-left:4px solid #009900; margin:10px 0 15px 20px; text-align:left;",
          recommendation
        ),
        tags$hr()
      )
    }
    
    ### USER INFORMATION NOTE -------------------------------------
    output$display_content_info <- renderUI({
      tags$div(
        style = "max-height: 700px; overflow-y: auto; text-align: left; font-family: Arial; line-height: 1.5;",
        
        panel_block("TabPanel 1 – Risk Heatmap",
                    "Risk Heatmap – Risk Analysis",
                    "Risk Analysis – Normalized Scores and Country Ranking",
                    "This analysis ranks countries based on normalized scores that integrate indicator values and population size. The heatmap highlights countries with high or low risk levels.",
                    "Scores are derived from indicator normalization followed by a population-weighted average.",
                    "Prioritize countries with high scores for resource allocation, enhanced monitoring, and rapid intervention.",
                    "fire"),
        
        panel_block("TabPanel 2 – Clustering",
                    "Clustering Analysis",
                    "Cluster Analysis of Countries Based on Disease Indicators",
                    "Countries are grouped into clusters with similar disease indicator profiles.",
                    "Hierarchical clustering (Ward.D2), K-means, intra-cluster variance reduction.",
                    "Tailor strategies according to the profile of each cluster.",
                    "project-diagram"),
        
        panel_block("TabPanel 3 – Statistical Analysis",
                    "Statistical Analysis",
                    "ANOVA, TukeyHSD, and Regression Outputs",
                    "These analyses identify significant differences between groups and highlight influential variables.",
                    "ANOVA, TukeyHSD (post-hoc), linear models (lm).",
                    "Focus on groups with significant differences and monitor key variables.",
                    "calculator"),
        
        panel_block("TabPanel 4 – Forecasts",
                    "Forecasts (2026)",
                    "Predicted Indicator Values for Malaria – WHO African Region",
                    "Forecasts anticipate trends for 2026.",
                    "Linear interpolation, monthly ARIMA, annual ARIMA.",
                    "Plan resources according to expected trends.",
                    "chart-line"),
        
        panel_block("TabPanel 5 – Indicator Overview",
                    "Indicator Overview – Buruli Ulcer",
                    "New Reported Cases of Buruli Ulcer + Map",
                    "The map shows the spatial and temporal distribution of cases.",
                    "Descriptive analysis.",
                    "Strengthen surveillance in areas with sharp increases.",
                    "map"),
        
        panel_block("TabPanel 6 – Disease Overview",
                    "Disease Overview – Malaria 2021–2024",
                    "Indicator Value Differences Between Current Estimates and Baseline",
                    "Analysis of changes from 2021–2024 compared to baseline levels.",
                    "Descriptive and temporal comparison analysis.",
                    "Adjust strategies to meet targets.",
                    "virus"),
        
        panel_block("TabPanel 7 – Fact Sheet",
                    "Malaria Epidemiology – WHO AFRO 2024 Fact Sheet",
                    "Trends in Morbidity, Mortality and Service Coverage",
                    "Overview of epidemiological trends.",
                    "Descriptive analysis + forecasts.",
                    "Adapt strategies according to observed progress.",
                    "file-alt"),
        
        panel_block("TabPanel 8 – Filter Dataset",
                    "Filtering Dataset",
                    "Dataset Filtering by Segment and Export",
                    "Tool for selecting relevant subgroups.",
                    "Dynamic filtering via Shiny.",
                    "Create subsets for specific analyses.",
                    "filter"),
        
        panel_block("TabPanel 9 – Pivot Data",
                    "Pivot Data Tool",
                    "Pivot Table Based on Disease, Indicator and Value",
                    "Interactive exploration using pivot tables.",
                    "Aggregation, transformation, Excel-like pivot logic.",
                    "Quickly generate decision-making summaries.",
                    "table"),
        
        panel_block("TabPanel 10 – Metadata",
                    "Metadata Overview",
                    "List of Diseases and Indicators Used",
                    "Presentation of database structure.",
                    "No statistical method.",
                    "Consult before any analysis.",
                    "database")
      )
    })
    
    
    #26 GENERETED REPORT FOR VPD BY LEVEL-------------------------
    
    
    output$factsheet_file <- downloadHandler(
      
      filename = function() {
        paste(input$filename_factsheet_file, Sys.Date(),sep = '.', switch(
          input$format_factsheet, HTML = 'html', PDF = 'pdf', Word = 'docx'
        ))
      },
      
      content = function(file) {
        withProgress(message = "Preparing the factsheet...", value = 0, {
        # Étape 1 : copie du fichier
        incProgress(0.2, detail = "Copying the template...")
        src <- normalizePath('factSheetTVD.Rmd')
        # temporarily switch to the temp dir, in case you do not have write
        # permission to the current working directory
        owd <- setwd(tempdir())
        on.exit(setwd(owd))
        file.copy(src, 'factSheetTVD.Rmd', overwrite = TRUE)
        
        # Étape 2 : rendu du document
        incProgress(0.5, detail = "Rendering the document...")
        library(rmarkdown)
        out <- render('factSheetTVD.Rmd', switch(
          
          input$format_factsheet,
          HTML = html_document(), PDF = pdf_document(), Word = word_document()
        ))
        # Étape 3 : finalisation
        incProgress(0.8, detail = "Finalisazing the file...")
        req(validate_password_basic()) # show only if authentication is true
        if(!is.null(base_user_filter_name()$permissions) &&  base_user_filter_name()$permissions=="admin"){ # download only if permission is admin account
          pbsapply(1:15, function(z) Sys.sleep(0.5))
          file.rename(out, file)
        }else if(!is.null(base_user_filter_name()$permissions) && base_user_filter_name()$permissions=="standard"){
          pbsapply(1:15, function(z) Sys.sleep(0.5))
          file.rename(out, file)
          incProgress(1, detail = "Completing")
        }
        })
        
      }
    )
    
   
  
    ## DISCONNECT THE SQLITE SERVER------------------------
    
      session$onSessionEnded(function() {
        if (DBI::dbIsValid(conn)) {
           dbDisconnect(conn)
         }
     })
    
   
}
# Run the application 


shinyApp(ui = ui, server = server)
