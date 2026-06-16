# Conclusions

## What We Learned

PostgreSQL is a cost-based optimizer.

Execution plans are selected according to estimated costs rather than fixed rules.

---

## Statistics Matter

Planner decisions depend on statistics collected through ANALYZE.

Accurate statistics improve cardinality estimation and lead to better execution plans.

---

## Cardinality Drives Strategy

Small result sets tend to favor:

- Nested Loop

Larger result sets tend to favor:

- Hash Join
- Parallel Hash Join

---

## Key Insight

The query did not change.

The join condition did not change.

The indexes did not change.

Only the expected number of rows changed.

That change in cardinality was enough for PostgreSQL to select an entirely different join strategy.

This demonstrates how statistics and cardinality estimation directly influence planner decisions.