# Setting a backfile
source("./dev/01_initial_settings.R")

# Pulling metadata from the API
meta <- EIAapi::eia_metadata(api_key = api_key, api_path = api_path)
start <- lubridate::ymd_h(meta$startPeriod, tz = "UTC")
end <- lubridate::ymd_h(meta$endPeriod, tz = "UTC")

# Backfill ----
back_fill_names <- paste(mapping$parent_id, mapping$subba_id, sep = "_")
back_fill <- lapply(1:nrow(mapping), function(i) {
    t <- Sys.time()
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

    meta <- data.frame(
        parent = parent,
        subba = subba,
        time = t,
        start = start,
        end = end,
        start_act = min(df$time),
        end_act = max(df$time),
        start_match = ifelse(start == min(df$time), TRUE, FALSE),
        end_match = ifelse(end == max(df$time), TRUE, FALSE),
        n_obs = nrow(df),
        na = sum(is.na(df$value)),
        type = "backfill"
    )

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

# Save the data ----
# Save data as csv file
write.csv(data, "./csv/ciso_grid.csv", row.names = FALSE)
# Save log
saveRDS(meta, file = "./metadata/ciso_log.RDS")