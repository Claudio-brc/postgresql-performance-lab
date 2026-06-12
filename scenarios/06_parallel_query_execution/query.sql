-- Environment

SHOW max_parallel_workers_per_gather;
SHOW max_parallel_workers;
SHOW max_worker_processes;
SHOW min_parallel_table_scan_size;
SHOW parallel_setup_cost;
SHOW parallel_tuple_cost;

--------------------------------------------------
-- Query 1
-- Global Aggregate
--------------------------------------------------

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    SUM(view_count)
FROM posts;

--------------------------------------------------
-- Query 2
-- Disable Parallelism
--------------------------------------------------

SET max_parallel_workers_per_gather = 0;

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    SUM(view_count)
FROM posts;

--------------------------------------------------
-- Restore
--------------------------------------------------

SET max_parallel_workers_per_gather = 2;

--------------------------------------------------
-- Query 3
-- High Cardinality GROUP BY
--------------------------------------------------

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    owner_user_id,
    SUM(view_count)
FROM posts
GROUP BY owner_user_id;

--------------------------------------------------
-- Query 4
-- Low Cardinality GROUP BY
--------------------------------------------------

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    post_type_id,
    COUNT(*)
FROM posts
GROUP BY post_type_id;

--------------------------------------------------
-- Query 5
-- Filter + Aggregate
--------------------------------------------------

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    COUNT(*)
FROM posts
WHERE view_count > 0;