library(jsonlite)
library(dplyr)
library(sf)
setwd("~/development/crea/studies/202105_overcapacity_indonesia_map/data/")
r <- readxl::read_xlsx("05202021_overcapacity_results.xlsx")
r$`Overcapacity costs (MM USD)` <- r$`Overcapacity costs (USD)`/1e6

plant_id_cols <- c("Country", "Subnational unit (province, state)", "Plant", "Sponsor", "Parent", "Location")
r <- r %>%
	group_by_at(plant_id_cols) %>%
	summarise_at(c("Capacity (MW)", "Overcapacity (MW)", "Refurbishment cost ($/kW)",
		"Overcapacity costs (USD)", "Overcapacity costs (MM USD)"), sum) %>%
	left_join(r %>% group_by_at(plant_id_cols) %>% summarise_at(c("Longitude","Latitude"), mean))


file.remove("units.geojson")
r %>%
  filter(!is.na(Longitude)) %>%
  sf::st_as_sf(coords=c("Longitude","Latitude")) %>%
  sf::st_write("units.geojson", overwrite=T)

