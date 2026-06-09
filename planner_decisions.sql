ANALYZE users;
ANALYZE posts;


EXPLAIN (ANALYZE, BUFFERS)
SELECT
    p.id,
    p.title,
    p.view_count,
    u.reputation
FROM posts p
JOIN users u
    ON u.id = p.owner_user_id
WHERE u.reputation > 10000
ORDER BY p.view_count DESC
LIMIT 20;

SELECT COUNT(*)
FROM users
WHERE reputation > 10000;


SELECT AVG(post_count)
FROM (
    SELECT
        owner_user_id,
        COUNT(*) AS post_count
    FROM posts
    GROUP BY owner_user_id
) x;

SELECT AVG(post_count)
FROM (
    SELECT
        p.owner_user_id,
        COUNT(*) AS post_count
    FROM posts p
    JOIN users u
        ON u.id = p.owner_user_id
    WHERE u.reputation > 10000
    GROUP BY p.owner_user_id
) x;

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    u.id,
    u.display_name,
    u.reputation,
    COUNT(*) AS posts
FROM users u
JOIN posts p
    ON p.owner_user_id = u.id
WHERE u.reputation > 10000
GROUP BY u.id, u.display_name, u.reputation
ORDER BY posts DESC
LIMIT 20;

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



