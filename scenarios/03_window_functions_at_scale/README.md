# Window Functions at Scale

## Objective

This scenario explores how PostgreSQL executes window functions over a
significant result set and how sorting operations affect performance. It focuses
on `ROW_NUMBER()`, `PARTITION BY`, `WindowAgg`, `Sort`, and `work_mem`.

## Dataset

- Dataset: DBA Stack Exchange
- Posts: approximately 243,410
- Analysis range: 2020–2024

## Scenario

Business question: what were the 10 most popular posts of each year since 2020?
The representative query uses `ROW_NUMBER() OVER (PARTITION BY ... ORDER BY
score DESC)` to rank posts independently within each year and returns the Top
10 posts per year.

## Execution Plan Analysis

The historical investigation used a `WindowAgg` node to calculate the ranking.
Approximately 57,000 rows had to be sorted before PostgreSQL could produce the
ranked results. Returning a small number of rows does not necessarily mean
PostgreSQL processes only that number of rows.

## Top-N and WindowAgg

The plan incorporated `row_number() <= N` as a `WindowAgg` run condition. The
condition reduced the output, but did not eliminate the initial sort needed to
establish ordering within each partition:

```text
Sort approximately 57k rows
        ↓
WindowAgg
        ↓
Run Condition: row_number() <= N
        ↓
smaller result set
```

## work_mem Experiment

The current `query.sql` represents the Top-10 business question. The historical
`work_mem` measurements instead used a temporary Top-1000-per-year variant,
which returned approximately 5000 rows.

Under the historical original/default session configuration, the relevant sort
used an external merge and spilled 2992 kB to disk; execution time was
approximately 246 ms. With `SET work_mem = '32MB'`, the sort used an in-memory
quicksort (5292 kB) and execution time was approximately 209 ms.

The important evidence is the plan change from external merge with disk I/O to
quicksort in memory. It demonstrates how `work_mem` can affect a sort that
exceeds its per-operation memory budget; it does not establish 32 MB as a
general PostgreSQL configuration recommendation.

## Findings

- PostgreSQL implemented ranking with `WindowAgg`.
- Sorting approximately 57k rows was required before ranking results were
  produced.
- Filtering on `yearly_rank <= N` did not eliminate that initial sort.
- In the historical Top-1000 experiment, changing `work_mem` changed the sort
  from external merge to quicksort.
- A small Top-N output does not imply that PostgreSQL processed only those
  output rows.

## Reproducibility Note

The timings are historical local measurements and vary with hardware,
PostgreSQL configuration, caching, and runtime conditions.
`historical-results.md` preserves the Top-1000 measurements, while
`historical-explain.txt` preserves their representative plan evidence. They are
not claimed as current benchmark results for the Top-10 query.
