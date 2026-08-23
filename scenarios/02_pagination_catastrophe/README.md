# Pagination Catastrophe

## Objective

This scenario investigates PostgreSQL pagination performance for indexed feed
queries. It examines increasing `OFFSET` values, Keyset Pagination, and the
execution-plan behavior behind their different performance characteristics.

## Dataset

- Source: DBA Stack Exchange
- Posts: approximately 243,410
- Date range: approximately 2008–2024

## Scenario

The use case is a backend or API feed query joining `posts` to `users`. It
returns posts ordered by `creation_date DESC` with a page size of `LIMIT 100`.

## Baseline Query

Before adding an index on `creation_date`, PostgreSQL needed a sequential or
parallel sequential scan followed by sorting to satisfy the requested order.
The historical local execution time was approximately 277 ms; it is not a
universal result.

## Adding an Index

An index on `creation_date` allowed PostgreSQL to use an Index Scan and avoid
the initial expensive sorting strategy. The historical local execution time was
approximately 6 ms.

The index dramatically improved the initial query, but indexing alone did not
change the scalability characteristics of deep OFFSET pagination.

## Deep OFFSET Pagination

Historical local measurements increased with page depth:

| Offset | Execution time |
|---|---:|
| 1000 | approximately 17 ms |
| 10000 | approximately 98 ms |
| 50000 | approximately 291 ms |

The plans showed that PostgreSQL continued to use the index correctly, while
traversing and discarding progressively more rows before returning the page:

| Query | Index rows read |
|---|---:|
| LIMIT 100 | approximately 101 |
| OFFSET 1000 | approximately 1122 |
| OFFSET 10000 | approximately 10246 |
| OFFSET 50000 | approximately 51239 |

A query can use the correct index and still scale poorly because of its access
pattern: OFFSET requires PostgreSQL to traverse the preceding rows before it
can return the requested page.

## Keyset Pagination

The historical alternative uses `creation_date` as a cursor. Rather than
“skip N rows”, Keyset Pagination continues after the last position returned by
the previous page. The historical observation was approximately 102 rows read
and 2.6 ms, because PostgreSQL could seek from a known index position and stop
after retrieving approximately the requested number of rows.

This is not a controlled claim that Keyset Pagination is always faster. A strict
comparison must use a cursor proven to represent the same logical page as the
OFFSET query; see `historical-results.md`.

## OFFSET vs Keyset: Trade-offs

OFFSET is reasonable for traditional numbered pagination, admin grids, smaller
datasets, interfaces that must jump directly to page N, and cases where
simplicity matters more than deep-page scalability. It naturally supports page
1, page 2, page 3, and page 87.

Keyset Pagination is generally better suited to feeds, infinite scroll,
timelines, large datasets, high-traffic APIs, and sequential next/previous
navigation. It works from a cursor returned by the preceding page. Its
important limitation is that it does not naturally support jumping directly to
page 87, because navigation is relative to a known cursor rather than an
absolute row offset.

The right strategy depends on navigation requirements and scaling
characteristics, not only on which query has the lowest execution time.

## Findings

- The `creation_date` index dramatically improved the historical baseline.
- Deep OFFSET degraded while PostgreSQL continued using the index.
- `EXPLAIN ANALYZE` exposed the increasing number of rows traversed for deeper
  pages.
- Keyset Pagination changed the access pattern by continuing from a known
  position.
- Pagination is a product and backend design decision as well as a database
  performance decision.

## Reproducibility Note

The timings are historical local measurements and vary with hardware,
PostgreSQL configuration, caching, and runtime conditions. The scenario mainly
demonstrates execution-plan behavior and scaling trends.
`historical-results.md` preserves the measurements captured during the original
experiment.
