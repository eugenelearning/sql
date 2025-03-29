with 
  avg_by_class as (
    select
      c.class,
      avg(r.position) as avg
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
  cl.country as car_country
from
  results r
join cars c on
  r.car = c.name
join classes cl  on
  c.class = cl.class
join avg_by_class a on
  a.class = c.class
where
  r.position < a.avg
group by
  c.name,
  c.class,
  r.position,
  cl.country
order by 
  c.class,
  r.position
asc
