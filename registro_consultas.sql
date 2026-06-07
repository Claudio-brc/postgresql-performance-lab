COPY posts (
    id,
    post_type_id,
    creation_date,
    score,
    view_count,
    owner_user_id,
    title,
    tags,
    answer_count,
    comment_count,
    favorite_count
)
FROM '/datasets/stackexchange/posts.csv'
DELIMITER ','
CSV HEADER;


SELECT COUNT(*)
FROM posts;

COPY posts (
    id,
    post_type_id,
    creation_date,
    score,
    view_count,
    owner_user_id,
    title,
    tags,
    answer_count,
    comment_count,
    favorite_count
)
FROM '/datasets/stackexchange/posts.csv'
DELIMITER ','
CSV HEADER;

TRUNCATE TABLE posts;

EXPLAIN (ANALYZE, BUFFERS)
SELECT owner_user_id, COUNT(*)
FROM posts
GROUP BY owner_user_id
ORDER BY COUNT(*) DESC
LIMIT 20;


CREATE INDEX idx_posts_owner_user_id
ON posts(owner_user_id);

COPY users (
    id,
    display_name,
    reputation,
    creation_date,
    views,
    up_votes,
    down_votes
)
FROM '/datasets/stackexchange/users.csv'
DELIMITER ','
CSV HEADER;


SELECT COUNT(*)
FROM users;



