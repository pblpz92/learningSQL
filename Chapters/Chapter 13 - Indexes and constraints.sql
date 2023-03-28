/*Chapter 13 - Indexes and constraints*/

/*13-1 Generate an alter table statement for the rental table so that an error will be
raised if a row having a value found in the rental.customer_id column is deleted
from the customer table.*/
ALTER TABLE RENTAL
ADD CONSTRAINT FK_RENTAL_CUSTOMER_ID FOREIGN KEY (CUSTOMER_ID)
REFERENCES CUSTOMER (CUSTOMER_ID) ON DELETE RESTRICT;

/*13-2 Generate a multicolumn index on the payment table that could be used by both of the 
following queries:

SELECT CUSTOMER_ID, PAYMENT_DATE, AMOUNT
FROM PAYMENT
WHERE PAYMENT_DATE > CAST('2019-12-31 23:59:59' AS DATETIME)

SELECT CUSTOMER_ID, PAYMENT_DATE, AMOUNT
FROM PAYMENT
WHERE PAYMENT_DATE > CAST('2019-12-31 23:59:59' AS DATETIME)
AND AMOUNT < 5;*/

CREATE INDEX IDX_PAYMENT_AMOUNT 
ON PAYMENT(PAYMENT_DATE, AMOUNT);
