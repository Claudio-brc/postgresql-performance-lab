-- Run inside the PostgreSQL container after `npm run convert:dataset`.
-- The compose file mounts the repository scripts at /scripts and datasets at
-- /datasets, so these are server-side COPY paths.

BEGIN;

TRUNCATE TABLE comments, votes, posts, users;

COPY users (
    id, display_name, reputation, creation_date, views, up_votes, down_votes
)
FROM '/datasets/stackexchange/users.csv'
WITH (FORMAT csv, HEADER true);

COPY posts (
    id, post_type_id, creation_date, score, view_count, owner_user_id,
    title, tags, answer_count, comment_count, favorite_count
)
FROM '/datasets/stackexchange/posts.csv'
WITH (FORMAT csv, HEADER true);

ANALYZE users;
ANALYZE posts;

COMMIT;

SELECT 'users' AS relation, count(*) AS rows FROM users
UNION ALL
SELECT 'posts', count(*) FROM posts;
