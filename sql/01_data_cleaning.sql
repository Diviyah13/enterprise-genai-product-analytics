-- Enterprise GenAI Product Analytics
-- Synthetic portfolio project
--
-- Purpose:
-- Create a clean analytical population from raw AI interaction logs
-- before calculating product KPIs.

WITH deduplicated_messages AS (

    SELECT
        message_id,
        thread_id,
        user_id,
        organisation_id,
        message_timestamp,
        message_type,

        ROW_NUMBER() OVER (
            PARTITION BY message_id
            ORDER BY message_timestamp
        ) AS duplicate_rank

    FROM raw_messages
),

valid_messages AS (

    SELECT
        m.message_id,
        m.thread_id,
        m.user_id,
        m.organisation_id,
        m.message_timestamp

    FROM deduplicated_messages m

    INNER JOIN organisations o
        ON m.organisation_id = o.organisation_id

    INNER JOIN users u
        ON m.user_id = u.user_id

    WHERE
        -- Keep one record per message
        m.duplicate_rank = 1

        -- Count user questions only
        AND m.message_type = 'question'

        -- Remove non-client activity
        AND o.is_test = 0
        AND o.is_demo = 0
        AND u.is_internal = 0
)

SELECT
    message_id,
    thread_id,
    user_id,
    organisation_id,
    message_timestamp,

    DATE_FORMAT(
        message_timestamp,
        '%Y-%m'
    ) AS month

FROM valid_messages

ORDER BY message_timestamp;
