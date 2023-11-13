# Settings file

series_json <- jsonlite::read_json(path = "./metadata/series.json")
series <- series_json[[1]]
api_path <- series_json[[2]]
mapping <- lapply(1:length(series), function(i) {
    return(data.frame(parent_id = series[[i]]$parent_id, subba_id = series[[i]]$subba_id))
}) |>
    dplyr::bind_rows()

api_key <- Sys.getenv("EIA_API_KEY")
offset <- 24 * 30 * 3