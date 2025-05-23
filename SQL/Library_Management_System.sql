CREATE DATABASE Library_Management_System;
USE Library_Management_System;

-- Authors Table
CREATE TABLE Authors (
    AuthorID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100),
    DateOfBirth DATE
);

-- Books Table
CREATE TABLE Books (
    BookID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(200),
    AuthorID INT,
    PublicationYear INT,
    Genre VARCHAR(50),
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);

-- Patrons Table
CREATE TABLE Patrons (
    PatronID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100),
    MembershipDate DATE
);

-- Loans Table
CREATE TABLE Loans (
    LoanID INT AUTO_INCREMENT PRIMARY KEY,
    BookID INT,
    PatronID INT,
    LoanDate DATE,
    ReturnDate DATE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (PatronID) REFERENCES Patrons(PatronID)
);

-- Insert Authors
INSERT INTO Authors (Name, DateOfBirth) VALUES
('J.K. Rowling', '1965-07-31'),
('George Orwell', '1903-06-25'),
('Jane Austen', '1775-12-16');

-- Insert Books
INSERT INTO Books (Title, AuthorID, PublicationYear, Genre) VALUES
('Harry Potter', 1, 1997, 'Fantasy'),
('1984', 2, 1949, 'Dystopian'),
('Pride and Prejudice', 3, 1813, 'Romance');

-- Insert Patrons
INSERT INTO Patrons (Name, MembershipDate) VALUES
('Alice', '2023-01-01'),
('Bob', '2023-02-15'),
('Charlie', '2023-03-10');

-- Insert Loans
INSERT INTO Loans (BookID, PatronID, LoanDate, ReturnDate) VALUES
(1, 1, '2023-04-01', '2023-04-10'),
(2, 2, '2023-04-05', NULL),
(3, 1, '2023-05-01', NULL);

SELECT B.Title, A.Name AS Author
FROM Books B
JOIN Authors A ON B.AuthorID = A.AuthorID;

SELECT P.Name, COUNT(*) AS TotalBorrowed
FROM Patrons P
JOIN Loans L ON P.PatronID = L.PatronID
GROUP BY P.PatronID;

SELECT 
    DATE_FORMAT(LoanDate, '%Y-%m') AS Month,
    COUNT(*) AS BooksLoaned
FROM Loans
GROUP BY Month;

DELIMITER //

CREATE PROCEDURE AddNewBook(
    IN p_Title VARCHAR(200),
    IN p_AuthorName VARCHAR(100),
    IN p_DOB DATE,
    IN p_PublicationYear INT,
    IN p_Genre VARCHAR(50)
)
BEGIN
    DECLARE aID INT;
    SELECT AuthorID INTO aID FROM Authors WHERE Name = p_AuthorName LIMIT 1;
    
    IF aID IS NULL THEN
        INSERT INTO Authors (Name, DateOfBirth)
        VALUES (p_AuthorName, p_DOB);
        SET aID = LAST_INSERT_ID();
    END IF;
    
    INSERT INTO Books (Title, AuthorID, PublicationYear, Genre)
    VALUES (p_Title, aID, p_PublicationYear, p_Genre);
END;
//

DELIMITER ;

CALL AddNewBook('Animal Farm', 'George Orwell', '1903-06-25', 1945, 'Political Fiction');

DELIMITER //

CREATE TRIGGER AutoUpdateReturnDate
BEFORE UPDATE ON Loans
FOR EACH ROW
BEGIN
    IF OLD.ReturnDate IS NULL AND NEW.ReturnDate IS NOT NULL THEN
        SET NEW.ReturnDate = CURDATE();
    END IF;
END;
//

DELIMITER ;
