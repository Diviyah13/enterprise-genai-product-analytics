{\rtf1\ansi\ansicpg1252\cocoartf2870
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 -- Enterprise GenAI Product Analytics\
-- Synthetic portfolio project\
-- Purpose:\
-- Identify conversation threads with more than one user question\
-- and calculate the monthly multi-turn engagement rate.\
\
WITH thread_activity AS (\
\
    SELECT\
        DATE_FORMAT(message_timestamp, '%Y-%m') AS month,\
        thread_id,\
        COUNT(DISTINCT message_id) AS question_count\
\
    FROM clean_questions\
\
    GROUP BY\
        DATE_FORMAT(message_timestamp, '%Y-%m'),\
        thread_id\
),\
\
monthly_engagement AS (\
\
    SELECT\
        month,\
\
        COUNT(DISTINCT thread_id) AS total_threads,\
\
        COUNT(\
            DISTINCT CASE\
                WHEN question_count > 1 THEN thread_id\
            END\
        ) AS multi_turn_threads\
\
    FROM thread_activity\
\
    GROUP BY month\
)\
\
SELECT\
    month,\
    total_threads,\
    multi_turn_threads,\
\
    ROUND(\
        multi_turn_threads * 100.0 / NULLIF(total_threads, 0),\
        2\
    ) AS multi_turn_rate_pct\
\
FROM monthly_engagement\
\
ORDER BY month;}