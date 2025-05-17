-- 1. Books Not Loaned Out in the Last 6 Months.
select b.BookID,b.Title
from Books b 
left join Loans l on l.BookID = b.BookID
and l.LoanDate >= date_sub(current_date,interval 6 month) 
where l.BookID is null;

-- 2. Top Members by Number of Books Borrowed in the Last Year
select m.MemberID,concat(m.FirstName,' ',m.LastName) as member_name,
count(l.BookID) as books_borrowed 
from Members m
left join Loans l on l.MemberID = m.MemberID 
and l.LoanDate >= date_sub(current_date,interval 1 year)
group by m.MemberID
order by books_borrowed desc 
limit 5

-- 3.Overdue Books Report
select b.BookID,b.Title,l.DueDate,l.ReturnDate
from Books b 
join Loans l on l.BookID = b.BookID 
where l.ReturnDate is null and 
l.DueDate < current_date 

-- 4. Top 3 Most Borrowed Categories
select c.CategoryID,c.CategoryName,count(l.LoanID) as Most_borrowed
from Categories c
left join BookCategories bc on bc.CategoryID = c.CategoryID
left join Loans l on l.BookID = bc.BookID
group by c.CategoryName,c.CategoryID
order by Most_borrowed desc 
limit 3

-- 5. Are there any books Belonging to Multiple Categories
select bc.BookID
from BookCategories bc
group by bc.BookID
having count(distinct bc.CategoryID) > 1


SELECT bc.BookID, 
       GROUP_CONCAT(DISTINCT c.CategoryName ORDER BY c.CategoryName) AS Categories
FROM BookCategories bc
JOIN Categories c ON c.CategoryID = bc.CategoryID
GROUP BY bc.BookID
HAVING COUNT(DISTINCT bc.CategoryID) > 1;

-- practice again 

-- 2. Top Members by Number of Books Borrowed in the Last Year
select m.MemberID,concat(m.FirstName,' ',m.LastName) as Member_name,
count(l.BookID) as no_of_books_borrowed
from Members m
left join Loans l on l.MemberID = m.MemberID
and l.LoanDate >= date_sub(current_date,interval 1 year)
group by m.MemberID
order by no_of_books_borrowed desc 
limit 5


-- 3.Overdue Books Report
with cte as (
select b.BookID,b.Title,l.DueDate,l.ReturnDate
from Books b 
left join Loans l on l.BookID = b.BookID 
where l.ReturnDate is null and 
l.DueDate <= current_date
)
select * from cte;
 
-- 4. Top 3 Most Borrowed Categories
with cte as (
select c.CategoryID,c.CategoryName,count(l.LoanID) as Most_borrowed
from categories c 
left join BookCategories bc on bc.CategoryID = c.CategoryID
left join Loans l on l.BookID = bc.BookID 
group by c.CategoryID,c.CategoryName
order by Most_borrowed desc
limit 3
)
select * from cte

-- 5. Are there any books Belonging to Multiple Categories
select bc.BookID,count(bc.CategoryID) as multiple_category
from BookCategories bc
group by bc.BookID
having count(distinct bc.CategoryID) > 1

-- Problem 2: Advanced Library Data Analysis

-- 6. Average Number of Days Books Are Kept
SELECT AVG(DATEDIFF(l.ReturnDate, l.LoanDate)) AS avg_days_kept
FROM Loans l
WHERE l.ReturnDate IS NOT NULL

select avg(datediff(l.ReturnDate,l.LoanDate)) as avg_days_kept
from loans l 
where ReturnDate is not null;

-- 7. Members with Reservations but No Loans in the Last Year
SELECT r.MemberID, r.BookID, r.ReservationID,l.LoanID
FROM Reservations r
LEFT JOIN Loans l 
  ON r.MemberID = l.MemberID 
  AND l.LoanDate >= DATE_SUB(current_date, INTERVAL 1 YEAR)
WHERE l.LoanID IS NULL;

-- 8. Percentage of Books Loaned Out per Category
SELECT
  c.CategoryID,
  c.CategoryName,
  COUNT(bc.BookID) AS book_loaned,
  ROUND(
    COUNT(bc.BookID) * 100.0 / (SELECT COUNT(bc.CategoryID) FROM BookCategories bc),
    2
  ) AS percentage_loaned
FROM Categories c
LEFT JOIN BookCategories bc ON bc.CategoryID = c.CategoryID
GROUP BY c.CategoryID, c.CategoryName;

-- 9. Total Number of Loans and Reservations Per Member
select r.MemberID,count(r.ReservationID) as total_reservation,
count(l.LoanID) as total_loans
from Reservations r 
left join loans l on l.MemberID = r.MemberID
group by r.MemberID

-- 10. Find Members Who Borrowed Books by the Same Author More Than Once
select l.MemberID,b.AuthorID,count(l.LoanID) as books_borrowed
from loans l 
left join Books b on b.BookID = l.BookID
group by l.MemberID,b.AuthorID
having count(l.LoanID) > 1

-- 11. List Members Who Have Both Borrowed and Reserved the Same Book
select l.MemberID,l.LoanID,r.ReservationID,l.BookID
from Loans l 
join Reservations r on r.MemberID = l.MemberID
and l.BookID = r.BookID

-- 12. Books Loaned and Never Returned
select l.LoanID,l.BookID,l.ReturnDate
from Loans l 
where l.ReturnDate is null

-- 13. Authors with the Most Borrowed Books
select b.AuthorID,count(l.LoanID) as Most_borrowed_books
from Books b 
join Loans l on l.BookID = b.BookID
group by b.AuthorID
order by Most_borrowed_books desc

-- 14. Which books were borrowed in the last 6 months, and which members borrowed them
SELECT l.MemberID, l.LoanID, l.BookID, l.LoanDate
FROM Loans l
WHERE l.LoanDate <= DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH);

