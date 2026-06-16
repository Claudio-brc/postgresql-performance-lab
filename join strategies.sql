EXPLAIN (ANALYZE, BUFFERS)
SELECT
    p.id,
    p.title,
    p.view_count,
    u.reputation
FROM posts p
JOIN users u
    ON u.id = p.owner_user_id
WHERE u.reputation > 50000
ORDER BY p.view_count DESC
LIMIT 20;

"Limit  (cost=1377.80..1377.85 rows=20 width=40) (actual time=884.348..884.355 rows=20 loops=1)"
"  Buffers: shared hit=13957 read=36"
"  ->  Sort  (cost=1377.80..1377.89 rows=35 width=40) (actual time=884.346..884.349 rows=20 loops=1)"
"        Sort Key: p.view_count DESC"
"        Sort Method: top-N heapsort  Memory: 25kB"
"        Buffers: shared hit=13957 read=36"
"        ->  Nested Loop  (cost=0.56..1376.90 rows=35 width=40) (actual time=3.575..870.611 rows=27228 loops=1)"
"              Buffers: shared hit=13954 read=36"
"              ->  Index Scan using idx_users_reputation_gt_10000 on users u  (cost=0.14..156.78 rows=37 width=12) (actual time=1.754..6.782 rows=15 loops=1)"
"                    Index Cond: (reputation > 50000)"
"                    Buffers: shared hit=16"
"              ->  Index Scan using idx_posts_owner_user_id on posts p  (cost=0.42..32.86 rows=12 width=44) (actual time=0.949..56.654 rows=1815 loops=15)"
"                    Index Cond: (owner_user_id = u.id)"
"                    Buffers: shared hit=13938 read=36"
"Planning:"
"  Buffers: shared hit=267 read=10 dirtied=1"
"Planning Time: 39.653 ms"
"Execution Time: 884.438 ms"

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    p.id,
    p.title,
    p.view_count,
    u.reputation
FROM posts p
JOIN users u
    ON u.id = p.owner_user_id
WHERE u.reputation > 1000
ORDER BY p.view_count DESC
LIMIT 20;


"Limit  (cost=10320.22..10322.55 rows=20 width=40) (actual time=284.383..290.117 rows=20 loops=1)"
"  Buffers: shared hit=6408"
"  ->  Gather Merge  (cost=10320.22..10398.86 rows=674 width=40) (actual time=284.382..290.111 rows=20 loops=1)"
"        Workers Planned: 2"
"        Workers Launched: 2"
"        Buffers: shared hit=6408"
"        ->  Sort  (cost=9320.20..9321.04 rows=337 width=40) (actual time=252.546..252.550 rows=20 loops=3)"
"              Sort Key: p.view_count DESC"
"              Sort Method: top-N heapsort  Memory: 26kB"
"              Buffers: shared hit=6408"
"              Worker 0:  Sort Method: top-N heapsort  Memory: 26kB"
"              Worker 1:  Sort Method: top-N heapsort  Memory: 26kB"
"              ->  Parallel Hash Join  (cost=4278.79..9311.23 rows=337 width=40) (actual time=177.480..245.121 rows=35547 loops=3)"
"                    Hash Cond: (p.owner_user_id = u.id)"
"                    Buffers: shared hit=6296"
"                    ->  Parallel Seq Scan on posts p  (cost=0.00..4766.21 rows=101421 width=44) (actual time=0.675..23.018 rows=81137 loops=3)"
"                          Buffers: shared hit=3752"
"                    ->  Parallel Hash  (cost=4272.57..4272.57 rows=498 width=12) (actual time=175.490..175.491 rows=283 loops=3)"
"                          Buckets: 1024  Batches: 1  Memory Usage: 104kB"
"                          Buffers: shared hit=2448"
"                          ->  Parallel Seq Scan on users u  (cost=0.00..4272.57 rows=498 width=12) (actual time=0.330..174.532 rows=283 loops=3)"
"                                Filter: (reputation > 1000)"
"                                Rows Removed by Filter: 82431"
"                                Buffers: shared hit=2448"
"Planning:"
"  Buffers: shared hit=16"
"Planning Time: 0.632 ms"
"Execution Time: 290.218 ms"

