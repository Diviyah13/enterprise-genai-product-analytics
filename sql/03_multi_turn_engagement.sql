-- Enterprise GenAI Product Analytics
-- Synthetic portfolio project
--
-- Purpose:
-- Measure conversational depth by identifying threads
-- containing more than one valid user question.

WITH thread_activity AS (

    SELECT
        DATE_FORMAT(message_timestamp, '%Y-%m') AS month,
        thread_id,

        COUNT(DISTINCT message_id) AS question_count

    FROM clean_questions

    GROUP BY
        DATE_FORMAT(message_timestamp, '%Y-%m'),
        thread_id
),

monthly_engagement AS (

    SELECT
        month,

        COUNT(DISTINCT thread_id) AS total_threads,

        COUNT(
            DISTINCT CASE
                WHEN question_count > 1
                THEN thread_id
            END
        ) AS multi_turn_threads

    FROM thread_activity

    GROUP BY month
)

SELECT
    month,
    total_threads,
    multi_turn_threads,

    ROUND(
        multi_turn_threads * 100.0
        / NULLIF(total_threads, 0),
        2
    ) AS multi_turn_rate_pct

FROM monthly_engagement

ORDER BY month;
