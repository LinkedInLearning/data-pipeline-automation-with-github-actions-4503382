#' Create a Metadata data.frame Template
#' @description The function creates a template metadata data.frame
#' @return An empty data.frame

metadata_tamplate <- function() {
    metadata_template <- data.frame(
        index = integer(),
        parent = character(),
        subba = character(),
        time = lubridate::POSIXct(),
        start = lubridate::POSIXct(),
        end = lubridate::POSIXct(),
        start_act = lubridate::POSIXct(),
        end_act = lubridate::POSIXct(),
        start_match = logical(),
        end_match = logical(),
        n_obs = integer(),
        na = integer(),
        type = character(),
        update = logical(),
        success = logical(),
        comments = character()
    )

    return(metadata_template)
}


create_metadata <- function(data, start, end, type) {
    meta <- metadata_tamplate()
    if (!is.null(data)) {
        meta$parent <- unique(data$parent)
        meta$subba <- unique(data$subba)
        meta$start_act <- min(data$period)
        meta$start_match <- ifelse(min(data$period) == start, TRUE, FALSE)
        meta$end_act <- max(data$period)
        meta$end_match <- ifelse(min(data$period) == end, TRUE, FALSE)
        meta$n_obs <- nrow(data)
        meta$na <- sum(is.na(data$value))
        if (meta$start_match && meta$end_match && type == "refresh" && meta$na == 0) {
            meta$success <- TRUE
        } else {
            meta$success <- FALSE
        }

        if (!meta$start_match) {
            meta$comments <- paste(meta$comments, "The start argument does not match the actual; ", sep = "")
        }

        if (!meta$end_match) {
            meta$comments <- paste(meta$comments, "The end argument does not match the actual; ", sep = "")
        }

        if (meta$na != 0) {
            meta$comments <- paste(meta$comments, "Missing values were found; ", sep = "")
        }
    } else {
        meta$comments <- paste(meta$comments, "No new data is available; ", sep = "")
    }
}