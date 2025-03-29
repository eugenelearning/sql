with
  total_bookings_by_user as (
    select
      c.id_customer as id,
      count(b.id_booking),
      avg(extract(day from age(b.check_out_date, b.check_in_date)))
    from
      booking b
    join room r on
      r.id_room = b.id_room
    join hotel h on
      h.id_hotel = r.id_hotel
    join customer c on
      c.id_customer = b.id_customer
    group by
      c.id_customer
  ),
  uniq_hotels_by_user as (
    select
      distinct c.id_customer as id,
      h.name as hotel_name
    from
      booking b
    join room r on
      r.id_room = b.id_room
    join hotel h on
      h.id_hotel = r.id_hotel
    join customer c on
      c.id_customer = b.id_customer
  )
select
  c.name as customer_name,
  c.email as customer_email,
  c.phone as customer_phone,
  tbu.count total_bookings,
  string_agg(uhbu.hotel_name, ',') hotels,
  tbu.avg avg_booking_duration
from
  customer c
join total_bookings_by_user tbu on
  tbu.id = c.id_customer
join uniq_hotels_by_user uhbu on
  uhbu.id = c.id_customer
where
  tbu.count > 2
group by
  c.name,
  c.email,
  c.phone,
  tbu.count,
  tbu.avg
having
  count(uhbu) > 1
order by tbu.count desc