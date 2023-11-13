#' Creating Metadata Table
#' @description The function creates metadata table for the refresh dataset
#' @param input The returned object from the eia_backfill function
#' @param start The start time or date used with the eia_backfill function
#' @param end The end time or date used with the eia_backfill function
#' @param type The type of work - c("backfill", "refresh")
#' @return a metadata table

create_metadata <- function(input, start, end, type) {
    # Error handling
    if (type != "backfill" && type != "refresh") {
        stop("The type argument is not valid")
    } else if (!lubridate::is.POSIXt(start) && !lubridate::is.Date(start)) {
        stop("The start argument is not valid time or date object")
    } else if (!lubridate::is.POSIXt(end) && !lubridate::is.Date(end)) {
        stop("The end argument is not valid time or date object")
    }

    parent <- unique(input$parent)
    subba <- unique(input$subba)


    meta <- data.frame(
        parent = parent,
        subba = subba,
        time = Sys.time(),
        start = start,
        end = end,
        start_act = min(input$time),
        end_act = max(input$time),
        start_match = ifelse(start == min(input$time), TRUE, FALSE),
        end_match = ifelse(end == max(input$time), TRUE, FALSE),
        n_obs = nrow(input),
        na = sum(is.na(input$value)),
        type = type
    )

    return(meta)
}