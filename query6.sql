SELECT first_name AS first_name, 'actor' AS origin FROM actor
UNION
SELECT first_name, 'customer' AS test1 FROM customer
UNION
SELECT UPPER(first_name), 'staff' FROM staff
ORDER BY 2 DESC;

SELECT
*
FROM payment
WHERE amount > (SELECT AVG(amount) FROM payment);

SELECT
*
FROM payment
WHERE customer_id = (SELECT customer_id FROM customer
                     WHERE first_name = 'ADAM');

SELECT title
FROM film
WHERE length > (SELECT AVG(length) FROM film);

SELECT * FROM film
WHERE film_id IN
(SELECT film_id FROM inventory
WHERE store_id=2
GROUP BY film_id
HAVING COUNT(*) >3);

SELECT first_name, last_name
FROM customer
WHERE customer_id IN
(SELECT customer_id
FROM payment
WHERE payment_date::date = '2022-01-25 23:59'
GROUP BY customer_id);

SELECT first_name, last_name, email
FROM customer
WHERE customer_id IN(
SELECT customer_id
FROM payment
GROUP BY customer_id
HAVING SUM(amount)>30
);

SELECT first_name, last_name, email
FROM customer
WHERE customer_id IN (SELECT customer_id
                      FROM payment
                      GROUP BY customer_id
                      HAVING SUM(amount) > 100)
AND customer_id IN (SELECT customer_id
                      FROM customer
                      INNER JOIN address
                      ON address.address_id = customer.address_id
                      WHERE district = 'California');

SELECT ROUND(AVG(total_amount),2) AS life_time_spent
FROM
(SELECT customer_id, SUM(amount) AS total_amount FROM payment
GROUP BY customer_id) AS subquery

SELECT
ROUND(AVG(amount_per_day),2) daily_rev
FROM
(SELECT
SUM(amount) amount_per_day,
payment_date::date
FROM payment
GROUP BY payment_date::date) A

SELECT
*, 'hello', 3
FROM payment;

SELECT
*, (SELECT ROUND(AVG(amount),2) FROM payment)
FROM payment;

SELECT
*, (SELECT MAX(amount) FROM payment)-amount difference
FROM payment;

SELECT * FROM payment p1
WHERE amount = (SELECT MAX(amount) FROM payment p2
                WHERE p1.customer_id = p2.customer_id)
ORDER BY customer_id;

SELECT title, film_id, replacement_cost, rating
FROM film f1
WHERE replacement_cost = (SELECT MIN(replacement_cost)
                          FROM film f2
                          WHERE f1.rating = f2.rating);

SELECT title, film_id, length, rating
FROM film f1
WHERE length = (SELECT MAX(length)
                          FROM film f2
                          WHERE f1.rating = f2.rating);

SELECT *,
(SELECT MAX(amount) FROM payment p2
WHERE p1.customer_id=p2.customer_id)
FROM payment p1
ORDER BY customer_id

SELECT
payment_id,
customer_id,
staff_id,
amount,
(SELECT SUM(amount) sum_amount
FROM payment p2
WHERE p1.customer_id=p2.customer_id),
(SELECT COUNT(amount) count_payments
FROM payment p2
WHERE p1.customer_id=p2.customer_id)
FROM payment p1
ORDER BY customer_id, amount DESC;

SELECT title,
       replacement_cost,
       rating,
       (SELECT AVG(replacement_cost)
        FROM film f2
        WHERE f1.rating = f2.rating)
FROM film f1
WHERE replacement_cost = (SELECT MAX(replacement_cost)
                          FROM film f3
                          WHERE f1.rating = f3.rating);

SELECT first_name, amount, payment_id
FROM payment p1
         INNER JOIN customer C
                    on p1.customer_id = c.customer_id
WHERE amount = (SELECT MAX(amount)
                FROM payment p2
                WHERE p1.customer_id = p2.customer_id);