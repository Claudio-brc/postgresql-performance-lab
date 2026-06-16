--------------------------------------------------
-- Cardinality Reference
--------------------------------------------------

SELECT COUNT(*)
FROM users
WHERE reputation > 50000;

SELECT COUNT(*)
FROM users
WHERE reputation > 1000;

--------------------------------------------------
-- Query 1
-- Very Selective Predicate
--------------------------------------------------

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

--------------------------------------------------
-- Query 2
-- Less Selective Predicate
--------------------------------------------------

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