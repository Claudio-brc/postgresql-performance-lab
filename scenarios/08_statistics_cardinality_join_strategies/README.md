# Statistics, Cardinality & Join Strategies

## Objective

This scenario examines how PostgreSQL's cost-based optimizer can select
different join strategies when predicate selectivity and expected cardinality
change.

## Dataset / Context

The experiment joins `posts` and `users`, filters on `users.reputation`, orders
by post view count, and returns the Top 20 rows. Statistics collected through
`ANALYZE` contribute to the cardinality estimates used by the planner.

## Question

How does a highly selective reputation predicate compare with a less selective
one when the query structure, join condition, ordering, and available indexes
remain unchanged?

## Experiment

The SQL first counts matching users, then analyzes two structurally equivalent
queries:

| Predicate | Matching users |
|---|---:|
| `reputation > 50000` | 15 |
| `reputation > 1000` | 848 |

The predicate value changes, which changes selectivity and the expected number
of rows participating in the join.

## Cardinality Difference

```text
Predicate selectivity
        ↓
Estimated cardinality
        ↓
Estimated cost of alternative plans
        ↓
Join strategy selected by the planner
```

Cardinality is an important input into planner costs, not a fixed threshold
that determines a particular join algorithm.

## Historical Execution Behavior

Earlier local testing observed a Nested Loop with indexed lookups for
`reputation > 50000`, where the outer relation was small. For
`reputation > 1000`, it observed a Parallel Hash Join with parallel sequential
scans, Parallel Hash, and Gather Merge. The larger expected participation
changed the relative estimated costs of the available strategies.

These are historical local observations, not newly reproduced plans or
universal PostgreSQL behavior.

## Findings

PostgreSQL is a cost-based optimizer: it selects plans from estimated costs
rather than fixed rules. In this experiment, the highly selective predicate
favored a Nested Loop with indexed lookups, while the less selective predicate
favored a Parallel Hash Join. The query structure, join condition, and indexes
remained unchanged; only predicate selectivity changed.

`historical-results.md` preserves the original local observations.
