library(dplyr)
rm(list = ls())
setwd("~/Downloads/Arpit Study /Spring 19 Classes/Practicum/Data Folder/Final")
# Reading the file for Dallas Geoids
dallas_geoids <- read_csv("Dallas_geoids.csv", col_types = cols(geoid = col_character()))

tx_wac_SE01 <- read_csv("tx_wac_SE01_JT00_2015.csv", col_types = cols(w_geocode = col_character()))
tx_wac_SE02 <- read_csv("tx_wac_SE02_JT00_2015.csv", col_types = cols(w_geocode = col_character()))
tx_wac_SE03 <- read_csv("tx_wac_SE03_JT00_2015.csv", col_types = cols(w_geocode = col_character()))


tx_wac_SE01$w_geocode <- substr(tx_wac_SE01$w_geocode, 1,12)
tx_wac_SE02$w_geocode <- substr(tx_wac_SE02$w_geocode, 1,12)
tx_wac_SE03$w_geocode <- substr(tx_wac_SE03$w_geocode, 1,12)

tx_wac_SE01_final <-  tx_wac_SE01 %>% group_by(w_geocode) %>% summarise(Jobs = sum(C000))
tx_wac_SE02_final <-  tx_wac_SE02 %>% group_by(w_geocode) %>% summarise(Jobs = sum(C000))
tx_wac_SE03_final <-  tx_wac_SE03 %>% group_by(w_geocode) %>% summarise(Jobs = sum(C000))

# Filtering the geoids for dallas only.
dallas_wac_SE01_final <- tx_wac_SE01_final[tx_wac_SE01_final$w_geocode %in% dallas_geoids$geoid,]
dallas_wac_SE02_final <- tx_wac_SE02_final[tx_wac_SE02_final$w_geocode %in% dallas_geoids$geoid,]
dallas_wac_SE03_final <- tx_wac_SE03_final[tx_wac_SE03_final$w_geocode %in% dallas_geoids$geoid,]

total_job_SE01 <- sum(dallas_wac_SE01_final$Jobs)
total_job_SE02 <- sum(dallas_wac_SE02_final$Jobs)
total_job_SE03 <- sum(dallas_wac_SE03_final$Jobs)

# reading the file obtained from OTP
# merging with 30 min travel time file.
travel_30min <- read_csv("travel_time_30min_transit.csv", col_types = cols(destination = col_character(), origin = col_character()))
travel_30min$X1 <- NULL

travel_30min_Jobs_SE01 <- merge(dallas_wac_SE01_final, travel_30min, by.x = "w_geocode", by.y = "destination")
travel_30min_Jobs_SE02 <- merge(dallas_wac_SE02_final, travel_30min, by.x = "w_geocode", by.y = "destination")
travel_30min_Jobs_SE03 <- merge(dallas_wac_SE03_final, travel_30min, by.x = "w_geocode", by.y = "destination")

#nrow(travel_30min_Jobs_SE01)
travel_30min_Jobs_SE01 <- travel_30min_Jobs_SE01[which(travel_30min_Jobs_SE01$travel_time <= 1800),]
travel_30min_Jobs_SE02 <- travel_30min_Jobs_SE02[which(travel_30min_Jobs_SE02$travel_time <= 1800),]
travel_30min_Jobs_SE03 <- travel_30min_Jobs_SE03[which(travel_30min_Jobs_SE03$travel_time <= 1800),]

#nrow(travel_30min_Jobs_SE01)

final_SE01 <- travel_30min_Jobs_SE01 %>% group_by(origin) %>% summarise(Jobs = sum(Jobs))
final_SE02 <- travel_30min_Jobs_SE02 %>% group_by(origin) %>% summarise(Jobs = sum(Jobs))
final_SE03 <- travel_30min_Jobs_SE03 %>% group_by(origin) %>% summarise(Jobs = sum(Jobs))


final_SE01["%_accesible"] <- (final_SE01$Jobs/total_job_SE01)*100
final_SE02["%_accesible"] <- (final_SE02$Jobs/total_job_SE02)*100
final_SE03["%_accesible"] <- (final_SE03$Jobs/total_job_SE03)*100

write_csv(final_SE01, "Dallas_30min_SE01.csv")
write_csv(final_SE02, "Dallas_30min_SE02.csv")
write_csv(final_SE03, "Dallas_30min_SE03.csv")

# merging with 60 min travel time file.

travel_60min <- read_csv("travel_time_60min_transit.csv", col_types = cols(destination = col_character(), origin = col_character()))
travel_60min$X1 <- NULL

travel_60min_Jobs_SE01 <- merge(dallas_wac_SE01_final, travel_60min, by.x = "w_geocode", by.y = "destination")
travel_60min_Jobs_SE02 <- merge(dallas_wac_SE02_final, travel_60min, by.x = "w_geocode", by.y = "destination")
travel_60min_Jobs_SE03 <- merge(dallas_wac_SE03_final, travel_60min, by.x = "w_geocode", by.y = "destination")

#nrow(travel_60min_Jobs_SE01)
travel_60min_Jobs_SE01 <- travel_60min_Jobs_SE01[which(travel_60min_Jobs_SE01$travel_time <= 3600),]
travel_60min_Jobs_SE02 <- travel_60min_Jobs_SE02[which(travel_60min_Jobs_SE02$travel_time <= 3600),]
travel_60min_Jobs_SE03 <- travel_60min_Jobs_SE03[which(travel_60min_Jobs_SE03$travel_time <= 3600),]

#nrow(travel_60min_Jobs_SE01)

final_SE01_60min <- travel_60min_Jobs_SE01 %>% group_by(origin) %>% summarise(Jobs = sum(Jobs))
final_SE02_60min <- travel_60min_Jobs_SE02 %>% group_by(origin) %>% summarise(Jobs = sum(Jobs))
final_SE03_60min <- travel_60min_Jobs_SE03 %>% group_by(origin) %>% summarise(Jobs = sum(Jobs))


final_SE01_60min["%_accesible"] <- (final_SE01_60min$Jobs/total_job_SE01)*100
final_SE02_60min["%_accesible"] <- (final_SE02_60min$Jobs/total_job_SE02)*100
final_SE03_60min["%_accesible"] <- (final_SE03_60min$Jobs/total_job_SE03)*100

write_csv(final_SE01_60min, "Dallas_60min_SE01.csv")
write_csv(final_SE02_60min, "Dallas_60min_SE02.csv")
write_csv(final_SE03_60min, "Dallas_60min_SE03.csv")


### Now after getting these please open Tablue and proceed with visualizations. Cheers!!
