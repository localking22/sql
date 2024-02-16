create database train;
use train;
create table passenger(passengerid int primary key,name varchar(50),
contactnumber varchar(30), ---assuming ###-###-#### format
email varchar(100));
insert into passenger(passengerid,name,contactnumber,email)values
(1,'john doe','123-456-7890','john.doe@example.com'),
(2,'jane smith','987-654-3210','jane.smith@example.com'),
(3,'michael brown','555-123-4567','michael.brown@example.com'),
(4,'emily johnson','222-333-4444','emily.johnson@example.com'),
(5,'david wilson','999-888-777','david.wilson@example.com'),
(6,'sarah lee','777-666-5555','sarah.lee@example.com'),
(7,'james miller','111-222-3333','james.miller@example.com'),
(8,'lisa taylor','444-555-6666','lisa.taylor@example.com'),
(9,'robert anderson','777-888-9999','robert.anderson@example.com'),
(10,'olivia martinez','666-555-4444','olivia martinez@example.com');
select * from passenger;

create table busfares(fareid int primary key,faretype varchar(40),price decimal(10,2),discounts nvarchar(50));
insert into busfares(fareid,faretype,price,discounts) values
(1,'sitting',50.00,'10% off for seniors'),
(2,'sleeper',100.00,'20% off for students');
select * from busfares;

create table bookings(bookingid int primary key,passengerid int,fareid int,seatnumber int,paymentstatus varchar(50),
Foreign key (passengerid) references passenger(passengerid),
foreign key(fareid) references Busfares(fareid),
constraint unique_seat_per_booking unique (bookingid,seatnumber),
constraint validpaymentstatus check (paymentstatus in ('paid','pending')));
insert into bookings(bookingid,passengerid,fareid,seatnumber,paymentstatus) values 
(1,1,1,10,'paid'),
(2,2,1,15,'pending'),
(3,3,2,5,'paid'),
(4,4,2,12,'paid'),
(5,5,1,8,'pending'),
(6,6,1,20,'paid'),
(7,7,2,3,'paid'),
(8,8,1,16,'pending'),
(9,9,2,7,'paid'),
(10,10,1,4,'pending');
select * from bookings;
select * from passenger;
select * from busfares;

--1
select name,paymentstatus  from passenger inner join bookings on passenger.passengerid=bookings.passengerid where paymentstatus='pending';
select passenger.name from passenger inner join bookings on passenger.passengerid=bookings.passengerid where paymentstatus='pending';

--2
select busfares.faretype from busfares inner join bookings on busfares.fareid=bookings.fareid;
----or
select fareid, count(*) as totalbookings
from bookings group by fareid;

--3
update bookings set paymentstatus='paid' where bookingid=2;
select * from bookings;

--4
select sum(fareid) as total_revenue from bookings where paymentstatus='paid';
select sum(fareid) as total_revenue from bookings where paymentstatus='pending';

--5
select passenger.* from passenger
join bookings ON passenger.passengerid = bookings.passengerid
where bookings.fareid=1;

--6
delete from bookings where passengerid=3;

--7
select 
    Bookings.bookingid,
    Passenger.name AS passenger_name,
    Passenger.contactnumber,
    Passenger.email,
    BusFares.faretype,
    BusFares.price,
    BusFares.discounts,
    Bookings.seatnumber,
    Bookings.paymentstatus
from 
    Bookings
join 
    Passenger ON Bookings.passengerid = Passenger.passengerid
join 
    BusFares ON Bookings.fareid = BusFares.fareid;

--8
select count(*) as totalbookings from bookings where bookingid=2;

--9
select passenger.* from passenger inner join bookings on 
passenger.passengerid=bookings.passengerid where seatnumber=10;

--10
select BusFares.*
from BusFares
join bookings ON BusFares.fareid = bookings.fareid
where bookings.bookingid = 9;

--11
select faretype, avg(price) AS average_price
from BusFares
group by faretype;

--12
select Passenger.* from passenger
 inner join (
    select passengerid
    from bookings
    group by passengerid
    having count(*)>1)AS bookings ON passenger.passengerid = Bookings.passengerid;

--13
SELECT
    BusFares.faretype,
    COUNT(Bookings.bookingid) AS booking_count
FROM
    BusFares
LEFT JOIN
    Bookings ON BusFares.fareid = Bookings.fareid
GROUP BY
    BusFares.faretype;
--or
select fareid, count(*) as bookingcount
from Bookings
group by fareid;

--14
select * from bookings where seatnumber between 1 and 10;

--15
select * from passenger
where passengerid in (select bookingid from bookings
where paymentstatus = 'pending');

