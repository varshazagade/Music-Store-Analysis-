
--Q.1:What is the senior most employee based on job title?

select*from employee
order by levels desc
limit 1

--Q.2:Which countries have the most Invoices?

select*from invoice;
select count(*) as c ,billing_country 
from invoice
group by billing_country
order by c desc

--Q.3:What are top 3 values of total invoice

select total from invoice
order by total desc
limit 3

--Q4:Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money .
--Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals 

select*from invoice
select sum(total) as invoice_total,billing_city from invoice
group by billing_city
order by invoice_total desc

--Q.5: Who is the best customer? The customer who has spent the most money will be declared the best customer.
--Write a query that returns the person who has spent the most money.

select customer.customer_id,customer.first_name,customer.last_name ,sum(invoice.total)as Total from customer
join invoice on customer.customer_id=invoice.customer_id
group by customer.customer_id
order by total desc
limit 1

--Q.6:Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
--Return your list oselect from customer
Select distinct email,first_name,last_name from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id in(
	select track_id from track
	join genre on track.genre_id = genre.genre_id
	where genre.name like 'Rock')
order by email;

--Q.7: Let's invite the artists who have written the most rock music in our dataset. 
--Write a query that returns the Artist name and total track count of the top 10 rock bands.

SELECT artist.artist_id, artist.name,COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id
ORDER BY number_of_songs DESC
LIMIT 10;

 --Q.8: Return all the track names that have a song length longer than the average song length. 
 --Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first.

SELECT name,track.Milliseconds from track
where Milliseconds >
	(select avg (Milliseconds) as Avg_track_length 
	from track)
order by track.Milliseconds desc;


--Q.9:Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent


with best_selling_artist as 
(
		select artist.artist_id as artist_id,artist.name as Artist_name,
		sum(invoice_line.unit_price * invoice_line.quantity) as Total_sales
		from invoice_line
        join track on track.track_id= invoice_line.track_id
		join album on album.album_id = track.album_id
		join artist on artist.artist_id = album.artist_id 
		Group by 1
		Order by 3 desc
		limit 1 
)
select c.customer_id,c.first_name,c.last_name,bsa.artist_name ,
sum(il.Unit_price*il.quantity) as Amount_spent from invoice i
join customer c on c.customer_id=i.customer_id
join invoice_line il on il.invoice_id=i.invoice_id
join track t on t.track_id=il.track_id
join album alb on alb.album_id=t.album_id
join best_selling_artist bsa on bsa.artist_id=alb.artist_id
group by 1,2,3,4
order by 5 desc;

--Q.10: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
--with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
--the maximum number of purchases is shared return all Genres. 

With popular_genre as
(
	select count(invoice_line.quantity ) as purchases ,customer.country,genre.name,genre.genre_id,
	Row_Number() Over(partition by customer.country order by count (invoice_line.quantity) desc) as RowNo 
	from invoice_line
	join invoice on invoice.invoice_id=invoice_line.invoice_id
	join customer on customer.customer_id=invoice.customer_id
	join track on track.track_id=invoice_line.track_id
	join genre on genre.genre_id=track.genre_id
	group by 2,3,4
	order by 2 asc,1 desc
)
select*from popular_genre where RowNo <=1
	



