## Install packages 
# install.packages(c("DBI","RSQLite","dbplyr"))

library(DBI)
library(RSQLite)
library(dplyr)

## Connect to database
connection <- dbConnect(SQLite(),"portal_mammals.sqlite")

## See what tables are in the database
dbListTables(connection)

## Look field in an individual table
dbListFields(connection,"plots")

## Direct connection with a table 

surveys <- tbl(connection, "surveys")
surveys

## Bring the table from databse to R as dataframe 
surv_df <- collect(surveys)

## Writing SQL query
count_query <- "SELECT species_id, COUNT(*)
                FROM surveys
                GROUP BY species_id"

## Run the query and save the results in R
x <- dbGetQuery(connection,count_query) 

##...alternative way
count_data <- tbl(connection,sql(count_query)) %>% collect()

## We can just do the same thing without any SQL query
species_counts <- surveys %>% 
  group_by(species_id) %>% 
  summarise(count = n()) %>% 
  collect()

species_counts

## Input data from R to database

copy_to(connection, species_counts, temporary = FALSE)

dbListTables(connection)



















