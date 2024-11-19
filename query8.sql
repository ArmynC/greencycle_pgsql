SELECT * FROM CUSTOMER
ORDER BY customer_id;

UPDATE customer
SET last_name='BROWN'
WHERE customer_id = 1;

UPDATE customer
SET email = lower(email);

UPDATE film
SET rental_rate = 1.99
WHERE rental_rate = 0.99;

ALTER TABLE customer
ADD COLUMN initials VARCHAR(10);

UPDATE customer
SET initials = LEFT(first_name,1) || '.' || LEFT(last_name,1) || '.';

INSERT INTO songs (song_name, genre, price, release_date)
VALUES
('Have a talk with Data','Chill out', 5.99,'01-06-2022'),
('Tame with Data','Classical', 4.99,'01-06-2022');

SELECT * FROM songs;

DELETE FROM songs
WHERE genre='Country music';

DELETE FROM songs
WHERE song_id IN (3,4)
RETURNING song_name, song_id;

DELETE FROM payment
WHERE payment_id IN (17021, 17025)
RETURNING *;

CREATE TABLE customer_address
AS
SELECT first_name, last_name, email, address, city
FROM customer c
LEFT JOIN address a
ON c.address_id=a.address_id
LEFT JOIN city ci
ON ci.city_id =a.city_id;

SELECT * FROM customer_address;

CREATE TABLE customer_spendings
AS
SELECT
first_name || ' ' || last_name AS name,
SUM(amount) AS total_amount
FROM customer c
LEFT JOIN payment p
ON c.customer_id=p.customer_id
GROUP BY first_name || ' ' || last_name;

SELECT * FROM customer_spendings;

DROP TABLE customer_spendings;

CREATE VIEW customer_spendings
AS
SELECT
first_name || ' ' || last_name AS name,
SUM(amount) AS total_amount
FROM customer c
LEFT JOIN payment p
ON c.customer_id=p.customer_id
GROUP BY first_name || ' ' || last_name;

CREATE VIEW films_category
AS
SELECT
title,
name,
length
FROM film f
LEFT JOIN film_category fc
ON f.film_id=fc.film_id
LEFT JOIN category c
ON c.category_id=fc.category_id
WHERE name IN ('Action','Comedy')
ORDER BY length DESC;

CREATE MATERIALIZED VIEW mv_film_category
AS
SELECT
title,
name,
length
FROM film f
LEFT JOIN film_category fc
ON f.film_id=fc.film_id
LEFT JOIN category c
ON c.category_id =fc.category_id
WHERE name IN('Action','Comedy')
ORDER BY length DESC;

SELECT * FROM mv_film_category;

REFRESH MATERIALIZED view mv_film_category;

UPDATE film
SET length=192
WHERE title='WORST BANGER';

CREATE VIEW v_customer_info
AS
SELECT cu.customer_id,
    cu.first_name || ' ' || cu.last_name AS name,
    a.address,
    a.postal_code,
    a.phone,
    city.city,
    country.country
     FROM customer cu
     JOIN address a ON cu.address_id = a.address_id
     JOIN city ON a.city_id = city.city_id
     JOIN country ON city.country_id = country.country_id
ORDER BY customer_id;

ALTER VIEW v_customer_info
RENAME TO v_customer_information;

ALTER VIEW v_customer_information
RENAME COLUMN customer_id TO c_id;

CREATE OR REPLACE VIEW v_customer_information
AS
SELECT
    cu.customer_id as c_id,
    cu.first_name || ' ' || cu.last_name AS name,
    a.address,
    a.postal_code,
    a.phone,
    city.city,
    country.country,
    CONCAT(LEFT(cu.first_name,1),LEFT(cu.last_name,1)) as initials
FROM customer cu
JOIN address a ON cu.address_id = a.address_id
JOIN city ON a.city_id = city.city_id
JOIN country ON city.country_id = country.country_id
ORDER BY c_id;

CREATE TABLE sales (
    transaction_id SERIAL PRIMARY KEY,
    customer_id INT,
    payment_type VARCHAR(20),
    creditcard_no VARCHAR(20),
    cost DECIMAL(5,2),
    quantity INT,
    PRICE DECIMAL(5,2)
);

SELECT * FROM sales;