# PostgreSQL Performance Lab

A hands-on PostgreSQL project focused on query optimization, execution plans, indexing strategies, planner decisions and performance tuning using real-world datasets.

The goal of this lab is not to learn PostgreSQL syntax.

The goal is to understand how PostgreSQL actually executes queries and how different optimization techniques impact performance.

---

## Dataset

This project uses data extracted from the DBA Stack Exchange public dataset.

Main tables:

| Table |     Rows |
| ----- | -------: |
| posts | ~243,000 |
| users | ~248,000 |

The dataset is large enough to expose real execution plan behavior while remaining easy to reproduce locally.

---

## Project Goals

Through a series of practical scenarios, this lab explores:

* Query optimization
* Execution plans
* Indexing strategies
* Materialized views
* Partitioning
* Parallel query execution
* Partial indexes
* Statistics and planner decisions

Every scenario contains:

* Problem statement
* Reproducible SQL scripts
* Execution plan analysis
* Conclusions and lessons learned

---

# Scenarios

## 01 - Analytics Query Optimization

**Objective**

Optimize an analytical query by reducing the amount of work performed before aggregation.

**Concepts**

* Aggregation
* Join Reduction
* Query Rewriting
* Execution Plans

**Key Lesson**

Sometimes performance improvements come from changing the shape of a query rather than adding indexes.

---

## 02 - Pagination Catastrophe

**Objective**

Compare OFFSET pagination against Keyset Pagination.

**Concepts**

* OFFSET
* LIMIT
* Keyset Pagination
* Index Usage

**Key Lesson**

OFFSET becomes increasingly expensive as page numbers grow.

Keyset Pagination maintains predictable performance.

---

## 03 - Window Functions at Scale

**Objective**

Analyze the cost of Window Functions and sorting operations.

**Concepts**

* WindowAgg
* ROW_NUMBER
* Sort
* work_mem

**Key Lesson**

Window Functions are often limited by sorting costs rather than the window calculation itself.

---

## 04 - Materialized Views for Analytics

**Objective**

Compare real-time aggregation against precomputed results.

**Concepts**

* Materialized Views
* Refresh Strategies
* Analytics Workloads

**Key Lesson**

Materialized Views trade freshness for speed.

Understanding refresh requirements is critical.

---

## 05 - Partitioning Basics

**Objective**

Understand how partition pruning reduces the amount of data scanned.

**Concepts**

* Range Partitioning
* Partition Pruning
* Query Routing

**Key Lesson**

Partitioning is not a performance feature by itself.

Its value comes from avoiding unnecessary data access.

---

## 06 - Parallel Query Execution

**Objective**

Understand how PostgreSQL distributes work across multiple workers.

**Concepts**

* Parallel Seq Scan
* Gather
* Gather Merge
* Partial Aggregate
* Parallel Hash Join

**Key Lesson**

Parallel execution is not always faster.

PostgreSQL uses cost estimation to decide when parallelism is worthwhile.

---

## 07 - Partial Indexes

**Objective**

Learn how Partial Indexes reduce index size while preserving query performance.

**Concepts**

* Partial Indexes
* Selectivity
* Bitmap Index Scan
* Planner Decisions

**Key Lesson**

The goal of indexing is not to index everything.

The goal is to index the data your workload actually uses.

---

## 08 - Statistics, Cardinality & Join Strategies

**Objective**

Understand how PostgreSQL chooses execution plans.

**Concepts**

* Statistics
* Cardinality Estimation
* Nested Loop
* Hash Join
* Cost-Based Optimization

**Key Lesson**

Execution plans change because PostgreSQL expects different numbers of rows, not because queries look different.

---

# Repository Structure

```text
postgres-performance-lab/
│
├── datasets/
│   └── stackexchange/
│
├── docker/
│
├── scripts/
│
├── scenarios/
│   ├── 01_analytics_query_optimization/
│   ├── 02_pagination_catastrophe/
│   ├── 03_window_functions_at_scale/
│   ├── 04_materialized_views_for_analytics/
│   ├── 05_partitioning_basics/
│   ├── 06_parallel_query_execution/
│   ├── 07_partial_indexes/
│   └── 08_statistics_cardinality_join_strategies/
│
├── README.md
├── LICENSE
├── .gitignore
├── package.json
└── package-lock.json
```

### Directory Overview

| Directory | Purpose                                              |
| --------- | ---------------------------------------------------- |
| datasets  | Stack Exchange dataset files used throughout the lab |
| docker    | PostgreSQL container configuration                   |
| scripts   | Database setup and data import scripts               |
| scenarios | Individual performance tuning scenarios and analysis |

---

# Running the Project

### 1. Download the Stack Exchange dump

Place extracted files inside:

```text
datasets/stackexchange/
```

### 2. Start PostgreSQL

```bash
docker compose up -d
```

### 3. Import the dataset

Run the import scripts included in the `scripts` directory.

### 4. Execute scenarios

Each scenario is self-contained and can be executed independently.

---

# What I Learned

Building this lab helped me understand:

* How PostgreSQL evaluates execution plans
* Why indexes sometimes help and sometimes do not
* How planner decisions are driven by statistics and cardinality estimates
* The trade-offs between different optimization techniques
* How to approach performance investigations methodically

Most importantly, it reinforced a simple idea:

> PostgreSQL performance tuning is not about memorizing tricks.
>
> It is about understanding how the planner thinks.

---

## Future Work

Possible future topics:

* VACUUM and Table Bloat
* Advanced Planner Internals
* PostgreSQL Internals

A separate project is planned to explore PostgreSQL as a development platform through:

* PL/pgSQL
* Functions
* Stored Procedures
* Triggers
* Audit Logging
* Transactions & Concurrency
* JSONB
* Event-Driven Patterns

---

## License

MIT
