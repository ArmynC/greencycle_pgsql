CREATE USER sarah
WITH password 'sarah1234';

CREATE role alex
WITH LOGIN PASSWORD 'alex1234';

CREATE TABLE test_table(id SERIAL);

SELECT * FROM test_table;
DROP TABLE test_table;

CREATE USER ria
WITH PASSWORD 'ria123';

CREATE USER mike
WITH PASSWORD 'mike123';

CREATE ROLE read_only;
CREATE ROLE read_update;

GRANT USAGE
ON SCHEMA PUBLIC
TO read_only;

GRANT SELECT
ON ALL TABLES IN SCHEMA public
TO read_only;

GRANT read_only to mike;

-- mike unable to
DELETE FROM customer
WHERE customer_id=33;

GRANT read_only
TO read_update;

GRANT ALL
ON ALL TABLES IN SCHEMA public
TO read_update;

REVOKE DELETE, INSERT
ON ALL TABLES IN SCHEMA public
FROM read_update;

GRANT read_update
TO ria;

-- test mia permission
SELECT * FROM customer;

DELETE FROM customer
WHERE customer_id=33;

UPDATE customer
SET first_name = 'MARIA'
WHERE first_name = 'MARY';

DROP ROLE mike;

DROP ROLE read_update; -- dependancies error

DROP OWNED BY read_update;
DROP ROLE read_update;

CREATE USER mia
WITH PASSWORD 'mia123';

CREATE ROLE analyst_emp;

GRANT SELECT
ON ALL TABLES IN SCHEMA public
TO analyst_emp;

GRANT INSERT, UPDATE
ON employees
TO analyst_emp;

ALTER ROLE analyst_emp CREATEDB;

SELECT
(SELECT AVG(amount)
 FROM payment p2
 WHERE p2.rental_id = p1.rental_id)
FROM payment p1;

CREATE INDEX index_rental_id_payment
ON payment
(rental_id);

DROP INDEX index_rental_id_payment;