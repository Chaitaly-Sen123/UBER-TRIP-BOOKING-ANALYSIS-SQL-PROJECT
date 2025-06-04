create database uberanalysis;
use uberanalysis;
create table uber(
 TripID int,
 PickupTime	text,
 DropOffTime	text,
 passenger_count int,	
 trip_distance	int,
 PULocationID	int,
 DOLocationID	int,
 fare_amount	int,
 SurgeFee	int,
 Vehicle	text,
 Payment_type text);
 
 create table location(
 LocationID int,
 Location	text,
 City text);
 
 select *
 from uber;
 
 
 /* REPLACING "/" WITH "-"*/
 
 update uber
set pickuptime=replace(pickuptime,"/","-");
set sql_safe_updates=0;

 /* REPLACING "/" WITH "-"*/
 
 update uber
set dropofftime=replace(dropofftime,"/","-");
set sql_safe_updates=0;

/*ADDING NEW COLUMN TO CONVERT THE DATE INTO PROPER FORMAT*/
 alter table  uber
add new_dropofftime date;
 
 /*ADDING NEW COLUMN TO CONVERT THE DATE INTO PROPER FORMAT*/
 alter table  uber
add new_pickupdate date;
 
 select*
 from location;
 
 /*CONVERTING INTO PROPER DATE AND TIME FORMAT*/

update uber
set new_dropofftime = str_to_date(dropofftime,'%m-%e-%Y %H:%i');

/*CONVERTING INTO PROPER DATE AND TIME FORMAT*/

update uber
set new_pickupdate = str_to_date(pickuptime,'%m-%e-%Y %H:%i');


/*ADDING NEW COLUMN TO KEEP THE TIME IN A SEPARATE COLUMN*/
 alter table  uber
add new_pickupTIME TIME;

UPDATE uber
SET NEW_PICKUPTIME=TIME(str_to_date(PICKUPTIME, '%m-%e-%Y %H:%i'));

 
 
 /*ADDING NEW COLUMN TO KEEP THE TIME IN A SEPARATE COLUMN*/
 alter table  uber
add new_DROPOFF TIME;

UPDATE uber
SET NEW_DROPOFF=TIME(str_to_date(DROPOFFTIME, '%m-%e-%Y %H:%i'));
 
 set sql_safe_updates=0;

set sql_safe_updates=1;
 
 /*Booking Trends*/
 
 /*Question 1- What are the top 5 cities with the highest number of trip bookings-
 Reason(Understanding the cities 
 with the highest demand that allow stakeholders to allocate more drivers and marketing efforts in those locations)*/
 
 with pickup_stats as(select l.city,count(*) as total_pickups
 from uber u join location l on u.PUlocationid=l.locationid
 group by l.city)
 select *
 from pickup_stats
 order by total_pickups desc
 limit 5;
 
 


-- Q2: How do DAILY booking trends vary across different cities?
-- Reason: Reveals  demand patterns that can influence staffing and promotional strategies.

SELECT L.CITY,U.NEW_PICKUPDATE,
COUNT(*) OVER (PARTITION BY L.CITY,U.NEW_PICKUPDATE ORDER BY U.NEW_PICKUPDATE) AS DAILY_BOOKINGS
FROM UBER U JOIN LOCATION L ON U.PULOCATIONID=L.LOCATIONID
ORDER BY L.CITY,U.NEW_PICKUPDATE;



 /* Hour Buckets (Morning, Afternoon, etc.)
 Why: Segments trips by time of day. Crucial for planning driver shifts, marketing campaigns, and pricing strategies*/

SELECT 
  CASE 
    WHEN HOUR(NEW_PICKUPTIME) BETWEEN 5 AND 11 THEN 'Morning (5AM–11AM)'
    WHEN HOUR(NEW_PICKUPTIME) BETWEEN 12 AND 16 THEN 'Afternoon (12PM–4PM)'
    WHEN HOUR(NEW_PICKUPTIME) BETWEEN 17 AND 20 THEN 'Evening (5PM–8PM)'
    WHEN HOUR(NEW_PICKUPTIME) BETWEEN 21 AND 23 THEN 'Night (9PM–11PM)'
    ELSE 'Late Night (12AM–4AM)'
  END AS time_slot,
  COUNT(*) AS total_trips
FROM uber
WHERE NEW_pickuptime IS NOT NULL
GROUP BY time_slot
ORDER BY total_trips DESC;


/* Weekend and Weedays trip Analysis*/

SELECT 
  CASE 
    WHEN DAYOFWEEK(STR_TO_DATE(pickuptime, '%d-%m-%Y %H:%i')) IN (1, 7) THEN 'Weekend'
    ELSE 'Weekday'
  END AS day_type,
  COUNT(*) AS total_trips
FROM uber
WHERE pickuptime IS NOT NULL
GROUP BY day_type;




/*No. Trip by City and Vehicle Type
this can help optimize operations.*/


SELECT 
  l.city AS City,
  u.vehicle AS Vehicle_Type,
  COUNT(*) AS Number_of_Trips
FROM 
  uber u
JOIN 
  location l ON u.pulocationid = l.locationid
GROUP BY 
  l.city, u.vehicle
ORDER BY 
  Number_of_trips DESC;
  
  


/* Peak Revenue Routes (From → To Locations)
Why? Identifies top routes that earn the most, helping with strategic route planning.

Simple Explanation: Tells you which pickup-drop pairs are making the most money.*/


SELECT 
  l1.LOCATION AS pickup_LOCATION, 
  l2.LOCATION AS dropoff_LOCATION,
  COUNT(*) AS total_trips,
  SUM(fare_amount + COALESCE(surgefee, 0)) AS total_revenue
FROM 
  uber u
JOIN 
  location l1 ON u.pulocationid = l1.locationid
JOIN 
  location l2 ON u.dolocationid = l2.locationid
GROUP BY 
  l1.LOCATION, l2.LOCATION
ORDER BY 
  total_revenue DESC
LIMIT 10; -- location



/* What are the top 5 most busiest routes based on pickup and drop-off cities?- no of trips
-- Reason: Identifying high-revenue routes can help in designing route-specific campaigns or dynamic pricing.*/
SELECT l1.city AS pickup_city, l2.city AS dropoff_city,
       COUNT(*) AS trip_count
FROM uber u
JOIN location l1 ON u.pulocationid = l1.locationid
JOIN location l2 ON u.dolocationid = l2.locationid
GROUP BY pickup_city, dropoff_city
Order by COUNT(*) desc
LIMIT 5
;



select distinct(payment_type)
from uber;

/*Write an SQL query to calculate the percentage distribution of each payment type 
(UberPay, Cash, AmazonPay, GooglePay) for Uber trips across different cities*/



SELECT
  l.city,
  ROUND(100.0 * SUM(CASE WHEN u.Payment_type = 'Uber Pay' THEN 1 ELSE 0 END) / COUNT(*), 2) AS UberPay,
  ROUND(100.0 * SUM(CASE WHEN u.Payment_type = 'Cash' THEN 1 ELSE 0 END) / COUNT(*), 2) AS Cash,
  ROUND(100.0 * SUM(CASE WHEN u.Payment_type = 'Amazon Pay' THEN 1 ELSE 0 END) / COUNT(*), 2) AS AmazonPay,
  ROUND(100.0 * SUM(CASE WHEN u.Payment_type = 'Google Pay' THEN 1 ELSE 0 END) / COUNT(*), 2) AS GooglePay
FROM
  uber u
JOIN
  location l ON u.PULocationID = l.LocationID
GROUP BY
  l.city
ORDER BY
  l.city;



select distinct(vehicle)
from uber;


/*What is the total distance covered by each cities  segregated by vehicle type 
(UberX, Uber Black, Uber Comfort, Uber Green, UberXL)location wise*/


SELECT
  l1.city AS City,
  ROUND(SUM(CASE WHEN u.Vehicle = 'UberX' THEN u.trip_distance ELSE 0 END), 2) AS UberX_Distance,
  ROUND(SUM(CASE WHEN u.Vehicle = 'Uber Black' THEN u.trip_distance ELSE 0 END), 2) AS UberBlack_Distance,
  ROUND(SUM(CASE WHEN u.Vehicle = 'Uber Comfort' THEN u.trip_distance ELSE 0 END), 2) AS UberComfort_Distance,
  ROUND(SUM(CASE WHEN u.Vehicle = 'Uber Green' THEN u.trip_distance ELSE 0 END), 2) AS UberGreen_Distance,
  ROUND(SUM(CASE WHEN u.Vehicle = 'UberXL' THEN u.trip_distance ELSE 0 END), 2) AS UberXL_Distance
FROM
  uber u
JOIN
  location l1 ON u.PULocationID = l1.LocationID
GROUP BY
  l1.city
ORDER BY
  City;

