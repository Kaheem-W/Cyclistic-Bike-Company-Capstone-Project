--Create new table to host all 12 months of data into a single table
CREATE TABLE [12-month-divvy-tripdata].[dbo].[yearlong_tripdata] (
    ride_id nvarchar,
    rideable_type nvarchar,
    started_at datetime,
	ended_at datetime,
	start_station_name nvarchar,
	start_station_id nvarchar,
	end_station_name nvarchar,
	end_station_id float,
	start_lat float,
	start_lng float,
	end_lat float,
	end_lng float,
	member_casual nvarchar,
	ride_length datetime,
	day_of_week float
)


--Add the data from all tables into the new one
INSERT INTO [12-month-divvy-tripdata].[dbo].[yearlong_tripdata]
SELECT * FROM [12-month-divvy-tripdata].[dbo].['202209-divvy-publictripdata$']

--Checking to see if the character length from the original table is longer than the new table
SELECT MAX(LEN(ride_id)),
    MAX(LEN(rideable_type)),
    MAX(LEN(started_at)),
	MAX(LEN(ended_at)),
	MAX(LEN(start_station_name)),
	MAX(LEN(start_station_id)),
	MAX(LEN(end_station_name)),
	MAX(LEN(end_station_id)),
	MAX(LEN(start_lat)),
	MAX(LEN(start_lng)),
	MAX(LEN(end_lat)),
	MAX(LEN(end_lng)),
	MAX(LEN(member_casual)),
	MAX(LEN(ride_length)),
	MAX(LEN(day_of_week))
FROM [12-month-divvy-tripdata].[dbo].['202209-divvy-publictripdata$']


--Since characters are too long, use the ALTER function to change the columns types
ALTER TABLE [12-month-divvy-tripdata].[dbo].[yearlong_tripdata] ALTER COLUMN ride_id VARCHAR(20)
ALTER TABLE [12-month-divvy-tripdata].[dbo].[yearlong_tripdata] ALTER COLUMN rideable_type VARCHAR(15)
ALTER TABLE [12-month-divvy-tripdata].[dbo].[yearlong_tripdata] ALTER COLUMN member_casual VARCHAR(10)
ALTER TABLE [12-month-divvy-tripdata].[dbo].[yearlong_tripdata] ALTER COLUMN end_station_name VARCHAR(70)
ALTER TABLE [12-month-divvy-tripdata].[dbo].[yearlong_tripdata] ALTER COLUMN start_station_name VARCHAR(70)
ALTER TABLE [12-month-divvy-tripdata].[dbo].[yearlong_tripdata] ALTER COLUMN start_station_id VARCHAR(40)


--Now that the data types for the columns match, the data for every month will be combined into the same table from September 2022 back to October 2021

--SEP 2022
INSERT INTO [12-month-divvy-tripdata].[dbo].[yearlong_tripdata]
SELECT * FROM [12-month-divvy-tripdata].[dbo].['202209-divvy-publictripdata$']

--Only 202209 data has end_station_id as float, other data tables have end_station_id as nvarchar
ALTER TABLE [12-month-divvy-tripdata].[dbo].[yearlong_tripdata] ALTER COLUMN end_station_id VARCHAR(40)

--AUG 2022
INSERT INTO [12-month-divvy-tripdata].[dbo].[yearlong_tripdata]
SELECT * FROM [12-month-divvy-tripdata].[dbo].['202208-divvy-tripdata$']

--JULY 2022
INSERT INTO [12-month-divvy-tripdata].[dbo].[yearlong_tripdata]
SELECT * FROM [12-month-divvy-tripdata].[dbo].['202207-divvy-tripdata$']

--JUNE 2022
INSERT INTO [12-month-divvy-tripdata].[dbo].[yearlong_tripdata]
SELECT * FROM [12-month-divvy-tripdata].[dbo].['202206-divvy-tripdata$']

--MAY 2022
INSERT INTO [12-month-divvy-tripdata].[dbo].[yearlong_tripdata]
SELECT * FROM [12-month-divvy-tripdata].[dbo].['202205-divvy-tripdata$']

--APR 2022
INSERT INTO [12-month-divvy-tripdata].[dbo].[yearlong_tripdata]
SELECT * FROM [12-month-divvy-tripdata].[dbo].['202204-divvy-tripdata$']

--MAR 2022
INSERT INTO [12-month-divvy-tripdata].[dbo].[yearlong_tripdata]
SELECT * FROM [12-month-divvy-tripdata].[dbo].['202203-divvy-tripdata$']

--FEB 2022
INSERT INTO [12-month-divvy-tripdata].[dbo].[yearlong_tripdata]
SELECT * FROM [12-month-divvy-tripdata].[dbo].['202202-divvy-tripdata$']

--start_station_id & end_station_id for the next month is too long
ALTER TABLE [12-month-divvy-tripdata].[dbo].[yearlong_tripdata] ALTER COLUMN start_station_id VARCHAR(100)
ALTER TABLE [12-month-divvy-tripdata].[dbo].[yearlong_tripdata] ALTER COLUMN end_station_id VARCHAR(100)

--JAN 2022
INSERT INTO [12-month-divvy-tripdata].[dbo].[yearlong_tripdata]
SELECT * FROM [12-month-divvy-tripdata].[dbo].['202201-divvy-tripdata$']

--DEC 2021
INSERT INTO [12-month-divvy-tripdata].[dbo].[yearlong_tripdata]
SELECT * FROM [12-month-divvy-tripdata].[dbo].['202112-divvy-tripdata$']

--NOV 2021
INSERT INTO [12-month-divvy-tripdata].[dbo].[yearlong_tripdata]
SELECT * FROM [12-month-divvy-tripdata].[dbo].['202111-divvy-tripdata$']

--OCT 2021
INSERT INTO [12-month-divvy-tripdata].[dbo].[yearlong_tripdata]
SELECT * FROM [12-month-divvy-tripdata].[dbo].['202110-divvy-tripdata$']


--With data with every month combined into a single table, gotta double check each month was copied correctly
SELECT APPROX_COUNT_DISTINCT(started_at)
FROM [12-month-divvy-tripdata].[dbo].[yearlong_tripdata]


SELECT top 1000 * 
FROM [12-month-divvy-tripdata].[dbo].[yearlong_tripdata]
WHERE ride_id = '62DF2EB49628DC9A'


--Analysis section to answer questions


-- How many trips do casuals book vs. members?
SELECT member_casual, COUNT(ride_id) AS number_of_trips
FROM [12-month-divvy-tripdata].[dbo].[yearlong_tripdata]
GROUP BY member_casual


--Min, max, and average ride length of members and casuals

--minimum time
SELECT member_casual, MIN(CONVERT(TIME, ride_length)) AS min_ride_length
FROM [12-month-divvy-tripdata].[dbo].[yearlong_tripdata]
GROUP BY member_casual

--maximum time
SELECT member_casual, MAX(CONVERT(TIME, ride_length)) AS max_ride_length
FROM [12-month-divvy-tripdata].[dbo].[yearlong_tripdata]
GROUP BY member_casual

--average time
SELECT member_casual, CONVERT(DECIMAL(10,2), 
    AVG(DATEDIFF(MINUTE, '00:00', ride_length)*1.0)) AS avg_ride_length
FROM [12-month-divvy-tripdata].[dbo].[yearlong_tripdata]
GROUP BY member_casual


--Most common day for trips for casuals and members (Sunday = 1, Saturday = 7)

--Most popular day for trips in both groups
SELECT TOP 1 day_of_week as popular_day_to_ride
FROM [12-month-divvy-tripdata].[dbo].[yearlong_tripdata]
GROUP BY day_of_week
ORDER BY COUNT(*) DESC

--most popular day for members
SELECT TOP 1 day_of_week as popular_day_to_ride
FROM [12-month-divvy-tripdata].[dbo].[yearlong_tripdata]
WHERE member_casual = 'member'
GROUP BY day_of_week
ORDER BY COUNT(*) DESC


--most popular day for casuals
SELECT TOP 1 day_of_week as popular_day_to_ride
FROM [12-month-divvy-tripdata].[dbo].[yearlong_tripdata]
WHERE member_casual = 'casual'
GROUP BY day_of_week
ORDER BY COUNT(*) DESC

--number of rides for each day of the week (Sunday = 1, Saturday = 7)
SELECT day_of_week, COUNT(ride_id) AS number_of_rides
FROM [12-month-divvy-tripdata].[dbo].[yearlong_tripdata]
GROUP BY day_of_week
ORDER BY day_of_week


--same thing for casuals
SELECT day_of_week, COUNT(ride_id) AS number_of_rides
FROM [12-month-divvy-tripdata].[dbo].[yearlong_tripdata]
WHERE member_casual = 'casual'
GROUP BY day_of_week
ORDER BY day_of_week


-- and now for members
SELECT day_of_week, COUNT(ride_id) AS number_of_rides
FROM [12-month-divvy-tripdata].[dbo].[yearlong_tripdata]
WHERE member_casual = 'member'
GROUP BY day_of_week
ORDER BY day_of_week


--Most popular route for riders in both groups
SELECT TOP 1 start_station_name AS point_a
FROM [12-month-divvy-tripdata].[dbo].[yearlong_tripdata]
WHERE start_station_name IS NOT NULL
GROUP BY start_station_name
ORDER BY COUNT(*) DESC
--most popular starting point is Streeter Dr & Grand Ave

SELECT TOP 1 end_station_name AS point_b
FROM [12-month-divvy-tripdata].[dbo].[yearlong_tripdata]
WHERE end_station_name IS NOT NULL
GROUP BY end_station_name
ORDER BY COUNT(*) DESC
--end point is same station as starting point


--Most popular route for members
SELECT TOP 1 start_station_name AS point_a
FROM [12-month-divvy-tripdata].[dbo].[yearlong_tripdata]
WHERE member_casual = 'member' AND start_station_name IS NOT NULL
GROUP BY start_station_name
ORDER BY COUNT(*) DESC
--most popular starting point is Kingsbury St & Kinzie St

SELECT TOP 1 end_station_name AS point_b
FROM [12-month-divvy-tripdata].[dbo].[yearlong_tripdata]
WHERE member_casual = 'member' AND end_station_name IS NOT NULL
GROUP BY end_station_name
ORDER BY COUNT(*) DESC
--end station is same as start station
--after doing some quick research it seems that this station is more inner city and next to apartment buildings.

--Most popular route for casuals
SELECT TOP 1 start_station_name AS point_a
FROM [12-month-divvy-tripdata].[dbo].[yearlong_tripdata]
WHERE member_casual = 'casual' AND start_station_name IS NOT NULL
GROUP BY start_station_name
ORDER BY COUNT(*) DESC
--most popular starting point is Streeter Dr & Grand Ave

SELECT TOP 1 end_station_name AS point_b
FROM [12-month-divvy-tripdata].[dbo].[yearlong_tripdata]
WHERE member_casual = 'casual' AND end_station_name IS NOT NULL
GROUP BY end_station_name
ORDER BY COUNT(*) DESC
--end station is same as start station
--after doing some quick research, the station at Streeter Dr & Grand Ave is in a somewhat popular spot by the navy pier, parks and beaches