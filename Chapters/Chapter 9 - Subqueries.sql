/*Esto*/
SELECT CUSTOMER_ID, FIRST_NAME, LAST_NAME
FROM CUSTOMER
WHERE CUSTOMER_ID = (SELECT MAX(CUSTOMER_ID)
					FROM CUSTOMER);
                    
/*Es lo mismo que esto*/
SELECT MAX(CUSTOMER_ID)
FROM CUSTOMER;

SELECT CUSTOMER_ID, FIRST_NAME, LAST_NAME
FROM CUSTOMER
WHERE CUSTOMER_ID = 599;
/*-------------------------------------*/

/*Devuelve todas las ciudades que no estén en la india*/
SELECT CITY_ID, CITY
FROM CITY
WHERE COUNTRY_ID <>
		(SELECT COUNTRY_ID
        FROM COUNTRY
        WHERE COUNTRY = 'INDIA');
        
/*Error provocado al usar una consulta de tipo no scalar subquery en una condicion de igualdad, ya que devuelve más de un resultado*/
SELECT CITY_ID, CITY
FROM CITY
WHERE COUNTRY_ID <>
		(SELECT COUNTRY_ID
        FROM COUNTRY
        WHERE COUNTRY != 'INDIA');

/*Uso del operador IN para comprboar si un valor se encuentra dentro de un grupo*/
SELECT COUNTRY_ID
FROM COUNTRY
WHERE COUNTRY IN ('CANADA', 'MEXICO');
/*Realizar las consultas sin el operador IN o NOT in será más tedioso cuantas más condiciones tengamos*/
SELECT COUNTRY_ID
FROM COUNTRY
WHERE COUNTRY = 'CANADA' OR COUNTRY = 'MEXICO';

/*Uso del operador IN para generar un resultset para una subconsulta*/
/*Retorna todas las ciudades pertenecientes a canada o méxico*/
SELECT CITY_ID, CITY
FROM CITY
WHERE COUNTRY_ID IN (SELECT COUNTRY_ID
					FROM COUNTRY
					WHERE COUNTRY IN ('CANADA', 'MEXICO'));

/*Retorna todas las ciudades QUE NO ESTÁN en canada o méxico*/                    
SELECT CITY_ID, CITY
FROM CITY
WHERE COUNTRY_ID NOT IN (SELECT COUNTRY_ID
					FROM COUNTRY
					WHERE COUNTRY IN ('CANADA', 'MEXICO'));
                    
/*Clientes que nunca han alquilado una película gratis usando el operador ALL. El operador NOT IN hace lo mismo y es bastante más inteligible al ojo humano*/
SELECT FIRST_NAME, LAST_NAME
FROM CUSTOMER
WHERE CUSTOMER_ID <> ALL /*NOT IN*/ (SELECT CUSTOMER_ID
							FROM PAYMENT
							WHERE AMOUNT = 0);

/*Si metemos un NULL en el grupo de valores a comparar dentro de un NOT IN, la consulta devolverá un resultset vacío, ya que cualquier cosa comparada a null devuelve unknown*/
SELECT FIRST_NAME, LAST_NAME, CUSTOMER_ID
FROM CUSTOMER
WHERE CUSTOMER_ID NOT IN (122, 452, NULL);

/*Selecciona todos los clientes que hayan alquilado más películas que el máximo de los clientes del continente norteamericano(usa, canada, mexico)*/
SELECT CUSTOMER_ID, COUNT(*)
FROM RENTAL
GROUP BY CUSTOMER_ID
HAVING COUNT(*) > ALL (SELECT COUNT(*)
					FROM RENTAL R
						INNER JOIN CUSTOMER C
						ON R.CUSTOMER_ID = C.CUSTOMER_ID
						INNER JOIN ADDRESS A
						ON C.ADDRESS_ID = A.ADDRESS_ID
						INNER JOIN CITY CT
						ON A.CITY_ID = CT.CITY_ID
						INNER JOIN COUNTRY CO
						ON CT.COUNTRY_ID = CO.COUNTRY_ID
					WHERE CO.COUNTRY IN ('CANADA', 'UNITED STATES', 'MEXICO')
					GROUP BY R.CUSTOMER_ID);

/*Selecciona todos los clientes que tengan más gasto en alquileres que el total de bolivia, paraguay o chile*/
/*Con la claúsula ANY se evaluará a verdadero tan pronto como una condición se cumpla*/
SELECT CUSTOMER_ID, SUM(AMOUNT)
FROM PAYMENT 
GROUP BY CUSTOMER_ID
HAVING SUM(AMOUNT) > ANY (SELECT SUM(P.AMOUNT) AS TOTAL_COUNTRY_AMOUNT
							FROM PAYMENT P
								INNER JOIN CUSTOMER CU
								ON P.CUSTOMER_ID = CU.CUSTOMER_ID
								INNER JOIN ADDRESS A
								ON CU.ADDRESS_ID = A.ADDRESS_ID
								INNER JOIN CITY CT
								ON A.CITY_ID = CT.CITY_ID
								INNER JOIN COUNTRY CO
								ON CT.COUNTRY_ID = CO.COUNTRY_ID
							WHERE COUNTRY IN ('BOLIVIA', 'PARAGUAY', 'CHILE')
							GROUP BY CO.COUNTRY);
                            
/*Subconsultas multicolumna*/
/*De esto, con subquerys que devuelven una sola columna*/
/*Actores que se apellidan monroe que aparecen en peliculas clasificadas como PG*/
SELECT FA.ACTOR_ID, FA.FILM_ID
FROM FILM_ACTOR FA
WHERE FA.ACTOR_ID IN
	(SELECT A.ACTOR_ID FROM ACTOR A WHERE A.LAST_NAME = 'MONROE')
	AND FA.FILM_ID IN
    (SELECT F.FILM_ID FROM FILM F WHERE F.RATING = 'PG');
    
/*Nombre y apellido de clientes que hayan alquilado 20 películas. Utiliza una subconsulta correlacionada*/
SELECT C.FIRST_NAME, C.LAST_NAME
FROM CUSTOMER C
WHERE (SELECT COUNT(*)
		FROM RENTAL R
        WHERE C.CUSTOMER_ID = R.CUSTOMER_ID) = 20;
        
/*Nombre y apellido de clientes que hayan alquilado películas por un valor de entre 180 y 240 usd. Utiliza una subconsulta correlacionada*/
SELECT C.FIRST_NAME, C.LAST_NAME
FROM CUSTOMER C
WHERE (SELECT SUM(P.AMOUNT)
		FROM PAYMENT P
        WHERE C.CUSTOMER_ID = P.CUSTOMER_ID) BETWEEN 180 AND 240;

/*Encuentra todos los clientes que alquilaron una película antes del 25 de mayo del 2005. Usa una subsonsulta correlacionada y el operador exists*/
SELECT C.FIRST_NAME, C.LAST_NAME
FROM CUSTOMER C
WHERE EXISTS (SELECT 1
				FROM RENTAL R
                WHERE C.CUSTOMER_ID = R.CUSTOMER_ID
				AND DATE(R.RENTArental_dateL_DATE) < '2005-05-25');

/*Busca nombres y apellidos de todos los actores que nunca han aparecido en una pelicula clasificada 'R'. Usa una subconsulta correlacionada y el operador NOT EXISTS*/
SELECT A.FIRST_NAME, A.LAST_NAME
FROM ACTOR A
WHERE NOT EXISTS (SELECT 1
					FROM FILM_ACTOR FA                    
                    INNER JOIN FILM F
                    ON F.FILM_ID = FA.FILM_ID
                    WHERE A.ACTOR_ID = FA.ACTOR_ID
                    AND F.RATING = 'R');

/*Update the last_update customer table dield with their last rental date. Use a correlational query*/
UPDATE CUSTOMER C
SET C.LAST_UPDATE =
	(SELECT MAX(R.RENTAL_DATE)
    FROM RENTAL R
    WHERE C.CUSTOMER_ID = R.CUSTOMER_ID)
WHERE EXISTS
	(SELECT 1
    FROM RENTAL R
    WHERE C.CUSTOMER_ID = R.CUSTOMER_ID);
    
/*Delete all the customers who have not rented a film in the last year. Use a correlational query*/
DELETE FROM CUSTOMER
WHERE 365 < ALL
	(SELECT DATEDIFF(NOW(), R.RENTAL_DATE)
    FROM RENTAL R
    WHERE CUSTOMER.CUSTOMER_ID = R.CUSTOMER_ID);
    
/*Generate a query with a list of customer ID's with their total rentals and amount of payment. Then use it as a subquery and retrieve their names and last names*/

SELECT C.FIRST_NAME, C.LAST_NAME, P.TOTAL_RENTALS, P.TOTAL_AMOUNT
FROM CUSTOMER C
	INNER JOIN
		(SELECT P.CUSTOMER_ID, COUNT(*) AS TOTAL_RENTALS, SUM(P.AMOUNT) AS TOTAL_AMOUNT
		FROM PAYMENT P
		GROUP BY P.CUSTOMER_ID) P
	ON C.CUSTOMER_ID = P.CUSTOMER_ID;
    
/*Create a query to define three groups from 0 to 74.99, up to 149.99, and up to 9999999.99, give them a name*/
SELECT 'Small fry' AS NAME, 0 AS 'LOWER_LIMIT', 74.99 AS 'HIGHER_LIMIT'
UNION ALL
SELECT 'Averaje Joe' AS NAME, 75 AS 'LOWER_LIMIT', 149.99 AS 'HIGHER_LIMIT'
UNION ALL 
SELECT 'Heavy hitter' AS NAME, 150 AS 'LOWER_LIMIT', 9999999.99 AS 'HIGHER_LIMIT';

/*Group the clients by the ranges given on the previous groups*/

SELECT PYMNT_GRPS.NAME, COUNT(*) AS NUM_CUSTOMERS
FROM
	(SELECT CUSTOMER_ID, SUM(AMOUNT) AS TOTAL_PAYMENTS
	FROM PAYMENT
	GROUP BY CUSTOMER_ID) AS PYMNT
INNER JOIN
	(SELECT 'Small fry' AS NAME, 0 AS 'LOWER_LIMIT', 74.99 AS 'HIGHER_LIMIT'
	UNION ALL
	SELECT 'Averaje Joe' AS NAME, 75 AS 'LOWER_LIMIT', 149.99 AS 'HIGHER_LIMIT'
	UNION ALL 
	SELECT 'Heavy hitter' AS NAME, 150 AS 'LOWER_LIMIT', 9999999.99 AS 'HIGHER_LIMIT') AS PYMNT_GRPS
ON PYMNT.TOTAL_PAYMENTS
	BETWEEN PYMNT_GRPS.LOWER_LIMIT AND PYMNT_GRPS.HIGHER_LIMIT
GROUP BY PYMNT_GRPS.NAME;

/*Show customers fname, lname, city, total money spent and total rentals*/
SELECT C.FIRST_NAME, C.LAST_NAME, CT.CITY, SUM(P.AMOUNT) AS TOTAL_MONEY, COUNT(*) AS TOTAL_RENTALS
FROM CUSTOMER C
	INNER JOIN PAYMENT P ON C.CUSTOMER_ID = P.CUSTOMER_ID
    INNER JOIN ADDRESS A ON C.ADDRESS_ID = A.ADDRESS_ID
    INNER JOIN CITY CT ON A.CITY_ID = CT.CITY_ID
GROUP BY C.FIRST_NAME, C.LAST_NAME;

/*Show customers fname, lname, city, total money spent and total rentals. Do the payment tables grouping as a subquery*/
SELECT C.FIRST_NAME, C.LAST_NAME, CT.CITY, P.TOTAL_AMOUNT, P.RENTALS
FROM
	(SELECT CUSTOMER_ID, SUM(AMOUNT)AS TOTAL_AMOUNT, COUNT(*) AS RENTALS
	FROM PAYMENT
	GROUP BY CUSTOMER_ID) P
INNER JOIN CUSTOMER C
ON C.CUSTOMER_ID = P.CUSTOMER_ID
INNER JOIN ADDRESS A
ON C.ADDRESS_ID = A.ADDRESS_ID
INNER JOIN CITY CT
ON A.CITY_ID = CT.CITY_ID;

/*Search first name, last name and total money revenues generated from PG-Rated films rentals where the cast included an actor whose last name starts with S*/
SELECT A.FIRST_NAME, A.LAST_NAME, SUM(P.AMOUNT)
FROM ACTOR A
	INNER JOIN FILM_ACTOR FA
    ON A.ACTOR_ID = FA.ACTOR_ID
    INNER JOIN FILM F
    ON FA.FILM_ID = F.FILM_ID
    INNER JOIN INVENTORY I
    ON F.FILM_ID = I.FILM_ID
    INNER JOIN RENTAL R
    ON I.INVENTORY_ID = R.INVENTORY_ID
    INNER JOIN PAYMENT P
    ON R.RENTAL_ID = P.RENTAL_ID
WHERE A.LAST_NAME LIKE 'S%'
	AND F.RATING = 'PG'
GROUP BY A.FIRST_NAME, A.LAST_NAME
ORDER BY SUM(P.AMOUNT) DESC;

/*Search first name, last name and total money revenues generated from PG-Rated films rentals where the cast included an actor whose last name starts with S. USE CTE's (Common table expressions)*/
WITH ACTORS_S AS /*Actors with last name starting with s*/
	(SELECT A.ACTOR_ID, A.FIRST_NAME, A.LAST_NAME
    FROM ACTOR A
    WHERE A.LAST_NAME LIKE 'S%'),
ACTORS_S_PG AS /*Actors with last name starting with s in pg rated films*/
	(SELECT S.FIRST_NAME, S.LAST_NAME, F.FILM_ID, F.TITLE
    FROM ACTORS_S S
    INNER JOIN FILM_ACTOR FA
    ON S.ACTOR_ID = FA.ACTOR_ID
    INNER JOIN FILM F
    ON FA.FILM_ID = F.FILM_ID
    WHERE F.RATING = 'PG'),
ACTORS_S_PG_REVENUE AS /*Money per film*/
	(SELECT SPG.FIRST_NAME, SPG.LAST_NAME, P.AMOUNT
    FROM ACTORS_S_PG AS SPG
    INNER JOIN INVENTORY AS I
    ON SPG.FILM_ID = I.FILM_ID
    INNER JOIN RENTAL R
    ON I.INVENTORY_ID = R.INVENTORY_ID
    INNER JOIN PAYMENT P
    ON R.RENTAL_ID = P.RENTAL_ID)
SELECT SPG_REV.FIRST_NAME, SPG_REV.LAST_NAME, SUM(SPG_REV.AMOUNT)
FROM ACTORS_S_PG_REVENUE SPG_REV
GROUP BY SPG_REV.FIRST_NAME, SPG_REV.LAST_NAME
ORDER BY SPG_REV.AMOUNT DESC;

/*Using scalar subqueries as expressions*/
SELECT
	(SELECT C.FIRST_NAME
    FROM CUSTOMER C
    WHERE C.CUSTOMER_ID = P.CUSTOMER_ID) AS FIRST_NAME,
    (SELECT C.LAST_NAME
    FROM CUSTOMER C
    WHERE C.CUSTOMER_ID = P.CUSTOMER_ID) AS LAST_NAME,
    (SELECT CT.CITY
    FROM CUSTOMER C
		INNER JOIN ADDRESS A
        ON C.ADDRESS_ID = A.ADDRESS_ID
        INNER JOIN CITY CT
        ON A.CITY_ID = CT.CITY_ID
	WHERE C.CUSTOMER_ID = P.CUSTOMER_ID) AS CITY,
    SUM(P.AMOUNT) AS TOTAL_PAYMENTS,
    COUNT(*) AS TOTAL_RENTALS
FROM PAYMENT P
GROUP BY P.CUSTOMER_ID;
    
/*Actors id, fname and lname. Order by film appearences. Scalar subquery in the order by clause. Descending order*/
SELECT A.ACTOR_ID, A.FIRST_NAME, A.LAST_NAME
FROM ACTOR A
ORDER BY (SELECT COUNT(*)
			FROM FILM_ACTOR FA
            WHERE A.ACTOR_ID = FA.ACTOR_ID) DESC;

/*-----EXERCISES-------*/    
/*9-1 Construct a query against the film table that uses a filter condition with a noncorrelationated subquery against the category table to find all action films*/
SELECT TITLE
FROM FILM
WHERE FILM_ID IN (SELECT FC.FILM_ID
					FROM FILM_CATEGORY FC
					INNER JOIN CATEGORY C
					ON FC.CATEGORY_ID = C.CATEGORY_ID
					AND C.NAME = 'ACTION');
                    
/*9-2 Rework the query from Exercise 9-1 using a correlated subquery against category and film_category tables to achieve the same results*/
SELECT F.TITLE
FROM FILM F
WHERE EXISTS (SELECT 1
				FROM FILM_CATEGORY FC
                INNER JOIN CATEGORY C
				ON FC.CATEGORY_ID = C.CATEGORY_ID
				WHERE F.FILM_ID = FC.FILM_ID
				AND C.NAME = 'ACTION');

/*9-3 Join the following query to a subquery against the film_actor table to show the level of each actor*/

SELECT ACTOR.ACTOR, RATING.LEVEL
FROM (SELECT FA.ACTOR_ID AS ACTOR, COUNT(*) AS APPEARANCES
		FROM FILM_ACTOR FA
		GROUP BY FA.ACTOR_ID) AS ACTOR
INNER JOIN
	(SELECT 'Hollywood Star' AS LEVEL, 30 AS MIN_ROLES, 99999 AS MAX_ROLES
	UNION ALL
	SELECT 'Prolific actor' AS LEVEL, 20 AS MIN_ROLES, 29 AS MAX_ROLES
	UNION ALL
	SELECT 'Newcomer' AS LEVEL, 1 AS MIN_ROLES, 19 AS MAX_ROLES) AS RATING
ON ACTOR.APPEARANCES
	BETWEEN RATING.MIN_ROLES AND RATING.MAX_ROLES;
    


	

