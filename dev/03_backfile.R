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
start <- lubridate::ymd_h(meta$startPeriod, tz = "UTC")
end <- lubridate::ymd_h(meta$endPeriod, tz = "UTC") - lubridate::hours(10)

# Backfill ----
back_fill_names <- paste(mapping$parent_id, mapping$subba_id, sep = "_")

back_fill <- lapply(1:nrow(mapping), function(i) {
    parent <- mapping$parent_id[i]
    subba <- mapping$subba_id[i]

    df <- EIAapi::eia_backfill(
        start = start,
        end = end,
        offset = offset,
        api_key = api_key,
        api_path = paste(api_path, "data", sep = ""),
        facets = list(parent = parent, subba = subba)
    )

    # TODO
    # Add unit tests
    # Add metadata
    meta <- create_metadata(input = df, start = start, end = end, type = "backfill")

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
if (all(meta$end_match) && sum(meta$na) == 0) {
    meta$success <- TRUE
    meta$update <- TRUE

    meta$comments <- ifelse(meta$start != meta$start_act, "Series start date does not match API metadata", meta$comments)
    # Save the data ----
    # Save data as csv file
    print("Saving the data to CSV file")
    write.csv(data, "./csv/ciso_grid.csv", row.names = FALSE)
    # Save log
    print("Saving the metadata")
    saveRDS(meta, file = "./metadata/ciso_log.RDS")
} else {
    print("Did not pass the initial tests, please check the metadata table")
}