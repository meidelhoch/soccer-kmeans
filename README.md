# soccer-kmeans
Partner final project for Intro to Data Science (STAT.220). My partner and I created a web app using shiny.io to analyze soccer players in the top 5 European leagues and used a k-means clustering algorithm to group players by playing style based on their stats.

https://eidelhochm.shinyapps.io/data_science_final/

The Graph tab allows you to create a graph compare two statistics within a league. The Radar tab allows you to choose two players to compare their radar charts among 6 different statistics. The three K-Means tabs allow you to choose a position and then select a player to see a table of players with similar stats and a similar play style to the player you selected.

The app.R file contains the code to run the shinyapp. The final_project_markdown.Rmd file contains the code used to web scrape and clean the data and perform the k-means analysis.
