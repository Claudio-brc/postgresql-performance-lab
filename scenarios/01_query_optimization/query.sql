-- Original

EXPLAIN (ANALYZE, BUFFERS)
SELECT u.id,
       u.display_name,
       COUNT(p.id) AS total_posts,
       AVG(p.score) AS avg_score,
       SUM(COALESCE(p.view_count, 0)) 
       AS total_views
  FROM users u
  JOIN posts p
    ON p.owner_user_id = u.id
 GROUP BY u.id, u.display_name
HAVING COUNT(p.id) >= 5
 ORDER BY total_views DESC 
 LIMIT 50;

--Optimized

EXPLAIN (ANALYZE, BUFFERS)
WITH top_users AS (
    SELECT owner_user_id,
           COUNT(*) AS total_posts,
           AVG(score) AS avg_score,
           SUM(COALESCE(view_count,0)) 
           AS total_views
      FROM posts
     GROUP BY owner_user_id
    HAVING COUNT(*) >= 5
)
SELECT u.id,
       u.display_name,
       t.total_posts,
       t.avg_score,
       t.total_views
  FROM top_users t  
  JOIN users u
    ON u.id = t.owner_user_id 
 ORDER BY t.total_views DESC
 LIMIT 50;