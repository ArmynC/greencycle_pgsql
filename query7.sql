CREATE DATABASE Company_x
WITH encoding = 'UTF-8';

COMMENT ON DATABASE company_x IS 'That is our database';

CREATE TABLE director (
director_id SERIAL PRIMARY KEY,
director_account_name VARCHAR(20) UNIQUE,
first_name VARCHAR(50),
last_name VARCHAR(50) DEFAULT 'Not specified',
date_of_birth DATE,
address_id INT REFERENCES address(address_id));

SELECT * FROM director;

DROP TABLE director;

ALTER TABLE director
ALTER COLUMN director_account_name TYPE VARCHAR(30),
ALTER COLUMN last_name DROP DEFAULT,
ALTER COLUMN last_name SET NOT NULL,
ADD COLUMN email VARCHAR(40);

ALTER TABLE director
RENAME COLUMN director_account_name TO account_name;

ALTER TABLE director
RENAME TO directors;

CREATE TABLE emp_table(
    emp_id SERIAL PRIMARY KEY,
    emp_name TEXT
);

SELECT * FROM emp_table;

DROP TABLE emp_table;

INSERT INTO emp_table
VALUES
(1, 'Frank'),
(2, 'Maria');

TRUNCATE emp_table;

CREATE TABLE songs(
    song_id SERIAL PRIMARY KEY,
    song_name VARCHAR(30) NOT NULL,
    genre VARCHAR(30) DEFAULT 'Not defined',
    price NUMERIC(4,2) CHECK (price>=1.99),
    release_date DATE CONSTRAINT date_check CHECK (release_date BETWEEN '1950-01-01' AND CURRENT_DATE)
);

SELECT * FROM songs;

ALTER TABLE songs
DROP CONSTRAINT songs_price_check;

ALTER TABLE songs
ADD CONSTRAINT songs_price_check CHECK (price>=0.99);

INSERT INTO songs
(song_name,price,release_date)
VALUES
('SQL Song',0.99,'2022-01-07');

TRUNCATE songs;