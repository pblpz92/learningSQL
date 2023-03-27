/*CHAPTER 11 - CONDITIONAL LOGIC*/

/*Select customer information. Create a new column using a case expression in the select clause indicating activity type(Active or inactive).*/
SELECT CU.FIRST_NAME, CU.LAST_NAME,
	CASE
		WHEN CU.ACTIVE = 1 THEN 'ACTIVE'
        ELSE 'INACTIVE'
	END ACTIVITY_TYPE
FROM CUSTOMER CU;

/*Select film title and category name, then create a SUGGESTED_VIEWER in order to clasify suggested groups of viewers for the film. Use a searched case expression in the select clause*/
SELECT F.TITLE, CAT.NAME,
	CASE 
		WHEN CAT.NAME IN ('CHILDREN', 'FAMILY', 'SPORTS', 'ANIMATION') THEN 'ALL AGES'
        WHEN CAT.NAME IN ('HORROR') THEN 'ADULT'
        WHEN CAT.NAME IN ('MUSIC', 'GAMES') THEN 'TEEN'
        ELSE 'OTHER'
	END 'SUGGESTED_VIEWER'
FROM FILM F
	INNER JOIN FILM_CATEGORY FC
	ON F.FILM_ID = FC.FILM_ID
    INNER JOIN CATEGORY CAT
    ON FC.CATEGORY_ID = CAT.CATEGORY_ID;

/*Return the number of rentals only for the active customers. Use a case expression that returns a subquery. Subquery is correlated*/
SELECT CUST.FIRST_NAME, CUST.LAST_NAME,
	CASE WHEN CUST.ACTIVE = 0 THEN 0
    ELSE 
		(SELECT COUNT(*)
		FROM RENTAL R
		WHERE R.CUSTOMER_ID = CUST.CUSTOMER_ID)
	END 'TOTAL_RENTALS'
FROM CUSTOMER CUST;
			
/*Select film title and category name, then create a SUGGESTED_VIEWER in order to clasify suggested groups of viewers for the film. Use a SIMPLE case expression in the select clause*/
SELECT F.TITLE, CAT.NAME,
	CASE CAT.NAME
		WHEN 'CHILDREN' THEN 'ALL AGES'
        WHEN 'FAMILY' THEN 'ALL AGES'
        WHEN 'SPORTS' THEN 'ALL AGES'
        WHEN 'ANIMATION' THEN 'ALL AGES'
        WHEN 'HORROR' THEN 'ADULT'
        WHEN 'MUSIC' THEN 'TEEN'
        WHEN 'GAMES' THEN 'TEEN'
        ELSE 'OTHER'
	END 'SUGGESTED_VIEWER'
FROM FILM F
	INNER JOIN FILM_CATEGORY FC
	ON F.FILM_ID = FC.FILM_ID
    INNER JOIN CATEGORY CAT
    ON FC.CATEGORY_ID = CAT.CATEGORY_ID;
    
/*Write a query that shows the number of film rentals for may, june, and july of 2005*/
SELECT COUNT(*), MONTHNAME(R.RENTAL_DATE) AS RENTAL_MONTH
FROM RENTAL R
WHERE R.RENTAL_DATE BETWEEN '2005-05-01' AND '2005-08-01'
GROUP BY MONTH(R.RENTAL_DATE);

/*Write the same query returning only one row. Achieve that by using a case expression*/
SELECT 
	SUM(CASE 
			WHEN MONTHNAME(R.RENTAL_DATE) = 'MAY' THEN 1 ELSE 0 
		END) AS MAY_RENTALS,
	SUM(CASE
			WHEN MONTHNAME(R.RENTAL_DATE) = 'JUNE' THEN 1 ELSE 0
		END) AS JUNE_RENTALS,
	SUM(CASE 
			WHEN MONTHNAME(R.RENTAL_DATE) = 'JULY' THEN 1 ELSE 0
		END) AS JULY_RENTALS    
FROM RENTAL R
WHERE R.RENTAL_DATE BETWEEN '2005-05-01' AND '2005-08-01';


/*Write a query that returns actors who have appeared on g, pg, or nc17 rated films whose name or last name starts with s. Use the exists operator inside case expressions*/
SELECT A.FIRST_NAME, A.LAST_NAME,
	CASE
		WHEN EXISTS (SELECT 1
					FROM FILM F
						INNER JOIN FILM_ACTOR FA                            
						ON F.FILM_ID = FA.FILM_ID
					WHERE A.ACTOR_ID = FA.ACTOR_ID
                    AND F.RATING = 'G')
		THEN 'Y'
        ELSE 'N'
	END 'G ACTOR',
    CASE
		WHEN EXISTS (SELECT 1
					FROM FILM F
						INNER JOIN FILM_ACTOR FA                            
						ON F.FILM_ID = FA.FILM_ID
					WHERE A.ACTOR_ID = FA.ACTOR_ID
                    AND F.RATING = 'PG')
		THEN 'Y'
        ELSE 'N'
	END 'PG ACTOR',
    CASE
		WHEN EXISTS (SELECT 1
					FROM FILM F
						INNER JOIN FILM_ACTOR FA                            
						ON F.FILM_ID = FA.FILM_ID
					WHERE A.ACTOR_ID = FA.ACTOR_ID
                    AND F.RATING = 'NC-17')
		THEN 'Y'
        ELSE 'N'
	END 'NC17 ACTOR'    
FROM ACTOR A
WHERE A.LAST_NAME LIKE 'S%' OR A.FIRST_NAME LIKE 'S%';

/*Use a simple case expression to count the number of copies of films in inventory*/
SELECT F.TITLE,
	CASE (SELECT COUNT(*) 
			FROM INVENTORY I
			WHERE F.FILM_ID = I.FILM_ID)
		WHEN 0 THEN 'OUT OF STOCK'
        WHEN 1 THEN 'SCARCE'
        WHEN 2 THEN 'SCARCE'
        WHEN 3 THEN 'AVAILABLE'
        WHEN 4 THEN 'AVAILABLE'
        ELSE 'COMMON'		
	END 'STOCKAGE'
FROM FILM F;

/*Compute the average payment amount for each customer. Include a case expression to ensure that denominator of the division is never 0*/
SELECT C.FIRST_NAME, C.LAST_NAME, 
	SUM(P.AMOUNT) AS TOTAL_AMOUNT, 
    COUNT(P.AMOUNT) AS TOTAL_PAYMENTS,
	SUM(P.AMOUNT) /
		CASE WHEN COUNT(P.AMOUNT) = 0 THEN 1
			ELSE COUNT(P.AMOUNT)
		END AVERAGE_PAYMENT
FROM CUSTOMER C
	LEFT JOIN PAYMENT P
	ON C.CUSTOMER_ID = P.CUSTOMER_ID
GROUP BY C.FIRST_NAME, C.LAST_NAME;
        
/*Set the customer.active field to 0 (inactive) for customers who have not rented a film in the last 90 days*/
UPDATE CUSTOMER C
SET C.ACTIVE = 
	CASE WHEN (SELECT DATEDIFF(NOW(), MAX(RENTAL_DATE))
				FROM RENTAL R
                WHERE R.CUSTOMER_ID = C.CUSTOMER_ID) >= 90
		THEN 0
        ELSE 1
	END
WHERE C.ACTIVE = 1;

/*Select customers first and last name, address, city and country. Is some field is null display unknown instead.*/
SELECT C.FIRST_NAME, C.LAST_NAME, 
	CASE 
		WHEN (A.ADDRESS IS NULL) THEN 'UNKNOWN'
        ELSE A.ADDRESS
	END ADDRESS, 
	CASE 
		WHEN (CT.CITY IS NULL) THEN 'UNKNOWN'
        ELSE CT.CITY
	END CITY, 
	CASE 
		WHEN (CO.COUNTRY IS NULL) THEN 'UNKNOWN'
		ELSE CO.COUNTRY
	END COUNTRY    
FROM CUSTOMER C
	LEFT JOIN ADDRESS A
	ON C.ADDRESS_ID = A.ADDRESS_ID
    LEFT JOIN CITY CT
	ON A.CITY_ID = CT.CITY_ID
	LEFT JOIN COUNTRY CO
	ON CT.COUNTRY_ID = CO.COUNTRY_ID;
    
/*Test your knoledge*/
/*11-1 Rewrite the following query, which uses a simple case expression, so that the same
results are achieved using a searched case expression. Try to use as few when clauses
as possible*/

/*SELECT NAME
CASE NAME
	WHEN 'ENGLISH' THEN 'LATIN1'
    WHEN 'ITALIAN' THEN 'LATIN1'
    WHEN 'FRENCH' THEN 'LATIN1'
    WHEN 'GERMAN' THEN 'LATIN1'
    WHEN 'JAPANSESE' THEN 'UTF8'
    WHEN 'MANDARIN' THEN 'UTF8'
    ELSE 'UNKNOWN'
END CHARACTER_SET
FROM LANGUAGE;*/

SELECT L.NAME,
	CASE
		WHEN L.NAME IN ('ENGLISH', 'ITALIAN', 'FRENCH', 'GERMAN') 
			THEN 'LATIN1'
        WHEN L.NAME IN ('JAPANESE', 'MANDARIN') 
			THEN 'UTF8'
        ELSE 'UNKNOWN'
	END CHARACTER_SET
FROM LANGUAGE L;

/*11-2 Rewrite the following query so that the result set contains a single row with five columns
(one for each rating). Name the five columns G, PG, PG_13, R and NC_17*/
/*SELECT RATING, COUNT(*)
FROM FILM
GROUP BY(RATING);*/

SELECT 
	SUM(CASE WHEN F.RATING = 'G' THEN 1 ELSE 0 END) G,
    SUM(CASE WHEN F.RATING = 'PG' THEN 1 ELSE 0 END) PG,
    SUM(CASE WHEN F.RATING = 'PG-13' THEN 1 ELSE 0 END) PG13,
    SUM(CASE WHEN F.RATING = 'R' THEN 1 ELSE 0 END) R,
    SUM(CASE WHEN F.RATING = 'NC-17' THEN 1 ELSE 0 END) NC17		
FROM FILM F;

				