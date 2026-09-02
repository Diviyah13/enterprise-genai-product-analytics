# Data Model

This project uses a simplified relational data model to represent how organisations, users and conversations interact with an enterprise GenAI assistant.

## Entity Relationship Overview

```text
Organisations
    │
    ├──< Users
    │
    └──< Threads
            │
            └──< Messages
```

A single organisation can contain multiple users.

A user can create multiple conversation threads.

Each thread can contain multiple messages.

---

## 1. Organisations

The `organisations` table represents client organisations using the platform.

| Field | Description |
|---|---|
| `organisation_id` | Unique identifier for the organisation |
| `organisation_name` | Synthetic organisation name |
| `segment` | Client segment: Enterprise, Mid-Market or SME |
| `created_at` | Date the organisation was created |
| `is_test` | Identifies test organisations |
| `is_demo` | Identifies demo organisations |

**Primary Key:** `organisation_id`

The organisation ID is used as the source of truth for organisation-level adoption metrics.

---

## 2. Users

The `users` table represents users associated with each organisation.

| Field | Description |
|---|---|
| `user_id` | Unique identifier for the user |
| `organisation_id` | Organisation the user belongs to |
| `user_created_at` | Date the user record was created |
| `user_status` | Synthetic user status |
| `is_internal` | Identifies internal employee activity |

**Primary Key:** `user_id`

**Foreign Key:**  
`organisation_id` → `organisations.organisation_id`

Internal-user activity is excluded from client-adoption reporting.

---

## 3. Threads

The `threads` table represents AI conversation sessions.

| Field | Description |
|---|---|
| `thread_id` | Unique identifier for the conversation |
| `user_id` | User who initiated the thread |
| `organisation_id` | Organisation associated with the conversation |
| `thread_created_at` | Timestamp when the conversation started |

**Primary Key:** `thread_id`

**Foreign Keys:**

`user_id` → `users.user_id`

`organisation_id` → `organisations.organisation_id`

---

## 4. Messages

The raw message log represents individual events within each conversation.

| Field | Description |
|---|---|
| `message_id` | Unique identifier for the message |
| `thread_id` | Conversation containing the message |
| `user_id` | User associated with the interaction |
| `organisation_id` | Organisation associated with the interaction |
| `message_timestamp` | Timestamp of the event |
| `message_type` | User question or assistant response |

**Primary Key:** `message_id`

---

## Analytical Grain

Different KPIs require different levels of aggregation.

| Analytical Level | Example Metric |
|---|---|
| Message | Questions Asked |
| User | Unique Users |
| Organisation | Active Organisations |
| Thread | Multi-turn Threads |
| Month | MoM Question Growth |
| Segment | Questions per Organisation |

This distinction is important because simply counting raw rows would not correctly answer every business question.

---

## Multi-turn Conversation Logic

A conversation containing multiple valid user questions is classified as multi-turn.

```text
Thread A
├── Question 1
├── Assistant Response
├── Question 2
└── Assistant Response

Result: Multi-turn
```

A conversation containing only one valid user question is single-turn.

```text
Thread B
├── Question 1
└── Assistant Response

Result: Single-turn
```

The calculation therefore occurs at **thread level**, not directly at message level.

---

## Data Cleaning Flow

```text
Raw Messages
      │
      ▼
Keep User Questions
      │
      ▼
Remove Test Organisations
      │
      ▼
Remove Demo Organisations
      │
      ▼
Remove Internal Users
      │
      ▼
Deduplicate Message IDs
      │
      ▼
Clean Question Dataset
      │
      ├──► User Metrics
      ├──► Organisation Metrics
      ├──► Thread Metrics
      └──► Segment Analysis
```

---

## Design Principle

Stable IDs are used as the source of truth throughout the project.

Names are not used as primary aggregation keys because names may:

- change over time
- contain formatting differences
- be duplicated
- represent multiple distinct records

Using IDs reduces aggregation errors and improves reproducibility.
