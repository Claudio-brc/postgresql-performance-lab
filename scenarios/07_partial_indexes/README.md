# Partial Indexes

## Objective

This scenario examines how a partial index can reduce index size for a
selective, repeated workload.

## Dataset

| Condition | Rows |
|---|---:|
| Total users | 248,141 |
| reputation > 1,000 | 848 |
| reputation > 10,000 | 90 |
| reputation > 50,000 | 15 |

## Problem

Most users have low reputation. Why index 248,141 rows when the query only
needs 90?

## Experiment

The SQL analyzes the reputation distribution, measures the baseline without a
scenario-specific reputation index, creates and measures a full index, then
creates `idx_users_reputation_gt_10000` with the predicate
`reputation > 10000`. It measures both index sizes, removes the full index,
analyzes `users`, and runs the final partial-index setup.

## Historical Results

The historical local observations were approximately 75 ms without an index,
0.7 ms with the full index, and 0.2 ms with the partial index. The full index
was 1744 kB and the partial index 16 kB—approximately 109x smaller. These
timings do not establish that the partial index is inherently faster; cache
state and other runtime conditions can affect them.

## Findings

The partial index reduced index size by approximately 109x while providing
comparable indexed query performance for the targeted workload. It is useful
when a workload repeatedly targets a well-defined subset of rows and PostgreSQL
can use it only when the query predicate is compatible with the index predicate.

## Reproducibility Note

`historical-results.md` preserves the local measurements from the original
experiment. Index choice and timing depend on data distribution, query
predicates, cache state, and runtime conditions.
