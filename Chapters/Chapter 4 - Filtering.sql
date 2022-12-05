/*CHAPTER 4 - FILTERING*/

/*Delete all the rentals from year 2004*/
DELETE
FROM RENTAL
WHERE YEAR(RENTAL_DATE) = 2004;

/*Delete all the rentals that were not in 2004 and 2006*/
DELETE
FROM RENTAL
WHERE YEAR(RENTAL_DATE) <> 2004
	AND YEAR(RENTAL_DATE) <> 2006;    

/*Get customer id and rental for all the rentals prior to 2005-05-25*/
SELECT CUSTOMER_ID, RENTAL_DATE
FROM RENTAL
WHERE RENTAL_DATE < '2005-05-25';

/*Get customer id and rental date from all films rented between 14 and 16 june 2005*/
SELECT CUSTOMER_ID, RENTAL_DATE
FROM RENTAL
WHERE RENTAL_DATE >= '2005-06-14' AND RENTAL_DATE <= '2005-06-16';

/*Get customer id and rental date from all films rented between 14 and 16 june 2005 using the BETWEEN operator*/
SELECT CUSTOMER_ID, RENTAL_DATE
FROM RENTAL
WHERE RENTAL_DATE BETWEEN '2005-06-14' AND '2005-06-16';

/*Get all the payments, customer id and amount from payment table between $10 and $11.99*/
SELECT CUSTOMER_ID, PAYMENT_DATE, AMOUNT
FROM PAYMENT
WHERE AMOUNT BETWEEN 10 AND 11.99;

/*Get all the film titles and rating from film table that are G or PG rated*/
SELECT TITLE, RATING
FROM FILM
WHERE RATING = 'G' OR RATING = 'PG';

/*Get all the film titles and rating from film table that are G or PG rated using the IN operator*/
SELECT TITLE, RATING
FROM FILM
WHERE RATING IN( 'G', 'PG');

/*Search for all the RATINGS from films containing PET in their title. Use the operator IN and a subquery. Then get all the film titles and ratings from those films*/
SELECT TITLE, RATING
FROM FILM
WHERE RATING IN(SELECT RATING
				FROM FILM
                WHERE TITLE LIKE '%PET%');
                
/*Select all the films that are not in rating pg13, r and nc17*/
SELECT TITLE, RATING
FROM FILM
WHERE RATING NOT IN ('PG-13', 'R', 'NC-17');

/*Select customers fname and lname where lname starts with Q*/
SELECT LAST_NAME, FIRST_NAME
FROM CUSTOMER
WHERE LEFT(LAST_NAME, 1) = 'Q';

/*Search for customers whose last name contains the letter A in second place, the letter T in 4th place followed by any number of characters then ending in S*/
SELECT LAST_NAME, FIRST_NAME
FROM CUSTOMER
WHERE LAST_NAME LIKE '_A_T%S';

/*Search for all the customers whose last name starts with Q or Y*/
SELECT LAST_NAME, FIRST_NAME
FROM CUSTOMER
WHERE LAST_NAME LIKE 'Q%' OR LAST_NAME LIKE 'Y%';

/*Search for all the customers whose last name starts with Q or Y using a REGULAR EXPRESSION*/
SELECT LAST_NAME, FIRST_NAME
FROM CUSTOMER
WHERE LAST_NAME REGEXP '^[QY]';

/*Select rental id and customer id for all the return dates with null values from the rental table*/
SELECT RENTAL_ID, CUSTOMER_ID
FROM RENTAL
WHERE RETURN_DATE IS NULL;

/*Select rental id and customer id and return date for all the return dates with not null values from the rental table*/
SELECT RENTAL_ID, CUSTOMER_ID, RETURN_DATE
FROM RENTAL
WHERE RETURN_DATE IS NOT NULL;

/*Select all the rentals that weren't returned during may through august of 2005*/
SELECT RENTAL_ID, CUSTOMER_ID, RETURN_DATE
FROM RENTAL
WHERE RETURN_DATE NOT BETWEEN '2005-05-01' AND '2005-09-01';

/*Select all the rentals that weren't returned during may through august of 2005 and append the returnals with null value on return_date*/
SELECT RENTAL_ID, CUSTOMER_ID, RETURN_DATE
FROM RENTAL
WHERE RETURN_DATE NOT BETWEEN '2005-05-01' AND '2005-09-01'
	OR RETURN_DATE IS NULL;
    
/*---------------------------------------------------*/


/*Construct a query that retrieves all rows from the payments table where the amount is either 1,98, 7,98 or 9,98*/
SELECT *
FROM PAYMENT
WHERE AMOUNT IN (1.98, 7.98, 9.98);

/*Construct a query that find all customers whose last name contains A in the second position and W anywhere after the A*/
SELECT *
FROM CUSTOMER
WHERE LAST_NAME LIKE '_A%W%';