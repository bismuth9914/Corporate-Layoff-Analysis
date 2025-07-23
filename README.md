# Corporate Layoff Analysis
Data cleaning and analysis of a world wide company layoff database. Data was found and cleaned using assistance from Alex the Analyst's YouTube channel and the git repository can be found here: https://github.com/AlexTheAnalyst/MySQL-YouTube-Series/blob/main/layoffs.csv

The goal of this project was to learn data cleaning practiices in SQL and then use the cleaned data in a Power BI report and contains the following files:

- **Data-Cleaning-Project.sql:** Displays the steps taken to clean the data.
- **Exploratory-Data-Analysis.sql:** SQL commands run to pull various information from the cleaned database.
- **Layoffs Exploration.pbix:** a Power BI report created to display insights on the data. ***Requires layoffs_staging_2.xlsx***

At present, the report contains the following:
- Page 1: Layoff information from March 6 2022 to March 6 2023 (the latest date in the initial file)
  - A bar chart displaying the top 10 industries for layoff information
  - A line graph displaying the timeline of the layoffs for that date range
  - A table displaying the top 10 layoff instances sorted by either largest number of workers laid off or largest percentage of workforce laid off for that company
  - Buttons that toggle between the sum of people laid off and the average percentage of workforce laid off
- Page 2: Layoff information displayed by country
  - A map and treemap displaying the countries sorted by total number of people laid off
  - Cards containing the total laid off, top industry, number of companies, and funds raised (millions) according to which country has been selected

Next steps for this data exploration are as follows:
1. Add average rowkforce laid off view for page 2
2. Add a page to the PowerBI report that focuses on industries
3. Create a mobile device variant of the report
4. Experiment with further normalizing the SQL data
