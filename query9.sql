SELECT
*,
SUM(amount) OVER(PARTITION BY customer_id)
FROM payment
ORDER BY 1;

SELECT
*,
COUNT(*) OVER(PARTITION BY customer_id)
FROM payment
ORDER BY 1;

SELECT
f.film_id,
title,
name AS category,
length as length_of_movie,
ROUND(AVG(length) OVER(PARTITION BY name),2) as avg_length_in_category
FROM film f
LEFT JOIN film_category fc
ON f.film_id=fc.film_id
LEFT JOIN category c
ON fc.category_id = c.category_id
ORDER BY 1;

SELECT *,
COUNT(*) OVER(PARTITION BY amount,customer_id)
FROM payment
ORDER BY customer_id;

SELECT *,
SUM(amount) OVER(ORDER BY payment_date)
FROM payment;

SELECT *,
SUM(amount) OVER(ORDER BY payment_id)
FROM payment;

SELECT *,
SUM(amount) OVER(PARTITION BY customer_id ORDER BY payment_date, payment_id)
FROM payment;

--flights
SELECT
flight_id,
departure_airport,
SUM(actual_arrival-scheduled_arrival)
OVER(PARTITION BY departure_airport ORDER BY flight_id)
FROM flights;

--movies
SELECT
f.title,
c.name,
f.length,
RANK() OVER(ORDER BY length DESC)
FROM film f
LEFT JOIN film_category fc ON f.film_id = fc.film_id
LEFT JOIN category c ON c.category_id = fc.category_id;

SELECT
f.title,
c.name,
f.length,
DENSE_RANK() OVER(PARTITION BY name ORDER BY length DESC)
FROM film f
LEFT JOIN film_category fc ON f.film_id = fc.film_id
LEFT JOIN category c ON c.category_id = fc.category_id;

SELECT * FROM
(SELECT
f.title,
c.name,
f.length,
DENSE_RANK() OVER(PARTITION BY name ORDER BY length DESC) as rank
FROM film f
LEFT JOIN film_category fc ON f.film_id = fc.film_id
LEFT JOIN category c ON c.category_id = fc.category_id
) a
WHERE rank = 1;

SELECT * FROM (SELECT name,
                      country,
                      COUNT(*),
                      RANK() OVER (PARTITION BY country ORDER BY count(*) DESC) AS rank
               FROM customer_list
                        LEFT JOIN payment
                                  ON id = customer_id
               GROUP BY name, country) a
WHERE rank BETWEEN 1 AND 3;

SELECT
name,
country,
COUNT(*),
FIRST_VALUE(name) OVER(PARTITION BY country ORDER BY count(*) DESC)
FROM customer_list
LEFT JOIN payment
ON id=customer_id
GROUP BY name,country;

SELECT
name,
country,
COUNT(*),
LEAD(name) OVER(PARTITION BY country ORDER BY count(*)) as rank
FROM customer_list
LEFT JOIN payment
ON id=customer_id
GROUP BY name,country;

SELECT
name,
country,
COUNT(*),
LEAD(COUNT(*)) OVER(PARTITION BY country ORDER BY count(*)) as rank,
LEAD(COUNT(*)) OVER(PARTITION BY country ORDER BY count(*)) - COUNT(*)
FROM customer_list
LEFT JOIN payment
ON id=customer_id
GROUP BY name,country;

SELECT
name,
country,
COUNT(*),
LAG(name) OVER(PARTITION BY country ORDER BY count(*)) as rank
FROM customer_list
LEFT JOIN payment
ON id=customer_id
GROUP BY name,country;

SELECT
name,
country,
COUNT(*),
LAG(COUNT(*)) OVER(PARTITION BY country ORDER BY count(*)) as rank,
LAG(COUNT(*)) OVER(PARTITION BY country ORDER BY count(*)) - COUNT(*)
FROM customer_list
LEFT JOIN payment
ON id=customer_id
GROUP BY name,country;

SELECT
SUM(amount),
payment_date::DATE,
LAG(SUM(amount)) OVER(ORDER BY payment_date::DATE) as previous_day,
SUM(amount) - LAG(SUM(amount)) OVER(ORDER BY payment_date::DATE) as difference,
ROUND(((SUM(amount) - LAG(SUM(amount)) OVER(ORDER BY payment_date::DATE))
/
LAG(SUM(amount)) OVER(ORDER BY payment_date::DATE))*100,2) as precentage_growth
FROM payment
GROUP BY payment_date::DATE;