--------------------------------------------------
-- Distribution Analysis
--------------------------------------------------

SELECT COUNT(*)
FROM users;

SELECT COUNT(*)
FROM users
WHERE reputation > 1000;

SELECT COUNT(*)
FROM users
WHERE reputation > 10000;

SELECT COUNT(*)
FROM users
WHERE reputation > 50000;

--------------------------------------------------
-- Baseline
--------------------------------------------------

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM users
WHERE reputation > 10000;

--------------------------------------------------
-- Full Index
--------------------------------------------------

CREATE INDEX idx_users_reputation
ON users(reputation);

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM users
WHERE reputation > 10000;

SELECT
    pg_size_pretty(
        pg_relation_size('idx_users_reputation')
    );

--------------------------------------------------
-- Partial Index
--------------------------------------------------

CREATE INDEX idx_users_reputation_gt_10000
ON users(reputation)
WHERE reputation > 10000;

SELECT
    pg_size_pretty(
        pg_relation_size('idx_users_reputation_gt_10000')
    );

--------------------------------------------------
-- Remove Full Index
--------------------------------------------------

DROP INDEX idx_users_reputation;

ANALYZE users;

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM users
WHERE reputation > 10000;