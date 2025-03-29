/*
сортировка по preferred_hotel_type работает некорректно
не удалось preferred_hotel_type использовать в order by case
*/ 
with
	uniq_hotels_by_user as (
		select distinct
			c.id_customer id,
			h.name hotel_name,
			h.id_hotel hotel_id
		from
			booking b
		join room r on
			r.id_room = b.id_room
		join hotel h on
			h.id_hotel = r.id_hotel
		join customer c on
			c.id_customer = b.id_customer
		order by
			c.id_customer
	),
	
	hotels_rank as (
		select
			h.id_hotel id,
			avg(r.price) price
		from
			hotel h
		join room r on
			r.id_hotel = h.id_hotel
		group by
			h.id_hotel
		order by
			price
	)
select
	c.id_customer,
	c.name,
	string_agg(uhbu.hotel_name, ',') visited_hotels,
	(case
		when exists (
			select id
			from hotels_rank
			where price > 300
			and id in (
				select uu1.hotel_id hotel_id
				from uniq_hotels_by_user uu1
				where uu1.id = c.id_customer
			)
		)
			then 'Дорогой'
		when exists (
			select id
			from hotels_rank
			where price < 300
			and price > 175
			and id in (
				select uu1.hotel_id hotel_id
				from uniq_hotels_by_user uu1
				where uu1.id = c.id_customer
			)
		)
			then 'Средний'
		else 
			'Дешевый'
	end) preferred_hotel_type
from
	customer c
join uniq_hotels_by_user uhbu on
	uhbu.id = c.id_customer
group by
	c.id_customer,
	c.name
order by
	preferred_hotel_type