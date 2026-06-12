# 07 - Partial Indexes

## Objective

Learn how Partial Indexes can reduce index size dramatically by indexing only the subset of rows frequently accessed by a query.

---

## Dataset

### users

- ~248k rows

Distribution:

| Condition | Rows |
|------------|---------:|
| Total Users | 248,141 |
| reputation > 1,000 | 848 |
| reputation > 10,000 | 90 |
| reputation > 50,000 | 15 |

---

## Problem

Most users have low reputation.

Queries targeting highly reputable users access only a tiny fraction of the table.

The question becomes:

> Why index 248,141 rows when the query only needs 90?

---

## Key Concepts

- Partial Indexes
- Bitmap Index Scan
- Bitmap Heap Scan
- Planner Decisions
- Index Size Reduction
- Selectivity