{\rtf1\ansi\ansicpg1252\cocoartf2870
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\froman\fcharset0 Times-Bold;\f1\froman\fcharset0 Times-Roman;\f2\fmodern\fcharset0 Courier;
}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;\red109\green109\blue109;}
{\*\expandedcolortbl;;\cssrgb\c0\c0\c0;\cssrgb\c50196\c50196\c50196;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\deftab720
\pard\pardeftab720\sa321\partightenfactor0

\f0\b\fs48 \cf0 \expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Validation Notes\
\pard\pardeftab720\sa240\partightenfactor0

\f1\b0\fs24 \cf0 This document explains the validation checks used to confirm that the product analytics metrics are calculated consistently and accurately.\
The goal of validation is to ensure that the final KPIs are not only technically correct, but also aligned with the intended business definitions.\
\pard\pardeftab720\sa298\partightenfactor0

\f0\b\fs36 \cf0 1. Raw vs Clean Record Reconciliation\
\pard\pardeftab720\sa240\partightenfactor0

\f1\b0\fs24 \cf0 The raw message dataset contains user questions, assistant responses, duplicate rows, test activity, demo activity and internal-user activity.\
The cleaned dataset should contain only valid external user questions.\
Validation check:\
\pard\pardeftab720\partightenfactor0

\f2\fs26 \cf0 Raw Message Rows\
        -\
Assistant Responses\
        -\
Test Organisation Activity\
        -\
Demo Organisation Activity\
        -\
Internal User Activity\
        -\
Duplicate Messages\
        =\
Clean Question Rows\
\pard\pardeftab720\sa240\partightenfactor0

\f1\fs24 \cf0 The cleaned total should reconcile with the exclusions recorded during the cleaning process.\
\pard\pardeftab720\partightenfactor0
\cf3 \strokec3 \
\pard\pardeftab720\sa298\partightenfactor0

\f0\b\fs36 \cf0 \strokec2 2. Duplicate Validation\
\pard\pardeftab720\sa240\partightenfactor0

\f1\b0\fs24 \cf0 Each valid message should appear only once in the clean dataset.\
Validation query concept:\
\pard\pardeftab720\partightenfactor0

\f2\fs26 \cf0 SELECT\
    message_id,\
    COUNT(*) AS record_count\
FROM clean_questions\
GROUP BY message_id\
HAVING COUNT(*) > 1;\
\pard\pardeftab720\sa240\partightenfactor0

\f1\fs24 \cf0 Expected result:\
\pard\pardeftab720\partightenfactor0

\f2\fs26 \cf0 0 duplicate message IDs\
\pard\pardeftab720\sa240\partightenfactor0

\f1\fs24 \cf0 If any records are returned, the deduplication logic should be reviewed.\
\pard\pardeftab720\partightenfactor0
\cf3 \strokec3 \
\pard\pardeftab720\sa298\partightenfactor0

\f0\b\fs36 \cf0 \strokec2 3. Test and Demo Organisation Validation\
\pard\pardeftab720\sa240\partightenfactor0

\f1\b0\fs24 \cf0 No test or demo organisations should appear in the final analytical population.\
Validation query concept:\
\pard\pardeftab720\partightenfactor0

\f2\fs26 \cf0 SELECT DISTINCT\
    cq.organisation_id\
FROM clean_questions cq\
JOIN organisations o\
    ON cq.organisation_id = o.organisation_id\
WHERE\
    o.is_test = 1\
    OR o.is_demo = 1;\
\pard\pardeftab720\sa240\partightenfactor0

\f1\fs24 \cf0 Expected result:\
\pard\pardeftab720\partightenfactor0

\f2\fs26 \cf0 0 organisations\
\pard\pardeftab720\partightenfactor0

\f1\fs24 \cf3 \strokec3 \
\pard\pardeftab720\sa298\partightenfactor0

\f0\b\fs36 \cf0 \strokec2 4. Internal User Validation\
\pard\pardeftab720\sa240\partightenfactor0

\f1\b0\fs24 \cf0 Internal employee activity should not contribute to client adoption metrics.\
Validation query concept:\
\pard\pardeftab720\partightenfactor0

\f2\fs26 \cf0 SELECT DISTINCT\
    cq.user_id\
FROM clean_questions cq\
JOIN users u\
    ON cq.user_id = u.user_id\
WHERE u.is_internal = 1;\
\pard\pardeftab720\sa240\partightenfactor0

\f1\fs24 \cf0 Expected result:\
\pard\pardeftab720\partightenfactor0

\f2\fs26 \cf0 0 internal users\
\pard\pardeftab720\partightenfactor0

\f1\fs24 \cf3 \strokec3 \
\pard\pardeftab720\sa298\partightenfactor0

\f0\b\fs36 \cf0 \strokec2 5. Monthly Question Reconciliation\
\pard\pardeftab720\sa240\partightenfactor0

\f1\b0\fs24 \cf0 The total number of monthly questions should reconcile with the total clean question dataset.\
For example:\
\pard\pardeftab720\partightenfactor0

\f2\fs26 \cf0 January Questions\
+\
February Questions\
+\
March Questions\
+\
...\
+\
August Questions\
=\
Total Clean Questions\
\pard\pardeftab720\sa240\partightenfactor0

\f1\fs24 \cf0 This check confirms that each valid question has been assigned to exactly one reporting month.\
\pard\pardeftab720\partightenfactor0
\cf3 \strokec3 \
\pard\pardeftab720\sa298\partightenfactor0

\f0\b\fs36 \cf0 \strokec2 6. Thread-Level Reconciliation\
\pard\pardeftab720\sa240\partightenfactor0

\f1\b0\fs24 \cf0 Every clean question must belong to a valid conversation thread.\
Validation check:\
\pard\pardeftab720\partightenfactor0

\f2\fs26 \cf0 Distinct thread IDs in Clean Questions\
=\
Thread IDs represented in Clean Threads\
\pard\pardeftab720\sa240\partightenfactor0

\f1\fs24 \cf0 No clean interaction should exist without a corresponding thread.\
\pard\pardeftab720\partightenfactor0
\cf3 \strokec3 \
\pard\pardeftab720\sa298\partightenfactor0

\f0\b\fs36 \cf0 \strokec2 7. Multi-turn Validation\
\pard\pardeftab720\sa240\partightenfactor0

\f1\b0\fs24 \cf0 A multi-turn thread is defined as a thread containing more than one valid user question.\
Example:\
\pard\pardeftab720\partightenfactor0

\f2\fs26 \cf0 Thread A = 1 question  \uc0\u8594  Single-turn\
Thread B = 2 questions \uc0\u8594  Multi-turn\
Thread C = 4 questions \uc0\u8594  Multi-turn\
\pard\pardeftab720\sa240\partightenfactor0

\f1\fs24 \cf0 The multi-turn rate is calculated as:\
\pard\pardeftab720\partightenfactor0

\f2\fs26 \cf0 Multi-turn Threads\
------------------ \'d7 100\
Total Threads\
\pard\pardeftab720\sa240\partightenfactor0

\f1\fs24 \cf0 The rate must always remain between:\
\pard\pardeftab720\partightenfactor0

\f2\fs26 \cf0 0% and 100%\
\pard\pardeftab720\partightenfactor0

\f1\fs24 \cf3 \strokec3 \
\pard\pardeftab720\sa298\partightenfactor0

\f0\b\fs36 \cf0 \strokec2 8. Organisation-Level Validation\
\pard\pardeftab720\sa240\partightenfactor0

\f1\b0\fs24 \cf0 An organisation should be classified as active only when at least one valid user question exists during the reporting period.\
Validation logic:\
\pard\pardeftab720\partightenfactor0

\f2\fs26 \cf0 Active Organisation\
=\
Organisation with \uc0\u8805  1 valid question\
\pard\pardeftab720\sa240\partightenfactor0

\f1\fs24 \cf0 An organisation should only be counted once per reporting period regardless of the number of users or questions associated with it.\
\pard\pardeftab720\partightenfactor0
\cf3 \strokec3 \
\pard\pardeftab720\sa298\partightenfactor0

\f0\b\fs36 \cf0 \strokec2 9. User-Level Validation\
\pard\pardeftab720\sa240\partightenfactor0

\f1\b0\fs24 \cf0 A user should only be counted once in the Unique Users KPI during each reporting period.\
Example:\
\pard\pardeftab720\partightenfactor0

\f2\fs26 \cf0 User A asks 1 question  \uc0\u8594  1 unique user\
User B asks 8 questions \uc0\u8594  1 unique user\
User C asks 3 questions \uc0\u8594  1 unique user\
\pard\pardeftab720\sa240\partightenfactor0

\f1\fs24 \cf0 Therefore:\
\pard\pardeftab720\partightenfactor0

\f2\fs26 \cf0 Unique Users \uc0\u8800  Questions Asked\
\pard\pardeftab720\sa240\partightenfactor0

\f1\fs24 \cf0 The KPI measures adoption breadth rather than usage volume.\
\pard\pardeftab720\partightenfactor0
\cf3 \strokec3 \
\pard\pardeftab720\sa298\partightenfactor0

\f0\b\fs36 \cf0 \strokec2 10. Month-on-Month Growth Validation\
\pard\pardeftab720\sa240\partightenfactor0

\f1\b0\fs24 \cf0 MoM Question Growth is calculated as:\
\pard\pardeftab720\partightenfactor0

\f2\fs26 \cf0 (Current Month Questions - Previous Month Questions)\
----------------------------------------------------\
              Previous Month Questions\
\pard\pardeftab720\sa240\partightenfactor0

\f1\fs24 \cf0 Example:\
\pard\pardeftab720\partightenfactor0

\f2\fs26 \cf0 July Questions   = 400\
August Questions = 460\
\pard\pardeftab720\sa240\partightenfactor0

\f1\fs24 \cf0 Calculation:\
\pard\pardeftab720\partightenfactor0

\f2\fs26 \cf0 (460 - 400) / 400\
= 0.15\
= 15%\
\pard\pardeftab720\sa240\partightenfactor0

\f1\fs24 \cf0 Positive values indicate growth.\
Negative values indicate declining usage.\
The first reporting month should not have a MoM growth value because no previous period exists for comparison.\
\pard\pardeftab720\partightenfactor0
\cf3 \strokec3 \
\pard\pardeftab720\sa298\partightenfactor0

\f0\b\fs36 \cf0 \strokec2 11. Segment Reconciliation\
\pard\pardeftab720\sa240\partightenfactor0

\f1\b0\fs24 \cf0 When all client segments are added together, their total question volume should reconcile with the overall monthly total.\
For each month:\
\pard\pardeftab720\partightenfactor0

\f2\fs26 \cf0 Enterprise Questions\
+\
Mid-Market Questions\
+\
SME Questions\
=\
Overall Questions Asked\
\pard\pardeftab720\sa240\partightenfactor0

\f1\fs24 \cf0 The same principle can be applied to other additive metrics such as thread counts.\
Distinct users and organisations should be interpreted carefully when aggregating across categories to avoid double counting.\
\pard\pardeftab720\partightenfactor0
\cf3 \strokec3 \
\pard\pardeftab720\sa298\partightenfactor0

\f0\b\fs36 \cf0 \strokec2 12. Boundary and Timestamp Validation\
\pard\pardeftab720\sa240\partightenfactor0

\f1\b0\fs24 \cf0 Reporting periods should use consistent timestamp boundaries.\
A safe monthly filter is:\
\pard\pardeftab720\partightenfactor0

\f2\fs26 \cf0 message_timestamp >= '2026-08-01'\
AND message_timestamp < '2026-09-01'\
\pard\pardeftab720\sa240\partightenfactor0

\f1\fs24 \cf0 rather than:\
\pard\pardeftab720\partightenfactor0

\f2\fs26 \cf0 message_timestamp <= '2026-08-31'\
\pard\pardeftab720\sa240\partightenfactor0

\f1\fs24 \cf0 Using the start of the following month as the exclusive upper boundary ensures that records created later on the final day of the month are not accidentally excluded.\
\pard\pardeftab720\partightenfactor0
\cf3 \strokec3 \
\pard\pardeftab720\sa321\partightenfactor0

\f0\b\fs48 \cf0 \strokec2 Validation Principle\
\pard\pardeftab720\sa240\partightenfactor0

\f1\b0\fs24 \cf0 A technically valid SQL query does not automatically guarantee a valid business metric.\
Validation therefore takes place at three levels:\
\pard\pardeftab720\partightenfactor0

\f2\fs26 \cf0 1. Data validation\
   Are the records clean and correctly classified?\
\
2. Calculation validation\
   Are the formulas and aggregation levels correct?\
\
3. Business validation\
   Does the KPI actually represent the behaviour we intend to measure?\
\pard\pardeftab720\sa240\partightenfactor0

\f1\fs24 \cf0 This approach helps ensure that final product analytics reporting is reproducible, explainable and trustworthy.\
}