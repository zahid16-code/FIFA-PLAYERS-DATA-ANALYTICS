CREATE DATABASE my_datasets;
USE my_datasets;

-- OVERVIEW OF THE DATA
SELECT * FROM fifa_players;

-- Data analysis has been completed

SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY ID, Name, Age -- 👈 Change these to your unique-identifying columns
               ORDER BY ID
           ) AS rn
    FROM fifa_players


DESCRIBE fifa_players;

-- DATA CLEANING AND WRANGLING
SET SQL_SAFE_UPDATES = 0;

SELECT COUNT(*)
FROM fifa_players
WHERE `Loan Date End` IS  NULL;

ALTER TABLE fifa_players
DROP COLUMN `Loan Date End`;


SELECT COUNT(*)
FROM fifa_players
WHERE Position  IS  NULL; 
-- BP and Position column are similer we have just put BP to where Position values are null
UPDATE fifa_players
SET Position=BP
WHERE Position IS NULL;

ALTER TABLE fifa_players
DROP COLUMN composure;

ALTER TABLE fifa_players
DROP COLUMN `A/W`,
DROP COLUMN `D/W`; -- more than half of data is null 

-- HANDLING DUPLICATE VALUES
WITH CTE AS
(SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY ID -- 👈 Change these to your unique-identifying columns
               ORDER BY ID
           ) AS rn
    FROM fifa_players)
SELECT COUNT(*)
FROM CTE; -- No duplicate values found in the data
-- Data analysis has been completed

-- EXPLORATARY DATA ANALYSIS
/* Next Step: Exploratory Data Analysis (EDA) & KPI Insights
After successful data cleaning, the next step involves conducting an in-depth Exploratory Data Analysis (EDA) to extract key insights from the dataset. 
The goal is to analyze trends, patterns, and relationships between player attributes and performance indicators. This will include:
Descriptive Statistics: Summarizing age, value, wages, and OVA distribution.
Position-wise Breakdown: Identifying top performers per position (ST, GK, CM, etc.).
Correlation Analysis: Finding relationships (e.g., between Physical traits and OVA).
KPI Dashboards: Creating visual summaries (bar charts, heatmaps) for performance, financials, and growth potential.
Identifying Outliers: Detecting standout players or anomalies in wages/value.
This step will provide a data-driven foundation for player performance insights and help build meaningful dashboards or reports.*/

-- 1 Which nationality produces the highest-rated players (OVA)?
SELECT Nationality,COUNT(*)AS Player_Count,AVG(OVA) AS Player_Rating
FROM fifa_players
GROUP BY Nationality
HAVING Player_Count>=10
ORDER BY Player_Rating DESC
LIMIT 10
;

-- 2 Which clubs have the most high-potential (POT) players?
SELECT Club,COUNT(*) AS Players,AVG(POT) AS AVG_POT
FROM fifa_players
GROUP BY Club
HAVING Players>=10
ORDER BY AVG_POT DESC
LIMIT 10;

-- 3 Which players have the highest potential vs. current OVA gap?
SELECT Name, POT - OVA AS GROWTH_DIFFERENCE
FROM fifa_players
ORDER BY GROWTH_DIFFERENCE  DESC
LIMIT 10;

-- 4 Do taller players have better heading accuracy?
SELECT Name,`Heading Accuracy`,Height
FROM fifa_players
ORDER BY `Heading Accuracy` DESC
LIMIT 10;

-- 5 Are good passers also good at vision and ball control?
SELECT Name,`Short Passing`,Vision,`Ball Control`
FROM fifa_players
ORDER BY `Short Passing` DESC 
LIMIT 10;

-- 6 Does aggression correlate with interceptions?
SELECT Name,Aggression,interceptions
FROM fifa_players
ORDER BY Aggression DESC
LIMIT 10;

-- 7 Who are the best defensive midfielders?
SELECT Name,Club,CDM
FROM fifa_players
ORDER BY CDM DESC
LIMIT 10;

-- 8 Which GK has the best reflex vs positioning?
SELECT Name, `GK Reflexes`, `GK Positioning`,
       (`GK Reflexes` - `GK Positioning`) AS Reflex_vs_Positioning
FROM fifa_players
WHERE Position = 'GK'
ORDER BY Reflex_vs_Positioning DESC
LIMIT 10;

--  9 What’s the average stat across all GK skills?
SELECT Name,`GK Diving`,`GK Reflexes`,`GK Handling`,`GK Positioning`,`GK Kicking`,(`GK Diving`+`GK Reflexes`+`GK Handling`+`GK Positioning`+`GK Kicking`)/5 AS GK_STATS
FROM fifa_players
ORDER BY GK_STATS DESC
LIMIT 10;

-- 10 What’s the average PAC for wingers vs full-backs?
SELECT BP,AVG(PAC) AS AVG_PAC
FROM fifa_players
WHERE BP IN ('LW','RW','LM','RM','LB','RB')
GROUP BY BP;

-- 11 Which positions have the most players with POT > 85?
SELECT BP,COUNT(*) AS PLAYERS
FROM fifa_players
WHERE POT >85
GROUP BY BP
ORDER BY PLAYERS DESC
LIMIT 10;

-- 12 Correlate Hits vs. OVA/POT (are popular players also the best?).
SELECT Name,Hits,OVA,POT
FROM fifa_players
ORDER BY Hits DESC
LIMIT 10;