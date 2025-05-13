-- LIbrary_managment_project:

CREATE TABLE branch (
    branch_id VARCHAR(10) PRIMARY KEY,
    manager_id VARCHAR(20),
    branch_address VARCHAR(50),
    contact_no VARCHAR(10)
);

select *from branch;
create table employees (
emp_id varchar(10) primary key,
emp_name varchar(25),
position varchar(15),
salary int,
branch_id varchar(25)
);



create table books
(
isbn varchar(20) primary key,	
book_title varchar(75),
category varchar(15),
rental_price float ,
status varchar(10),
author varchar(20),
publisher varchar(55)
) ;

CREATE TABLE members
(
member_id varchar(10) primary key,
member_name varchar (25),
member_address varchar(75),
reg_date date
) ;

CREATE TABLE issued_status
(
issued_id varchar(20) primary key,
issued_member_id varchar(10) FOREIGN KEY,
issued_book_name varchar(75),
issued_date date,
issued_book_isbn varchar(50) FOREIGN KEY,
issued_emp_id varchar(20) -- FOREIGN KEY
) ;

create table return_status
(
return_id varchar(10) primary key,
issued_id varchar(20),	
return_book_name varchar(75),
return_date date,
return_book_isbn varchar(35)
) ;

-- FOREIGN KEY
alter table issued_status
add constraint fk_members
FOREIGN KEY (issued_member_id)
references members(member_id);


alter table issued_status
add constraint fk_employees
FOREIGN KEY (issued_emp_id)
references employees(emp_id);

ALTER TABLE books
MODIFY category VARCHAR(20);


select *from branch;

alter table branch
modify column  contact_no varchar(25);

select *from members;

select *from return_status;

select *from employees;

select *from members;

-- project task Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"--

select *from books;

insert into books (isbn,book_title,category,rental_price,status,author,publisher)
values
  ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');


--- task 2 updating exiting member address---

select *from members;

update members 
set member_address = '240 Cedar St'
where member_id = 'c106';

--- Task 3 delect record from the issue status table  -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.-- 

select *from issued_status;

delete from issued_status
where  issued_id = 'IS121';

-- Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT *FROM BOOKS;

SELECT *FROM employees;
SELECT *FROM issued_status;

SELECT *FROM issued_status
WHERE issued_emp_id='E101';

-- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.

select *from members;

select *from issued_status;

select
    issued_emp_id,
    count(issued_id) as total_book_issued
    from issued_status
    group by issued_emp_id
    having count(issued_id) > 1;
    
    -- CTAS (Create Table As Select)
    -- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
    select *from issued_status;
    select *from books;
   
   create table book_cts
   as
   select 
      b.isbn,
      b.book_title,
      count(ist.issued_id) as no_issued
     from books as b
     join issued_status as ist
     on ist.issued_book_isbn = b.isbn
     group by 1,2;
     select *from book_cts;
     
     -- 4. Data Analysis & Findings
     --  following SQL queries were used to address specific questions:
     -- Task 7. Retrieve All Books in a Specific Category:
select *from books;

select *from books
where category = 'classic';

-- Task 8: Find Total Rental Income by Category:

select *from books;
select 
  b.category,
  sum(b.rental_price),
  count(*)
  from books as b
  join issued_status as ist
     on ist.issued_book_isbn = b.isbn
     group by 1;
     
     --  Tast 9=List Members Who Registered in the Last 180 Days:
     
     select *from members;
     
     select *from members
     where reg_date>= current_date - '180 days';
     
       INSERT INTO members (member_id, member_name, member_address, reg_data)
VALUES
    ('C201', 'Suhani', '5 Old Church Lane', '2024-07-01'),
    ('C222', 'Yuvraj', '4 Ber Close', '2024-07-02');
    
    select *from members;
    
SELECT * 
FROM members 
WHERE reg_date >= CURDATE() - INTERVAL 180 DAY;

-- TASK 10 List Employees with Their Branch Manager's Name and their branch details:

select 
 ep.*,
 b.branch_id,
 e2.emp_name as manager
from employees as ep
join 
branch as b
on b.branch_id = ep.branch_id
join 
employees as e2
 on b.manager_id = e2.emp_id;


select *from branch;

-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold 10$:
create table Books_greater_then_seven
as
select *from books
where rental_price>6;

select *from 
Books_greater_then_seven;

-- Task 12 Retrieve the List of Books Not Yet Returned-- 

select *from books;
select 
  Distinct ist.issued_book_name
from issued_status as ist
left join
return_status as rst
 on  ist.issued_id = rst.issued_id
 where rst.return_id is null