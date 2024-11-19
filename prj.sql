SELECT DISTINCT(replacement_cost)
FROM film
ORDER BY replacement_cost;

SELECT
    CASE
        WHEN replacement_cost >= 9.99 AND replacement_cost <= 19.99
        THEN 'Low'
        WHEN replacement_cost >= 20.00 AND replacement_cost <= 24.99
        THEN 'Medium'
        WHEN replacement_cost >= 25.00 AND replacement_cost <= 29.99
        THEN 'High'
    END as cost_category,
    COUNT(*)
FROM film
GROUP BY cost_category;

SELECT title, length, c.name
FROM film f
LEFT JOIN film_category fc
ON f.film_id = fc.film_id
LEFT JOIN category c
ON fc.category_id = c.category_id
WHERE c.name IN ('Drama', 'Sports')
ORDER BY length DESC;

SELECT c.name, COUNT(title)
FROM film f
LEFT JOIN film_category fc
ON f.film_id = fc.film_id
LEFT JOIN category c
ON fc.category_id = c.category_id
GROUP BY c.name;

SELECT first_name, last_name, COUNT(*)
FROM actor a
LEFT JOIN film_actor fa
ON a.actor_id = fa.actor_id
GROUP BY first_name, last_name
ORDER BY 3 DESC;

SELECT first_name, last_name, COUNT(*)
FROM film f
LEFT JOIN film_actor fa
ON f.film_id = fa.film_id
LEFT JOIN actor a
ON a.actor_id = fa.actor_id
GROUP BY first_name, last_name
ORDER BY 3 DESC;

SELECT a.address_id, address, district, first_name
FROM address a
LEFT JOIN customer c
ON a.address_id = c.address_id
WHERE first_name ISNULL;

SELECT city, SUM(amount)
FROM payment p
LEFT JOIN customer c
ON p.customer_id = c.customer_id
LEFT JOIN address a
ON c.address_id = a.address_id
LEFT JOIN city ci
ON a.city_id = ci.city_id
GROUP BY city
ORDER BY SUM(amount) DESC;

SELECT
country || ', ' || city as country_city,
SUM(amount)
FROM payment p
LEFT JOIN customer c
ON p.customer_id = c.customer_id
LEFT JOIN address a
ON c.address_id = a.address_id
LEFT JOIN city ci
ON a.city_id = ci.city_id
LEFT JOIN country co
ON ci.country_id = co.country_id
GROUP BY country_city
ORDER BY SUM(amount);

SELECT staff_id, ROUND(AVG(total),2)
FROM (
SELECT
staff_id,
customer_id,
SUM(amount) total
FROM payment
GROUP BY staff_id,
customer_id
ORDER BY 2
) as staff_payment
GROUP BY staff_id;

SELECT ROUND(AVG(daily_revenue),2)
FROM (SELECT SUM(amount) as daily_revenue, payment_date::date, EXTRACT(DOW FROM payment_date)
      FROM payment
      WHERE EXTRACT(DOW FROM payment_date) = 0
      GROUP BY payment_date::date,
               EXTRACT(DOW FROM payment_date)) as total_amount
ORDER BY 1 DESC;

SELECT
title,
length,
replacement_cost
FROM film f1
WHERE length > (SELECT AVG(length)
                FROM film f2
                WHERE f1.replacement_cost = f2.replacement_cost)
ORDER BY length;

SELECT
district,
ROUND(AVG(total),2) total_avg
FROM
(SELECT
district,
c.customer_id,
SUM(amount) total
FROM payment p
INNER JOIN customer c
ON p.customer_id=c.customer_id
INNER JOIN address a
ON a.address_id=c.address_id
GROUP BY
district,
c.customer_id) sub
GROUP BY district
ORDER BY 2 DESC;

SELECT
title,
amount,
name,
payment_id,
(SELECT SUM(amount) FROM payment p
LEFT JOIN rental r
ON r.rental_id=p.rental_id
LEFT JOIN inventory i
ON i.inventory_id=r.inventory_id
LEFT JOIN film f
ON f.film_id=i.film_id
LEFT JOIN film_category fc
ON fc.film_id=f.film_id
LEFT JOIN category c1
ON c1.category_id=fc.category_id
WHERE c1.name=c.name)
FROM payment p
LEFT JOIN rental r
ON r.rental_id=p.rental_id
LEFT JOIN inventory i
ON i.inventory_id=r.inventory_id
LEFT JOIN film f
ON f.film_id=i.film_id
LEFT JOIN film_category fc
ON fc.film_id=f.film_id
LEFT JOIN category c
ON c.category_id=fc.category_id
ORDER BY name;

SELECT title,
       name,
       SUM(amount) AS total
FROM payment p
LEFT JOIN rental r ON r.rental_id=p.rental_id
LEFT JOIN inventory i ON i.inventory_id=r.inventory_id
LEFT JOIN film f ON f.film_id=i.film_id
LEFT JOIN film_category fc ON fc.film_id=f.film_id
LEFT JOIN category c ON c.category_id=fc.category_id
GROUP BY name,
         title
HAVING SUM(amount) =
  (SELECT MAX(total)
   FROM
     (SELECT title, name,
      SUM(amount) AS total
      FROM payment p
      LEFT JOIN rental r ON r.rental_id=p.rental_id
      LEFT JOIN inventory i ON i.inventory_id=r.inventory_id
      LEFT JOIN film f ON f.film_id=i.film_id
      LEFT JOIN film_category fc ON fc.film_id=f.film_id
      LEFT JOIN category c1 ON c1.category_id=fc.category_id
      GROUP BY name, title) sub
   WHERE c.name=sub.name)