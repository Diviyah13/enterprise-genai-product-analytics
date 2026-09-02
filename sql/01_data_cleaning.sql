{\rtf1\ansi\ansicpg1252\cocoartf2870
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 -- Enterprise GenAI Product Analytics\
-- Synthetic portfolio project\
-- Purpose:\
-- Calculate monthly AI usage metrics from cleaned interaction data.\
\
SELECT\
    DATE_FORMAT(message_timestamp, '%Y-%m') AS month,\
\
    COUNT(DISTINCT message_id) AS questions_asked,\
\
    COUNT(DISTINCT user_id) AS unique_users,\
\
    COUNT(DISTINCT organisation_id) AS active_organisations,\
\
    COUNT(DISTINCT thread_id) AS total_threads\
\
FROM clean_questions\
\
GROUP BY\
    DATE_FORMAT(message_timestamp, '%Y-%m')\
\
ORDER BY\
    month;}