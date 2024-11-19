CREATE FUNCTION count_rr (min_r decimal(4,2),max_r decimal(4,2))
RETURNS INT
LANGUAGE plpgsql
AS
$$
DECLARE
movie_count INT;
BEGIN
SELECT COUNT(*)
INTO movie_count
FROM film
WHERE rental_rate BETWEEN min_r AND max_r;
RETURN movie_count;
END;
$$;

SELECT count_rr(3,6);

CREATE OR REPLACE FUNCTION search_on_name(first_n VARCHAR(20), last_n VARCHAR(20))
RETURNS NUMERIC(6,2)
LANGUAGE plpgsql
AS
$$
DECLARE
total_payments NUMERIC(6,2);
BEGIN
SELECT SUM(amount)
INTO total_payments
FROM payment p
LEFT JOIN customer c
ON p.customer_id = c.customer_id
WHERE c.first_name = first_n
AND c.last_name = last_n;
RETURN total_payments;
END;
$$;

SELECT search_on_name('AMY','LOPEZ');


CREATE TABLE acc_balance (
    id SERIAL PRIMARY KEY,
    first_name TEXT NOT NULL,
	last_name TEXT NOT NULL,
    amount DEC(9,2) NOT NULL
);

INSERT INTO acc_balance
VALUES
(1,'Tim','Brown',2500),
(2,'Sandra','Miller',1600)

SELECT * FROM acc_balance;

BEGIN;

UPDATE acc_balance
SET amount = amount -100
WHERE id=1;

UPDATE acc_balance
SET amount = amount +100
WHERE id=2;

COMMIT;

BEGIN;
UPDATE employees
SET position_title='Head of Sales'
WHERE emp_id=2;
UPDATE employees
SET position_title='Head of BI'
WHERE emp_id=3;
UPDATE employees
SET salary=12587.00
WHERE emp_id=2;
UPDATE employees
SET salary=14614.00
WHERE emp_id=3;
COMMIT;

SELECT * FROM acc_balance;

BEGIN;
UPDATE acc_balance
SET amount = amount -100
WHERE id=2;
DELETE FROM acc_balance
WHERE id=1;
ROLLBACK;

BEGIN;
UPDATE acc_balance
SET amount = amount -100
WHERE id=2;
SAVEPOINT s1;
DELETE FROM acc_balance
WHERE id=1;
ROLLBACK TO SAVEPOINT s1;

CREATE OR REPLACE PROCEDURE sp_transfer
(tr_amount INT, sender INT, recipient INT)
LANGUAGE plpgsql
AS
$$
BEGIN
UPDATE acc_balance
SET amount = amount + tr_amount
WHERE id = recipient;
UPDATE acc_balance
SET amount = amount - tr_amount
WHERE id = sender;
COMMIT;
END;
$$;

CALL sp_transfer(500,1,2);

SELECT * FROM acc_balance;

CREATE OR REPLACE PROCEDURE emp_swap (emp1 INT, emp2 INT)
LANGUAGE plpgsql
AS
$$
DECLARE
salary1 DECIMAL(8,2);
salary2 DECIMAL(8,2);
position1 TEXT;
position2 TEXT;
BEGIN

-- store values in variables
SELECT salary
INTO salary1
FROM employees
WHERE emp_id=1;

SELECT salary
INTO salary2
FROM employees
WHERE emp_id=2;

SELECT position_title
INTO position1
FROM employees
WHERE emp_id=1;

SELECT position_title
INTO position2
FROM employees
WHERE emp_id=2;

-- update salary

UPDATE employees
SET salary = salary2
WHERE emp_id=1;

UPDATE employees
SET salary = salary1
WHERE emp_id=2;

-- update title
UPDATE employees
SET position_title = position2
WHERE emp_id=1;

UPDATE employees
SET position_title = position1
WHERE emp_id=2;

COMMIT;
END;
$$;

CALL emp_swap(1,2);

SELECT * FROM employees
ORDER BY 1;