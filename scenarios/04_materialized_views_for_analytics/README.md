# Materialized Views for Analytics

## Objective

This scenario examines how a Materialized View can reduce read latency for a
repeated analytical query by precomputing an aggregation.

## Dataset

- users: approximately 248k rows
- posts: approximately 243k rows

## Business Question

Who are the most influential users based on post count, total views, and
average score?

## Problem

Answering this question directly requires joining `users` and `posts`,
aggregating the result, sorting it, and repeating that work for each query.

## Solution / Experiment

The experiment creates `mv_user_influence`, a Materialized View that physically
stores the precomputed user-level aggregation. A descending index on
`total_views` supports the Top-50 query against the materialized result.

The direct query and the Materialized View return the same influence metrics,
but the latter reads stored results rather than repeating the join and
aggregation on every request.

## Historical Results

The original local experiment observed approximately 780 ms for the analytics
query, 2615 ms for refresh, and 0.138 ms for the indexed Materialized View
query. These are historical local measurements, not current or universally
reproducible benchmarks; see `historical-results.md`.

## Refresh Trade-off

Materialized Views are not refreshed automatically. `REFRESH MATERIALIZED VIEW`
recomputes and stores the aggregation, introducing additional work and leaving
the stored data stale until refresh occurs. They are most useful when reads are
frequent and freshness requirements allow that trade-off.

## Findings

- Materialized Views physically store precomputed results.
- Query execution changed from repeated join and aggregation work to indexed
  reads over stored data.
- The read-latency benefit is balanced by refresh cost and data freshness.

Materialized Views do not eliminate computation; they move it from query time
to refresh time.
