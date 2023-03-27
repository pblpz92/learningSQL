/*Chapter 12 - Transactions*/
/*Test your knoledge*/
/*12-1 Generate a unit of work to transfer $50 from account 123 to account 789. You will
need to insert two rows into the transaction table and update two rows in the
account table. Use the following table definitions and data:

ACCOUNT:
account id		avail_balance		last_activity_date
----------		--------------		------------------
123				500					2019-07-10 20;53:27
789				75					2019-06-22 15:18:35

TRANSACTION
txn_id		txn_date		account_id		txn_type_cd		amount
------		--------		----------		-----------		---------
1001		2019-05-15		123				C				500
1002		2019-06-01		789				C				75

Use txn_type_cd = 'C' to indicade a credit(addition), and use 'D' to indicate a debit(substraction).*/

START TRANSACTION;

INSERT INTO TRANSACTION (TXN_ID, TXN_DATE, ACCOUNT_ID, TXN_TYPE_CD, AMOUNT)
VALUES (1003, NOW(), 123, 'D', 50);

INSERT INTO TRANSACTION (TXN_ID, TXN_DATE, ACCOUNT_ID, TXN_TYPE_CD, AMOUNT)    
VALUES (1004, NOW(), 789, 'C', 50);

UPDATE ACCOUNT
SET AVAIL_BALANCE = ABAIL_BALANCE - 50,
	LAST_ACTIVITY_DATE = NOW()
WHERE ACCOUNT_ID = 123;

UPDATE ACCOUNT
SET AVAIL_BALANCE = ABAIL_BALANCE + 50,
	LAST_ACTIVITY_DATE = NOW()
WHERE ACCOUNT_ID = 789;
    
COMMIT;