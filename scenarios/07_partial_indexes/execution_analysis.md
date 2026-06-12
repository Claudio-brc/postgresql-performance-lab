# Execution Analysis

## Baseline

Plan:

- Parallel Seq Scan

Execution Time:

~75 ms

Buffers:

2448

Observation:

PostgreSQL scanned the entire table to locate 90 matching rows.

---

## Full Index

Plan:

- Bitmap Index Scan
- Bitmap Heap Scan

Execution Time:

~0.7 ms

Index Size:

1744 kB

Observation:

The index eliminated the full table scan and dramatically reduced execution time.

---

## Partial Index

Definition:

```sql
CREATE INDEX idx_users_reputation_gt_10000
ON users(reputation)
WHERE reputation > 10000;
```

Execution Time:

~0.2 ms

Index Size:

16 kB

Observation:

The partial index contains only the rows relevant to the query workload.

Despite being dramatically smaller, it provided comparable query performance.