SELECT
NULL as month,
staff_id,
SUM(amount)
FROM payment
GROUP BY staff_id
UNION
SELECT
TO_CHAR(payment_date,'Month'),
NULL as staff_id,
SUM(amount)
FROM payment
GROUP BY TO_CHAR(payment_date,'Month')
UNION
SELECT
TO_CHAR(payment_date,'Month'),
staff_id,
SUM(amount)
FROM payment
GROUP BY
TO_CHAR(payment_date,'Month'),
staff_id;

SELECT
TO_CHAR(payment_date,'Month') as month,
staff_id,
SUM(amount)
FROM payment
GROUP BY
    GROUPING SETS (
        (staff_id),
        (month),
        (staff_id,month)
    )
ORDER BY 1,2;

SELECT
c.first_name,
c.last_name,
s.staff_id,
SUM(amount) as total,
ROUND(100*SUM(AMOUNT)/FIRST_VALUE(SUM(amount)) OVER(PARTITION BY c.first_name,c.last_name ORDER BY SUM(amount) DESC),2) as percentage
FROM customer c
LEFT JOIN payment p
ON c.customer_id = p.customer_id
LEFT JOIN staff s
ON p.staff_id = s.staff_id
GROUP BY
    GROUPING SETS (
        (c.first_name,c.last_name),
        (c.first_name,c.last_name,s.staff_id)
    );

SELECT
'Q' || TO_CHAR(payment_date,'Q') as quarter,
EXTRACT(month from payment_date) as month,
payment_date::date,
SUM(amount)
FROM payment
GROUP BY
    ROLLUP(
        'Q' || TO_CHAR(payment_date,'Q'),
        EXTRACT(month from payment_date),
        payment_date::date
    )
ORDER BY 1,2,3;

--flights
SELECT
EXTRACT(quarter from book_date) as quarter,
EXTRACT(month from book_date) as month,
TO_CHAR(book_date,'w') as week_in_month,
book_date::date,
SUM(total_amount)
FROM bookings
GROUP BY
    ROLLUP(
    EXTRACT(quarter from book_date),
    EXTRACT(month from book_date),
    TO_CHAR(book_date,'w'),
    book_date::date
    )
ORDER BY 1,2,3,4;

--movie
SELECT
customer_id,
staff_id,
payment_date::date,
SUM(amount)
FROM payment
GROUP BY
    CUBE(
    customer_id,
    staff_id,
    payment_date::date
    )
ORDER BY 1,2,3;

SELECT
p.customer_id,
payment_date::date,
title,
SUM(amount) as total
FROM payment p
LEFT JOIN rental r
ON r.rental_id=p.rental_id
LEFT JOIN inventory i
ON i.inventory_id=r.inventory_id
LEFT JOIN film f
ON f.film_id=i.film_id
GROUP BY
    CUBE(
    p.customer_id,
    payment_date::date,
    title
    )
ORDER BY 1,2,3;

CREATE TABLE employee (
    employee_id INT,
    name VARCHAR (50),
    manager_id INT
);

INSERT INTO employee
VALUES
	(1, 'Liam Smith', NULL),
	(2, 'Oliver Brown', 1),
	(3, 'Elijah Jones', 1),
	(4, 'William Miller', 1),
	(5, 'James Davis', 2),
	(6, 'Olivia Hernandez', 2),
	(7, 'Emma Lopez', 2),
	(8, 'Sophia Andersen', 2),
	(9, 'Mia Lee', 3),
	(10, 'Ava Robinson', 3);

SELECT
emp.employee_id,
emp.name as employee,
mng.name as manager,
mng2.name as manager_of_manager
FROM employee emp
LEFT JOIN employee mng
ON emp.manager_id=mng.employee_id
LEFT JOIN employee mng2
ON mng.manager_id=mng2.employee_id;

SELECT
f1.title,
f2.title,
f2.length
FROM film f1
LEFT JOIN film f2
ON f1.length=f2.length
WHERE
f1.title<>f2.title
ORDER BY length DESC;

SELECT
staff_id,
store.store_id,
last_name,
store.store_id*staff_id
FROM staff
CROSS JOIN store;

SELECT
first_name,
last_name,
SUM(amount)
FROM payment
NATURAL INNER JOIN customer
GROUP BY first_name, last_name;

SELECT *
FROM customer
NATURAL INNER JOIN address;