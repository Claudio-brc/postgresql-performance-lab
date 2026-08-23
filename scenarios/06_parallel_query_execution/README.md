# Parallel Query Execution

## Objective

This scenario examines how PostgreSQL decides when parallel execution is worth
using, including worker coordination and aggregation cardinality.

## Dataset

- posts: approximately 243k rows, approximately 56 MB
- users: approximately 248k rows, approximately 24 MB

## Experiment

The SQL first inspects parallel settings, then runs a global `SUM(view_count)`
with normal settings and again with `max_parallel_workers_per_gather = 0`. It
continues with a high-cardinality `GROUP BY owner_user_id`, a low-cardinality
`GROUP BY post_type_id`, and a filtered `COUNT(*)`.

## Execution Behavior

The historical plans included Parallel Seq Scan, Partial Aggregate, Finalize
Aggregate, Gather, and Gather Merge. PostgreSQL can split suitable scans among
workers, combine partial results, and choose between serial and parallel plans
based on estimated costs.

## Historical Observations

The historical local run used parallel scans and partial aggregation for
suitable global and low-cardinality aggregates. The serial global aggregate was
faster on that machine. The `owner_user_id` grouping produced roughly 64k groups
and used serial HashAggregate, while `post_type_id` produced about five groups
and was parallelized. The filtered count was also suitable for partial
aggregation.

## Findings

Parallel execution is not automatically faster. PostgreSQL estimates whether
the expected reduction in work justifies worker startup, coordination, and
result-combination overhead. Aggregation cardinality influenced the planner
behavior observed in this experiment.

## Reproducibility Note

`historical-results.md` preserves local observations from the original
experiment. Parallel plan selection and timing depend on configuration,
available workers, table size, and runtime conditions.
