-- Enterprise GenAI Product Analytics
-- Synthetic portfolio project
--
-- Purpose:
-- Compare AI adoption and engagement across client segments.

WITH segment_usage AS (

    SELECT
        DATE_FORMAT(cq.message_timestamp, '%Y-%m') AS month,
        o.segment,

        COUNT(DISTINCT cq.message_id) AS questions_asked,

        COUNT(DISTINCT cq.user_id) AS unique_users,

        COUNT(DISTINCT cq.organisation_id) AS active_organisations,

        COUNT(DISTINCT cq.thread_id) AS total_threads

    FROM clean_questions cq

    INNER JOIN organisations o
        ON cq.organisation_id = o.organisation_id

    GROUP BY
        DATE_FORMAT(cq.message_timestamp, '%Y-%m'),
        o.segment
),

segment_thread_activity AS (

    SELECT
        DATE_FORMAT(cq.message_timestamp, '%Y-%m') AS month,
        o.segment,
        cq.thread_id,

        COUNT(DISTINCT cq.message_id) AS question_count

    FROM clean_questions cq

    INNER JOIN organisations o
        ON cq.organisation_id = o.organisation_id

    GROUP BY
        DATE_FORMAT(cq.message_timestamp, '%Y-%m'),
        o.segment,
        cq.thread_id
),

multi_turn_summary AS (

    SELECT
        month,
        segment,

        COUNT(
            DISTINCT CASE
                WHEN question_count > 1
                THEN thread_id
            END
        ) AS multi_turn_threads

    FROM segment_thread_activity

    GROUP BY
        month,
        segment
)

SELECT
    s.month,
    s.segment,
    s.questions_asked,
    s.unique_users,
    s.active_organisations,
    s.total_threads,
    m.multi_turn_threads,

    ROUND(
        m.multi_turn_threads * 100.0
        / NULLIF(s.total_threads, 0),
        2
    ) AS multi_turn_rate_pct,

    ROUND(
        s.questions_asked * 1.0
        / NULLIF(s.active_organisations, 0),
        2
    ) AS questions_per_organisation

FROM segment_usage s

LEFT JOIN multi_turn_summary m
    ON s.month = m.month
    AND s.segment = m.segment

ORDER BY
    s.month,
    s.segment;
