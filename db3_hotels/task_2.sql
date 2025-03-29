/* похоже в ожидаемом выводе допущена ошибка, кажется забыли умножить цену на кол-во дней */ 
with
	total_spents_by_user as (
		select
			c.id_customer as id,
			count(b.id_booking) as total_booking,
			sum(r.price * extract(day from age(b.check_out_date, b.check_in_date)))
		from
			booking b
		join room r on
			r.id_room = b.id_room
		join hotel h on
			h.id_hotel = r.id_hotel
		join customer c on
			c.id_customer = b.id_customer
		group by id
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
	c.id_customer ID_customer,
	c.name,
	tsu.total_booking,
	tsu.sum total_spent,
	count(uhbu) unique_hotels
from
	customer c
join total_spents_by_user tsu on
	tsu.id = c.id_customer
join uniq_hotels_by_user uhbu on
	uhbu.id = c.id_customer
where
	tsu.sum > 500
group by
	c.id_customer,
	c.name,
	tsu.total_booking,
	tsu.sum
having
	count(uhbu) > 1
order by tsu.sum