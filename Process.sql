
USE [cyclistic_case_study];


--CREATING A NEW TABLE--------------------------------

--DROP TABLE IF EXISTS cyclistic_case_study.dbo.trip_data;
CREATE TABLE cyclistic_case_study.dbo.trip_data
	  (ride_id VARCHAR(255)
      ,rideable_type VARCHAR(255)
      ,started_at DATETIME2
      ,ended_at DATETIME2
      ,start_station_name VARCHAR(255)
      ,start_station_id VARCHAR(255)
      ,end_station_name VARCHAR(255)
      ,end_station_id VARCHAR(255)
      ,start_lat FLOAT
      ,start_lng FLOAT
      ,end_lat FLOAT
      ,end_lng FLOAT
      ,member_casual VARCHAR(255) )

--Altering the datatype of some of the columns to merge all the tables into a single table--------------------------------------

ALTER TABLE cyclistic_case_study.dbo.june_21 ALTER COLUMN start_station_id VARCHAR(255);
ALTER TABLE cyclistic_case_study.dbo.june_21 ALTER COLUMN end_station_id VARCHAR(255);
ALTER TABLE cyclistic_case_study.dbo.july_21 ALTER COLUMN start_station_id VARCHAR(255);
ALTER TABLE cyclistic_case_study.dbo.july_21 ALTER COLUMN end_station_id VARCHAR(255);
ALTER TABLE cyclistic_case_study.dbo.june_21 ALTER COLUMN start_station_id VARCHAR(255);
ALTER TABLE cyclistic_case_study.dbo.november_21 ALTER COLUMN start_station_id VARCHAR(255);
ALTER TABLE cyclistic_case_study.dbo.april_22 ALTER COLUMN start_station_id VARCHAR(255);


--INSERTING DATA INTO NEW TABLE FROM EXSISTING TABLES------------------------------

INSERT INTO cyclistic_case_study.dbo.trip_data (ride_id, rideable_type, started_at, ended_at, 
	start_station_name, start_station_id, end_station_name, end_station_id, start_lat,
	start_lng, end_lat, end_lng, member_casual)
	(SELECT * FROM june_21
	UNION
	SELECT * FROM july_21
	UNION
	SELECT * FROM august_2021
	UNION
	SELECT * FROM september_21
	UNION
	SELECT * FROM october_21
	UNION
	SELECT * FROM november_21
	UNION
	SELECT * FROM december_21
	UNION
	SELECT * FROM january_22
	UNION
	SELECT * FROM february_22
	UNION
	SELECT * FROM march_22
	UNION
	SELECT * FROM april_22
	UNION
	SELECT * FROM may_22
	)

SELECT COUNT(*) FROM cyclistic_case_study.dbo.trip_data




-- CLEANING -------------------------------------------------------

-- Deleting rows with NULL values ---------------------------------

SELECT count(*)
FROM cyclistic_case_study.dbo.trip_data
WHERE ride_id IS NULL
	OR rideable_type IS NULL
	OR started_at is NULL
	OR ended_at is NULL
	OR start_station_name is NULL
	OR start_station_id is NULL
	OR end_station_name is NULL
	OR end_station_id is NULL
	OR member_casual is NULL;

DELETE
FROM cyclistic_case_study.dbo.trip_data
WHERE ride_id IS NULL
	OR rideable_type IS NULL
	OR started_at is NULL
	OR ended_at is NULL
	OR start_station_name is NULL
	OR start_station_id is NULL
	OR end_station_name is NULL
	OR end_station_id is NULL
	OR member_casual is NULL;

-- Checking for anomalous entry-------------------------------------

SELECT DISTINCT start_station_name
FROM cyclistic_case_study.dbo.trip_data

SELECT DISTINCT end_station_name
FROM cyclistic_case_study.dbo.trip_data

-- Checking for misspellings---------------------------------

SELECT DISTINCT rideable_type, member_casual
FROM cyclistic_case_study.dbo.trip_data

--Deleting duplicates ----------------------------------------

SELECT ride_id, COUNT(ride_id) 
FROM cyclistic_case_study.dbo.trip_data
GROUP BY ride_id
HAVING COUNT(ride_id) > 1

------------Deletes the duplicates and the originals
--DELETE          
--FROM cyclistic_case_study.dbo.trip_data
--WHERE ride_id IN ( SELECT ride_id
--				FROM cyclistic_case_study.dbo.trip_data
--				GROUP BY ride_id
--				HAVING COUNT(ride_id) > 1)

------------Below method deletes only the duplicates

WITH ROWNUMCTE AS (
	SELECT *, ROW_NUMBER() OVER(PARTITION BY ride_id ORDER BY ride_id) AS row_num
	FROM cyclistic_case_study.dbo.trip_data
	)
DELETE FROM ROWNUMCTE
WHERE row_num > 1




-- MANIPULATION --------------------------------------------------------

-- Create columns: 'ride_length', 'day_of_Week' ----------------------------

ALTER TABLE cyclistic_case_study.dbo.trip_data ADD started_at_time TIME;
ALTER TABLE cyclistic_case_study.dbo.trip_data ADD ended_at_time TIME;

UPDATE cyclistic_case_study.dbo.trip_data SET started_at_time = CONVERT(TIME(0), started_at);
UPDATE cyclistic_case_study.dbo.trip_data SET ended_at_time = CONVERT(TIME(0), ended_at);

SELECT started_at, started_at_time FROM cyclistic_case_study.dbo.trip_data;
SELECT ended_at, ended_at_time FROM cyclistic_case_study.dbo.trip_data;

-------------------------------------------------------

ALTER TABLE cyclistic_case_study.dbo.trip_data ADD ride_length int;
UPDATE cyclistic_case_study.dbo.trip_data SET ride_length = DATEDIFF(MINUTE, started_at, ended_at );  ---ride_length_min would be an appropriate colname

SELECT started_at, ended_at, ride_length FROM cyclistic_case_study.dbo.trip_data;

-------------------------------------------------------------

ALTER TABLE cyclistic_case_study.dbo.trip_data ADD day_of_week VARCHAR(15);

UPDATE cyclistic_case_study.dbo.trip_data SET day_of_week = DATENAME(WEEKDAY, started_at)

SELECT day_of_week FROM cyclistic_case_study.dbo.trip_data

-- Delete rows with ride time less than 1 minute-----------------------

SELECT ride_length, started_at, ended_at
FROM cyclistic_case_study.dbo.trip_data
WHERE ride_length<=1;

DELETE
FROM cyclistic_case_study.dbo.trip_data
WHERE ride_length<=1;

