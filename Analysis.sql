

-- ANALYSIS -----------------------------------------------
-- How do annual members and casual riders use cyclistic bikes differently? --------------------------

-- Average, min, max of ride_length. Members vs casuals -----------------------------

SELECT member_casual, AVG(ride_length) AS avg_ride_time, MIN(ride_length) AS min_ride_time, MAX(ride_length) AS max_ride_time
FROM cyclistic_case_study.dbo.trip_data
GROUP BY member_casual;

-- Total Count of members vs casual rides ---------------------------

WITH RIDESPERCENTCTE AS (
	SELECT member_casual, COUNT(member_casual) AS ride_count, SUM(COUNT(member_casual)) OVER() AS total_rides
	FROM cyclistic_case_study.dbo.trip_data
	GROUP BY member_casual
	)
SELECT *, CAST((ride_count*100.00/total_rides) AS decimal(10,2)) AS rides_percent
FROM RIDESPERCENTCTE;

-- Type of bike preferred by Members vs Casuals -----------------------------------

SELECT rideable_type, member_casual, COUNT(rideable_type) AS total_rides,
	CAST((COUNT(rideable_type)*100.00/SUM(COUNT(*))OVER()) AS decimal(10,2)) AS rides_percent
FROM cyclistic_case_study.dbo.trip_data
GROUP BY member_casual, rideable_type
ORDER BY rideable_type, member_casual

-- day_of_week Usage by members vs casuals-----------------------------------

SELECT day_of_week, member_casual, AVG(ride_length) AS avg_ride_time, count(member_casual) AS total_rides
FROM cyclistic_case_study.dbo.trip_data
GROUP BY day_of_week, member_casual
ORDER BY CASE
          WHEN day_of_week = 'Sunday' THEN 1
          WHEN day_of_week = 'Monday' THEN 2
          WHEN day_of_week = 'Tuesday' THEN 3
          WHEN day_of_week = 'Wednesday' THEN 4
          WHEN day_of_week = 'Thursday' THEN 5
          WHEN day_of_week = 'Friday' THEN 6
          WHEN day_of_week = 'Saturday' THEN 7
		  ELSE 0
     END ASC, member_casual;

-- Usage per month. Members vs causals -----------------------------------

SELECT member_casual, DATEPART(MONTH, started_at) AS month_, COUNT(ride_id) AS total_rides
FROM cyclistic_case_study.dbo.trip_data
GROUP BY member_casual, DATEPART(MONTH, started_at)
ORDER BY DATEPART(MONTH, started_at), member_casual;

-- usage in different seasons, ride count and Average ride_length by Month. member vs casual ----------------------------------------------

--According to the meteorological definition, the seasons begin on the first day of the months that include the equinoxes and solstices. 
--In the Northern Hemisphere, for example,
--spring runs from March 1 to May 31;
--summer runs from June 1 to August 31;
--fall (autumn) runs from September 1 to November 30; and
--winter runs from December 1 to February 28 (February 29 in a leap year).

WITH SEASONCTE AS (
	SELECT *, CASE 
				WHEN MONTH(started_at) IN (12, 1, 2 ) THEN 'Winter'
				WHEN MONTH(started_at) IN (3, 4, 5) THEN 'Spring'
				WHEN MONTH(started_at) IN (6, 7, 8) THEN 'Summer'
				WHEN MONTH(started_at) IN (9, 10, 11) THEN 'Fall'
				ELSE 'NULL'
			END AS seasons
	FROM cyclistic_case_study.dbo.trip_data
)
SELECT member_casual, seasons, COUNT(ride_id) AS total_rides
FROM SEASONCTE
GROUP BY member_casual, seasons
ORDER BY CASE 
			WHEN seasons='Spring' THEN 1
			WHEN seasons='Summer' THEN 2
			WHEN seasons='Fall' THEN 3
			WHEN seasons='Winter' THEN 4
			ELSE 0
		END,
		member_casual;


-- Popular end_station names among members vs casuals -------------------------------------------------

SELECT member_casual, end_station_name, MIN(end_lat) AS end_lat, MIN(end_lng) AS end_lng,
		COUNT(ride_id) AS total_rides, AVG(ride_length) AS avg_ride_time
FROM cyclistic_case_study.dbo.trip_data
GROUP BY member_casual, end_station_name
ORDER BY member_casual ASC, total_rides DESC;

-- Common usage times. Members vs casuals --------------------------------------------
-- shown visually

--SELECT member_casual, started_at_time, COUNT(started_at_time) AS ride_count
--FROM cyclistic_case_study.dbo.trip_data
--GROUP BY member_casual, started_at_time
--ORDER BY member_casual, started_at_time;

SELECT member_casual, DATEPART( hour, started_at_time) AS hour_of_day, COUNT(started_at_time) AS ride_count
FROM cyclistic_case_study.dbo.trip_data
GROUP BY member_casual , DATEPART( hour, started_at_time)
ORDER BY member_casual, hour_of_day;