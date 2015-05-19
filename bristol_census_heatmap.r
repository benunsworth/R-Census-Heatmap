# How to make a simple heatmap on citizen reported health, using 2011 Census data from Bristol City Council's Socrata platform

library("pacman")  # Load package manager, you might need to install this package first
p_load(RSocrata,plyr,RColorBrewer)  # Use Pacman to load required packages, you might need to install these first

# Next job is load the data from opendata.bristol.gov.uk as a dataframe

census <- read.socrata("https://opendata.bristol.gov.uk/Health/2011-Census-health/bdwv-2hn9") 

# You can check the data looks right with: head(bristol.census)
# There are a few data cleaning/munging jobs before we can visualise

census <- census[order(census$Very.good.health.rate),]  # Ordered the data by Very.good.health.rate column
row.names(census) <- census$Names  # R automatically numbers rows, this replaces the numbers with values from the column "Names"
census <- census[,-c(1,2,3,4,6,8,10,12,14)]  # Delete the columns that we don't need - TIP... columns start at "1" not "0" in the R Language

census <- rename(census, c("Very.good.health.rate"="Very Good", "Good.health.rate"="Good",
 "Fair.health.rate"="Fair", "Bad.health.rate"="Bad", 
 "Very.bad.health.rate"="Very bad"))  # Using the plyr library's "rename" function to give the columns human readable names

census_matrix <- data.matrix(census)  # To make a heatmap in R we need the data in a matrix

# As you can see, most of the code ^^ is about getting our data into the right shape for the visualisation
# The final task is to use R's built in heatmap function and the RColorBrewer library to add some nice blue shades

health_heatmap <- heatmap(census_matrix, Rowv=NA, Colv=NA, col=brewer.pal(9,"Blues"), scale="column", margins=c(5,10), main="Bristol, Resident Reported Health by Ward - 2011 Census") 

