SELECT
    indexname,
    indexdef
FROM pg_indexes
WHERE tablename = 'posts';

EXPLAIN (ANALYZE, BUFFERS)
SELECT creation_date
FROM posts
WHERE creation_date >= '2024-01-01';

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    creation_date,
    title
FROM posts
WHERE creation_date >= '2024-01-01';

CREATE INDEX idx_posts_creation_date_title
ON posts (
    creation_date,
    title
);

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    creation_date,
    title
FROM posts
WHERE creation_date >= '2024-01-01';


SELECT
    indexname,
    indexdef
FROM pg_indexes
WHERE tablename = 'posts'
ORDER BY indexname;

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    creation_date,
    title
FROM posts
WHERE creation_date >= '2024-03-25';


SELECT
    pg_size_pretty(pg_relation_size('idx_posts_creation_date')) AS old_index,
    pg_size_pretty(pg_relation_size('idx_posts_creation_date_title')) AS covering_index;

DROP INDEX idx_posts_creation_date_title;

CREATE INDEX idx_posts_creation_date_covering
ON posts (creation_date)
INCLUDE (title);

ANALYZE posts;

SELECT
    creation_date,
    title
FROM posts
WHERE creation_date >= '2024-03-25';
	