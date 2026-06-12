SELECT COUNT(*)
FROM users;
--248141


SELECT COUNT(*)
FROM users
WHERE reputation > 1000;
--848

SELECT COUNT(*)
FROM users
WHERE reputation > 10000;
90

SELECT COUNT(*)
FROM users
WHERE reputation > 50000;
--15

SELECT
    indexname,
    indexdef
FROM pg_indexes
WHERE tablename = 'users';

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM users
WHERE reputation > 10000;

/*
"Gather  (cost=1000.00..5281.87 rows=93 width=42) (actual time=4.096..75.555 rows=90 loops=1)"
"  Workers Planned: 1"
"  Workers Launched: 1"
"  Buffers: shared hit=2448"
"  ->  Parallel Seq Scan on users  (cost=0.00..4272.57 rows=55 width=42) (actual time=0.408..53.455 rows=45 loops=2)"
"        Filter: (reputation > 10000)"
"        Rows Removed by Filter: 124026"
"        Buffers: shared hit=2448"
"Planning:"
"  Buffers: shared hit=45 read=1 dirtied=2"
"Planning Time: 7.826 ms"
"Execution Time: 75.631 ms"
*/

CREATE INDEX idx_users_reputation
ON users(reputation);


EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM users
WHERE reputation > 10000;

/*
"Bitmap Heap Scan on users  (cost=5.14..320.80 rows=93 width=42) (actual time=0.083..0.669 rows=90 loops=1)"
"  Recheck Cond: (reputation > 10000)"
"  Heap Blocks: exact=71"
"  Buffers: shared hit=74"
"  ->  Bitmap Index Scan on idx_users_reputation  (cost=0.00..5.12 rows=93 width=0) (actual time=0.017..0.018 rows=90 loops=1)"
"        Index Cond: (reputation > 10000)"
"        Buffers: shared hit=3"
"Planning:"
"  Buffers: shared hit=17 read=4"
"Planning Time: 14.884 ms"
"Execution Time: 0.716 ms"
*/


SELECT
    pg_size_pretty(
        pg_relation_size('idx_users_reputation')
    );
--1744 kB

CREATE INDEX idx_users_reputation_gt_10000
ON users(reputation)
WHERE reputation > 10000;

SELECT
    pg_size_pretty(
        pg_relation_size('idx_users_reputation_gt_10000')
    );

--16kb
	