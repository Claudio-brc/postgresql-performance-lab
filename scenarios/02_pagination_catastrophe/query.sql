-- 1. Baseline Query

SELECT
    p.id,
    p.creation_date,
    p.score,
    p.view_count,
    u.display_name
FROM posts p
JOIN users u
    ON u.id = p.owner_user_id
WHERE p.creation_date >= DATE '2018-01-01'
ORDER BY p.creation_date DESC
LIMIT 100;


-- 2. Index Creation

CREATE INDEX idx_posts_creation_date
ON posts (creation_date DESC);


-- 3. Deep OFFSET Pagination

SELECT
    p.id,
    p.creation_date,
    p.score,
    p.view_count,
    u.display_name
FROM posts p
JOIN users u
    ON u.id = p.owner_user_id
WHERE p.creation_date >= DATE '2018-01-01'
ORDER BY p.creation_date DESC
LIMIT 100 OFFSET 50000;


-- 4. Keyset Pagination

SELECT
    p.id,
    p.creation_date,
    p.score,
    p.view_count,
    u.display_name
FROM posts p
JOIN users u
    ON u.id = p.owner_user_id
WHERE p.creation_date >= DATE '2018-01-01'
  AND p.creation_date < TIMESTAMP '2024-03-27 10:31:32.763'
ORDER BY p.creation_date DESC
LIMIT 100;

-- Production note:
-- For deterministic pagination when multiple rows share the same
-- creation_date, a composite (creation_date, id) cursor can be used.
