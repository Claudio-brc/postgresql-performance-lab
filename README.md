# PostgreSQL Performance Lab

A hands-on laboratory for exploring query optimization, indexing strategies,
execution plans, planner behavior, and performance trade-offs in PostgreSQL.

Using real-world DBA Stack Exchange data, the lab reproduces focused workload
problems, examines PostgreSQL's execution choices, applies targeted changes,
and compares the observed behavior. It is not a PostgreSQL syntax tutorial or a
collection of universal optimization rules: the goal is to understand why a
plan was chosen, measure the effect of a change, and document when a trade-off
is appropriate.

## What This Lab Covers

- `EXPLAIN (ANALYZE, BUFFERS)` and execution-plan analysis
- Query rewriting and intermediate-result cardinality
- Indexing strategies and partial indexes
- OFFSET and keyset pagination
- Window functions, sorting, and `work_mem`
- Materialized Views and refresh/freshness trade-offs
- Range partitioning and partition pruning
- Parallel query execution and aggregation cardinality
- PostgreSQL statistics, cardinality estimation, and join strategies

## Dataset

The lab uses the public DBA Stack Exchange data dump. Its relevant tables are
approximately 248k users and 243k posts. This scale is large enough to expose
meaningful sort, join, scan, and planner behavior while remaining practical to
run locally.

The dataset is not committed to this repository. Obtain and extract the dump
separately, then place `Users.xml` and `Posts.xml` in:

```text
datasets/stackexchange/
```

## Scenarios

| Scenario | Investigation | Key lesson |
|---|---|---|
| [01 — Analytics Query Optimization](scenarios/01_query_optimization/) | Aggregate-before-join query rewrite | Reducing cardinality before expensive work can matter more than a local tuning change. |
| [02 — Pagination: OFFSET vs Keyset](scenarios/02_pagination_catastrophe/) | Deep indexed OFFSET and cursor-based access | The right strategy depends on navigation requirements as well as page-depth scalability. |
| [03 — Window Functions at Scale](scenarios/03_window_functions_at_scale/) | `ROW_NUMBER()`, sorting, and `work_mem` | A small Top-N result can still require sorting a large input. |
| [04 — Materialized Views for Analytics](scenarios/04_materialized_views_for_analytics/) | Precomputed aggregates and refresh cost | Materialized Views move computation from read time to refresh time. |
| [05 — Partitioning Basics](scenarios/05_partitioning_basics/) | Range partitions and date predicates | Partition pruning avoids considering irrelevant partitions; partitioning is not an automatic speedup. |
| [06 — Parallel Query Execution](scenarios/06_parallel_query_execution/) | Workers, partial aggregates, and planner costs | Parallelism has coordination overhead and is not automatically faster. |
| [07 — Partial Indexes](scenarios/07_partial_indexes/) | Full versus selective reputation indexes | A partial index can substantially reduce index size for a targeted workload. |
| [08 — Statistics, Cardinality & Join Strategies](scenarios/08_statistics_cardinality_join_strategies/) | Predicate selectivity and join selection | Cardinality estimates change the relative cost of available plans. |

Each scenario contains its SQL, a concise narrative, and—where available—local
historical measurements or plan evidence. Scenario documentation provides the
detailed analysis; this README is the map of the lab.

## Methodology

The experiments follow a consistent investigation workflow:

1. Define a concrete performance problem.
2. Establish a baseline.
3. Inspect the execution plan.
4. Identify the dominant cost or bottleneck.
5. Apply one targeted change.
6. Execute again under comparable conditions.
7. Compare plans and measurements.
8. Document the result and its trade-offs.

Execution time is only one signal. Dataset shape, PostgreSQL configuration,
cache state, hardware, and workload characteristics affect it, so historical
measurements are not presented as universal benchmark claims.

## Running the Lab

### Requirements

- Docker Desktop with Docker Compose v2
- Node.js and npm
- The extracted DBA Stack Exchange `Users.xml` and `Posts.xml` files

The Compose configuration uses PostgreSQL 16 with local development settings:
database `performance_lab`, user `postgres`, password `postgres`, and host port
`5434`.

### 1. Prepare the dataset

Place the XML files under `datasets/stackexchange/`, then install the Node
dependency and generate the CSV files expected by the importer:

```bash
npm ci
npm run convert:dataset
```

### 2. Start PostgreSQL

Run this command from the repository root:

```bash
docker compose -f docker/docker-compose.yml up -d
```

### 3. Import the data

The database schema is initialized by the container. Import the generated CSV
files and collect planner statistics:

```bash
docker compose -f docker/docker-compose.yml exec -T postgres psql -U postgres -d performance_lab -v ON_ERROR_STOP=1 -f /scripts/import.sql
```

Create the shared baseline index used by scenarios that join `posts` to
`users`:

```bash
docker compose -f docker/docker-compose.yml exec -T postgres psql -U postgres -d performance_lab -v ON_ERROR_STOP=1 -f /scripts/baseline.sql
```

### 4. Run a scenario

Read the scenario README first, then copy its SQL file into the container and
run it with `psql`. For example, Scenario 01:

```bash
docker compose -f docker/docker-compose.yml cp scenarios/01_query_optimization/query.sql postgres:/tmp/scenario.sql
docker compose -f docker/docker-compose.yml exec -T postgres psql -U postgres -d performance_lab -v ON_ERROR_STOP=1 -f /tmp/scenario.sql
```

Some scenarios create experiment-specific objects or indexes. Their own SQL and
README document the relevant setup, cleanup, and historical context. To reset
the base data, rerun the import command and then `baseline.sql`.

## Reading Performance Results

Raw execution time alone is insufficient. Read plans for scan types, estimated
versus actual rows, loops, sort methods, memory use, temporary disk activity,
buffers where recorded, index conditions, filtering, partition pruning,
parallel workers, and join algorithms.

The objective is to understand **why** performance changed, not simply whether
one execution happened to be faster.

## Related Project

- **PostgreSQL Performance Lab** focuses on understanding and optimizing how
  PostgreSQL executes workloads.
- [**PostgreSQL Development Lab**](https://github.com/Claudio-brc/postgresql-development-lab)
  focuses on database-side application behavior with PL/pgSQL, functions and
  procedures, triggers, business rules, validation, auditing, JSONB, and
  reusable database logic.

## Portfolio Context

This repository is part of a backend and database engineering portfolio. It
demonstrates practical SQL performance investigation, PostgreSQL execution-plan
analysis, query optimization, indexing decisions, planner behavior, measurement,
and documentation of technical trade-offs.
