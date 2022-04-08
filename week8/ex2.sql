EXPLAIN ANALYSE
SELECT f.film_id, f.title, c.name, rating
FROM film AS f
         JOIN film_category fc on f.film_id = fc.film_id
         JOIN category c on c.category_id = fc.category_id
WHERE f.film_id NOT IN (
    SELECT f.film_id
    FROM rental
             JOIN inventory i on i.inventory_id = rental.inventory_id
             JOIN film f on i.film_id = f.film_id)
  AND c.name IN ('Sci-Fi', 'Horror')
  AND rating IN ('R', 'PG-13');

-- Hash Join  (cost=661.68..731.72 rows=26 width=91) (actual time=10.352..10.546 rows=3 loops=1)
--   Hash Cond: (f.film_id = fc.film_id)
--   ->  Seq Scan on film f  (cost=639.58..708.58 rows=209 width=23) (actual time=10.015..10.238 rows=16 loops=1)
-- "        Filter: ((NOT (hashed SubPlan 1)) AND (rating = ANY ('{R,PG-13}'::mpaa_rating[])))"
--         Rows Removed by Filter: 984
--         SubPlan 1
--           ->  Hash Join  (cost=204.57..599.47 rows=16044 width=4) (actual time=1.018..7.857 rows=16044 loops=1)
--                 Hash Cond: (i.film_id = f_1.film_id)
--                 ->  Hash Join  (cost=128.07..480.67 rows=16044 width=2) (actual time=0.819..5.310 rows=16044 loops=1)
--                       Hash Cond: (rental.inventory_id = i.inventory_id)
--                       ->  Seq Scan on rental  (cost=0.00..310.44 rows=16044 width=4) (actual time=0.002..1.048 rows=16044 loops=1)
--                       ->  Hash  (cost=70.81..70.81 rows=4581 width=6) (actual time=0.812..0.813 rows=4581 loops=1)
--                             Buckets: 8192  Batches: 1  Memory Usage: 234kB
--                             ->  Seq Scan on inventory i  (cost=0.00..70.81 rows=4581 width=6) (actual time=0.002..0.340 rows=4581 loops=1)
--                 ->  Hash  (cost=64.00..64.00 rows=1000 width=4) (actual time=0.195..0.195 rows=1000 loops=1)
--                       Buckets: 1024  Batches: 1  Memory Usage: 44kB
--                       ->  Seq Scan on film f_1  (cost=0.00..64.00 rows=1000 width=4) (actual time=0.002..0.116 rows=1000 loops=1)
--   ->  Hash  (cost=20.54..20.54 rows=125 width=70) (actual time=0.299..0.300 rows=117 loops=1)
--         Buckets: 1024  Batches: 1  Memory Usage: 13kB
--         ->  Hash Join  (cost=1.22..20.54 rows=125 width=70) (actual time=0.039..0.278 rows=117 loops=1)
--               Hash Cond: (fc.category_id = c.category_id)
--               ->  Seq Scan on film_category fc  (cost=0.00..16.00 rows=1000 width=4) (actual time=0.008..0.092 rows=1000 loops=1)
--               ->  Hash  (cost=1.20..1.20 rows=2 width=72) (actual time=0.010..0.011 rows=2 loops=1)
--                     Buckets: 1024  Batches: 1  Memory Usage: 9kB
--                     ->  Seq Scan on category c  (cost=0.00..1.20 rows=2 width=72) (actual time=0.006..0.008 rows=2 loops=1)
-- "                          Filter: ((name)::text = ANY ('{Sci-Fi,Horror}'::text[]))"
--                           Rows Removed by Filter: 14
-- Planning Time: 1.079 ms
-- Execution Time: 10.587 ms


-- The query is already fast, any index I try to add do not influence the cost
-- This is there are already many indexes in the table
-- Bottleneck is in this join:
-- FROM film AS f
--          JOIN film_category fc on f.film_id = fc.film_id
--          JOIN category c on c.category_id = fc.category_id
-- as there are a lot of rows

-- DROP INDEX IF EXISTS a;
-- DROP INDEX IF EXISTS b;
-- CREATE INDEX a ON film (rating, film_id, title);
-- CREATE INDEX b ON category (category_id, name);


EXPLAIN ANALYSE
SELECT DISTINCT ON (c.city_id) c.city_id, c.city, amount
FROM address
         JOIN city c on c.city_id = address.city_id
         JOIN store s on address.address_id = s.address_id
         JOIN (SELECT store.store_id, sum(amount) as amount
               FROM store
                        JOIN inventory i on store.store_id = i.store_id
                        JOIN rental r on i.inventory_id = r.inventory_id
                        JOIN payment p on r.rental_id = p.rental_id
               GROUP BY store.store_id) AS stores_with_amount on stores_with_amount.store_id = s.store_id
ORDER BY c.city_id, amount;
-- Unique  (cost=1181.38..1181.39 rows=2 width=45) (actual time=13.785..13.794 rows=2 loops=1)
--   ->  Sort  (cost=1181.38..1181.39 rows=2 width=45) (actual time=13.784..13.789 rows=2 loops=1)
-- "        Sort Key: c.city_id, stores_with_amount.amount"
--         Sort Method: quicksort  Memory: 25kB
--         ->  Hash Join  (cost=1164.62..1181.37 rows=2 width=45) (actual time=13.697..13.783 rows=2 loops=1)
--               Hash Cond: (s.store_id = stores_with_amount.store_id)
--               ->  Nested Loop  (cost=1.32..18.06 rows=2 width=17) (actual time=0.020..0.103 rows=2 loops=1)
--                     ->  Hash Join  (cost=1.04..17.36 rows=2 width=6) (actual time=0.014..0.087 rows=2 loops=1)
--                           Hash Cond: (address.address_id = s.address_id)
--                           ->  Seq Scan on address  (cost=0.00..14.03 rows=603 width=6) (actual time=0.005..0.040 rows=603 loops=1)
--                           ->  Hash  (cost=1.02..1.02 rows=2 width=6) (actual time=0.005..0.006 rows=2 loops=1)
--                                 Buckets: 1024  Batches: 1  Memory Usage: 9kB
--                                 ->  Seq Scan on store s  (cost=0.00..1.02 rows=2 width=6) (actual time=0.003..0.003 rows=2 loops=1)
--                     ->  Index Scan using city_pkey on city c  (cost=0.28..0.35 rows=1 width=13) (actual time=0.006..0.006 rows=1 loops=2)
--                           Index Cond: (city_id = address.city_id)
--               ->  Hash  (cost=1163.27..1163.27 rows=2 width=36) (actual time=13.673..13.676 rows=2 loops=1)
--                     Buckets: 1024  Batches: 1  Memory Usage: 9kB
--                     ->  Subquery Scan on stores_with_amount  (cost=1163.23..1163.27 rows=2 width=36) (actual time=13.669..13.673 rows=2 loops=1)
--                           ->  HashAggregate  (cost=1163.23..1163.25 rows=2 width=36) (actual time=13.668..13.671 rows=2 loops=1)
--                                 Group Key: store.store_id
--                                 Batches: 1  Memory Usage: 24kB
--                                 ->  Hash Join  (cost=640.11..1090.25 rows=14596 width=10) (actual time=3.516..11.485 rows=14596 loops=1)
--                                       Hash Cond: (i.store_id = store.store_id)
--                                       ->  Hash Join  (cost=639.06..969.70 rows=14596 width=8) (actual time=3.512..9.746 rows=14596 loops=1)
--                                             Hash Cond: (r.inventory_id = i.inventory_id)
--                                             ->  Hash Join  (cost=510.99..803.28 rows=14596 width=10) (actual time=2.633..6.516 rows=14596 loops=1)
--                                                   Hash Cond: (p.rental_id = r.rental_id)
--                                                   ->  Seq Scan on payment p  (cost=0.00..253.96 rows=14596 width=10) (actual time=0.002..0.913 rows=14596 loops=1)
--                                                   ->  Hash  (cost=310.44..310.44 rows=16044 width=8) (actual time=2.608..2.609 rows=16044 loops=1)
--                                                         Buckets: 16384  Batches: 1  Memory Usage: 755kB
--                                                         ->  Seq Scan on rental r  (cost=0.00..310.44 rows=16044 width=8) (actual time=0.002..1.185 rows=16044 loops=1)
--                                             ->  Hash  (cost=70.81..70.81 rows=4581 width=6) (actual time=0.875..0.875 rows=4581 loops=1)
--                                                   Buckets: 8192  Batches: 1  Memory Usage: 243kB
--                                                   ->  Seq Scan on inventory i  (cost=0.00..70.81 rows=4581 width=6) (actual time=0.003..0.382 rows=4581 loops=1)
--                                       ->  Hash  (cost=1.02..1.02 rows=2 width=4) (actual time=0.002..0.002 rows=2 loops=1)
--                                             Buckets: 1024  Batches: 1  Memory Usage: 9kB
--                                             ->  Seq Scan on store  (cost=0.00..1.02 rows=2 width=4) (actual time=0.001..0.001 rows=2 loops=1)
-- Planning Time: 0.589 ms
-- Execution Time: 13.852 ms

-- The main bottleneck is joins in stores_with_amount sub queries.
-- I think I cannot optimize this using indexes

