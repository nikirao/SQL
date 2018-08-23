use sakila;

#1a - Display first and last names of all actors from the table `actor`.
select first_name, last_name from actor;


#1b - Display sfirst and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
select upper(Concat(first_name,' ',last_name)) as Actor_Name from actor;

#2a - find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe."
select actor_id, first_name,last_name from actor where UPPER(first_name)='JOE' ;

#2b - Find all actors whose last name contain the letters `GEN`.
select * from actor where upper(last_name) like '%GEN%';


#2c - Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order.
select * from actor where upper(last_name) like '%LI%' order by last_name, first_name;

#2d - Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China.
select country_id, country from country where upper(country) in ('AFGHANISTAN','BANGLADESH','CHINA');

#3a - create a column in the table `actor` named `description` and use the data type `BLOB`.
alter table actor add description blob ;

#3b - Delete the `description` column.
alter table actor drop column description;

#4a - List the last names of actors, as well as how many actors have that last name.
select last_name, count(*) as last_name_count from actor group by last_name;

#4b - List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors.
select last_name, count(*) as last_name_count from actor group by last_name having count(*)>1;

#4c - The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.
SET SQL_SAFE_UPDATES = 0;

update actor set first_name='HARPO' , last_name='WILLIAMS' where 
upper(first_name)='GROUCHO' and upper(last_name)='WILLIAMS';

COMMIT;


#4d - if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
update actor set first_name='GROUCHO'  where 
upper(first_name)='HARPO';

COMMIT;


#5a - You cannot locate the schema of the `address` table. Which query would you use to re-create it?
SHOW CREATE TABLE ADDRESS;


#6a-  Use `JOIN` to display the first and last names, as well as the address, of each staff member.
SELECT s.first_name,s.last_name,a.address,a.address2,a.district,a.city_id,a.postal_code 
FROM staff s 
join address a
on s.address_id=a.address_id ;


#6b - Use `JOIN` to display the total amount rung up by each staff member in August of 2005.
select s.first_name, s.last_name, sum(p.amount) as total_amount 
from staff  s 
join payment p 
on s.staff_id=p.staff_id
where p.payment_date like '2005-08%'
group by s.staff_id;


#6c - List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film'.Use inner join.
select f.title, count(fa.actor_id) as num_of_actors  
from film f 
inner join film_actor fa 
where f.film_id=fa.film_id 
group by f.film_id;


#6d - How many copies of the film `Hunchback Impossible` exist in the inventory system?
select count(inventory_id) as num_of_copies from inventory where film_id in 
(
select film_id from film where upper(title)='HUNCHBACK IMPOSSIBLE');


#6e - Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name.
select c.first_name, c.last_name, sum(p.amount) as total_amount_paid from customer c 
join payment p 
on c.customer_id=p.customer_id
group by c.customer_id
order by c.last_name;

#7a - Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
select title from film
where upper(title) like 'K%' 
or upper(title) like 'Q%' 
and language_id in
( 
 select language_id from language
 where upper(name)='ENGLISH'
 );
 
 #7b - Use subqueries to display all actors who appear in the film `Alone Trip`.
select first_name,last_name from actor where actor_id in (
	select actor_id from film_actor where film_id in (
		select film_id from film where upper(title)='ALONE TRIP'));
 



#7c - need the names and email addresses of all Canadian customers.
select c.first_name,c.last_name,c.email 
from customer c
join customer_list cl
on c.customer_id=cl.ID
where upper(cl.country)='CANADA';

#7d - Display the most frequently rented movies in descending order.
select title from film 
where film_id in (
select film_id from film_category
where category_id in 
(
select category_id 
from category 
where upper(name)='FAMILY'
)
);

#7e - Display the most frequently rented movies in descending order.
select f.title,count(f.title) as times_rented 
from film f
join inventory i
on f.film_id=i.film_id
join rental r
on i.inventory_id=r.inventory_id
group by i.film_id
order by count(f.title) desc;

#7f - Write a query to display how much business, in dollars, each store brought in.
select b.store_id,sum(a.amount) as total_business 
from payment a,staff b
where a.staff_id=b.staff_id
group by b.store_id;


#7g - Write a query to display for each store its store ID, city, and country.
select s.store_id, c.city, co.country 
from store s
join address a
on s.address_id=a.address_id
join city c
on a.city_id=c.city_id
join country co
on c.country_id=co.country_id;

#7h - List the top five genres in gross revenue in descending order.
select c.name, sum(p.amount) as gross_revenue 
from category c
join film_category fc 
on c.category_id=fc.category_id
join inventory i
on fc.film_id=i.film_id
join rental r 
on i.inventory_id=r.inventory_id
join payment p 
on r.rental_id=p.rental_id
group by c.category_id
order by sum(p.amount) desc
limit 5;


#8a - Use the solution from the problem above to create a view.
CREATE VIEW top_five_genres AS
(
select c.name, sum(p.amount) as gross_revenue 
from category c
join film_category fc 
on c.category_id=fc.category_id
join inventory i
on fc.film_id=i.film_id
join rental r 
on i.inventory_id=r.inventory_id
join payment p 
on r.rental_id=p.rental_id
group by c.category_id
order by sum(p.amount) desc
limit 5
);


#8b. How would you display the view that you created in 8a?
SELECT * from top_five_genres;

SHOW CREATE VIEW top_five_genres;

#8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW top_five_genres;

commit;

