-- 1. List the number of films per category.
SELECT 
    c.name AS category_name, 
    COUNT(f.film_id) AS number_of_films
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.category_id;

-- 2. Retrieve the store ID, city, and country for each store.
SELECT 
    s.store_id,
    a.city,
    a.country
FROM store s
JOIN address a ON s.address_id = a.address_id
JOIN city c ON a.city_id = c.city_id
JOIN country co ON c.country_id = co.country_id;

-- 3. Calculate the total revenue generated by each store in dollars.
SELECT 
    s.store_id,
    SUM(p.amount) AS total_revenue
FROM store s
JOIN inventory i ON s.store_id = i.store_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY s.store_id;

-- 4. Determine the average running time of films for each category.
SELECT 
    c.name AS category_name,
    AVG(f.length) AS average_length
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.category_id;

-- Bonus: Identify the film categories with the longest average running time.
SELECT 
    c.name AS category_name,
    AVG(f.length) AS average_length
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.category_id
HAVING AVG(f.length) = (SELECT MAX(average_length) 
                        FROM (SELECT AVG(length) AS average_length 
                              FROM film f2
                              JOIN film_category fc2 ON f2.film_id = fc2.film_id
                              GROUP BY fc2.category_id) AS subquery);

-- Bonus: Display the top 10 most frequently rented movies in descending order.
SELECT 
    f.title,
    COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id
ORDER BY rental_count DESC
LIMIT 10;

-- Bonus: Determine if "Academy Dinosaur" can be rented from Store 1.
SELECT 
    CASE 
        WHEN COUNT(i.inventory_id) > 0 THEN 'Can be rented'
        ELSE 'Cannot be rented'
    END AS rental_status
FROM inventory i
JOIN film f ON i.film_id = f.film_id
WHERE f.title = 'Academy Dinosaur' AND i.store_id = 1;

-- Provide a list of all distinct film titles, along with their availability status in the inventory.
SELECT 
    f.title,
    CASE 
        WHEN i.inventory_id IS NOT NULL THEN 'Available'
        ELSE 'NOT available'
    END AS availability_status
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
GROUP BY f.title;