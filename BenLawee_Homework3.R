# Homework 3 - Ben Lawee

# Sources outside of class (I had trouble with dplyr):
# https://dplyr.tidyverse.org/
# http://127.0.0.1:13308/library/dplyr/doc/programming.html
# https://datacarpentry.org/dc_zurich/R-ecology/04-dplyr.html
# https://dplyr.tidyverse.org/reference/desc.html
# https://dplyr.tidyverse.org/reference/top_n.html

#1) Pull the coronavirus dataset from github (CRAN version).
install.packages("coronavirus") # install
library(coronavirus)            # call to library

# View the first 100 lines of coronavirus dataset.
head(coronavirus, 100)

## Columns:
# date     - Date format, gives the date of the observation in y/m/d order
# province - character, further specifies location within country if applicable
# country  - character, country name
# lat      - numeric, latitude
# long     - numeric, longitude
# type     - character, type of case (either confirmed case, recovered, or death)
# cases    - number of the specified type of cases


#2) top 20 countries by total confirmed cases
# a)
# Install dplyr     
install.packages("dplyr")
library(dplyr)

# Use dplyr to select just the country, type, and cases columns, and filter only to the confirmed cases. This is saved as countrycases.
countrycases = coronavirus %>% 
  select(country, type, cases) %>%
  filter(type == "confirmed")

# The the sum of each contry is taken once they are grouped together. This is saved as country_case_list.
country_case_list = countrycases %>%
  group_by(country) %>%
  summarize(totalcases = sum(cases))

# The countries are sorted by case total, descending (otherwise, the top 20 would still be sorted alphabetically).
country_case_list = country_case_list %>%
  arrange(desc(totalcases))

# top_n is used to print the list in order of cases. Then it is printed.
country_case_list = top_n(country_case_list, 20, totalcases)
country_case_list

# b)
# The top countries by case are saved as the dataframe topFive. Then barplot() is used to create a basic barplot, with the names attached using the names.arg argument.
topFive = data.frame(country_case_list[1:5,])
barplot(topFive$totalcases, names.arg= c("US", "Brazil", "India", "Russia", "South Africa"))

# c)
# To flip the bar graph horizontal, the argument horiz = TRUE is added, with nothing else changed.
barplot(topFive$totalcases, names.arg= c("US", "Brazil", "India", "Russia", "South Africa"), horiz = TRUE)

# d)
# To add the title, the argument main is added.
barplot(topFive$totalcases, names.arg= c("US", "Brazil", "India", "Russia", "South Africa"), horiz = TRUE, main = "Top 5 countries by total cases")


#3)
# Note: I'm not sure if this is the correct dataset, or if the one above is the correct one. Either way, I'm using this one because the homework calls for the version of the dataframe with date formatting, which is from the coronavirus page linked. To be clear, both of these datasets are from that page.
#a)
# Load in the new dataframe with dates in date fromat, this is saved as covid_dates
covid_dates = refresh_coronavirus_jhu()

# Filter only the rows with new cases, and use only the date, data_type, and value columns.
dates_list = covid_dates %>%
  select(date, data_type, value) %>%
  filter(data_type == "cases_new")

# The same dates are combined and then their values are added together to get a total for each date, saved as dates_list.
dates_grouped = dates_list %>%
  group_by(date) %>%
  summarize(cases = sum(value))

# Finally, recent_cases stores the dataframe version of the tibble.
recent_cases = data.frame(dates_grouped)

#b)
# Plot uses date as the x axis and cases as the y axis, with labels. "n" argument gets rid of the points on the graph. lines() makes it a line chart with the same x and y inputs.
plot(recent_cases$date, recent_cases$cases, type = "n", xlab = "Date", ylab = "New Cases")
lines(recent_cases$date, recent_cases$cases)
