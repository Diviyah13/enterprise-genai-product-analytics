# Validation Notes

This document summarises the validation checks used to confirm that the product analytics metrics are calculated consistently and accurately.

The goal is to ensure that final KPIs are not only technically correct, but also aligned with the intended business definitions.

---

## 1. Raw vs Clean Reconciliation

The raw message dataset contains:

- user questions
- assistant responses
- duplicate rows
- test activity
- demo activity
- internal-user activity

The cleaned dataset should contain only valid external user questions.

Conceptually:

```text
Raw Message Rows
        -
Assistant Responses
        -
Test Organisation Activity
        -
Demo Organisation Activity
        -
Internal User Activity
        -
Duplicate Messages
        =
Clean Question Rows
```

---

## 2. Duplicate Validation

Each valid message should appear only once in the clean dataset.

```sql
SELECT
    message_id,
    COUNT(*) AS record_count
FROM clean_questions
GROUP BY message_id
HAVING COUNT(*) > 1;
```

**Expected result:** 0 duplicate message IDs.

---

## 3. Test and Demo Organisation Validation

No test or demo organisations should appear in the final analytical population.

```sql
SELECT DISTINCT
    cq.organisation_id
FROM clean_questions cq

INNER JOIN organisations o
    ON cq.organisation_id = o.organisation_id

WHERE
    o.is_test = 1
    OR o.is_demo = 1;
```

**Expected result:** 0 organisations.

---

## 4. Internal User Validation

Internal-user activity should not contribute to external client-adoption metrics.

```sql
SELECT DISTINCT
    cq.user_id
FROM clean_questions cq

INNER JOIN users u
    ON cq.user_id = u.user_id

WHERE u.is_internal = 1;
```

**Expected result:** 0 internal users.

---

## 5. Monthly Question Reconciliation

The sum of monthly question counts should equal the total number of clean questions.

```text
January
+ February
+ March
+ ...
+ August
=
Total Clean Questions
```

This confirms that each valid question has been assigned to exactly one reporting month.

---

## 6. Thread-Level Reconciliation

Every clean question must belong to a valid conversation thread.

```text
Distinct thread IDs in Clean Questions
=
Thread IDs represented in Clean Threads
```

No clean interaction should exist without a corresponding thread.

---

## 7. Multi-turn Validation

A multi-turn thread contains more than one valid user question.

```text
Thread A = 1 question  → Single-turn
Thread B = 2 questions → Multi-turn
Thread C = 4 questions → Multi-turn
```

The multi-turn rate is:

```text
Multi-turn Threads
------------------ × 100
Total Threads
```

The result must always remain between **0% and 100%**.

---

## 8. Organisation-Level Validation

An organisation is classified as active when it records at least one valid user question during the reporting period.

```text
Active Organisation
=
Organisation with ≥ 1 valid question
```

An organisation is counted only once per reporting period regardless of how many users or questions it has.

---

## 9. User-Level Validation

A user is counted once in the Unique Users KPI during each reporting period.

Example:

```text
User A asks 1 question  → 1 unique user
User B asks 8 questions → 1 unique user
User C asks 3 questions → 1 unique user
```

Therefore:

```text
Unique Users ≠ Questions Asked
```

Unique Users measures adoption breadth, while Questions Asked measures usage volume.

---

## 10. Month-on-Month Growth Validation

MoM Question Growth is calculated as:

```text
(Current Month Questions - Previous Month Questions)
----------------------------------------------------
              Previous Month Questions
```

Example:

```text
July Questions   = 400
August Questions = 460

(460 - 400) / 400
= 0.15
= 15%
```

Positive values indicate growth.

Negative values indicate declining usage.

The first reporting month should not have a MoM growth value because no previous period exists.

---

## 11. Segment Reconciliation

For additive metrics such as question volume:

```text
Enterprise Questions
+
Mid-Market Questions
+
SME Questions
=
Overall Questions Asked
```

Distinct users and organisations should be interpreted carefully across segments to avoid double counting.

---

## 12. Timestamp Boundary Validation

Monthly filters should use an exclusive upper boundary.

Preferred:

```sql
message_timestamp >= '2026-08-01'
AND message_timestamp < '2026-09-01'
```

Avoid:

```sql
message_timestamp <= '2026-08-31'
```

Using the start of the next month as the exclusive upper boundary prevents records created later on the final day of the month from being missed.

---

## Validation Framework

Validation takes place at three levels:

```text
1. Data Validation
   Are the records clean and correctly classified?

2. Calculation Validation
   Are the formulas and aggregation levels correct?

3. Business Validation
   Does the KPI represent the behaviour we intend to measure?
```

This approach helps ensure that the final product analytics output is reproducible, explainable and trustworthy.
