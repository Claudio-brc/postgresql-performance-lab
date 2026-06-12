SELECT
    MIN(creation_date),
    MAX(creation_date)
FROM posts;



SELECT
    EXTRACT(YEAR FROM creation_date) AS year,
    COUNT(*) AS posts
FROM posts
GROUP BY year
ORDER BY year;

SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'posts'
ORDER BY ordinal_position;

DROP TABLE IF EXISTS posts_partitioned CASCADE;

CREATE TABLE posts_partitioned (
    id BIGINT,
    creation_date TIMESTAMP NOT NULL,
    title TEXT,
    view_count INTEGER
)
PARTITION BY RANGE (creation_date);


CREATE TABLE posts_2020 PARTITION OF posts_partitioned
FOR VALUES FROM ('2020-01-01') TO ('2021-01-01');

CREATE TABLE posts_2021 PARTITION OF posts_partitioned
FOR VALUES FROM ('2021-01-01') TO ('2022-01-01');

CREATE TABLE posts_2022 PARTITION OF posts_partitioned
FOR VALUES FROM ('2022-01-01') TO ('2023-01-01');

CREATE TABLE posts_2023 PARTITION OF posts_partitioned
FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

CREATE TABLE posts_2024 PARTITION OF posts_partitioned
FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');


INSERT INTO posts_partitioned (
    id,
    creation_date,
    title,
    view_count
)
SELECT
    id,
    creation_date,
    title,
    view_count
FROM posts
WHERE creation_date >= '2020-01-01';

SELECT COUNT(*) FROM posts_2020;
SELECT COUNT(*) FROM posts_2021;
SELECT COUNT(*) FROM posts_2022;
SELECT COUNT(*) FROM posts_2023;
SELECT COUNT(*) FROM posts_2024;


EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM posts_partitioned
WHERE creation_date >= '2023-01-01';

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM posts_partitioned
WHERE creation_date >= '2024-01-01';

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM posts
WHERE creation_date >= '2024-01-01';