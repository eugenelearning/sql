with entries as (
  select
    model,
    horsepower,
    engine_capacity
  from
    car
  where
    horsepower > 150
    and engine_capacity < 3.0
    and price < 35000
union
  select
    model,
    horsepower,
    engine_capacity
  from
    motorcycle
  where
    horsepower > 150
    and engine_capacity < 1.5
    and price < 20000
union
  select
    model,
    null as horsepower,
    null as engine_capacity
  from
    bicycle
  where
    bicycle.gear_count > 18
    and price < 4000
)
select
  v.maker,
  entries.model,
  entries.horsepower,
  entries.engine_capacity,
  v.type as vehicle_type
from
  vehicle v
join entries on
  v.model = entries.model
order by
  entries.horsepower desc nulls last