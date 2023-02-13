/*CHAPTER 8 - GROPING AND AGGREGATES*/

/*Write a query to see how many films each customer rented*/
SELECT CUSTOMER_ID, COUNT(*)
FROM RENTAL
GROUP BY CUSTOMER_ID;

/*Write a query to see how many films each customer rented. Order by films rented in descendant order*/
SELECT CUSTOMER_ID, COUNT(*)
FROM RENTAL
GROUP BY CUSTOMER_ID
ORDER BY COUNT(*) DESC;

/*Write a query to show customer who have rented 40 or more films*/
SELECT CUSTOMER_ID, COUNT(*)
FROM RENTAL
GROUP BY CUSTOMER_ID
HAVING COUNT(*) >= 40;

/*Display max min avg total and num of payments from payment table*/
SELECT MAX(AMOUNT), MIN(AMOUNT), AVG(AMOUNT), SUM(AMOUNT) AS TOTAL_AMOUNT, COUNT(*) AS TOTAL_PAYMENTS
FROM PAYMENT;

/*Display max min avg total and num of payments from every customer in payment table*/
SELECT CUSTOMER_ID, MAX(AMOUNT), MIN(AMOUNT), AVG(AMOUNT), SUM(AMOUNT) AS TOTAL_AMOUNT, COUNT(*) AS TOTAL_PAYMENTS
FROM PAYMENT
GROUP BY CUSTOMER_ID;

/*Display the total amount of distinct customers and the total amount of rows from the payment table*/
SELECT COUNT(CUSTOMER_ID) AS NUM_OF_PAYMENTS, COUNT(DISTINCT CUSTOMER_ID) AS TOTAL_CUSTOMERS
FROM PAYMENT;

/*Get the maximum number of days between when a film was rented and returned*/
SELECT *, MAX(DATEDIFF(RETURN_DATE, RENTAL_DATE))
FROM RENTAL;

/*Find how many films does each actor have*/
SELECT ACTOR_ID, COUNT(*)
FROM FILM_ACTOR
GROUP BY ACTOR_ID;

/*Find the total number of films for each film rating for each actor*/
SELECT FA.ACTOR_ID, F.RATING, COUNT(*)
FROM FILM_ACTOR FA
	INNER JOIN FILM F
	ON FA.FILM_ID = F.FILM_ID
GROUP BY FA.ACTOR_ID, F.RATING
ORDER BY FA.ACTOR_ID, F.RATING;

/*Count the total of fields from rental table. Group them by year*/
SELECT EXTRACT(YEAR FROM RENTAL_DATE), COUNT(*)
FROM RENTAL R
GROUP BY EXTRACT(YEAR FROM RENTAL_DATE);

/*Find the total number of films for each film rating for each actor. Use the rollup modifier on the group by clause*/
SELECT FA.ACTOR_ID, F.RATING, COUNT(*)
FROM FILM_ACTOR FA
	INNER JOIN FILM F
	ON FA.FILM_ID = F.FILM_ID
GROUP BY FA.ACTOR_ID, F.RATING WITH ROLLUP
ORDER BY 1, 2;

/*Filter out films rated other than G or PG, and actors who appeared in 10 or more films*/
SELECT F.RATING, COUNT(*), FA.ACTOR_ID
FROM FILM_ACTOR FA
	INNER JOIN FILM F
    ON FA.FILM_ID = F.FILM_ID
WHERE F.RATING IN ('G', 'PG')
GROUP BY FA.ACTOR_ID, F.RATING
HAVING COUNT(*) > 9;

/*--------------------------------*/
/*Construct a query that counts the number of rows in the payment table*/
SELECT COUNT(*)
FROM PAYMENT;

/*Construct a query that counts the number of rows in the payment table made by each customer. Display the id and the total amount for each customer*/
SELECT CUSTOMER_ID, COUNT(*), SUM(AMOUNT)
FROM PAYMENT
GROUP BY CUSTOMER_ID;

/*Construct a query that counts the number of rows in the payment table made by each customer. Display the id and the total amount for each customer. Show customers with 40 or more payments*/
SELECT CUSTOMER_ID, COUNT(*), SUM(AMOUNT)
FROM PAYMENT
GROUP BY CUSTOMER_ID
HAVING COUNT(*) >= 40;
