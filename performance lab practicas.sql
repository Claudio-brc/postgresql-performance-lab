Pregunta de negocio


SELECT 
    column_name,
    data_type,
    is_nullable,
    character_maximum_length
FROM information_schema.columns
WHERE table_name = 'posts'

ORDER BY ordinal_position;


¿Qué usuarios tienen el mejor promedio de score entre aquellos que realizaron al menos 20 publicaciones?


users
posts
JOIN
GROUP BY
HAVING
AVG()
ORDER BY
LIMIT

Resultado esperado
user_id
display_name
total_posts
avg_score

WITH
	TOP_USERS AS (
		SELECT
			OWNER_USER_ID,
			COUNT(*) AS TOTAL_POSTS,
			AVG(SCORE) AS AVG_SCORE,
			SUM(COALESCE(VIEW_COUNT, 0)) AS TOTAL_VIEWS
		FROM
			POSTS
		GROUP BY
			OWNER_USER_ID
		HAVING
			COUNT(*) >= 5
	)
SELECT
	U.ID,
	U.DISPLAY_NAME,
	T.TOTAL_POSTS,
	T.AVG_SCORE,
	T.TOTAL_VIEWS
FROM
	TOP_USERS T
	JOIN USERS U ON U.ID = T.OWNER_USER_ID
ORDER BY
	T.TOTAL_VIEWS DESC
LIMIT
	5;

	---before

EXPLAIN (ANALYZE, BUFFERS)
SELECT u.display_name, count(p.id) as total_posts, avg(p.score) as avg_score FROM
users u 
inner join posts p 
  on p.owner_user_id = u.id
group by u.id 
having  count(p.id) > 20
order by avg_score desc
LIMIT 5

   ---after 

EXPLAIN (ANALYZE, BUFFERS)

WITH
	TOP_USERS AS (
		SELECT
			OWNER_USER_ID,
			COUNT(*) AS TOTAL_POSTS,
			AVG(SCORE) AS AVG_SCORE		
			
		FROM
			POSTS
		GROUP BY
			OWNER_USER_ID
		HAVING
			COUNT(*) >= 20	
			order by avg_score desc
		LIMIT 5 
	
	)
SELECT u.display_name, p.OWNER_USER_ID as total_posts, p.AVG_SCORE as avg_score FROM
users u 
inner join top_users p 
  on p.owner_user_id = u.id

---  ¿Cuáles son los 100 posts más vistos publicados desde 2020?
EXPLAIN (ANALYZE, BUFFERS)
select p.id, p.view_count, p.creation_date
from posts p
where p.creation_date >= '01/01/2020'
  and p.view_count is not null
order by p.view_count desc
limit 100
  
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    id,
    owner_user_id,
    creation_date
FROM posts
ORDER BY creation_date DESC
LIMIT 100 OFFSET 90000;
 






