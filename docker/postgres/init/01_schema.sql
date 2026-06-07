CREATE TABLE users (
    id BIGINT PRIMARY KEY,
    reputation INTEGER,
    creation_date TIMESTAMP,
    display_name TEXT,
    views INTEGER,
    up_votes INTEGER,
    down_votes INTEGER
);

CREATE TABLE posts (
    id BIGINT PRIMARY KEY,
    post_type_id INTEGER,
    creation_date TIMESTAMP,
    score INTEGER,
    view_count INTEGER,
    owner_user_id BIGINT,
    title TEXT,
    tags TEXT,
    answer_count INTEGER,
    comment_count INTEGER,
    favorite_count INTEGER
);

CREATE TABLE votes (
    id BIGINT PRIMARY KEY,
    post_id BIGINT,
    vote_type_id INTEGER,
    creation_date TIMESTAMP
);

CREATE TABLE comments (
    id BIGINT PRIMARY KEY,
    post_id BIGINT,
    score INTEGER,
    creation_date TIMESTAMP,
    user_id BIGINT
);