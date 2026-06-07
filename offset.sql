SELECT
    MIN(creation_date) AS min_date,
    MAX(creation_date) AS max_date,
    COUNT(*) AS total_posts
FROM posts;

SELECT
    indexname
FROM pg_indexes
WHERE tablename = 'posts';

EXPLAIN (ANALYZE, BUFFERS)
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


CREATE INDEX idx_posts_creation_date
ON posts (creation_date DESC);

ANALYZE posts;

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    id,
    creation_date
FROM posts
WHERE creation_date >= DATE '2018-01-01'
ORDER BY creation_date DESC
LIMIT 100 OFFSET 1000;


EXPLAIN (ANALYZE, BUFFERS)
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