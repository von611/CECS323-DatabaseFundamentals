-- connect 'jdbc:derby://localhost:1527/toyBankDB;create=true;user=manager;password=toyManPWD;';

-- customers who are depositors... i.e. who own some account
SELECT ID, Fname, Lname, cid, acct_number
  FROM customers C INNER JOIN depositors D ON C.id=D.cid;


-- An additional join with accounts can provide information about the account such as the balance
SELECT ID, Fname, Lname, cid, A.acct_number, balance, date_opened
  FROM customers C 
       INNER JOIN depositors D ON C.id=D.cid
       INNER JOIN accounts A ON D.acct_number=A.acct_number;


-- customers who have loans...
SELECT ID, fname, lname, owner_id, loan_number
  FROM customers C INNER JOIN loans L ON C.id=L.owner_id;


-- Note that no additional joins are required to get information about the loan, 
-- since unlike accounts, only one person can own a loan -- i.e. it's a 1-to-many relationship

SELECT ID, fname, lname, owner_id, loan_number, amount
  FROM customers C INNER JOIN loans L ON C.id=L.owner_id;



-- ID's of customers who do not own any loans

SELECT id
  FROM customers
EXCEPT
SELECT owner_id AS id
  FROM loans;


  
-- ID and names of customers who do not own any loans

SELECT id, fName, lName
  FROM customers
EXCEPT
SELECT owner_id as id, fName, lName
  FROM loans INNER JOIN customers ON owner_id=id;

-- disconnect;
-- exit;