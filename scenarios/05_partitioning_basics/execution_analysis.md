# Benchmark Results

## Query 1 - Partition Pruning (2023+)

```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM posts_partitioned
WHERE creation_date >= '2023-01-01';
```

Execution Time:

~7.2 ms

Plan Highlights:

- Append
- Seq Scan on posts_2023
- Seq Scan on posts_2024

Partitions Accessed:

- posts_2023
- posts_2024

Partitions Pruned:

- posts_2020
- posts_2021
- posts_2022

---

## Query 2 - Partition Pruning (2024+)

```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM posts_partitioned
WHERE creation_date >= '2024-01-01';
```

Execution Time:

~0.7 ms

Plan Highlights:

- Seq Scan on posts_2024

Partitions Accessed:

- posts_2024

Partitions Pruned:

- posts_2020
- posts_2021
- posts_2022
- posts_2023

---

## Query 3 - Original Table Comparison

```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM posts
WHERE creation_date >= '2024-01-01';
```

Execution Time:

~2.9 ms

Plan Highlights:

- Index Scan
- idx_posts_creation_date

---

## Summary

| Query | Execution Time | Access Strategy |
|---------|---------------:|----------------|
| posts_partitioned (2023+) | ~7.2 ms | Append + Partition Pruning |
| posts_partitioned (2024+) | ~0.7 ms | Seq Scan on posts_2024 |
| posts (original) | ~2.9 ms | Index Scan |

---

## Key Observation

The original table already had an efficient index on creation_date.

Partitioning improved performance for highly selective date ranges, but the most important outcome was observing PostgreSQL's ability to eliminate entire partitions before execution.

This behavior is known as Partition Pruning.

---

## Key Insight

Partitioning complements indexing.

Indexes optimize data access paths.

Partitioning reduces the amount of data PostgreSQL must consider during planning and execution.

Its value becomes increasingly important as tables grow into tens or hundreds of millions of rows.