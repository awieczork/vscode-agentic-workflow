#' @title {MODULE_TITLE} Module UI
#' @description UI component for the {MODULE_NAME} module.
#'
#' @param id Character string. The module namespace ID.
#'
#' @return A tagList containing the module UI elements.
#'
#' @examples
#' \dontrun{
#' mod_{MODULE_NAME}_ui("my_id")
#' }
#'
#' @export
mod_{MODULE_NAME}_ui <- function(id) {
  ns <- NS(id)


  tagList(
    # Module container with bslib card
    bslib::card(
      bslib::card_header(
        "{MODULE_TITLE}"
      ),
      bslib::card_body(
        # TODO: Add your UI components here
        # Use ns() to namespace all input/output IDs

        # Example input
        shiny::textInput(
          inputId = ns("text_input"),
          label = "Enter text:",
          placeholder = "Type here..."
        ),

        # Example output placeholder
        shiny::uiOutput(ns("dynamic_content"))
      ),
      bslib::card_footer(
        # Optional footer content
        shiny::actionButton(
          inputId = ns("submit_btn"),
          label = "Submit",
          class = "btn-primary"
        )
      )
    )
  )
}
