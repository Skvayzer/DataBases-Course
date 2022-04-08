DROP INDEX IF EXISTS name_len;
DROP INDEX IF EXISTS name_hash;
DROP INDEX IF EXISTS name_btree;

EXPLAIN SELECT * FROM customer WHERE length(name) < 11 AND length(name) > 9;
-- Seq Scan on customer  (cost=0.00..5033.00 rows=500 width=211)
--   Filter: ((length(name) < 11) AND (length(name) > 9))

EXPLAIN SELECT * FROM customer WHERE name = 'Dylan Smith';
-- Seq Scan on customer  (cost=0.00..4283.00 rows=2 width=211)
--   Filter: (name = 'Dylan Smith'::text)

EXPLAIN SELECT * FROM customer WHERE name < 'Hannah Wang';
-- Seq Scan on customer  (cost=0.00..4283.00 rows=35057 width=211)
--   Filter: (name < 'Hannah Wang'::text)

-------------------------------------------------------
-- Index using b-tree on name length
CREATE INDEX name_len ON customer (length(name));
-- Index using hash
CREATE INDEX name_hash ON customer USING HASH (name);
-- Index using b-tree on name
CREATE INDEX name_btree ON customer (name);
-------------------------------------------------------

EXPLAIN SELECT * FROM customer WHERE length(name) < 11 AND length(name) > 9;
-- Bitmap Heap Scan on customer  (cost=9.42..1326.48 rows=500 width=211)
--   Recheck Cond: ((length(name) < 11) AND (length(name) > 9))
--   ->  Bitmap Index Scan on name_len  (cost=0.00..9.29 rows=500 width=0)
--         Index Cond: ((length(name) < 11) AND (length(name) > 9))

EXPLAIN SELECT * FROM customer WHERE name = 'Dylan Smith';
-- Bitmap Heap Scan on customer  (cost=4.02..11.89 rows=2 width=211)
--   Recheck Cond: (name = 'Dylan Smith'::text)
--   ->  Bitmap Index Scan on name_hash  (cost=0.00..4.01 rows=2 width=0)
--         Index Cond: (name = 'Dylan Smith'::text)

EXPLAIN SELECT * FROM customer WHERE name < 'Hannah Wang';
-- Bitmap Heap Scan on customer  (cost=740.11..4211.32 rows=35057 width=211)
--   Recheck Cond: (name < 'Hannah Wang'::text)
--   ->  Bitmap Index Scan on name_btree  (cost=0.00..731.35 rows=35057 width=0)
--         Index Cond: (name < 'Hannah Wang'::text)


-- For all queries cost became much smaller because of indexes