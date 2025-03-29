with 
  min_results_position as (
    select min(position) as value from results
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
  cl.class as car_class,
  round(avg(r.position)::numeric, 4) as average_position,
  count(rc) as race_count,
  cl.country as car_country,
  tr.count as total_races
from
  cars c
join classes cl on
  c.class = cl.class
join results r on
  r.car = c.name
join races rc on
  rc.name = r.race
join total_races_by_class tr on 
  tr.class = c.class
where r.position = (select value from min_results_position)
group by
  c.name,
  cl.class,
  tr.count
order by car_name