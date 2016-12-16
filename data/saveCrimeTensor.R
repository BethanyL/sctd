# use Houston crime data, included as part of the ggmap package

library(ggmap)

# We obtained this csv file from the Houston Police Beats page of the City of Houston GIS Open Data web site
# http://cohgis.mycity.opendata.arcgis.com/
beats_table <- read.csv(file="Houston_Police_Beats.csv",head=TRUE,sep=",")
colnames(beats_table)[1] = "Beats"

# reorder the beats so that we can map them later 
beat_ordering <- beats_table$Beats
plottable_crimes = subset(crime, beat%in% beat_ordering)

tensor = table(plottable_crimes[, c("hour", "beat", "offense")])
tensor = tensor[,setdiff(beat_ordering,'24C60'),]

write.csv(tensor[,,1], 'hour-by-beat_AggravatedAssault2.csv')
write.csv(tensor[,,2], 'hour-by-beat_AutoTheft2.csv')
write.csv(tensor[,,3], 'hour-by-beat_Burglary2.csv')
write.csv(tensor[,,4], 'hour-by-beat_Murder2.csv')
write.csv(tensor[,,5], 'hour-by-beat_Rape2.csv')
write.csv(tensor[,,6], 'hour-by-beat_Robbery2.csv')
write.csv(tensor[,,7], 'hour-by-beat_Theft2.csv')
