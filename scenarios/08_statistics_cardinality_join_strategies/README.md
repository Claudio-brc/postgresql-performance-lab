# 08 - Statistics, Cardinality & Join Strategies

## Objective

Understand how PostgreSQL chooses execution plans based on statistics, cardinality estimates and cost calculations.

This scenario focuses on how changes in the expected number of rows can lead PostgreSQL to select completely different join strategies.

---

## Dataset

### users

- ~248k rows

### posts

- ~243k rows

---

## Problem

PostgreSQL supports multiple join algorithms:

- Nested Loop
- Hash Join
- Merge Join

The planner must decide which strategy is expected to be the cheapest.

This decision depends heavily on:

- Statistics
- Cardinality estimates
- Cost calculations

---

## Key Concepts

- Statistics
- ANALYZE
- Cardinality Estimation
- Cost-Based Optimization
- Nested Loop
- Hash Join
- Parallel Hash Join
- Planner Decisions