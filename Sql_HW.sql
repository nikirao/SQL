use sakila;
select first_name, last_name from actor;

select upper(Concat(first_name,' ',last_name)) as Actor_Name from actor;

select actor_id, first_name,last_name from actor where UPPER(first_name)='JOE' ;

select * from actor where upper(last_name) like '%GEN%';

select * from actor where upper(last_name) like '%LI%' order by last_name, first_name;

select country_id, country from country where upper(country) in ('AFGHANISTAN','BANGLADESH','CHINA');

alter table actor add description blob ;

alter table actor drop column description;

select last_name, count(*) as last_name_count from actor group by last_name;

select last_name, count(*) as last_name_count from actor group by last_name having count(*)>1;

SET SQL_SAFE_UPDATES = 0;

update actor set first_name='HARPO' , last_name='WILLIAMS' where 
upper(first_name)='GROUCHO' and upper(last_name)='WILLIAMS';

COMMIT;

update actor set first_name='GROUCHO'  where 
upper(first_name)='HARPO';

COMMIT;

SHOW CREATE TABLE ADDRESS;

SELECT s.first_name,s.last_name,a.address,a.address2,a.district,a.city_id,a.postal_code 
FROM staff s 
join address a
on s.address_id=a.address_id ;

select s.first_name, s.last_name, sum(p.amount) as total_amount 
from staff  s 
join payment p 
on s.staff_id=p.staff_id
where p.payment_date like '2005-08%'
group by s.staff_id;

select f.title, count(fa.actor_id) as num_of_actors  
from film f 
inner join film_actor fa 
where f.film_id=fa.film_id 
group by f.film_id;

select count(inventory_id) as num_of_copies from inventory where film_id in 
(
select film_id from film where upper(title)='HUNCHBACK IMPOSSIBLE');

select c.first_name, c.last_name, sum(p.amount) as total_amount_paid from customer c 
join payment p 
on c.customer_id=p.customer_id
group by c.customer_id
order by c.last_name;

select title from film
where upper(title) like 'K%' 
or upper(title) like 'Q%' 
and language_id in
( 
 select language_id from language
 where upper(name)='ENGLISH'
 );
 
 select first_name,last_name from actor 
 where actor_id in 
 ( 
 select actor_id from film
 where upper(title)='ALONE TRIP'
 );
 
 
select c.first_name,c.last_name,c.email 
from customer c
join customer_list cl
on c.customer_id=cl.ID
where upper(cl.country)='CANADA';


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


select f.title,count(f.title) as times_rented 
from film f
join inventory i
on f.film_id=i.film_id
join rental r
on i.inventory_id=r.inventory_id
group by i.film_id
order by count(f.title) desc;


select store,total_sales from sales_by_store;

select s.store_id, c.city, co.country 
from store s
join address a
on s.address_id=a.address_id
join city c
on a.city_id=c.city_id
join country co
on c.country_id=co.country_id;


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

SELECT * from top_five_genres;

SHOW CREATE VIEW top_five_genres;

DROP VIEW top_five_genres;

commit;

