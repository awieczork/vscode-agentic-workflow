#' @title {MODULE_TITLE} Module Server
#' @description Server logic for the {MODULE_NAME} module.
#'
#' @param id Character string. The module namespace ID (must match UI).
#'
#' @return A reactive value or NULL. Modules can return values for
#'   cross-module communication.
#'
#' @examples
#' \dontrun{
#' mod_{MODULE_NAME}_server("my_id")
#' }
#'
#' @export
mod_{MODULE_NAME}_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    # Namespace function for programmatic ID generation
    ns <- session$ns

    # -------------------------------------------------------------------------
    # Reactive Values
    # -------------------------------------------------------------------------
    rv <- reactiveValues(
      data = NULL,
      state = "idle"
    )

    # -------------------------------------------------------------------------
    # Observers
    # -------------------------------------------------------------------------
    observeEvent(input$submit_btn, {
      # TODO: Handle submit button click
      rv$state <- "processing"

      # Example: Process input
      rv$data <- input$text_input

      rv$state <- "complete"
    })

    # -------------------------------------------------------------------------
    # Outputs
    # -------------------------------------------------------------------------
    output$dynamic_content <- renderUI({
      req(rv$data)

      # TODO: Render dynamic content based on state
      tagList(
        tags$p(
          class = "text-success",
          paste("Received:", rv$data)
        )
      )
    })

    # -------------------------------------------------------------------------
    # Return Value (for cross-module communication)
    # -------------------------------------------------------------------------
    # Return reactive values or functions that parent modules can access
    return(
      list(
        data = reactive({ rv$data }),
        state = reactive({ rv$state })
      )
    )
  })
}
