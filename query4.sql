SELECT 9/4, 9.0/4, ROUND(9.0/4);

SELECT
film_id,
rental_rate AS old_rental_rate,
ROUND(rental_rate*1.4,2) AS new_rental_rate,
CEILING(rental_rate*1.4)-0.01 AS new_rental_rate_ceil
FROM film;

SELECT
film_id,
title,
ROUND(rental_rate/replacement_cost*100,2) AS precentage
FROM film
WHERE ROUND(rental_rate/replacement_cost*100,2) < 4
ORDER BY 2 ASC;

--flight
SELECT
actual_departure-scheduled_departure,
CASE
WHEN actual_departure-scheduled_departure IS null THEN 'no departure time'
WHEN actual_departure-scheduled_departure < '00:05' THEN 'On time'
WHEN actual_departure-scheduled_departure < '01:00' THEN 'A little bit late'
ELSE 'Very late'
END
FROM flights;

SELECT
COUNT(*) AS flights,
CASE
WHEN actual_departure-scheduled_departure IS null THEN 'no departure time'
WHEN actual_departure-scheduled_departure < '00:05' THEN 'On time'
WHEN actual_departure-scheduled_departure < '01:00' THEN 'A little bit late'
ELSE 'Very late'
END AS is_late
FROM flights
GROUP BY is_late;

SELECT
    book_ref,
    total_amount,
CASE
    WHEN total_amount < 20000.00 THEN 'Low price ticket'
    WHEN total_amount < 150000.00 THEN 'Mid price ticket'
    WHEN total_amount >= 150000.00 THEN 'High price ticket'
ELSE 'Unknown'
END AS ticket_price
FROM bookings;

SELECT
    COUNT(*),
CASE
    WHEN EXTRACT(MONTH FROM scheduled_departure) IN (12, 1, 2) THEN 'Winter'
    WHEN EXTRACT(MONTH FROM scheduled_departure) IN (3, 4, 5) THEN 'Spring'
    WHEN EXTRACT(MONTH FROM scheduled_departure) IN (6, 7, 8) THEN 'Summer'
    WHEN EXTRACT(MONTH FROM scheduled_departure) IN (9, 10, 11) THEN 'Fall'
ELSE 'Unknown'
END AS seasson
FROM flights
GROUP BY seasson;

--movie
SELECT
    title,
    rating,
    length,
CASE
    WHEN rating IN ('PG', 'PG-13') OR length > 210 THEN 'Great rating or long (tier 1)'
    WHEN description ILIKE '%Drama%' AND length > 90 THEN 'Long drama (tier 2)'
    WHEN description ILIKE '%Drama%' THEN 'Short drama (tier 3)'
    WHEN rental_rate < 1 THEN 'Very cheap (tier 4'
ELSE 'No tier'
END AS tier_list
FROM film
WHERE
CASE
    WHEN rating IN ('PG', 'PG-13') OR length > 210 THEN 'Great rating or long (tier 1)'
    WHEN description ILIKE '%Drama%' AND length > 90 THEN 'Long drama (tier 2)'
    WHEN description ILIKE '%Drama%' THEN 'Short drama (tier 3)'
    WHEN rental_rate < 1 THEN 'Very cheap (tier 4'
END IS NOT null;

SELECT
SUM(CASE
    WHEN rating IN ('PG','G') THEN 1
ELSE 0
END) AS no_of_ratings
FROM film;

SELECT
rating AS "G",
count(*)
FROM film
GROUP BY rating;

SELECT
    SUM(CASE WHEN rating = 'G' THEN 1 ELSE 0 END) AS "G",
    SUM(CASE WHEN rating = 'R' THEN 1 ELSE 0 END) AS "R",
    SUM(CASE WHEN rating = 'NC-17' THEN 1 ELSE 0 END) AS "NC-17",
    SUM(CASE WHEN rating = 'PG-13' THEN 1 ELSE 0 END) AS "PG-13",
    SUM(CASE WHEN rating = 'PG' THEN 1 ELSE 0 END) AS "PG"
FROM film;

--flights
SELECT
COALESCE(actual_arrival-scheduled_arrival, '0:00'),
COALESCE(CAST(actual_arrival-scheduled_arrival AS VARCHAR), 'Not arrived')
FROM flights;

SELECT
LENGTH(CAST(actual_arrival AS VARCHAR))
FROM flights;

SELECT
CAST(ticket_no AS bigint)
FROM tickets;

--movie
SELECT
title,
COALESCE(CAST(original_language_id AS VARCHAR),'No language')
FROM film;

--flights
SELECT
passenger_id,
REPLACE(passenger_id,' ',''),
CAST(REPLACE(passenger_id,' ','') AS BIGINT)
FROM tickets;

SELECT
flight_no,
REPLACE(flight_no,'PG',''),
CAST(REPLACE(flight_no,'PG','') AS INT)
FROM flights;