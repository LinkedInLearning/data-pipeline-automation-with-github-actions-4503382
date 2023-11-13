# Create mapping of parrent and sub regions
api_key <- Sys.getenv("EIA_API_KEY")
api_path <- "electricity/rto/region-sub-ba-data/"

parent_meta <- EIAapi::eia_metadata(api_key = api_key, api_path = paste(api_path, "facet/parent", sep = ""))
parent <- parent_meta$facets
names(parent) <- paste0("parent_", names(parent), sep = "")


subba_meta <- EIAapi::eia_metadata(api_key = api_key, api_path = paste(api_path, "facet/subba", sep = ""))
subba <- subba_meta$facets
names(subba) <- paste0("subba_", names(subba), sep = "")

subba$parent_id <- NA
head(subba)

for (i in 1:nrow(subba)) {
    e <- 1
    e <- unlist(gregexpr(pattern = ":", text = subba$subba_alias[i]))
    subba$parent_id[i] <- substr(x = subba$subba_alias[i], start = 1, stop = e - 1)
}

print(head(subba))

table(is.na(subba$parent_id))
all(unique(subba$parent_id) %in% unique(parent$parent_id))



mapping_table <- subba |>
    dplyr::left_join(parent, by = c("parent_id")) |>
    dplyr::select(parent_name, parent_id, subba_name, subba_id, subba_alias)

head(mapping_table)