WITH subquery AS(
    SELECT f.film_id, f.title, COUNT(r.rental_id) AS rental_count
        FROM film f
        JOIN inventory i on f.film_id = i.film_id
        JOIN rental r ON i.inventory_id = r.inventory_id
        GROUP BY f.film_id, f.title
)
SELECT film_id, title, rental_count
FROM subquery AS film_rentals
WHERE rental_count > 30;

-- no CTE
SELECT film_id, title, rental_duration
FROM (
    SELECT
        f.film_id,
        f.title,
        AVG(r.return_date - r.rental_date) AS rental_duration
        FROM film f
        JOIN inventory i ON f.film_id = i.film_id
        JOIN rental r ON i.inventory_id = r.inventory_id
        GROUP BY f.film_id, f.title
     ) AS film_durations
WHERE rental_duration > (
    SELECT AVG(rental_Duration)
    FROM (
        SELECT AVG(r.return_date - r.rental_date) AS rental_duration
        FROM film f
        JOIN inventory i ON f.film_id = i.film_id
        JOIN rental r ON i.inventory_id = r.inventory_id
        GROUP BY f.film_id
         )  AS subquery
    );

-- CTE
WITH rental_duration_cte AS
    (
        SELECT
        f.film_id,
        f.title,
        AVG(r.return_date - r.rental_date) AS rental_duration
        FROM film f
        JOIN inventory i ON f.film_id = i.film_id
        JOIN rental r ON i.inventory_id = r.inventory_id
        GROUP BY f.film_id, f.title
    )
SELECT film_id, title, rental_duration
FROM rental_duration_cte
WHERE rental_duration > (
    SELECT AVG(rental_duration)
    FROM rental_duration_cte
    );

WITH customer_totals AS (
    SELECT c.customer_id, c.first_name, c.last_name,
           COUNT(r.rental_id) AS rental_count,
           SUM(p.amount) AS total_amount
    FROM customer c
    JOIN rental r ON c.customer_id = r.customer_id
    JOIN payment p ON c.customer_id = p.customer_id AND p.rental_id = r.rental_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT customer_id, first_name, last_name, rental_count, total_amount
FROM customer_totals
WHERE rental_count > (SELECT AVG(rental_count) FROM customer_totals);


-- 1. Define the CTE for calculating total spending per customer
WITH customer_spending AS(
    SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_spent
    FROM customer c
    JOIN payment p ON c.customer_id = p.customer_id
    GROUP BY C.customer_id, c.first_name, c.last_name
),

-- 2. Define the CTE for finding high-spending customers
high_spending_customers AS (
    SELECT cs.customer_id, cs.first_name, cs.last_name, cs.total_spent
    FROM customer_spending cs
    WHERE cs.total_spent > (SELECT AVG(total_spent) FROM customer_spending)
)

-- 3. Use the CTEs to find films rented by high-spending customers
SELECT
    hsc.customer_id,
    hsc.first_name,
    hsc.last_name,
    hsc.total_spent,
    f.film_id,
    f.title
FROM high_spending_customers hsc
JOIN rental r ON hsc.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id;

-- Step 1: Create a CTE to calculate the total rental count and total rental amount for each customer

WITH customer_totals AS (
    SELECT c.customer_id, c.first_name, c.last_name,
           COUNT(r.rental_id) AS rental_count,
           SUM(p.amount) AS total_amount
    FROM customer c
    JOIN rental r ON c.customer_id = r.customer_id
    JOIN payment p ON c.customer_id = p.customer_id AND p.rental_id = r.rental_id
    GROUP BY c.customer_id, c.first_name, c.last_name
),

-- Step 2: Calculate the average rental count across all customers

average_rental_count AS (
    SELECT AVG(rental_count) AS avg_rental_count
    FROM customer_totals
),

-- Step 3: Identify customers who have rented more than the average number of films (high-rental customers)

high_rental_customers AS (
    SELECT ct.customer_id, ct.first_name, ct.last_name, ct.rental_count, ct.total_amount
    FROM customer_totals ct
    JOIN average_rental_count arc ON ct.rental_count > arc.avg_rental_count
)

-- Step 4: List the details of the films rented by these high-rental customers

SELECT hrc.customer_id, hrc.first_name, hrc.last_name, hrc.rental_count, hrc.total_amount, f.film_id, f.title
FROM high_rental_customers hrc
JOIN rental r ON hrc.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id;

WITH RECURSIVE count_cte AS (
    -- 1. Define recursive CTE
    -- Anchor member: Start with 1
    SELECT 1 AS number

    UNION ALL

    -- Recursive number: Increment the number by until 10
    SELECT number * 2
    FROM count_cte
    WHERE number < 5
)

-- 2. Select all numbers from the recursive CTE
    SELECT number
    FROM count_cte;


-- Hierarchical Category Table
    -- 1. New table

CREATE TABLE hierarchical_category (
    category_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    parent_category_id INTEGER REFERENCES hierarchical_Category(category_id)
);

-- 2. Insert sample data to establish hierarchical relationships
INSERT INTO hierarchical_category (category_id, name, parent_category_id)
VALUES
(1, 'Action', NULL),
(2, 'Animation', NULL),
(3, 'Children', 2),
(4, 'Classics', 1),
(5, 'Comedy', 1),
(6, 'Superhero', 4),
(7, 'Slapstick', 5),
(8, 'Documentary', NULL),
(9, 'Nature', 8),
(10, 'Space', 9),
(11, 'Astronomy', 10);

-- Using a recursive CTE with the new hierarchical category table
WITH RECURSIVE category_hierarchy AS(
    -- Anchor member: Select the given category
    SELECT c.category_id, c.name, c.parent_category_id
    FROM hierarchical_category c
    WHERE c.category_id = 1 -- Start with the given category

    UNION ALL

    -- Recursive member: Select subcategories of the current set of categories
    SELECT c.category_id, c.name, c.parent_category_id
    FROM hierarchical_category c
    INNER JOIN category_hierarchy ch ON c.parent_category_id = ch.category_id
)

-- 2. Select all subcategories from the recursive CTE
SELECT category_id, name, parent_category_id
FROM category_hierarchy;

-- Termination Condition
WITH RECURSIVE category_hierarchy AS (
    -- Anchor member: Select the given category with depth 1
    SELECT c.category_id, c.name, c.parent_category_id, 1 AS depth
    FROM hierarchical_category c
    WHERE c.category_id = 1 -- Start with the given category

    UNION ALL

    -- Recursive member: Select subcategories of the current set of categories
    SELECT c.category_id, c.name, c.parent_category_id, ch.depth + 1 AS DEPTH
    FROM hierarchical_category C
    INNER JOIN category_hierarchy ch ON c.parent_category_id = ch.category_id
    WHERE ch.depth < 2 -- Limit recursion depth to 2 levels
)

-- 2. Select all subcategories from the recursive CTE
SELECT category_id, name, parent_category_id, depth
FROM category_hierarchy;


--Step 1: Use a recursive CTE to find all subordinates of a given employee.
WITH RECURSIVE subordinate_tree AS (
    -- Anchor member: Select the given employee with level 1
    SELECT e.employee_id, e.name, e.manager_id, 1 AS level
    FROM employee e
    WHERE e.employee_id = 1  -- Start with the given employee (Alice)

    UNION ALL

    -- Recursive member: Select subordinates of the current set of employees and increment the level
    SELECT e.employee_id, e.name, e.manager_id, st.level + 1 AS level
    FROM employee e
    INNER JOIN subordinate_tree st ON e.manager_id = st.employee_id
)

-- Step 2: Select all subordinates from the recursive CTE
SELECT employee_id, name, manager_id, level
FROM subordinate_tree;