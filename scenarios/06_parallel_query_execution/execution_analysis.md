# Execution Analysis

## Query 1 - SUM(view_count)

Plan Highlights:

- Parallel Seq Scan
- Partial Aggregate
- Gather
- Finalize Aggregate

Workers:

- Planned: 2
- Launched: 2

Observation:

PostgreSQL divided the table scan among multiple workers and combined partial aggregate results.

---

## Query 2 - SUM(view_count) Without Parallelism

Plan Highlights:

- Seq Scan
- Aggregate

Observation:

The query executed entirely in a single process.

Interestingly, execution time was lower than the parallel version.

This demonstrates that parallel execution introduces overhead.

---

## Query 3 - GROUP BY owner_user_id

Plan Highlights:

- Seq Scan
- HashAggregate

Groups Produced:

~64k groups

Observation:

Despite the table size, PostgreSQL chose a serial execution strategy.

The planner estimated that combining a very large number of groups across workers would not be beneficial.

---

## Query 4 - GROUP BY post_type_id

Plan Highlights:

- Parallel Seq Scan
- Partial HashAggregate
- Gather Merge

Groups Produced:

5 groups

Observation:

The low number of groups made parallel aggregation attractive.

Each worker produced small partial result sets that could be merged efficiently.

---

## Query 5 - COUNT(*) WHERE view_count > 0

Plan Highlights:

- Parallel Seq Scan
- Partial Aggregate
- Gather
- Finalize Aggregate

Observation:

Parallel aggregation worked efficiently because partial counts are inexpensive to combine.