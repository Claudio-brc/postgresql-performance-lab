# 04 - Materialized Views for Analytics

## Objective

Understand how Materialized Views can improve the performance of analytical workloads by precomputing expensive aggregations.

---

## Dataset

- users: ~248k rows
- posts: ~243k rows

---

## Business Question

Who are the most influential users based on:

- number of posts
- total views
- average score

---

## Problem

Analytical queries often require:

- joins
- aggregations
- sorting

When executed repeatedly, these operations can become expensive.

---

## Solution

Use a Materialized View to precompute aggregated data and serve queries directly from stored results.

---

## Key Concepts

- Materialized Views
- Aggregations
- Analytics Workloads
- Refresh Strategy
- Read vs Refresh Trade-off
- Execution Plans