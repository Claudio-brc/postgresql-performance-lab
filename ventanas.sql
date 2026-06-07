| year | rank | post_id | score |
| ---- | ---- | ------- | ----- |
| 2024 | 1    | 123     | 542   |
| 2024 | 2    | 456     | 521   |
| ...  | ...  | ...     | ...   |
| 2023 | 1    | 789     | 811   |
| 2023 | 2    | 321     | 770   |



select  DATE_TRUNC('year', p.creation_date) AS post_year, 
    row_number() OVER (PARTITION BY DATE_TRUNC('year', p.creation_date) 
                 ORDER BY p.score DESC) AS yearly_rank,
        p.id as post_id,
		p.score 

from posts p
where p.creation_date
>= DATE '2020-01-01'
order by post_year DESC, yearly_rank

------------------------------------------------------------------------va
explain (analyze , buffers)
WITH ranked_posts AS (
    SELECT
        DATE_TRUNC('year', p.creation_date) AS post_year,
        ROW_NUMBER() OVER (
            PARTITION BY DATE_TRUNC('year', p.creation_date)
            ORDER BY p.score DESC
        ) AS yearly_rank,
        p.id AS post_id,
        p.score
    FROM posts p
    WHERE p.creation_date >= DATE '2020-01-01'
)
SELECT *
FROM ranked_posts
WHERE yearly_rank <= 10
ORDER BY post_year DESC, yearly_rank;
------------------------------------------------------------------------------


limit 50

SELECT 
    DATE_TRUNC('month', r.rental_date) AS rental_month,
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(*) AS total_rentals,
    RANK() OVER (PARTITION BY DATE_TRUNC('month', r.rental_date) 
                 ORDER BY COUNT(*) DESC) AS monthly_rank
FROM rental r
JOIN customer c ON c.customer_id = r.customer_id
GROUP BY DATE_TRUNC('month', r.rental_date), c.customer_id, c.first_name, c.last_name
ORDER BY rental_month DESC, monthly_rank;