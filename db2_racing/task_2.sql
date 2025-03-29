with min_results_position as (
	select min(position) as value from results
)
select
	c.name as car_name,
	cl.class as car_class,
	round(avg(r.position)::numeric, 4) as average_position,
	count(rc) as race_count,
	cl.country as car_country
from
	cars c
join classes cl on
	c.class = cl.class
join results r on
	r.car = c.name
join races rc on
	rc.name = r.race
where r.position = (select value from min_results_position)
group by
	c.name,
	cl.class
order by car_name
limit 1