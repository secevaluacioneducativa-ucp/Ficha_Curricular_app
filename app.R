library(shiny)
library(googlesheets4)

# -------------------------------------------------------------------
# Configuración de Google Sheets
# -------------------------------------------------------------------
SHEET_URL <- Sys.getenv("GOOGLE_SHEET_URL", "https://docs.google.com/spreadsheets/d/TU_ID_DE_TU_SHEET/edit")

EJES <- c(
  "1-Especificación, proyecto y desarrollo de sistemas de información.",
  "2-Especificación, proyecto y desarrollo de sistemas de comunicación de datos.",
  "3-Especificación, proyecto y desarrollo de software.",
  "4-Proyecto y dirección en lo referido a seguridad informática.",
  "5-Establecimiento de métricas y normas de calidad de software.",
  "6-Procedimientos y certificaciones del funcionamiento, condición de uso o estado de sistemas de información, sistemas de comunicación de datos, software, seguridad informática y calidad de software.",
  "7-Dirección y control de la implementación, operación y mantenimiento de sistemas de información, sistemas de comunicación de datos, software, seguridad informática y calidad de software.",
  "8-Identificación, formulación y resolución de problemas de ingeniería en sistemas de información/informática.",
  "9-Concepción, diseño y desarrollo de proyectos de ingeniería en sistemas de información / informática.",
  "10-Gestión, planificación, ejecución y control de proyectos de ingeniería en sistemas de información / informática.",
  "11-Utilización de técnicas y herramientas de aplicación en la ingeniería en sistemas de información / informática.",
  "12-Generación de desarrollos tecnológicos y/o innovaciones tecnológicas.",
  "13-Desempeño en equipos de trabajo.",
  "14-Comunicación efectiva.",
  "15-Actuación profesional ética y responsable.",
  "16-Evaluación y actuación en relación con el impacto social de su actividad profesional en el contexto global y local.",
  "17-Aprendizaje continuo.",
  "18-Desarrollo de una actitud profesional emprendedora."
)

ui <- fluidPage(
  titlePanel("Ficha de Actividad Curricular"),
  sidebarLayout(
    sidebarPanel(
      actionButton("guardar", "Guardar en Google Sheets", class = "btn-primary", width = "100%"),
      br(), br(),
      actionButton("limpiar", "Limpiar formulario", class = "btn-secondary", width = "100%"),
      br(), br(),
      verbatimTextOutput("estado")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("1. Actividad curricular",
          textInput("denominacion", "Indique la denominación de la actividad curricular:", ""),
          textInput("carreras_2023", "Carreras que se presentan a acreditación (2023):", ""),
          textInput("carreras_2026", "Carreras que se presentan a acreditación (2026):", "")
        ),
        tabPanel("2. Programa analítico",
          textInput("programa_analitico", "Nombre del Programa Analítico:", ""),
          h4("Ejes y enunciados multidimensionales y transversales"),
          uiOutput("ejes_ui")
        ),
        tabPanel("3. Carga horaria",
          h4("3.1.1. Carga horaria por bloque"),
          fluidRow(
            column(6,
              numericInput("cb_presencial", "Ciencias Básicas de la Ingeniería - Presencial", 0, min = 0),
              numericInput("tb_presencial", "Tecnologías Básicas - Presencial", 0, min = 0),
              numericInput("ta_presencial", "Tecnologías Aplicadas - Presencial", 0, min = 0),
              numericInput("ctc_presencial", "Ciencias y Tecnologías Complementarias - Presencial", 0, min = 0),
              numericInput("otros_presencial", "Otros contenidos - Presencial", 0, min = 0),
              numericInput("carga_total_presencial", "Carga horaria total - Presencial", 0, min = 0)
            ),
            column(6,
              numericInput("cb_distancia", "Ciencias Básicas de la Ingeniería - A distancia", 0, min = 0),
              numericInput("tb_distancia", "Tecnologías Básicas - A distancia", 0, min = 0),
              numericInput("ta_distancia", "Tecnologías Aplicadas - A distancia", 0, min = 0),
              numericInput("ctc_distancia", "Ciencias y Tecnologías Complementarias - A distancia", 0, min = 0),
              numericInput("otros_distancia", "Otros contenidos - A distancia", 0, min = 0),
              numericInput("carga_total_distancia", "Carga horaria total - A distancia", 0, min = 0)
            )
          ),
          h4("3.1.2. Actividades de formación práctica"),
          fluidRow(
            column(6,
              numericInput("practicas_supervisadas_presencial", "Instancias supervisadas de formación práctica - Presencial", 0, min = 0),
              numericInput("proyecto_integrador_presencial", "Proyecto Integrador - Presencial", 0, min = 0),
              numericInput("practica_profesional_presencial", "Práctica profesional supervisada - Presencial", 0, min = 0),
              numericInput("carga_horaria_total_practica_presencial", "Carga horaria total práctica - Presencial", 0, min = 0)
            ),
            column(6,
              numericInput("practicas_supervisadas_distancia", "Instancias supervisadas de formación práctica - A distancia", 0, min = 0),
              numericInput("proyecto_integrador_distancia", "Proyecto Integrador - A distancia", 0, min = 0),
              numericInput("practica_profesional_distancia", "Práctica profesional supervisada - A distancia", 0, min = 0),
              numericInput("carga_horaria_total_practica_distancia", "Carga horaria total práctica - A distancia", 0, min = 0)
            )
          ),
          textAreaInput("ambitos_practica", "3.1.3. Ámbitos donde se desarrollan las actividades de formación práctica:", "", height = "120px"),
          h4("3.2. Carga horaria semanal"),
          fluidRow(
            column(6,
              numericInput("carga_horaria_semanal_total_presencial", "Carga horaria semanal total - Presencial", 0, min = 0),
              numericInput("carga_horaria_semanal_practica_presencial", "Carga horaria semanal destinada a la formación práctica - Presencial", 0, min = 0)
            ),
            column(6,
              numericInput("carga_horaria_semanal_total_distancia", "Carga horaria semanal total - A distancia", 0, min = 0),
              numericInput("carga_horaria_semanal_practica_distancia", "Carga horaria semanal destinada a la formación práctica - A distancia", 0, min = 0)
            )
          )
        ),
        tabPanel("4. Bibliografía",
          uiOutput("bibliografia_ui")
        ),
        tabPanel("5. Equipo docente",
          h4("6.3. Auxiliares no graduados y otros docentes según dedicación"),
          fluidRow(
            column(3, numericInput("aux_menor_9", "Aux. no graduados ≤ 9h", 0, min = 0)),
            column(3, numericInput("aux_10_19", "Aux. no graduados 10-19h", 0, min = 0)),
            column(3, numericInput("aux_20_29", "Aux. no graduados 20-29h", 0, min = 0)),
            column(3, numericInput("aux_30_39", "Aux. no graduados 30-39h", 0, min = 0))
          ),
          fluidRow(
            column(3, numericInput("aux_40_mas", "Aux. no graduados ≥ 40h", 0, min = 0)),
            column(3, numericInput("otro_menor_9", "Otros docentes ≤ 9h", 0, min = 0)),
            column(3, numericInput("otro_10_19", "Otros docentes 10-19h", 0, min = 0)),
            column(3, numericInput("otro_20_29", "Otros docentes 20-29h", 0, min = 0))
          ),
          fluidRow(
            column(3, numericInput("otro_30_39", "Otros docentes 30-39h", 0, min = 0)),
            column(3, numericInput("otro_40_mas", "Otros docentes ≥ 40h", 0, min = 0))
          ),
          h4("6.4. Auxiliares no graduados y otros docentes según designación"),
          fluidRow(
            column(3, numericInput("design_contratados", "Contratados", 0, min = 0)),
            column(3, numericInput("design_regular_rentado", "Regular Rentado", 0, min = 0)),
            column(3, numericInput("design_regular_honorem", "Regular Ad Honorem", 0, min = 0)),
            column(3, numericInput("design_interino_rentado", "Interino Rentado", 0, min = 0))
          ),
          fluidRow(
            column(3, numericInput("design_interino_honorem", "Interino Ad Honorem", 0, min = 0))
          )
        ),
        tabPanel("6. Alumnos",
          h4("7.1. Cantidad total de alumnos que cursaron la actividad curricular en los últimos 8 años"),
          fluidRow(
            column(2, numericInput("alumnos_2023", "2023", 0, min = 0)),
            column(2, numericInput("alumnos_2024", "2024", 0, min = 0)),
            column(2, numericInput("alumnos_2025", "2025", 0, min = 0)),
            column(2, numericInput("alumnos_2026", "2026", 0, min = 0)),
            column(2, numericInput("alumnos_2027", "2027", 0, min = 0)),
            column(2, numericInput("alumnos_2028", "2028", 0, min = 0))
          ),
          fluidRow(
            column(2, numericInput("alumnos_2029", "2029", 0, min = 0)),
            column(2, numericInput("alumnos_2030", "2030", 0, min = 0))
          ),
          h4("7.2. Cantidad total de alumnos involucrados en los exámenes finales en los últimos 8 años"),
          fluidRow(
            column(2, numericInput("examen_2023", "2023", 0, min = 0)),
            column(2, numericInput("examen_2024", "2024", 0, min = 0)),
            column(2, numericInput("examen_2025", "2025", 0, min = 0)),
            column(2, numericInput("examen_2026", "2026", 0, min = 0)),
            column(2, numericInput("examen_2027", "2027", 0, min = 0)),
            column(2, numericInput("examen_2028", "2028", 0, min = 0))
          ),
          fluidRow(
            column(2, numericInput("examen_2029", "2029", 0, min = 0)),
            column(2, numericInput("examen_2030", "2030", 0, min = 0))
          )
        ),
        tabPanel("7. Autoevaluación",
          textAreaInput("autoeval_10_1", "10.1. Suficiencia y adecuación de los ámbitos donde se desarrolla la actividad:", "", height = "120px"),
          textAreaInput("autoeval_10_2", "10.2. Datos de inscripción y promoción de los alumnos:", "", height = "120px"),
          textAreaInput("autoeval_10_3", "10.3. Composición del equipo docente:", "", height = "120px"),
          textAreaInput("autoeval_10_4", "10.4. Acciones, reuniones y comisiones del equipo docente:", "", height = "120px")
        ),
        tabPanel("8. Otra información",
          textAreaInput("otra_informacion", "Ingrese otra información relevante:", "", height = "220px")
        )
      )
    )
  )
)

server <- function(input, output, session) {
  vals <- reactiveValues(status = "")

  output$estado <- renderText(vals$status)

  output$ejes_ui <- renderUI({
    tagList(
      lapply(seq_along(EJES), function(i) {
        selectInput(
          inputId = paste0("eje_", i),
          label = EJES[i],
          choices = c("Ninguna", "Bajo", "Medio", "Alto"),
          selected = "Ninguna"
        )
      })
    )
  })

  output$bibliografia_ui <- renderUI({
    tagList(
      lapply(1:8, function(i) {
        fluidRow(
          column(2, textInput(paste0("bib_", i, "_titulo"), "Título", "")),
          column(2, textInput(paste0("bib_", i, "_autores"), "Autores", "")),
          column(2, textInput(paste0("bib_", i, "_editorial"), "Editorial", "")),
          column(1, numericInput(paste0("bib_", i, "_ejemplares"), "Ejemplares", 0, min = 0)),
          column(2, textInput(paste0("bib_", i, "_link"), "Link", "")),
          column(1, numericInput(paste0("bib_", i, "_anio"), "Año", 0, min = 0))
        )
      })
    )
  })

  observeEvent(input$limpiar, {
    updateTextInput(session, "denominacion", value = "")
    updateTextInput(session, "carreras_2023", value = "")
    updateTextInput(session, "carreras_2026", value = "")
    updateTextInput(session, "programa_analitico", value = "")
    updateTextAreaInput(session, "ambitos_practica", value = "")
    updateTextAreaInput(session, "autoeval_10_1", value = "")
    updateTextAreaInput(session, "autoeval_10_2", value = "")
    updateTextAreaInput(session, "autoeval_10_3", value = "")
    updateTextAreaInput(session, "autoeval_10_4", value = "")
    updateTextAreaInput(session, "otra_informacion", value = "")

    lapply(seq_along(EJES), function(i) {
      updateSelectInput(session, paste0("eje_", i), selected = "Ninguna")
    })

    lapply(1:8, function(i) {
      updateTextInput(session, paste0("bib_", i, "_titulo"), value = "")
      updateTextInput(session, paste0("bib_", i, "_autores"), value = "")
      updateTextInput(session, paste0("bib_", i, "_editorial"), value = "")
      updateTextInput(session, paste0("bib_", i, "_link"), value = "")
      updateNumericInput(session, paste0("bib_", i, "_ejemplares"), value = 0)
      updateNumericInput(session, paste0("bib_", i, "_anio"), value = 0)
    })

    numeric_ids <- c(
      "cb_presencial", "cb_distancia", "tb_presencial", "tb_distancia",
      "ta_presencial", "ta_distancia", "ctc_presencial", "ctc_distancia",
      "otros_presencial", "otros_distancia", "carga_total_presencial", "carga_total_distancia",
      "practicas_supervisadas_presencial", "practicas_supervisadas_distancia",
      "proyecto_integrador_presencial", "proyecto_integrador_distancia",
      "practica_profesional_presencial", "practica_profesional_distancia",
      "carga_horaria_total_practica_presencial", "carga_horaria_total_practica_distancia",
      "carga_horaria_semanal_total_presencial", "carga_horaria_semanal_total_distancia",
      "carga_horaria_semanal_practica_presencial", "carga_horaria_semanal_practica_distancia",
      "aux_menor_9", "aux_10_19", "aux_20_29", "aux_30_39", "aux_40_mas",
      "otro_menor_9", "otro_10_19", "otro_20_29", "otro_30_39", "otro_40_mas",
      "design_contratados", "design_regular_rentado", "design_regular_honorem",
      "design_interino_rentado", "design_interino_honorem",
      "alumnos_2023", "alumnos_2024", "alumnos_2025", "alumnos_2026", "alumnos_2027", "alumnos_2028", "alumnos_2029", "alumnos_2030",
      "examen_2023", "examen_2024", "examen_2025", "examen_2026", "examen_2027", "examen_2028", "examen_2029", "examen_2030"
    )

    lapply(numeric_ids, function(id) {
      updateNumericInput(session, id, value = 0)
    })

    vals$status <- "Formulario limpiado."
  })

  save_record <- function(registro) {
    if (!nzchar(SHEET_URL) || grepl("TU_ID_DE_TU_SHEET", SHEET_URL)) {
      stop("Debes configurar una URL válida de Google Sheets.")
    }

    sheet_name <- "Respuestas"

    exists_sheet <- tryCatch({ read_sheet(SHEET_URL, sheet = sheet_name); TRUE }, error = function(e) FALSE)

    if (!exists_sheet) {
      blank_df <- as.data.frame(registro[0, , drop = FALSE])
      sheet_write(blank_df, ss = SHEET_URL, sheet = sheet_name)
    }

    sheet_append(SHEET_URL, data = registro, sheet = sheet_name)
  }

  observeEvent(input$guardar, {
    required <- c("denominacion", "programa_analitico")
    missing <- required[sapply(required, function(x) is.null(input[[x]]) || trimws(input[[x]]) == "")]

    if (length(missing) > 0) {
      vals$status <- "Faltan campos obligatorios: actividad curricular y nombre del programa analítico."
      return()
    }

    registro <- data.frame(
      timestamp = as.character(Sys.time()),
      denominacion = input$denominacion,
      carreras_2023 = input$carreras_2023,
      carreras_2026 = input$carreras_2026,
      programa_analitico = input$programa_analitico,
      stringsAsFactors = FALSE
    )

    for (i in seq_along(EJES)) {
      registro[[paste0("eje_", i)]] <- input[[paste0("eje_", i)]]
    }

    numeric_fields <- c(
      "cb_presencial", "cb_distancia", "tb_presencial", "tb_distancia",
      "ta_presencial", "ta_distancia", "ctc_presencial", "ctc_distancia",
      "otros_presencial", "otros_distancia", "carga_total_presencial", "carga_total_distancia",
      "practicas_supervisadas_presencial", "practicas_supervisadas_distancia",
      "proyecto_integrador_presencial", "proyecto_integrador_distancia",
      "practica_profesional_presencial", "practica_profesional_distancia",
      "carga_horaria_total_practica_presencial", "carga_horaria_total_practica_distancia",
      "carga_horaria_semanal_total_presencial", "carga_horaria_semanal_total_distancia",
      "carga_horaria_semanal_practica_presencial", "carga_horaria_semanal_practica_distancia"
    )

    for (field in numeric_fields) {
      registro[[field]] <- input[[field]]
    }

    registro$ambitos_practica <- input$ambitos_practica

    for (i in 1:8) {
      registro[[paste0("bib_", i, "_titulo")]] <- input[[paste0("bib_", i, "_titulo")]]
      registro[[paste0("bib_", i, "_autores")]] <- input[[paste0("bib_", i, "_autores")]]
      registro[[paste0("bib_", i, "_editorial")]] <- input[[paste0("bib_", i, "_editorial")]]
      registro[[paste0("bib_", i, "_ejemplares")]] <- input[[paste0("bib_", i, "_ejemplares")]]
      registro[[paste0("bib_", i, "_link")]] <- input[[paste0("bib_", i, "_link")]]
      registro[[paste0("bib_", i, "_anio")]] <- input[[paste0("bib_", i, "_anio")]]
    }

    docentes_fields <- c(
      "aux_menor_9", "aux_10_19", "aux_20_29", "aux_30_39", "aux_40_mas",
      "otro_menor_9", "otro_10_19", "otro_20_29", "otro_30_39", "otro_40_mas",
      "design_contratados", "design_regular_rentado", "design_regular_honorem",
      "design_interino_rentado", "design_interino_honorem"
    )

    for (field in docentes_fields) {
      registro[[field]] <- input[[field]]
    }

    for (anio in 2023:2030) {
      registro[[paste0("alumnos_", anio)]] <- input[[paste0("alumnos_", anio)]]
      registro[[paste0("examen_", anio)]] <- input[[paste0("examen_", anio)]]
    }

    registro$autoeval_10_1 <- input$autoeval_10_1
    registro$autoeval_10_2 <- input$autoeval_10_2
    registro$autoeval_10_3 <- input$autoeval_10_3
    registro$autoeval_10_4 <- input$autoeval_10_4
    registro$otra_informacion <- input$otra_informacion

    tryCatch({
      save_record(registro)
      vals$status <- "Datos guardados correctamente en Google Sheets."
    }, error = function(e) {
      vals$status <- paste("No se pudo guardar la información:", conditionMessage(e))
    })
  })
}

shinyApp(ui = ui, server = server)
