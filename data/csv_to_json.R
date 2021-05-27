library(jsonlite)
library(tidyverse)
library(countrycode)
r <- read_csv("country_share.csv")
r$iso3 <- countrycode(r$country, origin="country.name", destination="iso3c")
jsonlite::write_json(r, "country_share.json")



fileConn<-file("country_share.js")
writeLines(sprintf("var country_share=`%s`",jsonlite::toJSON(r)),fileConn)
close(fileConn)
