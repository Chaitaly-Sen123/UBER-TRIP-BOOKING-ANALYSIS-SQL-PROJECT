# UBER-TRIP-BOOKING-ANALYSIS-SQL-PROJECT
SQL PROJECT ANALYZING TRIP BOOKING TRENDS ACROSS CITIES
# 🚖 Uber Trip Booking Analysis SQL Project

## 📌 Objective(REVENUE OPTIMIZATION)
Analyze trip booking data across cities to identify trends, improve booking efficiency, and support strategic decisions.

---

## 🧾 Project Description
This project involves analyzing Uber trip data using SQL. The goal is to uncover hidden trends in user bookings, trip durations, and city-level performance. Key insights are derived to help improve service quality and optimize operations.

---

## 🗂️ Dataset Overview
- **table uber(
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
- **Location Table**: LocationID int,
 Location	text,
 City text);

---

## ❓ Key Questions Answered
- 📅 What is the most popular time of day for bookings?
- 🏙️ Which city has the highest booking volume?
- 🚦 What is the number of trips by city?
- 🔁 Total Distance Covered by each cities by Vehicle types
- ⚖️ Percentage Distribution of each payment
- Weekend and Weekday buckets

---

## 🛠️ Tools & Technologies Used
- **SQL**: Data querying and transformation
-** Power Point-Data visualization
- **GitHub**: Version control

---

---

## 📂 Folder Structure
```bash
├── README.md
├── SQL_Scripts/
│   └── uber_analysis_queries.sql
├── Data/
│   └── uber_trip_data.csv
└── Visualizations/
    └── trip_trend_charts.png
