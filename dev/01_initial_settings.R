# Settings file

series <- jsonlite::read_json(path = "./metadata/series.json")[[1]]
mapping <- lapply(1:length(series), function(i) {
    return(data.frame(parent_id = series[[i]]$parent_id, subba_id = series[[i]]$subba_id))
}) |>
    dplyr::bind_rows()

api_path <- "electricity/rto/region-sub-ba-data/data"
api_meta_path <- "electricity/rto/region-sub-ba-data/"
api_key <- Sys.getenv("EIA_API_KEY")
offset <- 24 * 30 * 3