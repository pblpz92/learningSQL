/* CHAPTER 10 - JOINS REVISITED */

/*Find the number of copie availables for each film in the inventory*/
SELECT F. FILM_ID, F.TITLE, COUNT(*) AS NUMBER_OF_COPIES
FROM FILM F
INNER JOIN INVENTORY I
	ON F.FILM_ID = I.FILM_ID
GROUP BY F.FILM_ID, F.TITLE;

/*Modify the previous query to return films that aren't in the inventory table*/
SELECT F. FILM_ID, F.TITLE, COUNT(I.INVENTORY_ID) AS NUMBER_OF_COPIES
FROM FILM F
LEFT OUTER JOIN INVENTORY I
	ON F.FILM_ID = I.FILM_ID
GROUP BY F.FILM_ID, F.TITLE;

/*Modify the previous query to use a right outer join*/
SELECT F. FILM_ID, F.TITLE, COUNT(I.INVENTORY_ID) AS NUMBER_OF_COPIES
FROM INVENTORY I
RIGHT OUTER JOIN FILM F
	ON I.FILM_ID = F.FILM_ID
GROUP BY F.FILM_ID, F.TITLE;

/*Use two left outer joins to include film id title inventory id and rental info*/
SELECT F.FILM_ID, F.TITLE, I.INVENTORY_ID, R.RENTAL_DATE
FROM FILM F
LEFT OUTER JOIN INVENTORY I
	ON F.FILM_ID = I.FILM_ID
LEFT OUTER JOIN RENTAL R
	ON I.INVENTORY_ID = R.INVENTORY_ID;
    
/*Do a cross join from category and language tables*/
SELECT C.NAME, L.NAME
FROM CATEGORY C
CROSS JOIN LANGUAGE L;

/*Create a query that generates a row for everyday in the year 2020*/
SELECT DATE_ADD('2020-01-01', INTERVAL(ONES.NUM + TENS.NUM + HUNDREDS.NUM) DAY) dt
FROM
	(SELECT 0 AS NUM UNION ALL
    SELECT 1 AS NUM UNION ALL
    SELECT 2 AS NUM UNION ALL
    SELECT 3 AS NUM UNION ALL
    SELECT 4 AS NUM UNION ALL
    SELECT 5 AS NUM UNION ALL
    SELECT 6 AS NUM UNION ALL
    SELECT 7 AS NUM UNION ALL
    SELECT 8 AS NUM UNION ALL
    SELECT 9 AS NUM) AS ONES
    CROSS JOIN
    (SELECT 0 AS NUM UNION ALL
    SELECT 10 AS NUM UNION ALL
    SELECT 20 AS NUM UNION ALL
    SELECT 30 AS NUM UNION ALL
    SELECT 40 AS NUM UNION ALL
    SELECT 50 AS NUM UNION ALL
    SELECT 60 AS NUM UNION ALL
    SELECT 70 AS NUM UNION ALL
    SELECT 80 AS NUM UNION ALL
    SELECT 90 AS NUM) AS TENS
	CROSS JOIN
    (SELECT 0 AS NUM UNION ALL
    SELECT 100 AS NUM UNION ALL
    SELECT 200 AS NUM UNION ALL
    SELECT 300 AS NUM ) AS HUNDREDS;
    
/*Create a query that generates a row for everyday in the year 2020 with the number of film rentals for each day, including days without rentals*/
SELECT DAYS.DT, COUNT(R.RENTAL_ID) AS NUM_RENTALS
FROM (SELECT DATE_ADD('2005-01-01', INTERVAL(ONES.NUM + TENS.NUM + HUNDREDS.NUM) DAY) DT
					FROM (SELECT 0 NUM UNION ALL
					SELECT 1 NUM UNION ALL
					SELECT 2 NUM UNION ALL
					SELECT 3 NUM UNION ALL
					SELECT 4 NUM UNION ALL
					SELECT 5 NUM UNION ALL
					SELECT 6 NUM UNION ALL
					SELECT 7 NUM UNION ALL
					SELECT 8 NUM UNION ALL
					SELECT 9 NUM) AS ONES
					CROSS JOIN 
					(SELECT 0 NUM UNION ALL
					SELECT 10 NUM UNION ALL
					SELECT 20 NUM UNION ALL
					SELECT 30 NUM UNION ALL
					SELECT 40 NUM UNION ALL
					SELECT 50 NUM UNION ALL
					SELECT 60 NUM UNION ALL
					SELECT 70 NUM UNION ALL
					SELECT 80 NUM UNION ALL
					SELECT 90 NUM) AS TENS
					CROSS JOIN 
					(SELECT 0 NUM UNION ALL
					SELECT 100 NUM UNION ALL
					SELECT 200 NUM UNION ALL
					SELECT 300 NUM) HUNDREDS
			WHERE DATE_ADD('2005-01-01', INTERVAL(ONES.NUM + TENS.NUM + HUNDREDS.NUM) DAY) < '2006-01-01') DAYS
LEFT OUTER JOIN RENTAL R 
	ON DAYS.DT = DATE(R.RENTAL_DATE)
GROUP BY DAYS.DT
ORDER BY 1;

/*Use a natural join to display the days customers have rented a film*/
SELECT CUST.FIRST_NAME, CUST.LAST_NAME, DATE(R.RENTAL_DATE)
FROM
	(SELECT C.CUSTOMER_ID, C.FIRST_NAME, C.LAST_NAME
	FROM CUSTOMER C) CUST
NATURAL JOIN RENTAL R;


/*Test your knoledge*/
/*10-1 Using the following table definitions and data, wite a query that returns each customer name along with their total payments*/

/*Customer:
Customer id				Name
1						John smith
2						Kathy Jones
3						Greg Oliver

Payment
Payment id				Customer id				Amount
101						1						8.99
102						3						4.99
103						1						7.99*/

SELECT C.FIRST_NAME, C.LAST_NAME, SUM(P.AMOUNT)
FROM CUSTOMER C
LEFT JOIN PAYMENT P
	ON C.CUSTOMER_ID = P.CUSTOMER_ID
GROUP BY C.FIRST_NAME, C.LAST_NAME;

/*Redo your query to use a different join*/
SELECT C.FIRST_NAME, C.LAST_NAME, SUM(P.AMOUNT)
FROM PAYMENT P
RIGHT JOIN CUSTOMER C
	ON C.CUSTOMER_ID = P.CUSTOMER_ID
GROUP BY C.FIRST_NAME, C.LAST_NAME;

/*Devise a query that will generate the set {1,2,3...,99, 100} (Hint: Use a cross join with at least two from clause subqueries)*/
SELECT (ONES.NUM + TENS.NUM) + 1
FROM
	(SELECT 0 AS NUM UNION ALL
    SELECT 1 AS NUM UNION ALL
    SELECT 2 AS NUM UNION ALL
    SELECT 3 AS NUM UNION ALL
    SELECT 4 AS NUM UNION ALL
    SELECT 5 AS NUM UNION ALL
    SELECT 6 AS NUM UNION ALL
    SELECT 7 AS NUM UNION ALL
    SELECT 8 AS NUM UNION ALL
    SELECT 9 AS NUM) AS ONES
    CROSS JOIN
    (SELECT 0 AS NUM UNION ALL
    SELECT 10 AS NUM UNION ALL
    SELECT 20 AS NUM UNION ALL
    SELECT 30 AS NUM UNION ALL
    SELECT 40 AS NUM UNION ALL
    SELECT 50 AS NUM UNION ALL
    SELECT 60 AS NUM UNION ALL
    SELECT 70 AS NUM UNION ALL
    SELECT 80 AS NUM UNION ALL
    SELECT 90 AS NUM) AS TENS
ORDER BY 1 ASC