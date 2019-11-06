library(tidyverse)


# the data for all CSIRO travellers within a set time period 
# has been taken from the compass site and saved to the data folder as CompassReport.csv

# CompassReport.csv is assigned to a variable "compass"
compass <- read.csv("data/CompassReport.csv")

# select useful rows for the table
CompassColumns <- select(compass, Traveller.Name,Departure.Date,Return.Date,Cost.Object,Line.Manager.Name,Endorser.Name,Status,Base.Contacts,Country,City,Segment.Start.Date,Segment.End.Date)

#convert data formats so that they can be sorted later on
CompassColumns$Departure.Date <- as.Date(CompassColumns$Departure.Date, format = "%d/%m/%Y")
CompassColumns$Return.Date <- as.Date(CompassColumns$Return.Date, format = "%d/%m/%Y")
CompassColumns$Segment.Start.Date <- as.Date(CompassColumns$Segment.Start.Date, format = "%d/%m/%Y")
CompassColumns$Segment.End.Date <- as.Date(CompassColumns$Segment.End.Date, format = "%d/%m/%Y")

# select all rows which have Michael as the line manager
CompassRows0 <- filter(CompassColumns[grep("*BAT117", CompassColumns$Line.Manager.Name),])

#select all rows which have Michael, Mario, Julianne, Lilly, Lynne, Ben,Di, Katharina, Larelle, Dean, Peter, Jaci, Uday, Anthony, Uta, Enli, Ryan, Mark,Andy as line managers
# these research director, group leaders, team leaders
CompassRows1 <- filter(CompassColumns[grep("*BAT117|*HER16G|*LIL016|*LIM05D|*MAC53H|*MAC488|*MAY137|*WAH006|*MCM168|*HOL353|*WIL99R|*BRO753|*NID001|*RIN019|*STO275|*WAN076|*FAR218|*THO734|*HAL33X", CompassColumns$Line.Manager.Name),])

# select all rows that have Michael as the endorser
CompassRows2 <- filter(CompassColumns[grep("*BAT117", CompassColumns$Endorser.Name),])

# combine all of CompassRows1 and CompassRows2 
CompassRows3 <- bind_rows(CompassRows1, CompassRows2)

# add a couple of blank columns for presentation
CompassRows3["Blank1"] = " "
CompassRows3["Blank2"] = " "

# don't need the endorser or line manager names for the final table
CompassRows4 <- select(CompassRows3,Traveller.Name,Status,Cost.Object,Departure.Date,Return.Date,Cost.Object,Blank1,Country,City,Segment.Start.Date,Segment.End.Date,Blank2,Base.Contacts )

# some rows were duplicates - Michael is both a line manager and the endorser
CompassRows5 <- distinct(CompassRows4)

# remove some column names and rename others
CompassRows6 <- rename(CompassRows5, " " = Traveller.Name,WBS = Cost.Object,Departure = Departure.Date,Return = Return.Date,"   " = Blank1,"    " = Segment.Start.Date,"     " = Segment.End.Date," " = Blank2, "Base Contact" = Base.Contacts )

# sort the output by departure date
CompassOutput <- CompassRows6[order(CompassRows6$Departure),]

# write the table into a csv file
write_csv(CompassOutput, path = "data/CompassOutput.csv")