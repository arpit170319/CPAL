setwd("D:/Spring_19/Practicum/Material/OTP")
library(dplyr)
file1 <- read.csv("points.csv")

Geo_Ids <- file1[c(1)]

WAC_TX_2015$w_geocode <- substr(WAC_TX_2015$w_geocode, 1, 12)

DataGroup = group_by(WAC_TX_2015, w_geocode)
Final = summarise(DataGroup, Jobs=sum(C000, na.rm = TRUE))

Filtered_Geo_Id <- merge(Final, Geo_Ids, by.x = "w_geocode", by.y = "geoid")

write.csv(Filtered_Geo_Id, file = "D:/Spring_19/Practicum/Material/Data/Jobs_Final.csv")

setwd("D:/Spring_19/Practicum/Material/Data")
file7 <- read.csv("Jobs_Accessable.csv")
file3 <- read.csv("Labour_Dallas_County_1.csv")
file4 <- file3[c(1,3)]
colnames(file4) <- c("GeoID", "Workers")

merged_jobs_workers <- merge(file4, file7, by.x = "GeoID", by.y = "origin")
