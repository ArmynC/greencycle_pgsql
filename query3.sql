SELECT
UPPER(email) AS email_upper,
LOWER(email) AS email_lower,
email,
LENGTH(email)
FROM customer
WHERE LENGTH(email) < 30;

SELECT
LOWER(first_name),
LOWER(last_name),
LOWER(email)
FROM customer
WHERE LENGTH(first_name) > 10
OR LENGTH(last_name) > 10;

SELECT
LEFT(first_name,2),
RIGHT(first_name,1),
first_name
FROM customer;

SELECT
RIGHT(LEFT(first_name,3),1),
first_name
FROM customer;

SELECT
RIGHT(email,5),
LEFT(RIGHT(email,4),1)
FROM customer;

SELECT
LEFT(first_name,1) || '.' || LEFT(last_name,1) || '.' AS initials,
first_name,
last_name
FROM customer;

SELECT
email,
LEFT(email,1) || '***' || RIGHT(email,19) AS email_anonymized
FROM customer;

SELECT
POSITION('@' IN email),
email
FROM customer;

SELECT
LEFT(email,POSITION('@' IN email)),
LEFT(email,POSITION('@' IN email)-1),
email
FROM customer;

SELECT
LEFT(email,POSITION(last_name IN email)),
LEFT(email,POSITION(last_name IN email)-2),
email
FROM customer;

SELECT
LEFT(email,POSITION(last_name IN email)-2) || ', ' || last_name as name,
email
FROM customer;

SELECT
last_name || ', ' || LEFT(email,POSITION('.' IN email)-1)
FROM customer;

SELECT
email,
SUBSTRING(email from 3 for 2)
FROM customer;

SELECT
email,
SUBSTRING (email from POSITION('.' IN email)+1 for LENGTH(last_name))
FROM customer;

SELECT
email,
SUBSTRING (email from POSITION('.' IN email)+1 for POSITION('@' IN email)-POSITION('.' IN email)-1)
FROM customer;

SELECT
email,
SUBSTRING(email from 1 for POSITION('.' IN email)-1) || SUBSTRING(email from POSITION('.' IN email) for POSITION('@' IN email)-POSITION('.' IN email))
FROM customer;

SELECT
email,
LEFT(SUBSTRING(email from 1 for POSITION('.' IN email)-1),1)
|| '***' || '.' ||
LEFT(SUBSTRING(email from POSITION('.' IN email)+1 for POSITION('@' IN email)-POSITION('.' IN email)),1)
|| '***' ||
SUBSTRING(email from POSITION('@' IN email) for POSITION(RIGHT(email,1) IN email)+1-POSITION('@' IN email)) AS email_anonymized
FROM customer;

SELECT
email,
'***' ||
RIGHT(SUBSTRING(email from 1 for POSITION('.' IN email)-1),1)
|| '.' ||
LEFT(SUBSTRING(email from POSITION('.' IN email)+1 for POSITION('@' IN email)-POSITION('.' IN email)),1)
|| '***' ||
SUBSTRING(email from POSITION('@' IN email) for POSITION(RIGHT(email,1) IN email)+1-POSITION('@' IN email)) AS email_anonymized
FROM customer;

SELECT
'***'
|| SUBSTRING(email from POSITION('.' IN email)-1 for 3)
|| '***'
|| SUBSTRING(email from POSITION('@' IN email))
FROM customer;

SELECT
EXTRACT(DAY from rental_date),
COUNT(*)
FROM rental
GROUP BY EXTRACT(DAY from rental_date)
ORDER BY COUNT(*) DESC;

SELECT
EXTRACT(MONTH from rental_date),
COUNT(*)
FROM rental
GROUP BY EXTRACT(MONTH from rental_date)
ORDER BY COUNT(*) DESC;

SELECT
EXTRACT(MONTH from payment_date) AS month,
SUM(amount)
FROM payment
GROUP BY month
ORDER BY COUNT(payment_date) DESC;

SELECT
EXTRACT(DOW from payment_date) AS day_of_week,
SUM(amount)
FROM payment
GROUP BY day_of_week
ORDER BY COUNT(payment_date) DESC;

SELECT
customer_id,
EXTRACT(WEEK from payment_date) AS week,
SUM(amount) AS total_payment
FROM payment
GROUP BY week, customer_id
ORDER BY COUNT(amount) DESC;

SELECT *,
EXTRACT(MONTH from payment_date),
TO_CHAR(payment_date,'Day'),
TO_CHAR(payment_date,'MM/YYYY'),
TO_CHAR(payment_date,'Day Month YYYY')
FROM payment;

SELECT
SUM(amount),
TO_CHAR(payment_date,'Dy, Month YYYY')
FROM payment
GROUP BY TO_CHAR(payment_date,'Dy, Month YYYY')

SELECT
SUM(amount) AS total_amount,
TO_CHAR(payment_date,'Dy, DD/MM/YYYY') AS day_y,
TO_CHAR(payment_date,'Mon, YYYY') AS mon,
TO_CHAR(payment_date,'Dy, HH:MM') AS day
FROM payment
GROUP BY payment_date
ORDER BY SUM(amount) DESC;

SELECT
SUM(amount) AS total_amount,
TO_CHAR(payment_date,'Dy, DD/MM/YYYY') AS day_y
FROM payment
GROUP BY day_y
ORDER BY total_amount DESC;

SELECT
SUM(amount) AS total_amount,
TO_CHAR(payment_date,'Mon, YYYY') AS mon_y
FROM payment
GROUP BY mon_y
ORDER BY total_amount DESC;

SELECT
SUM(amount) AS total_amount,
TO_CHAR(payment_date,'Dy, HH:MM') AS day
FROM payment
GROUP BY day
ORDER BY total_amount DESC;

SELECT CURRENT_DATE;
SELECT CURRENT_TIMESTAMP;

SELECT
CURRENT_DATE,
rental_date
FROM rental;

SELECT
CURRENT_TIMESTAMP,
CURRENT_TIMESTAMP-rental_date,
EXTRACT(DAY from return_date-rental_date)*24
+ EXTRACT(hour from return_date-rental_date) || 'hours'
FROM rental;

SELECT
CURRENT_TIMESTAMP,
TO_CHAR(return_date-rental_date,'MI')
FROM rental;

SELECT
customer_id,
return_date-rental_date AS date
FROM rental
WHERE customer_id = 35;
GROUP BY customer_id, date;

SELECT
customer_id,
AVG(return_date-rental_date) AS date
FROM rental
GROUP BY customer_id
ORDER BY date DESC;