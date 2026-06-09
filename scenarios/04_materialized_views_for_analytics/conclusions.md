# Conclusions

- Materialized Views store precomputed results physically.
- Query execution changed from a Merge Join + GroupAggregate workload to a simple Index Scan.
- Read performance improved dramatically.
- Data is not refreshed automatically.
- Refresh operations introduce additional cost.
- Materialized Views are most useful when reads are frequent and data freshness requirements are relaxed.

## Key Insight

Materialized Views do not eliminate computation.

They move it from query time to refresh time.