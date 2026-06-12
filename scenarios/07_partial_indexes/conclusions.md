# Conclusions

## What We Learned

Partial Indexes allow PostgreSQL to index only the rows that matter for a specific workload.

In this scenario:

- Full Index: 1744 kB
- Partial Index: 16 kB

The partial index was approximately 109x smaller.

---

## Key Insight

The goal of indexing is not to index everything.

The goal is to index what queries actually need.

When a workload repeatedly targets a small subset of rows, Partial Indexes can provide excellent performance while dramatically reducing index size.

---

## Practical Takeaway

Before creating an index, ask:

> Am I indexing the entire table, or only the data my queries actually use?