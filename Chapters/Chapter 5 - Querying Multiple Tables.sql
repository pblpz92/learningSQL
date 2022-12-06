/*Retrieve the cartesian product of customer and address table*/
SELECT C.FIRST_NAME, C.LAST_NAME, A.ADDRESS
FROM CUSTOMER C JOIN ADDRESS A;

/*Retrieve all customers with their addresses*/
SELECT C.FIRST_NAME, C.LAST_NAME, A.ADDRESS
FROM CUSTOMER C
	INNER JOIN ADDRESS A
	ON C.ADDRESS_ID = A.ADDRESS_ID;
    
/*Retrieve all customers with their addresses whose postal id is 52137*/    
SELECT C.FIRST_NAME, C.LAST_NAME, A.ADDRESS
FROM CUSTOMER C
	INNER JOIN ADDRESS A
    ON C.ADDRESS_ID = A.ADDRESS_ID
WHERE A.POSTAL_CODE = 52137;

/*Retrieve all customers with their cities*/    
SELECT C.FIRST_NAME, C.LAST_NAME, CT.CITY
FROM CUSTOMER C
	INNER JOIN ADDRESS A
    ON C.ADDRESS_ID = A.ADDRESS_ID
	INNER JOIN CITY CT
    ON A.CITY_ID = CT.CITY_ID;
    
/*Retrieve all CALIFORNIAN customers with their addresses and cities using a subquery that joins city and address tables*/    
SELECT C.FIRST_NAME, C.LAST_NAME, ADDR.ADDRESS, ADDR.CITY
FROM CUSTOMER C
	INNER JOIN (SELECT A.ADDRESS_ID, A.ADDRESS, CT.CITY
				FROM ADDRESS A
					INNER JOIN CITY CT
					ON A.CITY_ID = CT.CITY_ID
				WHERE A.DISTRICT = 'CALIFORNIA') ADDR
	ON C.ADDRESS_ID = ADDR.ADDRESS_ID;
    
/*Find the films where cuba birch and cate mcqueen appeared*/
SELECT F.TITLE
FROM ACTOR A
	INNER JOIN FILM_ACTOR FA
    ON A.ACTOR_ID = FA.ACTOR_ID
    INNER JOIN FILM F
    ON FA.FILM_ID = F.FILM_ID
WHERE (A.FIRST_NAME = 'CUBA' AND A.LAST_NAME = 'BIRCH')
	OR (A.FIRST_NAME = 'CATE' AND A.LAST_NAME = 'MCQUEEN');

/*Find the films where cuba birch and cate mcqueen appeared TOGETHER*/
SELECT F.TITLE
FROM FILM F
	INNER JOIN FILM_ACTOR FA1
    ON F.FILM_ID = FA1.FILM_ID
    INNER JOIN ACTOR A1
    ON FA1.ACTOR_ID = A1.ACTOR_ID
    INNER JOIN FILM_ACTOR FA2
    ON F.FILM_ID = FA2.FILM_ID 
    INNER JOIN ACTOR A2
    ON FA2.ACTOR_ID = A2.ACTOR_ID
WHERE (A1.FIRST_NAME = 'CUBA' AND A1.LAST_NAME = 'BIRCH')
	AND (A2.FIRST_NAME = 'CATE' AND A2.LAST_NAME = 'MCQUEEN');
    
/*Suppose that the film table has a filed named prequel_film_id that points to a prequel film stored in the same table. Do a self join and show all the films with prequel*/
SELECT F.TITLE, F_PRNT.TITLE AS PREQUEL
FROM FILM F
	INNER JOIN FILM F_PRNT
    ON F.PREQUEL_FILM_ID = F_PRNT.FILM_ID
WHERE F.PREQUEL_FILM_ID IS NOT NULL;

/*-----------------------------------*/

/*Write a query that returns the title of every film in which an actor with the first name john appeared*/
SELECT F.TITLE
FROM FILM F
	INNER JOIN FILM_ACTOR FA
    ON F.FILM_ID = FA.FILM_ID
    INNER JOIN ACTOR A
    ON FA.ACTOR_ID = A.ACTOR_ID
WHERE A.FIRST_NAME = 'JOHN';

/*Construct a query that returns all addresses that are in the same city. You will need to join the address table to itself, and each row should include two different addresses*/
SELECT A1.ADDRESS, A2.ADDRESS, A1.CITY_ID
FROM ADDRESS A1
	INNER JOIN ADDRESS A2
    ON A1.CITY_ID = A2.CITY_ID
    AND A1.ADDRESS < A2.ADDRESS;
