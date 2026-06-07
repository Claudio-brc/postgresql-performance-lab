# Pagination Catastrophe

## Objective

This scenario explores the performance impact of OFFSET pagination and compares it with keyset pagination.

## Dataset

- Source: DBA Stack Exchange
- Posts: 243,410
- Date Range: 2008–2024

## Query Pattern

Typical feed query:

```sql
SELECT ...
ORDER BY creation_date DESC
LIMIT 100 OFFSET N;