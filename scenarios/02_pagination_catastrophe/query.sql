----baseline----

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


----indexed version----

CREATE INDEX idx_posts_creation_date
ON posts (creation_date DESC);


----keyset version----

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