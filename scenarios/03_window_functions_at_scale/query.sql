WITH ranked_posts AS (
    SELECT
        DATE_TRUNC('year', p.creation_date) AS post_year,
        ROW_NUMBER() OVER (
            PARTITION BY DATE_TRUNC('year', p.creation_date)
            ORDER BY p.score DESC
        ) AS yearly_rank,
        p.id,
        p.owner_user_id,
        p.score,
        p.view_count,
        p.creation_date
    FROM posts p
    WHERE p.creation_date >= DATE '2020-01-01'
)
SELECT
    post_year,
    yearly_rank,
    id AS post_id,
    owner_user_id,
    score,
    view_count,
    creation_date
FROM ranked_posts
WHERE yearly_rank <= 10
ORDER BY post_year DESC, yearly_rank;