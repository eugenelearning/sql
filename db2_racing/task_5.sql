with 
	avg_by_car as (
		select
			c.name,
			c.class,
			avg(r.position)
		from
			results r
		join cars c on
			c.name = r.car
		join classes cl on
			c.class = cl.class
		group by
			c.name
	),
	low_result_cars_in_class as (
		select
			c.class,
			count(r.position)
		from
			cars c
		join classes cl on c.class = cl.class
		join results r on r.car = c.name
		where r.position > 3
			group by c.class
		
	),
	total_races_by_class as (
		select
			c.class,
			count(r.race)
		from
			results r
		join cars c on
			c.name = r.car
		join classes cl on
			c.class = cl.class
		group by
			c.class
	)
select
	c.name as car_name,
	c.class as car_class,
	avg(r.position) as average_position,
	count(r) as race_count,
	tr.count as total_races,
	lrc.count as low_position_count
	
	from
		results r
	join cars c on
		c.name = r.car
	join classes cl on
		c.class = cl.class
	join avg_by_car a on
		a.name = c.name
	join total_races_by_class tr on 
		tr.class = c.class
	join low_result_cars_in_class lrc on 
		lrc.class = c.class
	where a.avg > 3
	
group by
	c.name,
	r.position,
	c.class,
	tr.count,
	a.avg,
	lrc.count

order by low_position_count desc