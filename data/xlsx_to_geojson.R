library(jsonlite)
library(dplyr)
library(sf)
setwd("~/development/crea/studies/202105_overcapacity_indonesia_map/data/")
r <- readxl::read_xlsx("latest_results.xlsx")
r$`FOM (MM USD)` <- r$`FOM ($)`/1e6
r$`Overcapacity (MW)` <- r$`Capacity (MW)`


plant_id_cols <- c("Country", "Subnational unit (province, state)", "Plant", "Sponsor", "Parent", "Location", "ParentID")
r <- r %>%
	group_by_at(plant_id_cols) %>%
	summarise_at(c("Overcapacity (MW)", "FOM (MM USD)"), sum) %>%
	left_join(r %>% group_by_at(plant_id_cols) %>% summarise_at(c("Longitude","Latitude"), mean))


file.remove("units.geojson")
r %>%
  filter(!is.na(Longitude)) %>%
  sf::st_as_sf(coords=c("Longitude","Latitude")) %>%
  sf::st_write("units.geojson", overwrite=T)

