-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT count(film_id) as number_hunchback
FROM INVENTORY
WHERE film_id = (SELECT film_id FROM film WHERE title = 'Hunchback Impossible');

-- 2. List all films whose length is longer than the average of all the films.
SELECT *
FROM sakila.film
WHERE length >= (SELECT avg(length) FROM sakila.film)

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT *
FROM sakila.actor
WHERE actor_id IN (SELECT actor_id
FROM sakila.film_actor INNER JOIN sakila.film USING (film_id) WHERE title = "Alone Trip"); -- I am getting an error and I cant figure out where I made the syntax error.

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT *
FROM sakila.film
WHERE film_id IN (SELECT film_id
	FROM sakila.film_category
	WHERE category_id = 
		(SELECT category_id FROM category WHERE name = 'Family'));
        
-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

-- Subqueries
SELECT CONCAT(first_name,' ',last_name),email
FROM customer
WHERE address_id IN (SELECT address_id
FROM address WHERE city_id IN (SELECT city_id
FROM city WHERE country_id IN (SELECT country_id FROM Country WHERE country = 'Canada')));


-- JOINS
SELECT CONCAT(c.first_name,' ',c.last_name) AS name,c.email
FROM customer c INNER JOIN address a USING(address_id)
INNER JOIN city ci USING(city_id) INNER JOIN country co USING(country_id)
WHERE co.country = 'Canada';


-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT *
FROM sakila.film
WHERE film_id IN 
	(SELECT film_id
	FROM sakila.film_actor
	WHERE actor_id =
		(SELECT actor_id FROM sakila.film_actor GROUP BY actor_id ORDER BY count(film_id) DESC LIMIT 1));
        
-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
SELECT customer_id FROM payment GROUP BY customer_id ORDER BY SUM(amount) DESC LIMIT 1;

SELECT title FROM film
WHERE film_id IN 
	(SELECT film_id FROM inventory
	WHERE inventory_id IN 
		(SELECT inventory_id FROM rental
		WHERE customer_id = 
			(SELECT customer_id FROM payment GROUP BY customer_id ORDER BY SUM(amount) DESC LIMIT 1)));
            
-- 8. Customers who spent more than the average payments.
