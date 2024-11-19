SELECT
SUM(amount),
AVG(amount),
ROUND(AVG(amount),2) AS average
FROM payment;

SELECT
MIN(replacement_cost),
MAX(replacement_cost),
ROUND(AVG(replacement_cost),2),
SUM(replacement_cost)
FROM film;

SELECT
staff_id,
customer_id,
SUM(amount),
COUNT(*)
FROM payment
WHERE amount > 0
GROUP BY staff_id, customer_id
ORDER BY SUM(amount);

SELECT
staff_id,
SUM(amount),
COUNT(*),
DATE(payment_date)
FROM payment
WHERE amount != 0
GROUP BY staff_id, DATE(payment_date)
HAVING COUNT(*) > 30;
ORDER BY SUM(amount) DESC, COUNT(*) DESC;

SELECT
customer_id,
DATE(payment_date),
ROUND(AVG(amount),2) AS avg_amount,
COUNT(*)
FROM payment
WHERE DATE(payment_date) IN ('2022-04-28', '2020-04-29', '2022-04-30')
GROUP BY customer_id, DATE(payment_date)
HAVING AVG(amount) > 1
ORDER BY 3 DESC;
