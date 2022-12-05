/*CHAPTER 3 - QUERY PRIMER*/

/*Display all the rows and columns from the category table*/
SELECT *
FROM CATEGORY;

/*Display all the rows and columns from the language table*/
SELECT *
FROM LANGUAGE;

/*Display all the rows and columns from the language table without using * on your query*/
SELECT LANGUAGE_ID, NAME, LAST_UPDATE
FROM LANGUAGE;

/*Display all the languages name*/
SELECT NAME
FROM LANGUAGE;

/*Display language name, id, a new column language usage with the literal value of 'COMMON' and the number pi multiplied by the id, and the function upper case on language name*/
SELECT LANGUAGE_ID, 'COMMON' AS LANGUAGE_USAGE, LANGUAGE_ID * pi() AS LANG_PI_VALUE, upper(NAME) AS LANGUAGE_NAME
FROM LANGUAGE;

/*Display the user, version and database from the current session*/
SELECT VERSION(), USER(), DATABASE();

/*Select all the actor id's from film_actor table and order them ascending*/
SELECT ACTOR_ID
FROM FILM_ACTOR
ORDER BY ACTOR_ID ASC;

/*Select all the actor id's from film_actor table and order them ascending without duplicate rows*/
SELECT DISTINCT ACTOR_ID
FROM FILM_ACTOR
ORDER BY ACTOR_ID ASC;

/*Select frist name and last name in only one filed from all the customers whose name is JESSIE. Achieve this by doing a subquery*/
SELECT CONCAT(CUST.LAST_NAME, ', ', CUST.FIRST_NAME)
FROM (SELECT *
		FROM CUSTOMER C
        WHERE FIRST_NAME = 'JESSIE') AS CUST;
        
/*Create a temporary table with id, fname and lname called actors_j*/
CREATE TEMPORARY TABLE ACTORS_J (
	ACTOR_ID INT,
    FIRST_NAME VARCHAR(255),
    LAST_NAME VARCHAR(255)
);

/*Insert all actors whose last name starts with J to the temporary table*/
INSERT INTO ACTORS_J
SELECT ACTOR_ID, FIRST_NAME, LAST_NAME
FROM ACTOR
WHERE LAST_NAME LIKE 'J%';

/*Creaate a view cust_vw that displays id, fname and lname and active columns from customers*/
CREATE VIEW CUST_VW AS
SELECT C.CUSTOMER_ID, C.FIRST_NAME, C.LAST_NAME, C.ACTIVE
FROM CUSTOMER C;

/*Display inactive customers(active=0) fname and lname from cust_vw*/
SELECT FIRST_NAME, LAST_NAME
FROM CUST_VW
WHERE ACTIVE = 0;

/*Select customers first name, last name and exactly hour from customers who rented a film on 2005-06-14*/
/*Field RENTAL_DATE stores a TIMESTAMP. Use built in functions date() to extract date and time() to extract hour*/
SELECT C.FIRST_NAME, C.LAST_NAME, TIME(R.RENTAL_DATE) AS RENTAL_TIME
FROM CUSTOMER C
	INNER JOIN RENTAL R
    ON C.CUSTOMER_ID = R.CUSTOMER_ID
WHERE DATE(R.RENTAL_DATE) = '2005-06-14';

/*Select all the film titles with rating G and rental duration greater than 6 days*/
SELECT TITLE
FROM FILM
WHERE RATING = 'G' AND RENTAL_DURATION >= 7;

/*Select all the film titles with rating G or rental duration greater than 6 days*/
SELECT TITLE
FROM FILM
WHERE RATING = 'G' OR RENTAL_DURATION >= 7;

/*Display title, rating and rental duration from films with rating G and rental duration greater than 6 or films with rating pg13 and rental duration less than 4 days*/
SELECT F.TITLE, F.RATING, F.RENTAL_DURATION
FROM FILM F
WHERE (F.RATING = 'G' AND F.RENTAL_DURATION >= 7) OR (F.RATING = 'PG-13' AND F.RENTAL_DURATION < 4);

/*Fname and lname from customers who have rented 40 or more films*/
SELECT C.FIRST_NAME, C.LAST_NAME, COUNT(*)
FROM CUSTOMER C
	INNER JOIN RENTAL R
    ON C.CUSTOMER_ID = R.CUSTOMER_ID
GROUP BY C.FIRST_NAME, C.LAST_NAME
HAVING COUNT(*) >= 40;

/*Select customers first name, last name and exactly hour from customers who rented a film on 2005-06-14*/
/*Order the resultset alphabetically by last name*/
SELECT C.FIRST_NAME, C.LAST_NAME, TIME(R.RENTAL_DATE) AS RENTAL_TIME
FROM CUSTOMER C
	INNER JOIN RENTAL R
    ON C.CUSTOMER_ID = R.CUSTOMER_ID
WHERE DATE(R.RENTAL_DATE) = '2005-06-14'
ORDER BY C.LAST_NAME;

/*Select customers first name, last name and exactly hour from customers who rented a film on 2005-06-14*/
/*Order the resultset alphabetically by last name then by first name*/
SELECT C.FIRST_NAME, C.LAST_NAME, TIME(R.RENTAL_DATE) AS RENTAL_TIME
FROM CUSTOMER C
	INNER JOIN RENTAL R
    ON C.CUSTOMER_ID = R.CUSTOMER_ID
WHERE DATE(R.RENTAL_DATE) = '2005-06-14'
ORDER BY C.LAST_NAME, C.FIRST_NAME;

/*Select customers first name, last name and exactly hour from customers who rented a film on 2005-06-14*/
/*Order the resultset by descending rental hour*/
SELECT C.FIRST_NAME, C.LAST_NAME, TIME(R.RENTAL_DATE) AS RENTAL_TIME
FROM CUSTOMER C
	INNER JOIN RENTAL R
    ON C.CUSTOMER_ID = R.CUSTOMER_ID
WHERE DATE(R.RENTAL_DATE) = '2005-06-14'
ORDER BY TIME(R.RENTAL_DATE) DESC;

/*Select customers first name, last name and exactly hour from customers who rented a film on 2005-06-14*/
/*Order the resultset by the third select clause desc*/
SELECT C.FIRST_NAME, C.LAST_NAME, TIME(R.RENTAL_DATE) AS RENTAL_TIME
FROM CUSTOMER C
	INNER JOIN RENTAL R
    ON C.CUSTOMER_ID = R.CUSTOMER_ID
WHERE DATE(R.RENTAL_DATE) = '2005-06-14'
ORDER BY 3 DESC;

/*--------------------------------------------------*/

/*Retrieve the actor id, fname and lname from all actors. order by lname and then by fname*/
SELECT A.ACTOR_ID, A.FIRST_NAME, A.LAST_NAME
FROM ACTOR A
ORDER BY A.LAST_NAME, A.FIRST_NAME;

/*retrieve id fname and lname for all actors whose last name is williams or davis*/
SELECT A.ACTOR_ID, A.FIRST_NAME, A.LAST_NAME
FROM ACTOR A
WHERE A.LAST_NAME LIKE 'WILLIAMS' OR A.LAST_NAME LIKE 'DAVIS';

/*search distinct customers id who rented a film on july 5 2005*/
SELECT DISTINCT R.CUSTOMER_ID
FROM RENTAL R
WHERE DATE(R.RENTAL_DATE) LIKE '2005-07-05';

/*select email and return date from customers who rented a film on 2005-06-14. Order the resultset by return date in descending order*/
SELECT C.EMAIL, R.RETURN_DATE
FROM CUSTOMER C
	INNER JOIN RENTAL R
    ON C.CUSTOMER_ID = R.CUSTOMER_ID
WHERE DATE(R.RENTAL_DATE) = '2005-06-14'
ORDER BY R.RETURN_DATE DESC;