# soccer-kmeans
Partner final project for Intro to Data Science (STAT.220). My partner and I created a web app using shiny.io to analyze soccer players in the top 5 European leagues and used a k-means clustering algorithm to group players by playing style based on their stats.

https://eidelhochm.shinyapps.io/data_science_final/


Technical write up from project:

The code provided demonstrates the creation of a Shiny web application using R about the European soccer leagues. The app consists of multiple tabs, each serving a different purpose: Description, Graph, Radar, and three tabs for player search using k means.

This data was intially scraped from the webpage FBREF.com which compiles data on the top international soccer players. The data was than cleaned and tidied in the R-markdown and compiled into the readable CSVs. This cleaning and tidying occurs in the final_project_markdown.Rmd using skills that we learned in this class to rename columns, use regular expressions to tidy data and select certain columns for analysis.

After loading the data from the CSVs into a app.R document, the user interface follows a logical path of data exploration guided by the navbarPage tabs at the top of the page. The UI creates the tabs which all display various types of data output, these tabs are created in the upper half of our shiny code. Within each of the tabs, the user has the option to select different soccer statistics, players and more.   

Inside the server function, different output functions are defined to render various elements based on user inputs. For the first tab, the renderPlotly function is used to render a scatter plot based on any two soccer specific variables. The user can than filter by league and color the graph by position. In addition, the user can hover over points to see more information about that player. The next tab function compares two players based off of an users input on radar maps. The radar maps relies on the ggradar package and compares the players on five statistics that give a sense of the players general ability. 

In the "K Means" tabs, a k-means clustering analysis is performed on the defender data, the midfield data and the forward data. Initially, analysis of the elbow plots was performed to determine the correct number of clusters. Then each player was sorted into a cluster. All of this analysis was performed in the final_project_markdown.Rmd. The user picks a player and by cluster analysis, a table of similar players will be generated based off stastistical similarities. 
