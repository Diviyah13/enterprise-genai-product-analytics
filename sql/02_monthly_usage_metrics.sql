-- Enterprise GenAI Product Analytics
-- Synthetic portfolio project
--
-- Purpose:
-- Calculate monthly core product-usage KPIs from the cleaned
-- AI interaction dataset.

SELECT
    DATE_FORMAT(message_timestamp, '%Y-%m') AS month,

    COUNT(DISTINCT message_id) AS questions_asked,

    COUNT(DISTINCT user_id) AS unique_users,

    COUNT(DISTINCT organisation_id) AS active_organisations,

    COUNT(DISTINCT thread_id) AS total_threads,

    ROUND(
        COUNT(DISTINCT message_id) * 1.0
        / NULLIF(COUNT(DISTINCT organisation_id), 0),
        2
    ) AS questions_per_organisation,

    ROUND(
        COUNT(DISTINCT message_id) * 1.0
        / NULLIF(COUNT(DISTINCT user_id), 0),
        2
    ) AS questions_per_user

FROM clean_questions

GROUP BY
    DATE_FORMAT(message_timestamp, '%Y-%m')

ORDER BY month;
