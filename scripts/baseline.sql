-- Shared, non-experimental prerequisite for scenarios that join posts to users.
-- Do not add scenario-specific indexes here.

CREATE INDEX IF NOT EXISTS idx_posts_owner_user_id
    ON posts (owner_user_id);

ANALYZE users;
ANALYZE posts;
