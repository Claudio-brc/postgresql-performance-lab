# 06 - Parallel Query Execution

## Objective

Understand how PostgreSQL executes queries using multiple workers and how the planner decides whether parallel execution is beneficial.

---

## Dataset

### posts

- ~243k rows
- ~56 MB

### users

- ~248k rows
- ~24 MB

---

## Problem

Large table scans can become expensive when executed by a single process.

PostgreSQL can distribute work across multiple workers, but parallel execution introduces coordination overhead.

The objective of this scenario is to understand:

- Parallel Seq Scan
- Partial Aggregation
- Gather
- Gather Merge
- Planner Decisions

---

## Key Concepts

- Parallel Query Execution
- Workers
- Parallel Seq Scan
- Partial Aggregate
- Gather
- Gather Merge
- Aggregation Strategies
- Planner Cost Estimation