SELECT payment_id,
pa.customer_id,
amount,
first_name,
last_name
FROM payment AS pa
INNER JOIN customer AS cu
ON pa.customer_id = cu.customer_id;

SELECT
payment.*,
first_name,
last_name,
email
FROM payment
INNER JOIN staff
ON staff.staff_id = payment.staff_id
WHERE staff.staff_id = 1;

--flights
SELECT
    s.fare_conditions AS "Fare Conditions",
    COUNT(*) AS "Count"
FROM
    boarding_passes AS bp
INNER JOIN
    flights AS f
    ON bp.flight_id = f.flight_id
INNER JOIN
    seats s
    ON f.aircraft_code = s.aircraft_code AND bp.seat_no = s.seat_no
GROUP BY
    s.fare_conditions
ORDER BY 2 DESC;

SELECT *
FROM boarding_passes b
FULL OUTER JOIN tickets t
ON b.ticket_no = t.ticket_no
WHERE b.ticket_no IS NULL;

SELECT * FROM aircrafts_data a
LEFT JOIN flights f
ON a.aircraft_code = f.aircraft_code
WHERE f.flight_id IS null;

SELECT
    boarding_passes.seat_no,
    COUNT(*)
FROM;

SELECT RIGHT(s.seat_no,1), COUNT(*) FROM seats s
LEFT JOIN boarding_passes b
ON s.seat_no = b.seat_no
GROUP BY RIGHT(s.seat_no,1)
ORDER BY COUNT(*) DESC;

--movies
SELECT
    district,
    first_name,
    last_name,
    a.phone
FROM customer c
LEFT JOIN address a
ON c.address_id = a.address_id
WHERE district = 'Texas';

SELECT *
FROM address a
LEFT JOIN customer c
ON c.address_id = a.address_id
WHERE first_name IS null;

--flights
SELECT seat_no, ROUND(AVG(amount),2) FROM boarding_passes b
LEFT JOIN ticket_flights t
ON b.ticket_no = t.ticket_no
AND b.flight_id = t.flight_id
GROUP BY seat_no
ORDER BY 2 DESC;

SELECT t.ticket_no, tf.flight_id, passenger_name, scheduled_departure
FROM tickets t
INNER JOIN ticket_flights tf
ON t.ticket_no = tf.ticket_no
INNER JOIN flights f
ON f.flight_id = tf.flight_id;

--movie
SELECT first_name, last_name, email, co.country
FROM customer cu
LEFT JOIN address ad
ON cu.address_id = ad.address_id
LEFT JOIN city ci
ON ci.city_id = ad.city_id
LEFT JOIN country co
ON co.country_id = ci.country_id
WHERE country = 'Brazil';

--flights
SELECT passenger_name, SUM(total_amount)
FROM tickets t
LEFT JOIN bookings b
ON t.book_ref = b.book_ref
GROUP BY passenger_name
ORDER BY 2 DESC;

SELECT passenger_name, fare_conditions, COUNT(*)
FROM tickets t
INNER JOIN bookings b
ON t.book_ref = b.book_ref
INNER JOIN ticket_flights tf
ON t.ticket_no = tf.ticket_no
WHERE passenger_name = 'ALEKSANDR IVANOV'
GROUP BY fare_conditions, passenger_name
ORDER BY 3 DESC;

--movie
SELECT first_name, last_name, title, COUNT(*)
FROM customer cu
INNER JOIN rental re
ON cu.customer_id = re.customer_id
INNER JOIN inventory inv
ON inv.inventory_id = re.inventory_id
INNER JOIN film fi
ON fi.film_id = inv.film_id
WHERE first_name='GEORGE' AND last_name='LINTON'
GROUP BY title, first_name, last_name
ORDER BY 4 DESC;