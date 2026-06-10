# 05 - Partitioning Basics

## Objective

Understand how PostgreSQL partitioning works and how partition pruning can reduce the amount of data considered during query execution.

---

## Dataset

- posts: ~243k rows

Date range:

- 2008-09-16
- 2024-03-31

---

## Problem

As tables grow over time, filtering by date may require PostgreSQL to consider increasingly large amounts of data.

Partitioning allows PostgreSQL to organize data into smaller physical tables while preserving a single logical table interface.

---

## Approach

A partitioned version of the posts table was created using:

PARTITION BY RANGE (creation_date)

Partitions:

- 2020
- 2021
- 2022
- 2023
- 2024

---

## Key Concepts

- Declarative Partitioning
- Range Partitioning
- Partition Pruning
- Query Planning
- Scalability