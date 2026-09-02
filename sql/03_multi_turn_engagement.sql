{\rtf1\ansi\ansicpg1252\cocoartf2870
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 -- Enterprise GenAI Product Analytics\
-- Synthetic portfolio project\
-- Purpose:\
-- Clean raw AI interaction logs before KPI calculation.\
\
WITH deduplicated_messages AS (\
\
    SELECT\
        message_id,\
        thread_id,\
        user_id,\
        organisation_id,\
        message_timestamp,\
        message_type,\
\
        ROW_NUMBER() OVER (\
            PARTITION BY message_id\
            ORDER BY message_timestamp\
        ) AS duplicate_rank\
\
    FROM raw_messages\
),\
\
valid_messages AS (\
\
    SELECT\
        m.message_id,\
        m.thread_id,\
        m.user_id,\
        m.organisation_id,\
        m.message_timestamp\
\
    FROM deduplicated_messages m\
\
    INNER JOIN organisations o\
        ON m.organisation_id = o.organisation_id\
\
    INNER JOIN users u\
        ON m.user_id = u.user_id\
\
    WHERE\
        m.duplicate_rank = 1\
\
        -- Only count questions submitted by users\
        AND m.message_type = 'question'\
\
        -- Exclude test organisations\
        AND o.is_test = 0\
\
        -- Exclude demo organisations\
        AND o.is_demo = 0\
\
        -- Exclude internal employee activity\
        AND u.is_internal = 0\
)\
\
SELECT\
    message_id,\
    thread_id,\
    user_id,\
    organisation_id,\
    message_timestamp,\
\
    DATE_FORMAT(\
        message_timestamp,\
        '%Y-%m'\
    ) AS month\
\
FROM valid_messages\
\
ORDER BY message_timestamp;}