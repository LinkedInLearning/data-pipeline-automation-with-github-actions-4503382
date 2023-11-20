# Load functions and settings
source("./dev/00_functions.R")
source("./dev/02_initial_settings.R")

# Load metadata

meta_log <- readRDS(file = "./metadata/ciso_log.RDS")

meta_df <- meta_log |>
    dplyr::filter(success) |>
    dplyr::filter(index == max(index))


meta_new <- metadata_tamplate()


str(meta_new)
index <- max(meta_df$index)

# Pulling metadata from the API
meta <- EIAapi::eia_metadata(api_key = api_key, api_path = api_path)
end_api <- lubridate::ymd_h(meta$endPeriod, tz = "UTC")

# Check if new data is available
mapping_df <- mapping |>
    dplyr::mutate(status = FALSE) |>
    dplyr::left_join(meta_df |> dplyr::select(parent_id = parent, subba_id = subba, end_act), by = c("parent_id", "subba_id"))


# Checking if new data is available

for (i in 1:nrow(mapping_df)) {
    parent_id <- mapping_df$parent_id[i]
    subba_id <- mapping_df$subba_id[i]
    end <- mapping_df$end_act[i]
    start <- end + lubridate::hours(1)
    if (end_api > start) {
        mapping_df$status[i] <- TRUE
    }
}

# If new data available
if (any(mapping_df$status)) {
    mapping_success <- mapping_df |> dplyr::filter(status)

    data_refresh <- lapply(1:nrow(mapping_success), function(i) {
        parent <- mapping_success$parent_id[i]
        subba <- mapping_success$subba_id[i]
        start <- mapping_success$end_act[i] + lubridate::hours(1)


        df <- EIAapi::eia_backfill(
            start = start,
            end = end_api,
            offset = offset,
            api_key = api_key,
            api_path = paste(api_path, "data", sep = ""),
            facets = list(parent = parent, subba = subba)
        )

        meta <- create_metadata(input = df, start = start, end = end_api, type = "refresh")
        meta$index[1] <- index + 1



        if (meta$start_match[1] && meta$end_match[1] && meta$na[1] == 0 && meta$n_obs[1] > 0) {
            meta$update[1] <- TRUE
            meta$success[1] <- TRUE
        } else {
            meta$update[1] <- FALSE
            meta$success[1] <- FALSE
        }

        output <- list(data = df, meta = meta)
    })


    # Parse the backfill output
    data_new <- lapply(data_refresh, function(i) {
        d <- i$data
        return(d)
    }) |>
        dplyr::bind_rows()
    meta_temp <- NULL
    meta_temp <- lapply(data_refresh, function(i) {
        m <- i$meta
        return(m)
    }) |>
        dplyr::bind_rows()

    meta_new <- rbind(meta_new, meta_temp)
}


# No new data is available

if (any(!mapping_df$status)) {
    mapping_no_success <- mapping_df |> dplyr::filter(!status)
    meta_temp <- NULL
    meta_temp <- lapply(1:nrow(mapping_no_success), function(i) {
        temp <- NULL
        temp <- data.frame(
            index = index + 1,
            parent = mapping_no_success$parent_id[i],
            subba = mapping_no_success$subba_id[i],
            time = Sys.time(),
            update = FALSE,
            success = FALSE,
            comments = "No updates available"
        )

        return(temp)
    })

    meta_new <- dplyr::bind_rows(meta_new, meta_temp)
}


if (any(meta_new$success) && nrow(data_new) > 0) {
    data <- readr::read_csv("./csv/ciso_grid.csv",
        col_types = list(
            time = readr::col_datetime(format = ""),
            subba = readr::col_character(),
            subba_name = readr::col_character(),
            parent = readr::col_character(),
            parent_name = readr::col_character(),
            value = readr::col_integer(),
            value_units = readr::col_character()
        )
    ) |>
        dplyr::bind_rows(data_new)

    # Save the data ----
    # Save data as csv file
    print("Append and save the data to CSV file")
    write.csv(data, "./csv/ciso_grid.csv", row.names = FALSE)
}

if (nrow(meta_new) > 0) {
    # Save log
    print("Saving the metadata")
    meta_new <- rbind(meta_log, meta_new)
    print(meta_new)
    saveRDS(meta_new, file = "./metadata/ciso_log.RDS")
}