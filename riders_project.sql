-- QUESTION 1: What is total company revenue?
SELECT SUM(fare) AS total_revenue 
FROM rides 
WHERE ride_status = 'completed';

-- QUESTION 2: Which city makes the most money?
SELECT d.city, ROUND(SUM(r.fare), 2) AS revenue
FROM rides r 
JOIN drivers d ON r.driver_id = d.driver_id
WHERE r.ride_status = 'completed'
GROUP BY d.city 
ORDER BY revenue DESC;

-- QUESTION 3: Who are the top 5 earning drivers?
SELECT d.name, COUNT(r.ride_id) AS total_rides, 
       ROUND(SUM(r.fare), 2) AS total_earnings
FROM rides r 
JOIN drivers d ON r.driver_id = d.driver_id
WHERE r.ride_status = 'completed'
GROUP BY d.name 
ORDER BY total_earnings DESC 
LIMIT 5;

-- QUESTION 4: Which driver cancels rides the most?
SELECT d.name,
    COUNT(*) AS total_rides,
    SUM(CASE WHEN r.ride_status = 'cancelled' THEN 1 ELSE 0 END) AS cancellations,
    ROUND(SUM(CASE WHEN r.ride_status = 'cancelled' THEN 1 ELSE 0 END) 
          * 100.0 / COUNT(*), 1) AS cancel_rate_pct
FROM rides r 
JOIN drivers d ON r.driver_id = d.driver_id
GROUP BY d.name 
ORDER BY cancel_rate_pct DESC;

-- QUESTION 5: Do premium members spend more than free members?
SELECT ri.membership,
    COUNT(DISTINCT ri.rider_id) AS total_riders,
    COUNT(r.ride_id) AS total_rides,
    ROUND(SUM(r.fare), 2) AS total_spent,
    ROUND(AVG(r.fare), 2) AS avg_fare_per_ride
FROM rides r 
JOIN riders ri ON r.rider_id = ri.rider_id
WHERE r.ride_status = 'completed'
GROUP BY ri.membership;

-- QUESTION 6: Average driver rating per city
SELECT d.city, ROUND(AVG(rr.stars), 2) AS avg_rating
FROM ride_ratings rr 
JOIN drivers d ON rr.driver_id = d.driver_id
GROUP BY d.city 
ORDER BY avg_rating DESC;

-- QUESTION 7: What do riders complain about the most?
SELECT complaint_type, 
       COUNT(*) AS total_complaints,
    SUM(CASE WHEN resolved = 'yes' THEN 1 ELSE 0 END) AS resolved,
    SUM(CASE WHEN resolved = 'no' THEN 1 ELSE 0 END) AS unresolved
FROM complaints
GROUP BY complaint_type 
ORDER BY total_complaints DESC;

-- QUESTION 8: Most popular payment method
SELECT payment_method, COUNT(*) AS usage_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM rides), 1) AS percentage
FROM rides
GROUP BY payment_method 
ORDER BY usage_count DESC;

-- QUESTION 9: Monthly revenue trend
SELECT DATE_FORMAT(ride_date, '%Y-%m') AS month,
    COUNT(*) AS total_rides,
    ROUND(SUM(fare), 2) AS monthly_revenue
FROM rides 
WHERE ride_status = 'completed'
GROUP BY month 
ORDER BY month;

-- QUESTION 10: Happy customers who never complained
SELECT ri.name, ri.email, ri.membership
FROM riders ri
WHERE ri.rider_id NOT IN (SELECT rider_id FROM complaints);

-- QUESTION 11: Driver leaderboard ranked by city (Window Function)
SELECT d.name, d.city,
    COUNT(r.ride_id) AS total_rides,
    ROUND(SUM(r.fare), 2) AS total_earnings,
    ROUND(AVG(rr.stars), 2) AS avg_rating,
    RANK() OVER (PARTITION BY d.city ORDER BY SUM(r.fare) DESC) AS city_rank
FROM drivers d
JOIN rides r ON d.driver_id = r.driver_id
JOIN ride_ratings rr ON d.driver_id = rr.driver_id
WHERE r.ride_status = 'completed'
GROUP BY d.name, d.city;

-- QUESTION 12: High value riders (spent above average)
SELECT ri.name, ri.city, ri.membership, 
       ROUND(SUM(r.fare), 2) AS total_spent
FROM riders ri 
JOIN rides r ON ri.rider_id = r.rider_id
WHERE r.ride_status = 'completed'
GROUP BY ri.name, ri.city, ri.membership
HAVING total_spent > (
    SELECT AVG(rider_total) FROM (
        SELECT SUM(fare) AS rider_total FROM rides 
        WHERE ride_status = 'completed'
        GROUP BY rider_id
    ) AS sub
);

-- QUESTION 13: Inactive drivers worth re-activating
SELECT d.name, d.city, d.status, 
       ROUND(SUM(r.fare), 2) AS past_earnings
FROM drivers d 
JOIN rides r ON d.driver_id = r.driver_id
WHERE d.status = 'inactive' 
AND r.ride_status = 'completed'
GROUP BY d.name, d.city, d.status 
ORDER BY past_earnings DESC;

-- QUESTION 14: What day of the week is busiest?
SELECT DAYNAME(ride_date) AS day_of_week,
    COUNT(*) AS total_rides,
    ROUND(SUM(fare), 2) AS revenue
FROM rides 
WHERE ride_status = 'completed'
GROUP BY day_of_week 
ORDER BY total_rides DESC;

-- QUESTION 15: CEO Summary Dashboard (View)
CREATE VIEW ceo_dashboard AS
SELECT
    d.city,
    COUNT(r.ride_id) AS total_rides,
    SUM(CASE WHEN r.ride_status = 'completed' THEN 1 ELSE 0 END) AS completed,
    SUM(CASE WHEN r.ride_status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled,
    ROUND(SUM(r.fare), 2) AS total_revenue,
    ROUND(AVG(rr.stars), 2) AS avg_driver_rating
FROM rides r
JOIN drivers d ON r.driver_id = d.driver_id
LEFT JOIN ride_ratings rr ON r.ride_id = rr.ride_id
GROUP BY d.city;

SELECT * FROM ceo_dashboard;
