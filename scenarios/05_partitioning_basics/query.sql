-- Create partitioned table

DROP TABLE IF EXISTS posts_partitioned CASCADE;

CREATE TABLE posts_partitioned (
    id BIGINT,
    creation_date TIMESTAMP NOT NULL,
    title TEXT,
    view_count INTEGER
)
PARTITION BY RANGE (creation_date);

-- Partitions

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

-- Load data

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

-- Query 1

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM posts_partitioned
WHERE creation_date >= '2023-01-01';

-- Query 2

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM posts_partitioned
WHERE creation_date >= '2024-01-01';

-- Comparison

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM posts
WHERE creation_date >= '2024-01-01';