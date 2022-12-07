/*CHAPTER 6 - WORKING WITH SETS*/

/*Perform a set union when the two sets have a num column and a string column*/
SELECT 1 AS NUM, 'ABC' AS STRING
UNION
SELECT 2 AS NUM, 'XYZ' AS STR;

/*Perform a query that retrives first name and names from all customers and actors. Set a column type to difference them*/
SELECT 'ACTOR' AS TYP, A.FIRST_NAME, A.LAST_NAME
FROM ACTOR A
UNION ALL
SELECT 'CUSTOMER' AS TYP, C.FIRST_NAME, C.LAST_NAME
FROM CUSTOMER C;

/*Perform a query that retrives first name and names from all actors. Perform a set operator UNION ALL with the same query to see how duplicates aren't removed*/
SELECT 'ACTOR' AS TYP, A.FIRST_NAME, A.LAST_NAME
FROM ACTOR A
UNION ALL
SELECT 'ACTOR' AS TYP, A.FIRST_NAME, A.LAST_NAME
FROM ACTOR A;

/*There are 2 person called jennifer davis, one in the actor table and another one in the customer table. Perform a query to find the duplicate using union all and searching by first name starting with j and lname starting with d.*/
SELECT 'CUSTOMER' AS TYP, C.FIRST_NAME, C.LAST_NAME
FROM CUSTOMER C
WHERE C.FIRST_NAME LIKE 'J%' AND C.LAST_NAME LIKE 'D%'
UNION ALL
SELECT 'ACTOR' AS TYP, A.FIRST_NAME, A.LAST_NAME
FROM ACTOR A
WHERE A.FIRST_NAME LIKE 'J%' AND A.LAST_NAME LIKE 'D%';

/*Remove the duplicate from the previous query*/
SELECT C.FIRST_NAME, C.LAST_NAME
FROM CUSTOMER C
WHERE C.FIRST_NAME LIKE 'J%' AND C.LAST_NAME LIKE 'D%'
UNION
SELECT A.FIRST_NAME, A.LAST_NAME
FROM ACTOR A
WHERE A.FIRST_NAME LIKE 'J%' AND A.LAST_NAME LIKE 'D%';

/*Order the previous query by last name then by first name*/
SELECT 'CUSTOMER' AS TYP, C.FIRST_NAME AS FNAME, C.LAST_NAME AS LNAME
FROM CUSTOMER C
WHERE C.FIRST_NAME LIKE 'J%' AND C.LAST_NAME LIKE 'D%'
UNION ALL
SELECT 'ACTOR' AS TYP, A.FIRST_NAME, A.LAST_NAME
FROM ACTOR A
WHERE A.FIRST_NAME LIKE 'J%' AND A.LAST_NAME LIKE 'D%'
ORDER BY LNAME, FNAME;

/*Check different result and have a look how placing the set operator in different places make a difference*/
SELECT A.FIRST_NAME, A.LAST_NAME
FROM ACTOR A
WHERE A.FIRST_NAME LIKE 'J%' AND A.LAST_NAME LIKE 'D%'
UNION ALL
SELECT A.FIRST_NAME, A.LAST_NAME
FROM ACTOR A
WHERE A.FIRST_NAME LIKE 'M%' AND A.LAST_NAME LIKE 'T%'
UNION
SELECT C.FIRST_NAME, C.LAST_NAME
FROM CUSTOMER C
WHERE C.FIRST_NAME LIKE 'J%' AND C.LAST_NAME LIKE 'D%';
/*Set operators appearance order changed*/
SELECT A.FIRST_NAME, A.LAST_NAME
FROM ACTOR A
WHERE A.FIRST_NAME LIKE 'J%' AND A.LAST_NAME LIKE 'D%'
UNION 
SELECT A.FIRST_NAME, A.LAST_NAME
FROM ACTOR A
WHERE A.FIRST_NAME LIKE 'M%' AND A.LAST_NAME LIKE 'T%'
UNION ALL
SELECT C.FIRST_NAME, C.LAST_NAME
FROM CUSTOMER C
WHERE C.FIRST_NAME LIKE 'J%' AND C.LAST_NAME LIKE 'D%';

/*--------------------------------*/
/*Set a = {L M N O P}
Set b = {P Q R S T}
A UNION B = {L M N O P Q R S T}
A UNION ALL B = {L M N O P P Q R S T}
A INTERSECT B = {P}
A EXCEPT B = {L M N O}*/

/*Write a compound query that finds the first and last names of all actors and customers whose last name starts with l*/
SELECT A.FIRST_NAME, A.LAST_NAME
FROM ACTOR A
WHERE A.LAST_NAME LIKE 'L%'
UNION
SELECT C.FIRST_NAME, C.LAST_NAME
FROM CUSTOMER C
WHERE C.LAST_NAME LIKE 'L%';

/*Sort the previous query by lname*/
SELECT A.FIRST_NAME AS FNAME, A.LAST_NAME AS LNAME
FROM ACTOR A
WHERE A.LAST_NAME LIKE 'L%'
UNION
SELECT C.FIRST_NAME, C.LAST_NAME
FROM CUSTOMER C
WHERE C.LAST_NAME LIKE 'L%'
ORDER BY LNAME;