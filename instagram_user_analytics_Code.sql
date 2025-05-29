
-- Instagram User Data Analysis Project
-- SQL Queries for Marketing Analysis & Investor Metrics

-- 1. Loyal User Reward: Identify the five oldest users
SELECT
    username,
    created_at AS registration_date
FROM
    users
ORDER BY
    created_at ASC
LIMIT 5;


-- 2. Inactive User Engagement: Identify users who have never posted a photo
SELECT
    u.username
FROM
    users u
LEFT JOIN
    photos p ON u.id = p.user_id
WHERE
    p.id IS NULL;


-- 3. Contest Winner Declaration: User whose photo received the most likes
SELECT
    u.username AS contest_winner,
    p.id AS photo_id,
    p.image_url,
    COUNT(l.user_id) AS total_likes_on_photo
FROM
    photos p
JOIN
    likes l ON p.id = l.photo_id
JOIN
    users u ON p.user_id = u.id
GROUP BY
    p.id, u.username, p.image_url
ORDER BY
    total_likes_on_photo DESC
LIMIT 1;


-- 4. Hashtag Research: Top five most commonly used hashtags
SELECT
    t.tag_name,
    COUNT(pt.photo_id) AS times_used
FROM
    tags t
JOIN
    photo_tags pt ON t.id = pt.tag_id
GROUP BY
    t.tag_name
ORDER BY
    times_used DESC
LIMIT 5;


-- 5. Ad Campaign Launch: Best day of the week for user registrations
SELECT
    DAYNAME(created_at) AS registration_day,
    COUNT(id) AS total_registrations
FROM
    users
GROUP BY
    registration_day
ORDER BY
    total_registrations DESC;


-- 6. User Engagement: Average number of posts per user
SELECT
    (SELECT COUNT(*) FROM photos) / (SELECT COUNT(*) FROM users) AS average_posts_per_user;


-- Alternative detailed user post count
WITH user_post_counts AS (
    SELECT
        u.id AS user_id,
        COUNT(p.id) AS posts_by_user
    FROM
        users u
    LEFT JOIN
        photos p ON u.id = p.user_id
    GROUP BY
        u.id
)
SELECT
    SUM(posts_by_user) AS total_photos_posted,
    COUNT(user_id) AS total_users,
    SUM(posts_by_user) / COUNT(user_id) AS average_posts_per_user_detailed
FROM
    user_post_counts;


-- 7. Bots & Fake Accounts: Identify users who have liked every single photo
WITH user_likes_summary AS (
    SELECT
        u.username,
        COUNT(l.photo_id) AS num_photos_liked_by_user
    FROM
        users u
    LEFT JOIN
        likes l ON u.id = l.user_id
    GROUP BY
        u.username
)
SELECT
    username
FROM
    user_likes_summary
WHERE
    num_photos_liked_by_user = (SELECT COUNT(*) FROM photos)
ORDER BY
    username;
