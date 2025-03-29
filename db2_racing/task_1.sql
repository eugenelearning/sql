select
  c.name as car_name,
  cl.class as car_class,
  round(avg(r.position)::numeric,4) as average_position,
  count(rc) as race_count
from
  cars c
join classes cl on
  c.class = cl.class
join results r on
  r.car = c.name
join races rc on
  rc.name = r.race
group by
  c.name,
  cl.class
order by
  average_position,
  car_name