# 🚗 Rideshare App SQL Analysis

## Project Overview
This project simulates a real-world data analyst role at a ride-sharing company (similar to Uber).
Using SQL, I built and queried a relational database to answer 15 real business questions
that would directly inform company decisions.

## Business Questions Answered
1. What is the company's total revenue?
2. Which city generates the most revenue?
3. Who are the top 5 earning drivers?
4. Which drivers have the highest cancellation rate?
5. Do premium members spend more than free members?
6. What is the average driver rating per city?
7. What do riders complain about the most?
8. What is the most popular payment method?
9. What is the monthly revenue trend?
10. Which riders have never made a complaint?
11. Driver leaderboard ranked within each city
12. Who are the highest value riders?
13. Which inactive drivers are worth re-activating?
14. What day of the week is the busiest?
15. CEO summary dashboard (SQL View)

## Database Schema
- `riders` — customer information and membership type
- `drivers` — driver details, city, car, and rating
- `rides` — every ride taken with fare, distance, and status
- `ride_ratings` — star ratings given after each ride
- `complaints` — customer complaints and resolution status
- `promo_codes` — available discount codes

## SQL Skills Used
- JOINS (INNER JOIN, LEFT JOIN)
- GROUP BY and Aggregate Functions (SUM, AVG, COUNT)
- CASE WHEN statements
- Subqueries
- Window Functions (RANK, PARTITION BY)
- Views
- DATE functions
- HAVING clause

## How to Run This Project
1. Install MySQL and MySQL Workbench
2. Open `rideshare_analysis.sql` in MySQL Workbench
3. Run the CREATE TABLE section
4. Import each CSV file using the Table Data Import Wizard
5. Run the analysis queries one by one

## Tools Used
- MySQL 8.0
- MySQL Workbench
- GitHub