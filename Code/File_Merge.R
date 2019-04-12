test <- read.csv("D:/Spring_19/Practicum/Material/Data/Workers.csv",  colClasses = "character")
test$GeoId <- paste(test$state,test$county, test$tract, test$block.group, sep = "")
test$workforce <- as.numeric(test$workforce)
head(test)
test$X0 <- NULL
test$state <- NULL
test$county <- NULL
test$tract <- NULL
test$block.group <- NULL
write.csv(test, file = "D:/Spring_19/Practicum/Material/Data/Worker_geoid.csv")