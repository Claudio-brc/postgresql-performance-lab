SHOW max_parallel_workers_per_gather; 2
SHOW max_parallel_workers; 8
SHOW max_worker_processes; 8
SHOW min_parallel_table_scan_size; 8mb
SHOW parallel_setup_cost; 1000
SHOW parallel_tuple_cost; 0.1

SELECT
    relname,
    pg_size_pretty(pg_total_relation_size(relid))
FROM pg_catalog.pg_statio_user_tables
ORDER BY pg_total_relation_size(relid) DESC;


EXPLAIN (ANALYZE, BUFFERS)
SELECT
    SUM(view_count)
FROM posts;

SET max_parallel_workers_per_gather = 0;
SET max_parallel_workers_per_gather = 2;

analyze posts;

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    owner_user_id,
    SUM(view_count)
FROM posts
GROUP BY owner_user_id;

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    COUNT(*)
FROM posts
WHERE view_count > 0;

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    post_type_id,
    COUNT(*)
FROM posts
GROUP BY post_type_id;