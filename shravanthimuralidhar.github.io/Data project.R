# 1. Create a sample data set
# First let us build a dirty data frame with some obvious duplicates
#Load library
install.packages("dplyr")
library(dplyr)

#create data with duplicates
df <- data.frame(
  id = c(1, 2, 2, 3, 4, 4),
  name = c("Alice", "Bob", "Bob", "Charlie", "David", "David"),
  score = c(90, 85, 85, 95, 80, 70), #Note: the last David has a different score
  date = as.Date(c("2023-01-01", "2023-01,02", "2023-01-02", "2023-01-03", "2023-01-04", "2023-01-05"))
)

print(df)#this print statement executes the above data

#Identifying the duplicates
#Before deleting its good practice to see what exactly you are about to lose.

#To find full-row duplicates
#Returns only the rows that are exact copies of a previous row
df[duplicated(df), ]

#To count occurances of each record
df %>%
  group_by(id, name) %>%
  summarise(n=n(), .groups = "drop") %>%
  filter(n>1)
'''
#Solutions: Removing duplicates
###Option A: Remove Exact mathces(Base R)
This keeps only the first occurances of every unique row.
'''R
Clean_df <- unique(df)

#Option B: Rremovome based on specific columns(dplyr)
#Sometimes rows arent identical(like the "David" rows above), but you want to treat them as duplicates based on an ID.
#Keep the first David, discard the second
df_distinct <- df %>%
  distinct(id, name, .keep_all = TRUE)

#Option C: resolving conflicts(the smart way)
#If you have two different scores for the same person, you might want to keep the most recent one or the hughest one rather than just a random first record.
#Keep the record with the highest score for each person
df_resolved <- df %>%
  group_by(id, name) %>%
  slice_max(score, n=1, with_ties = FALSE) %>%
  ungroup()
print(df_resolved)
