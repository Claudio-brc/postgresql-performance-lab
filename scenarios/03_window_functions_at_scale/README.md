# Window Functions at Scale

This scenario explores how PostgreSQL executes window functions over large result sets and the impact of sorting operations on query performance.

The goal is to understand:

- ROW_NUMBER()
- PARTITION BY
- WindowAgg execution
- Sort operations
- work_mem influence on query execution

Business question: What were the 10 most popular posts of each year since 2020?

Dataset: DBA Stack Exchange

Posts: 243,410
Analysis Range: 2020 - 2024

Concepts:

- Window Functions
- ROW_NUMBER()
- PARTITION BY
- WindowAgg
- Sort
- work_mem