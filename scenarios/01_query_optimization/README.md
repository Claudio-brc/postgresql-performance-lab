# Analytics Query Optimization

## Objective

This scenario investigates the performance impact of reducing intermediate
result cardinality in an analytical query involving users and posts. The central
idea is: **Aggregate First, Join Later**.

## Dataset

- Users: approximately 248k rows
- Posts: approximately 243k rows

## Scenario

The query identifies users with at least five posts and returns their post
count, average score, and total views. The original approach joined `users` and
`posts` before aggregation and filtering.

## Baseline

The historical execution plan showed more than 236k rows participating in the
join before aggregation and filtering, producing a large intermediate result
set. Historical local execution time: approximately **2469 ms**.

## Optimization

The query was rewritten to aggregate posts by `owner_user_id` before joining
the reduced result set with `users`.

```text
Original:  posts → join large dataset → aggregate/filter
Optimized: posts → aggregate/filter → join reduced dataset
```

Historical local execution time: approximately **507 ms**. Historical observed
improvement: approximately **79%**.

## Additional Experiment: work_mem

An additional experiment increased `work_mem` and eliminated HashAggregate disk
spill, but produced only a marginal additional improvement. This indicated that
memory pressure was not the primary bottleneck in the original investigation.

## Findings

Execution-plan analysis changed the initial hypothesis that sorting or
aggregation might be the main bottleneck. The main cost was the large join input
before aggregation and filtering. Reducing cardinality before expensive
operations can have a greater impact than increasing memory or adding indexes.

## Reproducibility Note

Execution times are historical local measurements and may vary with hardware,
PostgreSQL configuration, caching, and runtime conditions.
`historical-results.md` preserves the historical measurements, and
`historical-explain.txt` preserves the original execution-plan evidence. These
timings are not claimed as current benchmark results.
