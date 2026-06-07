# PostgreSQL Performance Lab

Personal laboratory for practicing PostgreSQL performance tuning, query optimization, and execution plan analysis.

## Dataset

1. Download the Stack Exchange data dump.
2. Copy the files into `datasets/stackexchange`.
3. Run the import scripts.

## Goals

* Analyze query execution plans.
* Understand and optimize index usage.
* Compare OFFSET and Keyset Pagination.
* Identify performance bottlenecks.
* Practice PostgreSQL performance tuning techniques.

## Topics Covered

* Sequential Scan vs Index Scan
* Composite Indexes
* Covering Indexes
* Pagination Strategies
* EXPLAIN and EXPLAIN ANALYZE
* Query Optimization

## Project Structure

```text
scenarios/   # Performance scenarios and experiments
scripts/     # Import and utility scripts
docker/      # Docker configuration
postgres/    # PostgreSQL setup files
```

This repository is intended for learning, experimentation, and documenting PostgreSQL performance optimization techniques.
