EXPLAIN (ANALYZE, BUFFERS)
SELECT
    u.id,
    u.display_name,
    COUNT(p.id) AS posts_count,
    SUM(COALESCE(p.view_count,0)) AS total_views,
    AVG(p.score) AS avg_score
FROM users u
JOIN posts p
    ON p.owner_user_id = u.id
GROUP BY
    u.id,
    u.display_name
ORDER BY total_views DESC
LIMIT 50;

CREATE MATERIALIZED VIEW mv_user_influence AS
SELECT
    u.id,
    u.display_name,
    COUNT(p.id) AS posts_count,
    SUM(p.view_count) AS total_views,
    AVG(p.score) AS avg_score
FROM users u
JOIN posts p
    ON p.owner_user_id = u.id
GROUP BY
    u.id,
    u.display_name;

CREATE INDEX idx_mv_user_influence_views
ON mv_user_influence(total_views DESC);	


SELECT COUNT(*)
FROM mv_user_influence;

SELECT *
FROM mv_user_influence
ORDER BY total_views DESC
LIMIT 50;

SELECT COUNT(*)
FROM mv_user_influence
WHERE total_views IS NULL;

SELECT COUNT(*)
FROM posts
WHERE view_count IS NULL;


DROP MATERIALIZED VIEW IF EXISTS mv_user_influence;

CREATE MATERIALIZED VIEW mv_user_influence AS
SELECT
    u.id,
    u.display_name,
    COUNT(p.id) AS posts_count,
    SUM(COALESCE(p.view_count, 0)) AS total_views,
    AVG(p.score) AS avg_score
FROM users u
JOIN posts p
    ON p.owner_user_id = u.id
GROUP BY
    u.id,
    u.display_name;

CREATE INDEX idx_mv_user_influence_views
ON mv_user_influence(total_views DESC);	


EXPLAIN (ANALYZE, BUFFERS)
SELECT
    id,
    display_name,
    posts_count,
    total_views,
    avg_score
FROM mv_user_influence
ORDER BY total_views DESC
LIMIT 50;

EXPLAIN (ANALYZE, BUFFERS)
REFRESH MATERIALIZED VIEW mv_user_influence;