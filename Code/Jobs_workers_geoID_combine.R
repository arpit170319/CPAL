#The working directory should be set to a folder containing the Open Trip Planner output
setwd("D:/Spring_19/Practicum/Material/OTP/Transit_30min")

#Create a vector listing the names of all the csv files exported from OTP
file_names = dir()

#Create a very large dataframe, combining all of the csv files exported from OTP.
#This took about 20 minutes to process.
otpdata091515 <- do.call(rbind,lapply(file_names,read.csv))

#Import 2014 Census LED Data
leddata2014 <- read.csv("D:/Spring_19/Practicum/Material/Data/Jobs_Final.csv")
#Merge Open trip planner output with census jobs data
#Required more than 8 hours
alldata091515 <- merge(otpdata091515, leddata2014, by.y = "w_geocode", by.x = "destination")
#Create a new table with only the rows which have a travel time of under 1,800 seconds (30 minutes)
#Less than 2 hours
alldata091515U30 = alldata091515[which(alldata091515$travel_time<1800),]
alldata091515U30_filtered <- alldata091515U30[c(1,4,7)]

write.csv(alldata091515U30_filtered, file = "D:/Spring_19/Practicum/Material/Data/origin_dest_jobs.csv")

workers <- read.csv("D:/Spring_19/Practicum/Material/Data/Labour_Dallas_County_1.csv")
workers_fil <- workers[c(1,3)]
colnames(workers_fil) <- c("GeoID", "Workers")

merged_data <- merge(workers_fil, alldata091515U30_filtered, by.x = "GeoID", by.y = "origin")

library(dplyr)
DataGroup = group_by(merged_data, GeoID)

write.csv(DataGroup, file = "D:/Spring_19/Practicum/Material/Data/origin_dest_jobs_worker.csv")

#Install "dplyer" package
#library("dplyr", lib.loc="/Library/Frameworks/R.framework/Versions/3.3/Resources/library")
#Create a new table identical to previous, but grouped by trip "origin"
library(dplyr)
DataGroup = group_by(alldata091515U30, origin)
#Create a new table based on the sum of the number of jobs for which the travel time is under 30
#minutes
Final = summarise(DataGroup, Jobs=sum(Jobs, na.rm = TRUE))
Final = mutate(Final, Jobs = Jobs/2)

write.csv(Final, file = "D:/Spring_19/Practicum/Material/Data/Jobs_Accessable.csv")
