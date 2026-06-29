/*==========================================================
  COGNIZANT DIGITAL NURTURE 5.0
  MODULE 3 - PL/SQL PROGRAMMING
  BANKING DATABASE
==========================================================*/

SET SERVEROUTPUT ON;

/*==========================================================
  DROP TABLES (Ignore errors if running for the first time)
==========================================================*/

DROP TABLE Loans CASCADE CONSTRAINTS;
DROP TABLE Accounts CASCADE CONSTRAINTS;
DROP TABLE Customers CASCADE CONSTRAINTS;
DROP TABLE Employees CASCADE CONSTRAINTS;

/*==========================================================
  CREATE TABLES
==========================================================*/

CREATE TABLE Customers (
    CustomerID NUMBER PRIMARY KEY,
    CustomerName VARCHAR2(50),
    Age NUMBER,
    Balance NUMBER,
    IsVIP VARCHAR2(5)
);

CREATE TABLE Loans (
    LoanID NUMBER PRIMARY KEY,
    CustomerID NUMBER,
    InterestRate NUMBER,
    DueDate DATE,
    FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Accounts (
    AccountID NUMBER PRIMARY KEY,
    CustomerID NUMBER,
    AccountType VARCHAR2(20),
    Balance NUMBER,
    FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Employees (
    EmployeeID NUMBER PRIMARY KEY,
    EmployeeName VARCHAR2(50),
    Department VARCHAR2(30),
    Salary NUMBER
);

/*==========================================================
  INSERT SAMPLE DATA
==========================================================*/

INSERT INTO Customers VALUES (101,'Rahul',65,15000,'FALSE');
INSERT INTO Customers VALUES (102,'Anita',35,8000,'FALSE');
INSERT INTO Customers VALUES (103,'Priya',70,25000,'FALSE');

INSERT INTO Loans VALUES (201,101,10,TRUNC(SYSDATE)+20);
INSERT INTO Loans VALUES (202,102,9,TRUNC(SYSDATE)+45);
INSERT INTO Loans VALUES (203,103,11,TRUNC(SYSDATE)+10);

INSERT INTO Accounts VALUES (301,101,'Savings',50000);
INSERT INTO Accounts VALUES (302,102,'Savings',25000);
INSERT INTO Accounts VALUES (303,103,'Savings',70000);

INSERT INTO Employees VALUES (401,'Amit','HR',50000);
INSERT INTO Employees VALUES (402,'Sneha','IT',60000);
INSERT INTO Employees VALUES (403,'Rohan','IT',55000);

COMMIT;

/*==========================================================
  DATABASE CREATED SUCCESSFULLY
==========================================================*/



/*==========================================================
  EXERCISE 1 : CONTROL STRUCTURES
==========================================================*/

------------------------------------------------------------
-- Scenario 1
-- Apply 1% discount to loan interest rate
-- for customers above 60 years
------------------------------------------------------------

BEGIN

    FOR c IN (
        SELECT CustomerID
        FROM Customers
        WHERE Age > 60
    )

    LOOP

        UPDATE Loans
        SET InterestRate = InterestRate - 1
        WHERE CustomerID = c.CustomerID;

    END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Scenario 1 Completed');

END;
/

------------------------------------------------------------
-- Scenario 2
-- Mark customers as VIP if Balance > 10000
------------------------------------------------------------

BEGIN

    FOR c IN (
        SELECT CustomerID
        FROM Customers
        WHERE Balance > 10000
    )

    LOOP

        UPDATE Customers
        SET IsVIP = 'TRUE'
        WHERE CustomerID = c.CustomerID;

    END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Scenario 2 Completed');

END;
/

------------------------------------------------------------
-- Scenario 3
-- Display reminders for loans due within 30 days
------------------------------------------------------------

BEGIN

    FOR l IN (

        SELECT CustomerID,
               LoanID,
               DueDate

        FROM Loans

        WHERE DueDate BETWEEN TRUNC(SYSDATE)
                          AND TRUNC(SYSDATE)+30

    )

    LOOP

        DBMS_OUTPUT.PUT_LINE(
            'Reminder : Customer '
            || l.CustomerID
            || ' Loan ID '
            || l.LoanID
            || ' Due Date '
            || l.DueDate
        );

    END LOOP;

END;
/

/*==========================================================
  EXERCISE 3 : STORED PROCEDURES
==========================================================*/

------------------------------------------------------------
-- Scenario 1
-- Process Monthly Interest
------------------------------------------------------------

CREATE OR REPLACE PROCEDURE ProcessMonthlyInterest
AS
BEGIN

    UPDATE Accounts
    SET Balance = Balance + (Balance * 0.01)
    WHERE AccountType = 'Savings';

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Monthly Interest Processed');

END;
/

------------------------------------------------------------
-- Scenario 2
-- Update Employee Bonus
------------------------------------------------------------

CREATE OR REPLACE PROCEDURE UpdateEmployeeBonus(

    p_department IN VARCHAR2,
    p_bonus IN NUMBER

)
AS
BEGIN

    UPDATE Employees
    SET Salary = Salary + (Salary * p_bonus / 100)
    WHERE Department = p_department;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Employee Bonus Updated');

END;
/

------------------------------------------------------------
-- Scenario 3
-- Transfer Funds
------------------------------------------------------------

CREATE OR REPLACE PROCEDURE TransferFunds(

    p_fromAccount IN NUMBER,
    p_toAccount IN NUMBER,
    p_amount IN NUMBER

)
AS

    v_balance NUMBER;

BEGIN

    SELECT Balance
    INTO v_balance
    FROM Accounts
    WHERE AccountID = p_fromAccount;

    IF v_balance >= p_amount THEN

        UPDATE Accounts
        SET Balance = Balance - p_amount
        WHERE AccountID = p_fromAccount;

        UPDATE Accounts
        SET Balance = Balance + p_amount
        WHERE AccountID = p_toAccount;

        COMMIT;

        DBMS_OUTPUT.PUT_LINE('Transfer Successful');

    ELSE

        DBMS_OUTPUT.PUT_LINE('Insufficient Balance');

    END IF;

END;
/

/*==========================================================
  TESTING THE PROCEDURES
==========================================================*/

BEGIN
    ProcessMonthlyInterest;
END;
/

BEGIN
    UpdateEmployeeBonus('IT',10);
END;
/

BEGIN
    TransferFunds(301,302,5000);
END;
/

PROMPT
PROMPT ============================
PROMPT CUSTOMERS
PROMPT ============================

SELECT * FROM Customers;

PROMPT
PROMPT ============================
PROMPT LOANS
PROMPT ============================

SELECT * FROM Loans;

PROMPT
PROMPT ============================
PROMPT ACCOUNTS
PROMPT ============================

SELECT * FROM Accounts;

PROMPT
PROMPT ============================
PROMPT EMPLOYEES
PROMPT ============================

SELECT * FROM Employees;