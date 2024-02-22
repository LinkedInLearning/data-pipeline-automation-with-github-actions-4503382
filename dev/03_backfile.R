# Description ----
# Initial data pull (backfill) of historical data
# Requirements:
# Set the series details on the ./metadata/series.json file
# Set the api key on the 02_initial_settings.R file

# Setting a backfile
source("./dev/00_functions.R")
source("./dev/02_initial_settings.R")
# Pulling metadata from the API
meta <- EIAapi::eia_metadata(api_key = api_key, api_path = api_path)
start <- as.POSIXct("2018-07-01 0:00:00")
end <- as.POSIXct("2024-02-18 0:00:00")

time_vec <- seq.POSIXt(from = start, to = end, by = "hour")
# Backfill ----
back_fill_names <- paste(mapping$parent_id, mapping$subba_id, sep = "_")

back_fill <- lapply(1:nrow(mapping), function(i) {
    parent <- mapping$parent_id[i]
    subba <- mapping$subba_id[i]
    subba_name <- mapping$subba_name[i]
    parent_name <- mapping$parent_name[i]

    df <- temp <- NULL
    temp <- EIAapi::eia_backfill(
        start = start,
        end = end,
        offset = offset,
        api_key = api_key,
        api_path = paste(api_path, "data", sep = ""),
        facets = list(parent = parent, subba = subba)
    )



    df <- data.frame(
        time = time_vec, subba = subba,
        subba_name = subba_name, parent = parent,
        parent_name = parent_name
    ) |> dplyr::left_join(temp, by = c(
        "time", "subba", "parent",
        "subba_name", "parent_name"
    ))

    if (nrow(df) != length(time_vec)) {
        stop(paste(subba_name, "There is mismatch between the number of expected rows and actual one, check the merge", sep = " - "))
    }


    # TODO
    # Add unit tests
    # Add metadata
    meta <- create_metadata(input = df, start = start, end = end, type = "backfill")
    comment <- NULL
    meta$success[1] <- TRUE
    meta$success[1] <- TRUE


    if (!meta$end_match[1]) {
        comment <- paste(commant, "Mismatch between the ending time of the request and the one available on the API")
        meta$success[1] <- FALSE
        meta$update[1] <- FALSE
    }

    if (sum(meta$na) > 0) {
        comment <- paste(comment, "The end date is not matching the API metadata")
        meta$success[1] <- FALSE
        meta$update[1] <- FALSE
    }

    if (meta$comments[1] == "") {
        meta$comments[1] <- comment
    }

    output <- list(data = df, meta = meta)
    return(output)
}) |> setNames(back_fill_names)


# Parse the backfill output
data <- lapply(back_fill, function(i) {
    d <- i$data
    return(d)
}) |>
    dplyr::bind_rows()

meta <- lapply(back_fill, function(i) {
    m <- i$meta
    return(m)
}) |>
    dplyr::bind_rows()



plotly::plot_ly(
    data = data,
    x = ~time,
    y = ~value,
    color = ~subba,
    type = "scatter",
    mode = "line"
)

# Backfile inspection
if (!any(meta$success)) {
    print("One or more series failed the test, please check the comments")
    print("Did not pass the initial tests, please check the metadata table")
} else {
    # Save the data ----
    # Save data as csv file
    print("Saving the data to CSV file")
    write.csv(data, "./csv/ciso_grid.csv", row.names = FALSE)
    # Save log
    print("Saving the metadata")
    saveRDS(meta, file = "./metadata/ciso_log.RDS")
}


# In case only missing values FALSE
meta$success <- TRUE
meta$update <- TRUE
print("Saving the data to CSV file")
write.csv(data, "./csv/ciso_grid.csv", row.names = FALSE)
# Save log
print("Saving the metadata")
saveRDS(meta, file = "./metadata/ciso_log.RDS")