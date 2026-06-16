# Execution Analysis

## Query 1 - reputation > 50000

Matching Users:

15

Execution Plan:

- Nested Loop
- Index Scan on users
- Index Scan on posts

Observation:

PostgreSQL estimated that only a very small number of users would satisfy the predicate.

Because the outer relation was small, repeated index lookups on posts were considered efficient.

Join Strategy:

Nested Loop

---

## Query 2 - reputation > 1000

Matching Users:

848

Execution Plan:

- Parallel Hash Join
- Parallel Seq Scan on posts
- Parallel Seq Scan on users
- Parallel Hash
- Gather Merge

Observation:

The predicate became much less selective.

The planner estimated that a significantly larger number of rows would participate in the join.

Instead of performing hundreds of index lookups, PostgreSQL chose to build a hash table and perform a Parallel Hash Join.

Join Strategy:

Parallel Hash Join

---

## Cardinality Impact

The query structure remained identical.

Only the predicate selectivity changed.

PostgreSQL selected completely different execution strategies because the expected number of rows changed significantly.