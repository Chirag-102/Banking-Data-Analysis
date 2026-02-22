



    CREATE DATABASE Power_BI2;


USE Power_BI2;

   =========================================================
   Clean Drop (Respect FK Order)
   ========================================================= 

IF OBJECT_ID('dbo.Transactions', 'U') IS NOT NULL DROP TABLE dbo.Transactions;
IF OBJECT_ID('dbo.Accounts', 'U') IS NOT NULL DROP TABLE dbo.Accounts;
IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL DROP TABLE dbo.Customers;
GO

  =========================================================
   Customers Table
   ========================================================= 

CREATE TABLE dbo.Customers (
    CustomerID     INT IDENTITY(1,1) PRIMARY KEY,
    Name           NVARCHAR(100) NOT NULL,
    Gender         CHAR(1) NULL CHECK (Gender IN ('M','F')),
    DateOfBirth    DATE NULL,
    Address        NVARCHAR(200) NULL,
    Email          NVARCHAR(100) NULL,
    Phone          VARCHAR(20) NULL
);
GO

  =========================================================
   Accounts Table
   ========================================================= 

CREATE TABLE dbo.Accounts (
    AccountID   INT IDENTITY(100,1) PRIMARY KEY,
    CustomerID  INT NOT NULL,
    Type        NVARCHAR(20) NOT NULL,
    OpenDate    DATE NOT NULL,
    Balance     DECIMAL(18,2) NOT NULL DEFAULT 0,

    CONSTRAINT FK_Accounts_Customers
        FOREIGN KEY (CustomerID)
        REFERENCES dbo.Customers(CustomerID)
);
GO

 =========================================================
   Transactions Table
   ========================================================= 

CREATE TABLE dbo.Transactions (
    TransactionID    INT IDENTITY(100000,1) PRIMARY KEY,
    AccountID        INT NOT NULL,
    TransactionDate  DATE NOT NULL,
    Type             VARCHAR(20) NOT NULL,
    Amount           DECIMAL(18,2) NOT NULL,
    Description      NVARCHAR(200) NULL,
    Currency         VARCHAR(10) NOT NULL,

    CONSTRAINT FK_Transactions_Accounts
        FOREIGN KEY (AccountID)
        REFERENCES dbo.Accounts(AccountID)
);
GO

   =========================================================
   Insert Sample Customers
   ========================================================= 

INSERT INTO dbo.Customers (Name, Gender, DateOfBirth, Address, Email, Phone)
VALUES
('Ajay Sharma',  'M', '1980-11-04', '123 Main St', NULL, '9891000001'),
('Priya Singh',  'F', '1975-07-21', '22B Park Road', 'priya@sample.com', '9891000002'),
('Sarah Khan',   'F', '1989-02-20', NULL, 'sarahkhan@email.com', '9891000003'),
('Mark Lee',     'M', '1995-05-14', '456 North Rd', 'markl@email.com', '9891000004'),
('Nadea Kumar',  'F', '1982-12-04', NULL, NULL, '9891000005');
GO

   =========================================================
   Insert Sample Accounts
   ========================================================= 

INSERT INTO dbo.Accounts (CustomerID, Type, OpenDate, Balance)
VALUES
(1, 'SAVINGS', '2013-03-14', 10000.00),
(2, 'CURRENT', '2011-06-20', 2500.00),
(3, 'SAVINGS', '2019-11-02', 0.00),
(4, 'CURRENT', '2018-07-21', 50.00),
(5, 'SAVINGS', '2016-05-07', 14.75);
GO

   =========================================================
   Insert Sample Transactions
   ========================================================= 

INSERT INTO dbo.Transactions (AccountID, TransactionDate, Type, Amount, Description, Currency)
VALUES
(100, '2025-01-10', 'DEBIT',  120.50, 'ATM Withdrawal', 'USD'),
(101, '2025-01-11', 'CREDIT', 500.00, 'Salary Credit',  'USD'),
(102, '2025-01-12', 'DEBIT',   75.25, 'Online Payment', 'USD');
GO

  =========================================================
   Simple Join Query (For Analysis / Demo)
   ========================================================= 

SELECT
    t.TransactionID,
    t.TransactionDate,
    t.Type      AS TransactionType,
    t.Amount,
    t.Currency,
    a.AccountID,
    a.Type      AS AccountType,
    a.Balance,
    c.CustomerID,
    c.Name
FROM dbo.Transactions t
JOIN dbo.Accounts a   ON t.AccountID = a.AccountID
JOIN dbo.Customers c  ON a.CustomerID = c.CustomerID;
GO