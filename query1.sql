SELECT
COUNT (*)
FROM payment
WHERE amount = 0;

SELECT
first_name
FROM customer
WHERE first_name = 'ADAM';

SELECT COUNT(amount)
FROM payment
WHERE customer_id = 100;

SELECT last_name, first_name
FROM customer
WHERE first_name = 'ERICA';

SELECT *
FROM payment
WHERE amount > 10
ORDER BY amount DESC;

SELECT COUNT(*)
FROM rental
WHERE return_date IS null;

SELECT payment_id
FROM payment
WHERE amount <= 2
ORDER BY amount DESC;

SELECT *
FROM payment
WHERE (customer_id=30
OR customer_id = 31)
AND amount = 2.99;

SELECT *
FROM payment
WHERE (customer_id = 322
OR customer_id = 346
OR customer_id = 354)
AND (amount < 2 OR amount > 10)
ORDER BY customer_id, amount DESC;

SELECT * FROM rental
WHERE rental_date BETWEEN '2022-05-24' AND '2022-05-26 21:59'
ORDER BY rental_date DESC;

SELECT COUNT(amount)
FROM payment
WHERE (payment_date BETWEEN '2022-01-26' AND '2022-01-27 23:59')
AND (amount BETWEEN 1.99 AND 3.99);

SELECT * FROM customer
WHERE customer_id IN (123,212,323,243,353,432);

SELECT * FROM customer
WHERE first_name NOT IN ('LYDIA','MATTHEW');

SELECT amount FROM payment
WHERE customer_id IN (12,25,67,93,124,234)
AND amount IN (4.99,7.99, 9.99)
AND payment_date BETWEEN '2022-01-01' AND '2022-02-01';

SELECT * FROM film
WHERE description LIKE '%Drama%'
AND title LIKE '_T%';

SELECT COUNT(description)
FROM film
WHERE description LIKE '%Documentary%';

SELECT COUNT(customer_id)
FROM customer
WHERE first_name LIKE '___'
AND (last_name LIKE '%X' OR last_name LIKE '%Y');

SELECT title, description AS description_of_movie, release_year
FROM film
WHERE description LIKE '%Documentary%';

SELECT COUNT(title) as no_of_movies
FROM film
WHERE description LIKE '%Saga%'
AND (title LIKE 'A%' OR title LIKE '%R');

SELECT first_name
FROM customer
WHERE first_name ILIKE '%ER%'
AND first_name ILIKE '_A%'
ORDER BY last_name DESC;

SELECT COUNT(payment_id)
FROM payment
WHERE (amount = 0
OR amount BETWEEN 3.99 AND 7.99)
AND payment_date BETWEEN '2022-05-01' AND '2022-05-02';