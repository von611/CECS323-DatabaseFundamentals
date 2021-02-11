-- connect 'jdbc:derby://localhost:1527/toyBankDB;create=true;user=manager;password=toyManPWD;';

-- * It builds a set of tables for maintaining banking data on
-- * a fictitious enterprise called ToyBank with several branches
-- * located throughout the country.
-- *
-- * Bank customers are those people who own accounts and/or loans.
-- * This ownership is stored in the depositors table (due to a many-to-many relationship)
-- * and the loas table (due to a 1-to-many relationship).
-- * Loans and Accounts must be owned by at least one customer.
-- *
-- *
-- * This script can be executed from the Derby plugin to Eclipse
-- *
-- * The first time it executes, the script will generate errors as it
-- * attempts to drop tables that _should_ not be part of the current schema.
-- * When executed subsequently, it will remove all existing data and tables, 
-- * create the tables, and insert the initial set of tuples.
-- *
-- * Acknowledgement:
-- * These tables are based on the banking schema that is presented
-- * in the textbook: "Database System Concepts", 3rd edition by
-- * Silberschatz, Korth, and Sudarshan.
-- *



DROP TABLE loans; 
DROP TABLE depositors; 
DROP TABLE accounts; 
DROP TABLE customers; 
DROP TABLE branches; 

CREATE TABLE branches
(
   id         INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY(START WITH 101, INCREMENT BY 1),
   street     VARCHAR(30) NOT NULL,
   city       VARCHAR(20) NOT NULL, 
   state      CHAR(2) NOT NULL, 
   zipcode    CHAR(10) NOT NULL, 
   assets     DECIMAL(10,2) NOT NULL, 
   CONSTRAINT branches_PK PRIMARY KEY (id), 
   CONSTRAINT branches_CK UNIQUE (street, city, state, zipcode),
   CONSTRAINT positive_assets CHECK (assets > 0) 
); 


CREATE TABLE accounts    -- an account, its branch, balance, and date when opened
(
   account_number   INTEGER NOT NULL, 
   branch_id     INTEGER NOT NULL, 
   balance       DECIMAL(10,2) NOT NULL, 
   date_opened   DATE NOT NULL,
   CONSTRAINT accounts_PK PRIMARY KEY (account_number), 
   CONSTRAINT accounts_branch_FK
       FOREIGN KEY (branch_id) REFERENCES branches(id),
   CONSTRAINT positive_balance CHECK (balance > 0) 
); 
  

CREATE TABLE customers
(
   id      INTEGER NOT NULL,
   fname   VARCHAR(20) NOT NULL, 
   lname   VARCHAR(20) NOT NULL, 
   street  VARCHAR(30) NOT NULL,
   city    VARCHAR(20) NOT NULL, 
   state   CHAR(2) NOT NULL, 
   zipcode CHAR(10) NOT NULL, 
   age     INTEGER NOT NULL,
   CONSTRAINT customers_PK PRIMARY KEY (id),
   CONSTRAINT customers_CK UNIQUE (fname, lname, street, city, state, zipcode)
); 
  

CREATE TABLE depositors   -- a customer and the account she owns
( 
   cid          INTEGER NOT NULL, 
   account_number  INTEGER NOT NULL, 
   CONSTRAINT depositors_PK PRIMARY KEY(cid, account_number), 
   CONSTRAINT depositors_customers_FK
       FOREIGN KEY(cid) REFERENCES customers(id) ON DELETE CASCADE,
   CONSTRAINT depositors_accounts_FK
       FOREIGN KEY(account_number) REFERENCES accounts(account_number) ON DELETE CASCADE
);
  

CREATE TABLE loans   -- a loan, its branch, its owner (at most one), the amount, and date when opened
(
   loan_number   INTEGER NOT NULL, 
   branch_id     INTEGER NOT NULL, 
   owner_id      INTEGER NOT NULL,
   amount        DECIMAL(10,2) NOT NULL, 
   date_opened   DATE NOT NULL,

   CONSTRAINT loans_PK PRIMARY KEY (loan_number), 
   CONSTRAINT loans_branch_FK
       FOREIGN KEY (branch_id) REFERENCES branches(id),
   CONSTRAINT loans_customers_FK
       FOREIGN KEY (owner_id) REFERENCES customers(id),
   CONSTRAINT nonnegative_loan_amount CHECK (amount >= 0) 
); 


INSERT INTO customers(id, lname, fname, street, city, state, zipcode, age) VALUES
    (5629,  'Lane', 'Lois', '593 Kryptonite Blvd.', 'Metropolis', 'CA', '90844', 27),
    (3762,  'Kent', 'Clark', '729 Steel St', 'Metropolis', 'CA', '90831', 28),
    (1023,  'Parker', 'Peter', '762 Web Way', 'Huntington Beach', 'CA', '90700', 26),
    (6720,  'Luthor', 'Lex', '9351 Swamp Alley', 'Huntington Beach', 'CA', '90715', 30),
    (9123,  'Watson', 'Mary-Jane', '762 Web Way', 'Huntington Beach', 'CA', '90700', 25),
    (1387,  'Osborn', 'Harry', '1 Main St', 'Huntington Beach', 'CA', '90701', 26),
    (8623,  'Banner', 'Bruce', '1953 Cherry Ave', 'Long Beach', 'CA', '90843', 39),
    (2385,  'Prince', 'Diana', '6153 Wonder Woman Blvd', 'Long Beach', 'NY', '11561', 40),
    (6520,  'Wolverine', 'Logan', '7285 Mountain Loop', 'Pasadena', 'CA', '90023', 33),
    (5638,  'Grey', 'Jeane', '832 Rose Blvd', 'Beverly Hills', 'CA', '90210', 30),
    (7163,  'Storm', 'Ororo', '832 Rose Blvd', 'Beverly Hills', 'CA', '90210', 34),
    (6329,  'Rogue', 'Marie', '7285 Mountain Loop', 'Pasadena', 'CA', '90023', 21),
    (4629,  'Cyclops', 'Scott', '832 Rose Blvd', 'Beverly Hills', 'CA', '90210', 29),
    (7263,  'Sabretooth', 'Victor', '1 Feline Dr', 'Big Bear', 'CA', '90445', 35);


-- commit;

INSERT INTO branches(street,city,state,zipcode,assets)
   VALUES ('532 First Ave','Brooklyn','NY', '01937', 9000000); 

-- For information on IDENTITY_VAL_LOCAL
--   See: https://db.apache.org/derby/docs/10.0/manuals/reference/sqlj82.html

INSERT INTO accounts VALUES (5101101, IDENTITY_VAL_LOCAL(), 5000, '2005-02-10'),
                            (5101666, IDENTITY_VAL_LOCAL(), 675, '2005-03-18');
INSERT INTO loans VALUES(9101170, IDENTITY_VAL_LOCAL(), 6520, 1000, '2005-01-01'),
                        (9101140, IDENTITY_VAL_LOCAL(), 6329, 1500, '2005-09-23');

INSERT INTO branches(street,city,state,zipcode,assets)
   VALUES ('94 Redwoods','Palo Alto','CA', '92557', 2100000); 

INSERT INTO accounts VALUES (5102222, IDENTITY_VAL_LOCAL(), 7000, '2001-11-30');
INSERT INTO loans VALUES(9102230, IDENTITY_VAL_LOCAL(), 1387, 2000, '2001-07-14');

INSERT INTO branches(street,city,state,zipcode,assets)
   VALUES ('8723 Perryridge Way','Long Beach','CA', '90806', 1700000); 

INSERT INTO accounts VALUES (5103102, IDENTITY_VAL_LOCAL(), 400, '2002-04-11'),
                            (5103555, IDENTITY_VAL_LOCAL(), 5000, '2003-09-17');
INSERT INTO loans VALUES(9103150, IDENTITY_VAL_LOCAL(), 2385, 1500, '2003-09-17'),
                        (9103160, IDENTITY_VAL_LOCAL(), 9123, 1300, '2004-10-23');

INSERT INTO branches(street,city,state,zipcode,assets)
   VALUES ('441 Mianus Blvd','Long Beach','CA', '90808', 400000); 
INSERT INTO accounts VALUES (5104215, IDENTITY_VAL_LOCAL(), 7000, '2002-08-03');
INSERT INTO loans VALUES(9104930, IDENTITY_VAL_LOCAL(), 7163, 500, '2001-05-10');

INSERT INTO branches(street,city,state,zipcode,assets)
   VALUES ('7 Round Hill Rd','Long Beach','CA', '90807', 8000000); 
INSERT INTO accounts VALUES (5105305, IDENTITY_VAL_LOCAL(), 350, '2002-07-04');
INSERT INTO loans VALUES(9105110, IDENTITY_VAL_LOCAL(), 1387, 900, '2002-04-20');

INSERT INTO branches(street,city,state,zipcode,assets)
   VALUES ('100 Pownal St','Bennington','CA', '94531', 300000); 
INSERT INTO loans VALUES(9106170, IDENTITY_VAL_LOCAL(), 7263, 23000, '2001-04-19');

INSERT INTO branches(street,city,state,zipcode,assets)
   VALUES ('1731 North Town Rd','Rye','CA', '91278', 3700000); 
INSERT INTO accounts VALUES (5107820, IDENTITY_VAL_LOCAL(), 5500, '2002-06-28');

INSERT INTO branches(street,city,state,zipcode,assets)
   VALUES ('1839 Brighton Ave','Brooklyn','NY', '01937', 7100000); 
INSERT INTO accounts VALUES (5108201, IDENTITY_VAL_LOCAL(), 9000, '2002-10-03'),
                            (5108217, IDENTITY_VAL_LOCAL(), 7500, '2002-03-18');
  
  
INSERT INTO depositors VALUES
   (4629,5107820), (6329,5101101), (1387,5104215),
   (2385,5103102), (8623,5105305), (6329,5108201),
   (6520,5108217), (5629,5102222), (3762,5102222),
   (1023,5103555), (1023,5101666), (9123,5103555);

-- commit;
-- 
-- disconnect;
-- exit;