# Settings file

series_json <- jsonlite::read_json(path = "./metadata/series.json")
series <- series_json[[1]]
api_path <- series_json[[2]]
mapping <- lapply(1:length(series), function(i) {
    return(data.frame(
        parent_id = series[[i]]$parent_id,
        parent_name = series[[i]]$parent_name,
        subba_id = series[[i]]$subba_id,
        subba_name = series[[i]]$subba_name
    ))
}) |>
    dplyr::bind_rows()

api_key <- Sys.getenv("EIA_API_KEY")
if (api_key == "") {
    api_key <- Sys.getenv("API_KEY")
}

offset <- 24 * 30 * 3