# Benchmark Results

## Original Analytics Query

Execution Time:

~780 ms

Plan Highlights:

- Merge Join
- GroupAggregate
- Sort
- Limit

---

## Materialized View Query

Execution Time:

~0.138 ms

Plan Highlights:

- Index Scan
- Limit

---

## Materialized View Refresh

Execution Time:

~2615 ms

---

## Benchmark Summary

| Operation | Time |
|------------|---------:|
| Analytics Query | ~780 ms |
| Refresh Materialized View | ~2615 ms |
| Query on Materialized View | ~0.138 ms |

---

## Observations

- Materialized Views dramatically reduced read latency.
- Query execution changed from a full aggregation workload to an indexed lookup.
- Refresh operations remained expensive because PostgreSQL must recompute and store the aggregated dataset.

---

## Key Insight

Materialized Views do not eliminate computation.

They move it from query execution time to refresh time.

This trade-off is often beneficial when read frequency is significantly higher than refresh frequency.