# Execution Plans

---

## Query A - reputation > 1000

```sql
SELECT ...
WHERE u.reputation > 1000
ORDER BY p.view_count DESC
LIMIT 20;
```

```text
"Limit  (cost=6938.74..6941.04 rows=20 width=41) (actual time=975.516..990.641 rows=20 loops=1)"
"  Buffers: shared hit=33942 read=6211"
"  ->  Gather Merge  (cost=6938.74..6944.72 rows=52 width=41) (actual time=975.512..990.631 rows=20 loops=1)"
"        Workers Planned: 1"
"        Workers Launched: 1"
"        Buffers: shared hit=33942 read=6211"
"        ->  Sort  (cost=5938.73..5938.86 rows=52 width=41) (actual time=956.660..956.666 rows=20 loops=2)"
"              Sort Key: p.view_count DESC"
"              Sort Method: top-N heapsort  Memory: 25kB"
"              Buffers: shared hit=33942 read=6211"
"              Worker 0:  Sort Method: top-N heapsort  Memory: 27kB"
"              ->  Nested Loop  (cost=0.42..5937.34 rows=52 width=41) (actual time=1.529..939.945 rows=30793 loops=2)"
"                    Buffers: shared hit=33935 read=6211"
"                    ->  Parallel Seq Scan on users u  (cost=0.00..4272.57 rows=55 width=12) (actual time=0.847..180.092 rows=45 loops=2)"
"                          Filter: (reputation > 10000)"
"                          Rows Removed by Filter: 124026"
"                          Buffers: shared hit=32 read=2416"
"                    ->  Index Scan using idx_posts_owner_user_id on posts p  (cost=0.42..30.15 rows=12 width=45) (actual time=0.452..16.513 rows=684 loops=90)"
"                          Index Cond: (owner_user_id = u.id)"
"                          Buffers: shared hit=33903 read=3795"
"Planning:"
"  Buffers: shared hit=89 read=15 dirtied=4"
"Planning Time: 16.259 ms"
"Execution Time: 990.751 ms"
```

---

## Query B - reputation > 10000

```sql
SELECT ...
WHERE u.reputation > 10000
ORDER BY p.view_count DESC
LIMIT 20;
```

```text
"Limit  (cost=10320.91..10323.24 rows=20 width=41) (actual time=497.224..525.892 rows=20 loops=1)"
"  Buffers: shared hit=6378 read=30"
"  ->  Gather Merge  (cost=10320.91..10403.05 rows=704 width=41) (actual time=497.221..525.882 rows=20 loops=1)"
"        Workers Planned: 2"
"        Workers Launched: 2"
"        Buffers: shared hit=6378 read=30"
"        ->  Sort  (cost=9320.88..9321.76 rows=352 width=41) (actual time=461.510..461.522 rows=20 loops=3)"
"              Sort Key: p.view_count DESC"
"              Sort Method: top-N heapsort  Memory: 26kB"
"              Buffers: shared hit=6378 read=30"
"              Worker 0:  Sort Method: top-N heapsort  Memory: 26kB"
"              Worker 1:  Sort Method: top-N heapsort  Memory: 26kB"
"              ->  Parallel Hash Join  (cost=4279.08..9311.52 rows=352 width=41) (actual time=180.243..442.841 rows=35547 loops=3)"
"                    Hash Cond: (p.owner_user_id = u.id)"
"                    Buffers: shared hit=6266 read=30"
"                    ->  Parallel Seq Scan on posts p  (cost=0.00..4766.21 rows=101421 width=45) (actual time=0.029..127.495 rows=81137 loops=3)"
"                          Buffers: shared hit=3722 read=30"
"                    ->  Parallel Hash  (cost=4272.57..4272.57 rows=521 width=12) (actual time=177.026..177.028 rows=283 loops=3)"
"                          Buckets: 1024  Batches: 1  Memory Usage: 104kB"
"                          Buffers: shared hit=2448"
"                          ->  Parallel Seq Scan on users u  (cost=0.00..4272.57 rows=521 width=12) (actual time=0.490..175.916 rows=283 loops=3)"
"                                Filter: (reputation > 1000)"
"                                Rows Removed by Filter: 82431"
"                                Buffers: shared hit=2448"
"Planning:"
"  Buffers: shared hit=16"
"Planning Time: 16.384 ms"
"Execution Time: 527.182 ms"
```

---

## Query C - reputation > 50000

```sql
SELECT ...
WHERE u.reputation > 50000
ORDER BY p.view_count DESC
LIMIT 20;
```

```text
"Limit  (cost=6263.46..6265.76 rows=20 width=41) (actual time=244.446..258.720 rows=20 loops=1)"
"  Buffers: shared hit=16430"
"  ->  Gather Merge  (cost=6263.46..6266.91 rows=30 width=41) (actual time=244.444..258.712 rows=20 loops=1)"
"        Workers Planned: 1"
"        Workers Launched: 1"
"        Buffers: shared hit=16430"
"        ->  Sort  (cost=5263.45..5263.53 rows=30 width=41) (actual time=227.132..227.138 rows=20 loops=2)"
"              Sort Key: p.view_count DESC"
"              Sort Method: top-N heapsort  Memory: 25kB"
"              Buffers: shared hit=16430"
"              Worker 0:  Sort Method: top-N heapsort  Memory: 25kB"
"              ->  Nested Loop  (cost=0.42..5262.72 rows=30 width=41) (actual time=0.553..219.587 rows=13614 loops=2)"
"                    Buffers: shared hit=16423"
"                    ->  Parallel Seq Scan on users u  (cost=0.00..4272.57 rows=31 width=12) (actual time=0.112..95.086 rows=8 loops=2)"
"                          Filter: (reputation > 50000)"
"                          Rows Removed by Filter: 124063"
"                          Buffers: shared hit=2448"
"                    ->  Index Scan using idx_posts_owner_user_id on posts p  (cost=0.42..31.82 rows=12 width=45) (actual time=0.254..15.613 rows=1815 loops=15)"
"                          Index Cond: (owner_user_id = u.id)"
"                          Buffers: shared hit=13975"
"Planning:"
"  Buffers: shared hit=16"
"Planning Time: 0.726 ms"
"Execution Time: 258.809 ms"
```